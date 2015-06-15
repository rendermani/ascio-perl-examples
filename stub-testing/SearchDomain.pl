#!/usr/bin/perl
use Data::Dumper;

#debug request: 
 
use SOAP::Lite +trace =>  qw(debug);

#use SOAP::Lite;
use strict;
use warnings; 
use AscioServices qw(:all);

# I have no idea why the namespace declaration is needed, because other parsers can extract the proper namespace out of the WSDL
# Other programming languages don't need a namespace definion. Probably because the proper targetNamespace is in the included schema.
# Had to fix the Stub-Classes, because the wrong NS was there too. 

my $ns = 'http://www.ascio.com/2007/01';

my $loginQuery =
      SOAP::Data
->name(session =>
            \SOAP::Data->value(
            SOAP::Data->name(Account => 'testing-account'),
            SOAP::Data->name(Password => 'testing-password')
      ))->attr({xmlns => $ns});

my @loginResult = LogIn($loginQuery);
my $sessionId =  $loginResult[1];

# do registrant verification:

my $clauses = SOAP::value(
	SOAP::Data->name(Clause => 
		SOAP::value(
			SOAP::Data->name(Attribute => "DomainName"),
			SOAP::Data->name(Operator => "Is"),
			SOAP::Data->name(Value => "whmcs-test-manuel.co")
		)
	)
);


my @query = ( 
 	SOAP::Data->name(sessionId => $sessionId), 
 	SOAP::Data->name('criteria' => 
 		\SOAP::Data->value( 
 			SOAP::Data->name('Clauses' => 
 				\SOAP::Data->value( 
 					SOAP::Data->name('Clause' => 
						\SOAP::Data->value( 
							SOAP::Data->name('Attribute'=> 'DomainName'), 
							SOAP::Data->name('Operator'=> 'Like'), 
							SOAP::Data->name('Value'=> 'group%') 
 						) 
 					), 
 				)
 			), 
 			SOAP::Data->name('Mode'=> 'Strict'), 
 			SOAP::Data->name('Withstates' => 
 				\SOAP::Data->value( 
 					SOAP::Data->name('string'=> 'active')->attr({xmlns=> 'http://schemas.microsoft.com/2003/10/Serialization/Arrays'})->type(""), 
 					SOAP::Data->name('string'=> 'deleted')->attr({xmlns=> 'http://schemas.microsoft.com/2003/10/Serialization/Arrays'})->type("") 
 				)
			) 
 		) 
 	)  
 );  
my @result = SearchDomain(@query)->attr({xmlns => $ns}); ;
print "Result SearchDomain\n\n";
print "soap_sample() \@results: ", Dumper(@result);
