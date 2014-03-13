#!/usr/local/bin/perl

sub prjGen
{
#### prj generation ######
$libraryName = "ahir";
$fileType = "vhdl";
addFileList($ahirLib_dir);

$libraryName = "ahir_ieee_proposed";
$fileType = "vhdl";
addFileList($ahirIEEElib_dir);

$libraryName = "work";
$fileType = "vhdl";
addFileList($VHDL_dir);

$libraryName = "work";
$fileType = "vhdl";
addFileList($VHDL_dir);

$libraryName = "work";
$fileType = "vhdl";
addFileList($VHDL_dir);

$libraryName = "work";
$fileType = "verilog";
addFileList($verilog_dir);

$libraryName = "work";
$fileType = "verilog";
addFileList($modifiedFiles_dir);
}



sub addFileList 
{
	my ($presentDir) = @_;
	print ("reading from ${presentDir}\n");
	opendir (DIR, $presentDir) || die "Error opening directory ${presentDir}\n";
	open(MYFILE, ">>", $oplist) || die "Error opening the prj file ${oplist}. Check permissions\n";
	my $count = 0;

# remove current and lower directory representatives from the search #
	@files = grep !/^\./, readdir(DIR);
####################################################################

	foreach(@files)
	{
		my $filename = $_;
		print MYFILE "${fileType} ${libraryName} ${presentDir}${l}${filename} \n";
		$count = $count + 1;
	}
	if ($count == 0) 
	{
		print "no file in the directory ${presentDir}\n";
	}	
	else
	{
		print MYFILE "\n\n";
	}
}
1;
