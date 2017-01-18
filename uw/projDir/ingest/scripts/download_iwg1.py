#!/usr/bin/env python

#===========================================================================
#
# DOWNLOAD aircraft data in IWG1 format
#
#===========================================================================

import os
import sys
from stat import *
import time
import datetime
from datetime import timedelta
import dateutil.parser
import string
import subprocess
from optparse import OptionParser
import atexit

def main():

    global appName
    appName = "download_iwg1.py"

    global DATA_DIR
    global project
    
    DATA_DIR = os.environ['DATA_DIR']
    project = os.environ['project']

    global startTime
    startTime = time.time()

    global prevEntryTime
    prevEntryTime = ""

    # parse the command line

    global options
    parseArgs()

    # initialize
    
    if (options.debug == True):
        print >>sys.stderr, "======================================================="
        print >>sys.stderr, "BEGIN: " + appName + " " + str(datetime.datetime.now())
        print >>sys.stderr, "======================================================="

    # set exit condition
    
    atexit.register(procmapUnregister)
    
    # loop, getting data

    while (True):
        procmapRegister()
        getOneEntry()
        time.sleep(float(options.intervalSecs))
        
    # let the user know we are done

    if (options.debug == True):
        print >>sys.stderr, "======================================================="
        print >>sys.stderr, "END: " + appName + " " + str(datetime.datetime.now())
        print >>sys.stderr, "======================================================="

    sys.exit(0)

########################################################################
# Get one data line

def getOneEntry():

    global prevEntryTime
    
    # determine the file name from the last part of the URL

    urlParts = options.inputUrl.split("/")
    fileName = urlParts[-1:][0]
    if (options.debug == True):
        print >>sys.stderr, "URL parts: ", urlParts
        print >>sys.stderr, "fileName: ", fileName

    # ensure outputdir exists

    if not os.path.exists(options.outputDir):
        runCommand("mkdir -p " + options.outputDir)
    
    # go to output dir

    os.chdir(options.outputDir)

    # delete any existing files, since wget will name the
    # files fileName.1, fileName.2 etc if the file already exists

    runCommand("/bin/rm " + fileName + "*")

    # perform wget
    
    cmd = 'wget ' + options.inputUrl
    runCommand(cmd)

    # compute file path

    filePath = os.path.join(options.outputDir, fileName)
    if (options.debug == True):
        print >>sys.stderr, "filePath: ", filePath
    
    # parse the file

    file = open(filePath, 'r');
    line = file.readline()
    if (options.debug == True):
        print >>sys.stderr, "line: ", line

    # split comma-delimted values

    lineParts = line.split(',')
    if (len(lineParts) < 3):
        print >>sys.stderr, "..... no data found"
        return
    
    dateTimeStr = lineParts[1]
    dtime = dateutil.parser.parse(dateTimeStr)
    if (options.debug == True):
        print >>sys.stderr, "dtime: ", dtime
    
    yyyymmdd = "%.4d%.2d%.2d" % (dtime.year, dtime.month, dtime.day)
    hhmmss = "%.2d%.2d%.2d" % (dtime.hour, dtime.minute, dtime.second)
    entryTime = yyyymmdd + hhmmss

    if (options.debug == True):
        print >>sys.stderr, "entryTime: ", entryTime

    # check if we have already handled this time
    
    if (entryTime == prevEntryTime):
        if (options.debug == True):
            print >>sys.stderr, "  ==>> entry time already read: ", prevEntryTime
            print >>sys.stderr, "  ==>> ignoring"
        runCommand("/bin/rm " + fileName + "*")
        return

    prevEntryTime = entryTime

    # make day dir

    if not os.path.exists(yyyymmdd):
        runCommand("mkdir -p " + yyyymmdd)

    # move the file into the day dir

    renamedFileName = entryTime + "_" + fileName
    renamedFilePath = os.path.join(yyyymmdd, renamedFileName)
    runCommand("/bin/mv -f " + fileName + " " + renamedFilePath)
    
    # write latest_data_info
    cmd = 'LdataWriter -dir ' + options.outputDir + \
          ' -rpath ' + renamedFilePath + \
          ' -ltime ' + entryTime + \
          ' -writer ' + appName
    runCommand(cmd)
    
########################################################################
# Register with procmap

def procmapRegister():

    # determine the file name from the last part of the URL

    command = "procmap_register"
    command = command + " -instance " + options.instance
    command = command + " -name " + appName
    command = command + " -pid " + str(os.getpid())
    command = command + " -reg_int 60 "
    command = command + " -start " + str(startTime)
    
    runCommand(command)
    
########################################################################
# Un-register with procmap

def procmapUnregister():

    # determine the file name from the last part of the URL

    command = "procmap_unregister"
    command = command + " -instance " + options.instance
    command = command + " -name " + appName
    command = command + " -pid " + str(os.getpid())
    
    runCommand(command)
    
########################################################################
# Parse the command line

def parseArgs():
    
    global options

    # parse the command line

    usage = "usage: %prog [options]"
    parser = OptionParser(usage)

    # these options come from the ldata info file

    parser.add_option('--debug',
                      dest='debug', default='False',
                      action="store_true",
                      help='Set debugging on')

    parser.add_option('--verbose',
                      dest='verbose', default='False',
                      action="store_true",
                      help='Set debugging on')

    parser.add_option('--interval',
                      dest='intervalSecs',
                      default=5,
                      help='Time interval between gets - secs')

    parser.add_option('--input_url',
                      dest='inputUrl',
                      default='http://asp-interface-2.arc.nasa.gov/API/parameter_data/N555DS/IWG1',
                      help='URL for wget for IWG1 data')

    parser.add_option('--output_dir',
                      dest='outputDir',
                      default='raw/aircraft/N555DS',
                      help='Output directory')

    parser.add_option('--instance',
                      dest='instance',
                      default='N555DS',
                      help='Process instance')

    (options, args) = parser.parse_args()

    if (options.verbose):
        options.debug = True

    if (options.debug == True):
        print >>sys.stderr, "Options:"
        print >>sys.stderr, "  debug? ", options.debug
        print >>sys.stderr, "  intervalSecs: ", options.intervalSecs
        print >>sys.stderr, "  inputUrl: ", options.inputUrl
        print >>sys.stderr, "  outputDir: ", options.outputDir

########################################################################
# Run a command in a shell, wait for it to complete

def runCommand(cmd):

    if (options.debug == True):
        print >>sys.stderr, "running cmd:",cmd
    
    try:
        retcode = subprocess.call(cmd, shell=True)
        if retcode < 0:
            print >>sys.stderr, "Child was terminated by signal: ", -retcode
        else:
            if (options.debug == True):
                print >>sys.stderr, "Child returned code: ", retcode
    except OSError, e:
        print >>sys.stderr, "Execution failed:", e

########################################################################
# kick off main method

if __name__ == "__main__":

   main()
