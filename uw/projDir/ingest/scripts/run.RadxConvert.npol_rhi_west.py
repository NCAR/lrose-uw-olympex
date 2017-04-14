#Pair up NPOL UF files and combine to create single cfradial file

import numpy as np
import os
import logging as log

# Inputs
inDir = '/home/disk/bob/olympex/raw/npol_qc2/rhi'
paramFile = '../params/RadxConvert.npol_rhi_west'
binDir = '/home/disk/meso-home/meso/lrose/bin'
#dates = ['20151105','20151112','20151113','20151114','20151115',
#         '20151116','20151117','20151118','20151119','20151120',
#         '20151121','20151122','20151123','20151124','20151125',
#         '20151126','20151130',
#         '20151201','20151202','20151203','20151204','20151205',
#         '20151206','20151207','20151208','20151209','20151210',
#         '20151211','20151212','20151214','20151215',
#         '20151216','20151217','20151218','20151219']
#         '20160103','20160104','20160105',
#         '20160106','20160108','20160110',
#         '20160111','20160112','20160113','20160114','20160115']
dates = ['20151213']
    
# Start log
log.basicConfig(format='%(levelname)s:%(message)s',level=log.INFO)

for date in dates:
    print date
    thisDir = inDir+'/'+date+'/rhi_a'
    for fname1 in os.listdir(thisDir):
        if fname1.endswith('00-20.uf'):
            log.info( "file1 = {}".format(fname1) )
            # Find matching date and time
            # For filename format: NPOL1_2015_1212_130002_rhi_00-20.uf.gz
            #radar,year,monthday,time,scan,azrange = fname1.split("_")  for orig files
            # For filename format: olympex_NPOL1_20151213_140003_rhi_00-20.uf
            project,radar,date,time,scan,azrange = fname1.split("_")
            fname2 = project+'_'+radar+'_'+date+'_'+time+'_'+scan+'_20-40.uf'
            if os.path.isfile(thisDir+'/'+fname2):
                log.info( "file2 = {}".format(fname2) )
                command = binDir+'/RadxConvert -v -params '+paramFile+' -f '+thisDir+'/'+fname1+' '+thisDir+'/'+fname2
                os.system(command)
                if not os.path.exists(thisDir+'/DONE'):
                    os.makedirs(thisDir+'/DONE')
                os.rename(thisDir+'/'+fname1, thisDir+'/DONE/'+fname1)
                os.rename(thisDir+'/'+fname2, thisDir+'/DONE/'+fname2)










  
