#!/usr/bin/perl

use LWP::UserAgent;
use LWP::Protocol::https;
use strict;
use warnings;

# the perl script is used to test sendmail function of my server
# It post a http request via https.
# user authentication message is needed.

# This is the sendMail URL, with API provided by server.
my $url = 'https://xxx/sendMail';

# param
my $from = '';
my $to = '';
my $subject = 'Send mail test';
my $content = 'Hello mail';

# Username
my $username = '';

# Makes a prompt for you to enter your password
my $password;
print "Enter password: ";
system('stty','-echo');
chop($password=<STDIN>);
system('stty','echo');

my $ua = LWP::UserAgent->new();
$ua->protocols_allowed(['https']);

my $response = $ua->post($url,
                    Content_Type => 'form-data',
                    Content => [from => $from,
                    to => $to,
                    subject => $subject,
                    content => $content
                    user_name => $username,
		    password => $password
                    ]);

printf "GG %s\n", $response->status_line;
my $resp_cont = $response->content();
print "GG $resp_cont\n";

