#!/usr/local/bin/perl

######## shell commands and paths ########
use Cwd;
use File::Find;
use File::Copy;
my $dir = getcwd();
my $remove = "rm";
my $force = "-rf";
my $l = "/";
my $createFile = "touch";
my $templateDir = "templates";
$opFile = "chnl_tester.v";
$chnlTemplate = "${templateDir}${l}chnl_wrapper.v";
$riffa2ahirTemplate = "${templateDir}${l}riffa2ahir_inst.v";
$ahirTemplate = "${templateDir}${l}ahir_system_inst.v";


########## string patterns ##########
$riffa2ahir_pat = "__riffa2ahir_slave_instance";
$ahirSys_pat = "__ahir_system_instance";
$null_pipe = "";
$txLen_pat = "__out_length_parameter_declaration";
$chnlIndex_pat = "__CHNL_INDEX__";

### create blank chnl_tester file to write on ###
system("$remove $force $opFile");
system("$createFile $opFile");

@in_pipe_names;
@out_pipe_names;
@out_data_len;

print "how many channels do you need?\n";
$num_chnls = <STDIN>;
if (($num_chnls>12)||($num_chnls<1))
{
	print "specified number of channels is illegal. Should be between 1 to 12\n";
	exit 1;
}


for ($i = 0; $i < $num_chnls; $i = $i + 1)
{
	print "what is the name of input pipe on chnl no. ${i}? Leave blank if there is no pipe on this port \n";
	$in_pipe_names[$i] = <STDIN>;
	chomp $in_pipe_names[$i];
	if ($in_pipe_names[$i] ne $null_pipe)
	{
		$in_pipe_names[$i] = "dummy${i}_in";
	}
	print "what is the name of output pipe on chnl no. ${i}? Leave blank if there is no pipe on this port \n";
	$out_pipe_names[$i] = <STDIN>;
	chomp $out_pipe_names[$i];
	if ($out_pipe_names[$i] ne $null_pipe)
	{
		print "enter the length of data to be transmitted on pipe $out_pipe_names[$i]\n";
		$out_data_len[$i] = <STDIN>;
		chomp $out_data_len[$i];
	}
	else
	{
		$out_pipe_names[$i] = "dummy${i}_out";
		$out_data_len[$i] = "0";
	}
}

open(INFILE1, "<", $chnlTemplate) or die ("cannot open ${chnlTemplate} : $!\n");
open(INFILE2, "<", $riffa2ahirTemplate) or die ("cannot open ${riffa2ahirTemplate} : $!\n");
open(INFILE3, "<", $ahirTemplate) or die ("cannot open ${ahirTemplate} : $!\n");
@chnlTemp = <INFILE1>; 
@interface = <INFILE2>;
@ahirSys = <INFILE3>;
chomp @chnlTemp;
chomp @interface;
close(INFILE1);
close(INFILE2);
close(INFILE3);


open(OUTFILE, ">>", $opFile) or die ("cannot open ${opFile} : $!\n");; 

my $line_count = 0;
foreach (@chnlTemp)
{
	$line_count = $line_count + 1;
	my $s = $_;
	$s =~ s/\s+//g;
	if ($s eq $txLen_pat)
	{
		&txLenDeclare;
	}
			
	elsif ($s eq $riffa2ahir_pat)
	{
		&riffa2ahirInstantiate;	
	}
	elsif ($s eq $ahirSys_pat)
	{
		last;
	}
	else
	{
	print OUTFILE "$_\n";
	}
}





sub txLenDeclare
{
	for ($i = 0; $i < $num_chnls; $i = $i + 1)
	{
		print OUTFILE "	parameter CHNL${i}_OUT_DATA_LEN = 32\'d$out_data_len[$i]";
		if ($i == $num_chnls-1)
		{
			print OUTFILE "\n";
		}
		else
		{
			print OUTFILE ",\n";
		}
	}	
}

sub riffa2ahirInstantiate
{
	for ($i = 0; $i < $num_chnls; $i = $i + 1)
	{
		my $chnlIndex = "$i";
		foreach(@interface)
		{
			my $toPrintLine = $_;
			$toPrintLine =~ s/${chnlIndex_pat}/${chnlIndex}/g;			
			print OUTFILE "$toPrintLine\n";
		}
	}
}		
