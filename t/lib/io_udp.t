#!./perl

BEGIN {
    chdir 't' if -d 't';
    @INC = '../lib' if -d '../lib';
    require Config; import Config;
    if ( ($Config{'extensions'} !~ /\bSocket\b/ ||
          $Config{'extensions'} !~ /\bIO\b/)    &&
          !(($^O eq 'VMS') && $Config{d_socket})) {
	print "1..0\n";
	exit 0;
    }
}

$| = 1;
print "1..3\n";

use Socket;
use IO::Socket qw(AF_INET SOCK_DGRAM INADDR_ANY);

$udpa = IO::Socket::INET->new(Proto => 'udp', Addr => 'localhost');
$udpb = IO::Socket::INET->new(Proto => 'udp', Addr => 'localhost');

print "ok 1\n";

$udpa->send("ok 2\n",0,$udpb->sockname);
$rem = $udpb->recv($buf="",5);
print $buf;
$udpb->send("ok 3\n");
$udpa->recv($buf="",5);
print $buf;
