#!/usr/bin/perl

$RAW_DIR = "/home/disk/bob/olympex/raw/d3r_qc/ka/rhi";
$TMP_DIR = $RAW_DIR."/tmp";
$PARAM_DIR = "~meso/projDir/ingest/params";
#$BIN_DIR = "/home/disk/meso-home/meso/cvs/bin";
#$BIN_DIR = "/home/disk/meso-home/meso/build/bin";
$BIN_DIR = "/home/disk/blitz/bin";
$OUT_DIR = "/home/disk/bob/olympex/cfradial/moments/d3r_ka_qc/rhi";
  
@dates = ("20151108","20151109","20151110",
	  "20151111","20151112","20151113","20151114","20151115",
          "20151116","20151117","20151118","20151119",
          "20151123","20151124",
          "20151126","20151127","20151130",
	  "20151201","20151202","20151203","20151204","20151205",
	  "20151206","20151207","20151208","20151209","20151210",
	  "20151211","20151212","20151213","20151214","20151215",
	  "20151216","20151217","20151218","20151219",
          "20160107","20160108","20160109","20160110",
	  "20160111","20160112","20160113","20160114","20160115");
#@dates = ("20160106");

for $idate (0..$#dates) {

    chdir($RAW_DIR."/".$dates[$idate]);

    #create output directory if it does not exist
    #$outdir = $OUT_BASE."/".$dates[$idate];
    #print "outdir = $outdir\n";
    #unless (-e $outdir) {
	#mkdir $outdir;
    #}
    
    $last_sweep = 0;
    $first_file = 1;
    foreach $file (<olympex_d3r_ka_*.nc>) {
	print "file = $file\n";
	($yyyymmdd,$hhmmss,$sweep) = ($file =~ /olympex_d3r_ka_(.*)_(.*)_(.*)\.nc/);
	print "   sweep = $sweep and last_sweep = $last_sweep\n";
	if ($first_file) {
	    #$first_yyyymmdd = $yyyymmdd;
	    #$first_hhmmss = $hhmmss;
	    #$last_yyyymmdd = $yyyymmdd;
	    #$last_hhmmss = $hhmmss;
	    $first_file = 0;
	    #print "   first file: sweep = $sweep, first daytime = $first_yyyymmdd $first_hhmmss\n";
	    print "   first file: sweep = $sweep\n";
	}
	if ($sweep > $last_sweep) {
	    print "   ADDING TO EXISTING VOLUME\n";
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    system($command);
	    $last_sweep = $sweep;
	    #$last_yyyymmdd = $yyyymmdd;
	    #$last_hhmmss = $hhmmss;
	    #print "   last file: sweep = $last_sweep, last daytime = $last_yyyymmdd $last_hhmmss\n";
	    print "   last file: sweep = $last_sweep\n";
	}
	else {
	    print "   PROCESS VOLUME\n";
	    #$first_yr = substr($first_yyyymmdd,0,4);
	    #$first_mo = substr($first_yyyymmdd,4,2);
	    #$first_da = substr($first_yyyymmdd,6,2);
	    #$first_hr = substr($first_hhmmss,0,2);
	    #$first_mi = substr($first_hhmmss,2,2);
	    #$first_se = substr($first_hhmmss,4,2);
	    #$start_time = $first_yr." ".$first_mo." ".$first_da." ".$first_hr." ".$first_mi." ".$first_se;
	    #print "   start_time = $start_time\n";
	    #$last_yr = substr($last_yyyymmdd,0,4);
	    #$last_mo = substr($last_yyyymmdd,4,2);
	    #$last_da = substr($last_yyyymmdd,6,2);
	    #$last_hr = substr($last_hhmmss,0,2);
	    #$last_mi = substr($last_hhmmss,2,2);
	    #$last_se = substr($last_hhmmss,4,2);
	    #$end_time = $last_yr." ".$last_mo." ".$last_da." ".$last_hr." ".$last_mi." ".$last_se;
	    #print "   end_time = $end_time\n";
	    #$command = "$BIN_DIR/RadxConvert -params $PARAM_DIR/RadxConvert.d3r.ka.archive -start \'$start_time\' -end \'$end_time\'";
	    $command = "$BIN_DIR/RadxConvert -params $PARAM_DIR/RadxConvert.d3r.ka.archive.rhi -f $TMP_DIR/*.nc";
	    #$command = "$BIN_DIR/RadxConvert -ag_all -f $TMP_DIR/*.nc -outdir $OUT_DIR -v";
	    print "   command = $command\n";
	    #exit;
	    system($command);
	    #$command = "sleep 60";
	    #print "    command = $command . . . . sleeping\n";
	    #system($command);
	    print "   EMPTY TMP_DIR AND MOVE LAST SWEEP INTO IT\n";
	    $command = "/bin/rm ".$TMP_DIR."/*.nc";
	    print "   command = $command\n";
	    system($command);
	    $command = "cp ".$file." ".$TMP_DIR;
	    print "   command = $command\n";
	    system($command);
	    $last_sweep = $sweep;
	    #$first_yyyymmdd = $yyyymmdd;
	    #$first_hhmmss = $hhmmss;
	    #print "   first file: sweep = $sweep, first daytime = $first_yyyymmdd $first_hhmmss\n";
	    print "   first file: sweep = $sweep\n";
	    #$last_yyyymmdd = $yyyymmdd;
	    #$last_hhmmss = $hhmmss;
	    #print "   last file: sweep = $last_sweep, last daytime = $last_yyyymmdd $last_hhmmss\n";
	    print "   last file: sweep = $last_sweep\n";
	}
    }
    #process files left in tmp dir
    print "   PROCESS LAST VOLUME\n";
    $command = "$BIN_DIR/RadxConvert -params $PARAM_DIR/RadxConvert.d3r.ka.archive.rhi -f $TMP_DIR/*.nc";
    print "   command = $command\n";
    system($command);
    print "   EMPTY TMP_DIR\n";
    $command = "/bin/rm ".$TMP_DIR."/*.nc";
    print "   command = $command\n";
    system($command);
}

exit(0);
