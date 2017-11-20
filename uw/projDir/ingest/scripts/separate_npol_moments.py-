#!/usr/bin/env python

#===========================================================================
#
# Separate NPOL moments into PPI and RHI
#
#===========================================================================

import os
import sys
from stat import *
import time
import datetime
from datetime import timedelta
import string
import subprocess
from optparse import OptionParser

def main():

    appName = "separate_npol_moments.py"

    global DATA_DIR
    global project
    
    DATA_DIR = os.environ['DATA_DIR']
    project = os.environ['project']

    # parse the command line

    global options
    parseArgs()

    # initialize
    
    if (options.debug == True):
        print >>sys.stderr, "======================================================="
        print >>sys.stderr, "BEGIN: " + appName + " " + str(datetime.datetime.now())
        print >>sys.stderr, "======================================================="

    #   compute valid time string

    validTime = time.gmtime(int(options.validTime))
    year = int(validTime[0])
    month = int(validTime[1])
    day = int(validTime[2])
    hour = int(validTime[3])
    minute = int(validTime[4])
    sec = int(validTime[5])
    yyyymmdd = "%.4d%.2d%.2d" % (year, month, day)
    hh = "%.2d" % hour
    mm = "%.2d" % minute
    validDayStr = "%.4d%.2d%.2d" % (year, month, day)
    validDateTimeStr = "%.4d%.2d%.2d%.2d%.2d%.2d" % (year, month, day, hour, minute, sec)

    # check for PPI or RHI

    if (options.fileName.find("PPI") > 0):
        isRhi = False

    if (options.fileName.find("RHI") > 0):
        isRhi = True

    combinedDir = os.path.join(DATA_DIR, project)
    combinedDir = os.path.join(combinedDir, "cfradial/moments/npol/combined")
    combinedDir = os.path.join(combinedDir, validDayStr)
    fullFilePath = os.path.join(combinedDir, options.fileName)
    
    if (options.debug == True):
        print >>sys.stderr, "isRhi: ", isRhi
        print >>sys.stderr, "validDayStr: ", validDayStr
        print >>sys.stderr, "combinedDir: ", combinedDir
        print >>sys.stderr, "fullFilePath: ", fullFilePath

    if (isRhi):
        # create rhi dir if necessary
        rhiDir = os.path.join(DATA_DIR, project)
        rhiDir = os.path.join(rhiDir, "cfradial/moments/npol/rhi")
        rhiDayDir = os.path.join(rhiDir, validDayStr)
        relFilePath = os.path.join(validDayStr, options.fileName)
        if (options.debug == True):
            print >>sys.stderr, "rhiDayDir: ", rhiDayDir
        if not os.path.exists(rhiDayDir):
            runCommand("mkdir -p " + rhiDayDir)
        runCommand("mv " + fullFilePath + " " + rhiDayDir)
        # write latest_data_info
        cmd = 'LdataWriter -dir ' + rhiDir  + \
              ' -rpath ' + relFilePath + \
              ' -ltime ' + validDateTimeStr + \
              ' -writer ' + appName
        runCommand(cmd)
    else:
        # create sur dir if necessary
        surDir = os.path.join(DATA_DIR, project)
        surDir = os.path.join(surDir, "cfradial/moments/npol/sur")
        surDayDir = os.path.join(surDir, validDayStr)
        relFilePath = os.path.join(validDayStr, options.fileName)
        if (options.debug == True):
            print >>sys.stderr, "surDayDir: ", surDayDir
        if not os.path.exists(surDayDir):
            runCommand("mkdir -p " + surDayDir)
        runCommand("mv " + fullFilePath + " " + surDayDir)
        # write latest_data_info
        cmd = 'LdataWriter -dir ' + surDir  + \
              ' -rpath ' + relFilePath + \
              ' -ltime ' + validDateTimeStr + \
              ' -writer ' + appName
        runCommand(cmd)
            
    # let the user know we are done

    if (options.debug == True):
        print >>sys.stderr, "======================================================="
        print >>sys.stderr, "END: " + appName + " " + str(datetime.datetime.now())
        print >>sys.stderr, "======================================================="

    sys.exit(0)

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

    parser.add_option('--unix_time',
                      dest='validTime',
                      default=0,
                      help='Valid time for data')

    parser.add_option('--full_path',
                      dest='combinedDir',
                      default='unknown',
                      help='Dir with combined moments files')

    parser.add_option('--file_name',
                      dest='fileName',
                      default='unknown',
                      help='Name of combined file')

    parser.add_option('--rel_file_path',
                      dest='relFilePath',
                      default='unknown',
                      help='Relative path of combined file')

    # these options are specific to the image type

    (options, args) = parser.parse_args()

    if (options.verbose):
        options.debug = True

    if (options.debug == True):
        print >>sys.stderr, "Options:"
        print >>sys.stderr, "  debug? ", options.debug
        print >>sys.stderr, "  validTime: ", options.validTime
        print >>sys.stderr, "  combinedDir: ", options.combinedDir
        print >>sys.stderr, "  relFilePath: ", options.relFilePath
        print >>sys.stderr, "  fileName: ", options.fileName

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
