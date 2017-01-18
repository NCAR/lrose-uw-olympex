#!/usr/bin/perl

$MAIN_DIR = "/home/disk/bob/olympex/raw/d3r_qc/ka";

@dates = ("20151113","20151126","20151127","20160107","20160108","20160114");
#@dates = ("20151108","20151109","20151110",
#	  "20151111","20151112","20151113","20151114","20151115",
#          "20151116","20151117","20151118","20151119",
#	  "20151123","20151124",
#          "20151126","20151127","20151130",
#	  "20151201","20151202","20151203","20151204","20151205",
#	  "20151206","20151207","20151208","20151209","20151210",
#	  "20151211","20151212","20151213","20151214","20151215",
#	  "20151216","20151217","20151218","20151219",
#	  "20160107","20160108","20160109","20160110",
#	  "20160111","20160112","20160113","20160114","20160115");

chdir($MAIN_DIR);
    
for $idate (0..$#dates) {
    
    $command = "/bin/mv ".$dates[$idate]."/rhi/*.nc rhi/".$dates[$idate];
    print "command = $command\n";
    system($command);
    $command = "/bin/rm -r ".$dates[$idate]."/rhi";
    print "command = $command\n";
    system($command);
    
    $command = "/bin/mv ".$dates[$idate]."/sun/*.nc sun/".$dates[$idate];
    print "command = $command\n";
    system($command);
    $command = "/bin/rm -r ".$dates[$idate]."/sun";
    print "command = $command\n";
    system($command);
   
    $command = "/bin/mv ".$dates[$idate]."/sur/*.nc sur/".$dates[$idate];
    print "command = $command\n";
    system($command);
    $command = "/bin/rm -r ".$dates[$idate]."/sur";
    print "command = $command\n";
    system($command);

    $command = "/bin/rm -r ".$dates[$idate];
    print "command = $command\n";
    system($command);
    
}

