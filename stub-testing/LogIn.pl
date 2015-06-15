#!/usr/bin/perl
use lib '/home/mani/aws-tests';
use SOAP::Lite +trace => qw( debug );
use AscioServices;
$namespace = 'http://www.ascio.com/2007/01';

$query =
      SOAP::Data
->name(session =>
            \SOAP::Data->value(
            SOAP::Data->name(Account => 'test-account')->attr({xmlns => $namespace}),
            SOAP::Data->name(Password => 'test-password')->attr({xmlns => $namespace})
      ))->attr({xmlns => $namespace});

$ascio = new AscioServices();
$ascio->LogIn($query);
