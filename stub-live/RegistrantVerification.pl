#!/usr/bin/perl
use Data::Dumper;

#debug request: 

#use SOAP::Lite +trace =>
#    qw(debug);

use SOAP::Lite;

use AscioServices qw(:all);

# I have no idea why the namespace declaration is needed, because other parsers can extract the proper namespace out of the WSDL
# Other programming languages don't need a namespace definion. Probably because the proper targetNamespace is in the included schema.
# Had to fix the Stub-Classes, because the wrong NS was there too. 

my $ns = 'http://www.ascio.com/2007/01';

my $query =
      SOAP::Data
->name(session =>
            \SOAP::Data->value(
            SOAP::Data->name(Account => 'live-account'),
            SOAP::Data->name(Password => 'live-password')
      ))->attr({xmlns => $ns});

my @result = LogIn($query);
my $sessionId =  @result[1];

# do registrant verification:

my @query = SOAP::Data->value(
	SOAP::Data->name(sessionId => $sessionId)->attr({xmlns => $ns}), 
	SOAP::Data->name(value => 'example-email@email.com')->attr({xmlns => $ns})
);

my @result = DoRegistrantVerification(@query);
print "Result DoRegistrantVerification\n\n";
print "soap_sample() \@results: ", Dumper(@result);


# look if registrant is verified, long information: 

my @query = SOAP::Data->value(
	SOAP::Data->name(sessionId => $sessionId)->attr({xmlns => $ns}), 
	SOAP::Data->name(value => 'example-email@email.com')->attr({xmlns => $ns})
);

my @result = GetRegistrantVerificationInfo(@query);
print "Result GetRegistrantVerificationInfo\n\n";
print "soap_sample() \@results: ", Dumper(@result);


# look if registrant is verified, short information: 

my @query = SOAP::Data->value(
	SOAP::Data->name(sessionId => $sessionId)->attr({xmlns => $ns}), 
	SOAP::Data->name(value => 'example-email@email.com')->attr({xmlns => $ns})
);

my @result = GetRegistrantVerificationStatus(@query);
print "Result GetRegistrantVerificationStatus\n\n";

print "soap_sample() \@results: ", Dumper(@result);