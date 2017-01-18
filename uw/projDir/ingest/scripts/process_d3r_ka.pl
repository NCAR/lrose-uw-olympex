#!/usr/bin/perl

$RAW_DIR = "/home/disk/bob/olympex/raw/d3r/ka";
$TMP_DIR = $RAW_DIR."/tmp";
$PARAM_DIR = "~meso/projDir/ingest/params";
$BIN_DIR = "/home/disk/meso-home/meso/cvs/bin";
  
@dates = ("20151108");

for $idate (0..$#dates) {
    
    chdir($RAW_DIR."/".$dates[$idate]);

    $last_sweep = "00";
    $first_file = 1;
    foreach $file (<KaD3R*.nc>) {
	print "file = $file\n";
	($yyyymmdd,$hhmmss,$sweep) = ($file =~ /KaD3R_(.*)_(.*)_(.*)\.nc/);
	print "   sweep = $sweep and last_sweep = $last_sweep\n";
	if ($first_file) {
	    $first_yyyymmdd = $yyyymmdd;
	    $first_hhmmss = $hhmmss;
	    $last_yyyymmdd = $yyyymmdd;
	    $last_hhmmss = $hhmmss;
	    $first_file = 0;
	    print "   first file: sweep = $sweep, first daytime = $first_yyyymmdd $first_hhmmss\n";
	}
	if ($sweep > $last_sweep) {
	    print "   ADDING TO EXISTING VOLUME\n";
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    #system($command);
	    $last_sweep = $sweep;
	    $last_yyyymmdd = $yyyymmdd;
	    $last_hhmmss = $hhmmss;
	    print "   last file: sweep = $last_sweep, last daytime = $last_yyyymmdd $last_hhmmss\n";
	}
	else {
	    print "   PROCESS VOLUME\n";
	    if ($sweep == "01") {
		print "this is a birdbath scan/volume\n";
	    }
	    elsif ($last_sweep <= "05") {
		print "this is a surveillance volume\n";
	    }
	    else {
		print "this is an rhi volume\n";
	    }
	    $first_yr = substr($first_yyyymmdd,0,4);
	    $first_mo = substr($first_yyyymmdd,4,2);
	    $first_da = substr($first_yyyymmdd,6,2);
	    $first_hr = substr($first_hhmmss,0,2);
	    $first_mi = substr($first_hhmmss,2,2);
	    $first_se = substr($first_hhmmss,4,2);
	    $start_time = $first_yr." ".$first_mo." ".$first_da." ".$first_hr." ".$first_mi." ".$first_se;
	    print "   start_time = $start_time\n";
	    $last_yr = substr($last_yyyymmdd,0,4);
	    $last_mo = substr($last_yyyymmdd,4,2);
	    $last_da = substr($last_yyyymmdd,6,2);
	    $last_hr = substr($last_hhmmss,0,2);
	    $last_mi = substr($last_hhmmss,2,2);
	    $last_se = substr($last_hhmmss,4,2);
	    $end_time = $last_yr." ".$last_mo." ".$last_da." ".$last_hr." ".$last_mi." ".$last_se;
	    print "   end_time = $end_time\n";
	    #$command = "$BIN_DIR/RadxConvert -params $PARAM_DIR/RadxConvert.d3r.ka.archive -start \'$start_time\' -end \'$end_time\'";
	    $command = "$BIN_DIR/RadxConvert -params $PARAM_DIR/RadxConvert.d3r.ka.archive -f $TMP_DIR/*.nc";
	    print "   command = $command\n";
	    #system($command);
	    print "   EMPTY TMP_DIR AND MOVE LAST SWEEP INTO IT\n";
	    $command = "/bin/rm ".$TMP_DIR."/*.nc";
	    print "   command = $command\n";
	    #system($command);
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    #system($command);
	    $last_sweep = $sweep;
	    $first_yyyymmdd = $yyyymmdd;
	    $first_hhmmss = $hhmmss;
	    print "   first file: sweep = $sweep, first daytime = $first_yyyymmdd $first_hhmmss\n";
	    $last_yyyymmdd = $yyyymmdd;
	    $last_hhmmss = $hhmmss;
	    print "   last file: sweep = $last_sweep, last daytime = $last_yyyymmdd $last_hhmmss\n";
	}
    }

}

exit(0);
