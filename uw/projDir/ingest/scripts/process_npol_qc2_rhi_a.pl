#!/usr/bin/perl

$IN_DIR = "/home/disk/bob/olympex/raw/npol_qc2/rhi/20151213/rhi_a";
$PARAM_DIR = "/home/disk/meso-home/meso/git/lrose-uw-olympex/uw/projDir/ingest/params";

chdir($IN_DIR);

foreach $file (<*rhi_00-20.uf>) {
  print "file = $file\n";
  ($yyyymmdd,$hhmmss) = ($file =~ /olympex_NPOL1_(.*)_(.*)_rhi_00-20\.uf/);
  $file1 = "olympex_NPOL1_".$yyyymmdd."_".$hhmmss."_rhi_00-20.uf";
  $file2 = "olympex_NPOL1_".$yyyymmdd."_".$hhmmss."_rhi_20-40.uf";
  print "file1 = $file1\n";
  print "file2 = $file2\n";
  if (-e $file2) {
    $command = "RadxConvert -v -params ".$PARAM_DIR."/RadxConvert.npol_qc.rhi -f ".$IN_DIR."/".$file1." ".$IN_DIR."/".$file2;
    #print "command = $command\n";
    system($command);
  } else {
    $command = "RadxConvert -v -params ".$PARAM_DIR."/RadxConvert.npol_qc.rhi -f ".$IN_DIR."/".$file1;
    #print "command = $command\n";
    system($command);
  }
}

