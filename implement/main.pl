#!/usr/local/bin/perl

## include function files
require 'prjGen.pl';


######## inclusions, shell commands #########
use Cwd;
use File::Find;
use File::Copy;
$workingDir = getcwd();
$remove = "rm";         #remove call
$force = "-rf";	       #force switch
$l = "/";               #slash direction
$copyf = "cp";
$move = "mv";          #move call
$createFile = "touch";


### initiation #######
$fileType = "vhdl";
$libraryName = "work";
$xstDir = "${workingDir}${l}xst"; 
$oplist = "${xstDir}${l}pcie.prj";
system("$remove $force $oplist");
system("$createFile $oplist");

######## paths for all files to be included in synthesis ###########
$HDL_dir = "${workingDir}${l}..${l}hdl"; 
$VHDL_dir = "${HDL_dir}${l}vhdl";
$verilog_dir = "${HDL_dir}${l}verilog";
$ahirLib_dir = "${HDL_dir}${l}ahir";
$ahirIEEElib_dir = "${HDL_dir}${l}ahir_ieee_proposed";
$modifiedFiles_dir = "${HDL_dir}${l}modified";

&prjGen;
