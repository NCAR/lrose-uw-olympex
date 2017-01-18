#!/usr/bin/perl

$RAW_DIR = "/home/disk/bob/olympex/cfradial/moments/xband_dbz/sur_single";
$TMP_DIR = $RAW_DIR."/tmp";
$PARAM_DIR = "~meso/projDir/ingest/params";
#$BIN_DIR = "/home/disk/meso-home/meso/cvs/bin";
$BIN_DIR = "/home/disk/blitz/bin";
  
@dates = ('20151114','20151115',
	  '20151116','20151117','20151118','20151119','20151120',
	  '20151121','20151122','20151123','20151124','20151125',
	  '20151127','20151128','20151129','20151130',
	  '20151201','20151202','20151203','20151204','20151205',
	  '20151206','20151207','20151208','20151209','20151210',
	  '20151211','20151212','20151213','20151214','20151215',
	  '20151216','20151217','20151218','20151219','20151220',
	  '20151221','20151222','20151223','20151224','20151225',
	  '20151226','20151227','20151228','20151229','20151230',
	  '20151231',
	  '20160101','20160102','20160103','20160104','20160105',
	  '20160106','20160107','20160108','20160109','20160110',
	  '20160111','20160112','20160113','20160114','20160115',
	  '20160116','20160117','20160118','20160119','20160120',
	  '20160121','20160122','20160123','20160124','20160125');

for $idate (0..$#dates) {
    
    chdir($RAW_DIR."/".$dates[$idate]);

    $last_angle = "0";
    $first_file = 1;
    foreach $file (<cfrad.*.nc>) {
	print "file = $file\n";
	($date,$time,$angle) = ($file =~ /cfrad\.(.*)_(.*)_xband_DBZ_(.*)_PPI\.nc/);
	print "   angle = $angle and last_angle = $last_angle\n";
	if ($first_file) {
	    $first_date = $date;
	    $first_time = $time;
	    $last_date = $date;
	    $last_time = $time;
	    $first_file = 0;
	    print "   first file: angle = $angle, first daytime = $first_date $first_time\n";
	}
	if ($angle > $last_angle) {
	    print "   ADDING TO EXISTING VOLUME\n";
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    system($command);
	    $last_angle = $angle;
	    $last_date = $date;
	    $last_time = $time;
	    print "   last file: angle = $last_angle, last daytime = $last_date $last_time\n";
	}
	else {
	    print "   PROCESS VOLUME\n";
	    $first_yr = substr($first_date,0,4);
	    $first_mo = substr($first_date,4,2);
	    $first_da = substr($first_date,6,2);
	    $first_hr = substr($first_time,0,2);
	    $first_mi = substr($first_time,2,2);
	    $first_se = substr($first_time,4,2);
	    $start_time = $first_yr." ".$first_mo." ".$first_da." ".$first_hr." ".$first_mi." ".$first_se;
	    print "   start_time = $start_time\n";
	    $last_yr = substr($last_date,0,4);
	    $last_mo = substr($last_date,4,2);
	    $last_da = substr($last_date,6,2);
	    $last_hr = substr($last_time,0,2);
	    $last_mi = substr($last_time,2,2);
	    $last_se = substr($last_time,4,2);
	    $end_time = $last_yr." ".$last_mo." ".$last_da." ".$last_hr." ".$last_mi." ".$last_se;
	    print "   end_time = $end_time\n";
	    $command = "$BIN_DIR/RadxConvert -v -params $PARAM_DIR/RadxConvert.xband.SUR -f $TMP_DIR/*.nc";
	    print "   command = $command\n";
	    system($command);
	    print "   EMPTY TMP_DIR AND MOVE LAST SWEEP INTO IT\n";
	    $command = "/bin/rm ".$TMP_DIR."/*.nc";
	    print "   command = $command\n";
	    system($command);
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    system($command);
	    $last_angle = $angle;
	    $first_date = $date;
	    $first_time = $time;
	    print "   first file: angle = $angle, first daytime = $first_date $first_time\n";
	    $last_date = $date;
	    $last_time = $time;
	    print "   last file: angle = $last_angle, last daytime = $last_date $last_time\n";
	}
    }
    $command = "$BIN_DIR/RadxConvert -v -params $PARAM_DIR/RadxConvert.xband.SUR -f $TMP_DIR/*.nc";
    print "   command = $command\n";
    system($command);
    print "   EMPTY TMP_DIR\n";
    $command = "/bin/rm ".$TMP_DIR."/*.nc";
    print "   command = $command\n";
    system($command);
   
}

exit(0);
