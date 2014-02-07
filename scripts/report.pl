#!/usr/bin/perl

use LWP::UserAgent;
use LWP::Protocol::https;
use strict;
use warnings;

# This is the URL you must use to report
my $url = 'https://xxx/report';

my $num_args = $#ARGV + 1;
if ($num_args != 2)
{
  print "\nUsage: perl report.pl id_number to\n";
  exit;
}

my $id   = $ARGV[0];
my $to   = $ARGV[1];

# param

my $ua = LWP::UserAgent->new();
$ua->protocols_allowed(['https']);

my $response = $ua->post($url,
                    Content_Type => 'form-data',
                    Content => [id => $id,
                    to => $to
                    ]);

printf "GG %s\n", $response->status_line;
my $response_content = $response->content();
print "GG $response_content\n";
print "end."

