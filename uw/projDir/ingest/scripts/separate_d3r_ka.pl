#!/usr/bin/perl

$RAW_DIR = "/home/disk/bob/olympex/raw/d3r_qc/ka";
$TMP_DIR = $RAW_DIR."/tmp";
  
#@dates = ("20160108");
@dates = ("20151110","20151111","20151112","20151113","20151114","20151115",
	  "20151116","20151117","20151118","20151119",
	  "20151120","20151121","20151122","20151123","20151124","20151125",
	  "20151126","20151127","20151128","20151129","20151130","20151201",
	  "20151202","20151203","20151204","20151205","20151206","20151207",
	  "20151208","20151209","20151210","20151211","20151212","20151213",
	  "20151214","20151215","20151216","20151217","20151218","20151219",
	  "20160103","20160104","20160105","20160106","20160107","20160108",
	  "20160109","20160110","20160111","20160112","20160113","20160114",
	  "20160115");

for $idate (0..$#dates) {
    
    chdir($RAW_DIR."/".$dates[$idate]);

    $last_sweep = 0;
    $first_file = 1;
    foreach $file (<olympex_d3r_ka_*.nc>) {
	print "file = $file\n";
	($yyyymmdd,$hhmmss,$sweep) = ($file =~ /olympex_d3r_ka_(.*)_(.*)_(.*)\.nc/);
	if ($first_file) {
	    $first_file = 0;
	}
	if ($sweep > $last_sweep) {
	    $command = "/bin/mv ".$file." ".$TMP_DIR;
	    system($command);
	    $last_sweep = $sweep;
	}
	else {
	    if ($last_sweep eq '01') {   # sun cal
		$command = "/bin/mv ".$TMP_DIR."/*.nc ".$RAW_DIR."/".$dates[$idate]."/sun";
		system($command);
	    }
	    elsif ($last_sweep gt '10') {   # rhi volume
		$command = "/bin/mv ".$TMP_DIR."/*.nc ".$RAW_DIR."/".$dates[$idate]."/rhi";
		system($command);
	    }
	    else {   # sur volume
		$command = "/bin/mv ".$TMP_DIR."/*.nc ".$RAW_DIR."/".$dates[$idate]."/sur";
		system($command);
	    }
   
	    # move last sweep into tmp dir
	    $command = "/bin/mv ".$file." ".$TMP_DIR;
	    system($command);
	    $last_sweep = $sweep;
	}
    }

}

exit(0);
