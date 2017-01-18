# ***** merge code for NPOL data *****
# Author: Stacy Brodzik, University of Washington
# Date: October 24, 2016
# Description: 

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
import os
import logging as log
import sys

# ------------------------------------ START INPUTS ------------------------------------
## input and output directories
inDir = '/home/disk/bob/olympex/raw/npol_qc2/'
outDir = inDir
binDir = '/home/disk/meso-home/meso/build/bin/'
date = ['20151113']
#date = ['20151105','20151112','20151113','20151114','20151115','20151116',
#        '20151117','20151118','20151119','20151120','20151121','20151122',
#        '20151123','20151124','20151125','20151126','20151130','20151201',
#        '20151202','20151203','20151204','20151205','20151206','20151207',
#        '20151208','20151209','20151210','20151211','20151212','20151213',
#        '20151214','20151215','20151216','20151217','20151218','20151219',
#        '20160103','20160104','20160105','20160106','20160108','20160110',
#        '20160111','20160112','20160113','20160114','20160115']

## RadxConvert param file
paramFile = '/home/disk/meso-home/meso/projDir/ingest/params/RadxConvert.npol_qc.rhi'
# ------------------------------------- END INPUTS -------------------------------------

# set up logging
log.basicConfig(format='%(levelname)s:%(message)s',level=log.INFO)

# process data for each year and month
for i,idate in enumerate(date):
    log.info('i = {} and idate = {}'.format(i,idate) )
    os.chdir(inDir+idate+'/rhi_a')

    for file in os.listdir(inDir+idate+'/rhi_a'):
        log.info('file = {}'.format(file) )
        if '00-20' in file:
            # determine if there is a matching 20-40 file
            file2 = file[0:file.find('00-20')]+'20-40.uf' 		
            if os.path.isfile(file2):
                command = binDir+'RadxConvert -v -param '+paramFile+' -f '+file+' '+ file2
        else:
            command = binDir+'RadxConvert -v -param '+paramFile+' -f '+file
        log.info('   command = {}'.format(command) )
