
use Net::SMTP;

my $num_args = $#ARGV + 1;
if ($num_args != 4)
{
  print "\nUsage: perl mail.pl xxx xxx xxx xxx\n";
  exit;
}


my $argv0   = $ARGV[0];
my $argv1   = $ARGV[1];
my $argv2   = $ARGV[2];
my $argv3   = $ARGV[3];

my $cmd = "$argv0 $argv1 $argv2 $argv3";

# Execute the command.
#system($cmd);

# Send mail after command execution.
$smtp = Net::SMTP->new('smtphost.xxx.com'); # connect to an SMTP server
$smtp->mail( 'xxx@xxx.com' );           # use the sender's address here
$smtp->to('xxx@xxx.com');               # recipient's address
$smtp->data();                                   # Start the mail

# Send the header.
$smtp->datasend("To: <Your Name> xxx@xxx.com\n");
$smtp->datasend("From: <Your Name> xxx@xxx.com\n");
$smtp->datasend("Subject: xxx!\n");

# Send the body.
$smtp->datasend("Content: xxx\n");
$smtp->dataend();                   # Finish sending the mail
$smtp->quit;                        # Close the SMTP connection
