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
$ahirTemplate = "${templateDir}${l}ahirPorts_inst.v";


########## string patterns ##########
$riffa2ahir_pat = "__riffa2ahir_slave_instance";
$ahirSys_pat = "__ahirSys_port_declaration";
$null_pat = "";
$txLen_pat = "__out_length_parameter_declaration";
$chnlIndex_pat = "__CHNL_INDEX__";
$inPipe_pat = "__in_pipe_name__";
$outPipe_pat = "__out_pipe_name__";

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
	print "what is the name of output pipe on chnl no. ${i}? Leave blank if there is no pipe on this port \n";
	$out_pipe_names[$i] = <STDIN>;
	chomp $out_pipe_names[$i];
	if ($out_pipe_names[$i] ne $null_pat)
	{
		print "enter the length of data to be transmitted on pipe $out_pipe_names[$i]\n";
		$out_data_len[$i] = <STDIN>;
		chomp $out_data_len[$i];
	}
	else
	{
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
chomp @ahirSys;
close(INFILE1);
close(INFILE2);
close(INFILE3);
$numPorts = @ahirSys;
&removeFalsePorts;

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
		&ahirSysInstantiate;
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

sub ahirSysInstantiate
{
	for ($i = 0; $i < $num_chnls; $i = $i + 1)
	{
		my $chnlIndex = "$i";
		my $portCount = 0;
		foreach(@ahirSys)
		{
			$portCount = $portCount + 1;
			my $toPrintLine = $_;
			if (($toPrintLine =~ /${inPipe_pat}/) && ($in_pipe_names[$i] eq $null_pat)){;}
			elsif (($toPrintLine =~ /${outPipe_pat}/) && ($out_pipe_names[$i] eq $null_pat)){;}
			else
			{
				$toPrintLine =~ s/${inPipe_pat}/$in_pipe_names[$i]/g;
				$toPrintLine =~ s/${outPipe_pat}/$out_pipe_names[$i]/g;
				$toPrintLine =~ s/${chnlIndex_pat}/${chnlIndex}/g;			
				print OUTFILE "$toPrintLine";
				if ($portCount == $numPorts)
				{
					if ($i == $num_chnls - 1)
					{
						print OUTFILE "\n";
					}
					else
					{
						print OUTFILE ",\n";
					}
				}
				else
				{
					print OUTFILE "\n";
				}
			}
		}		
	}
}	

sub removeFalsePorts
{
	for ($i=0; $i < $numPorts; $i = $i + 1)
	{
		my $s = $ahirSys[$i];
		$s =~ s/\s+//g;
		if ($s eq $null_pat)
		{
			splice(@ahirSys, $i,  1);
			$i = $i - 1;	 
			$numPorts = $numPorts - 1;
		}
	}
}
