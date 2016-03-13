use strict;
use File::Basename;
use argola;
use chobak_fnm;

my $callidvr;
my $outerfile;
my $outerfdir;
my $outerfbas;
my $outerfext;
my $outerfok;
my $theftype;
my $nfsedir;

my $edbase;
my $edflag;
my $edfile;
my $cmdon;



# Now find out where everything is stored:
$nfsedir = $ENV{"NFS_EDIT_PRG_DIR"};
if ( $nfsedir eq "" )
{
  die "\n"
  . "Failed to specify edit directory environment variable:\n"
  . "  NFS_EDIT_PRG_DIR:\n"
  . "\n";
}

if ( !( -d $nfsedir ) )
{
  die "\n"
  . "No such directory:\n"
  . "  " . $nfsedir . ":\n"
  . "Check environment variable: NFS_EDIT_PRG_DIR:\n"
  . "\n";
}



# Establish CallID Variable:
sleep(2); # Just to prevent the last remaining possible cause of duplication:
$callidvr = `date +%s`; chomp($callidvr);
$callidvr .= "-" . $$;

#system("echo",$callidvr);

if ( !(&argola::yet()) )
{
  die "\nNo target file specified:\n\n";
}

$outerfile = &argola::getrg();
$outerfdir = dirname($outerfile);

if ( ! ( -d ( $outerfdir ) ) )
{
  die "\nNo directory containing file:\n    " . $outerfile . ":\n\n";
}


# Now we figure out what the file type is:

$outerfbas = $outerfile;
$outerfok = &chobak_fnm::oneext($outerfbas,$outerfext);
$theftype = "txt";
if ( $outerfok ) { $theftype = $outerfext; }


$edbase = $nfsedir . "/" . $callidvr . "-b.txt";
$edflag = $nfsedir . "/" . $callidvr . "-f.txt";
$edfile = $nfsedir . "/" . $callidvr . "-e." . $theftype;


if ( -f $outerfile )
{
  system("cp",$outerfile,$edfile);
}
$cmdon = "| cat >";
&argola::wraprg_lst($cmdon,$edbase);
open TAK, $cmdon;
print TAK $theftype . "\n";
close TAK;
system("touch",$edflag);


system("echo","Beginning NFS edit of: " . $outerfile . ":");
while ( -f $edflag )
{
  sleep(2);
}
system("echo","Finishing NFS edit of: " . $outerfile . ":");
system("cp",$edfile,$outerfile);



system("rm","-rf",$edbase,$edflag,$edfile);




