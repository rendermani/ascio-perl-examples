use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IRegistrantService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('CreateRegistrant')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(registrant=>
		\SOAP::Data->value(
			SOAP::Data->name(Name=> 'John Doe'),
			SOAP::Data->name(OrgName=> 'Doe Inc'),
			SOAP::Data->name(Address1=> '10 Main Street'),
			SOAP::Data->name(Address2=> ''),
			SOAP::Data->name(PostalCode=> '2200'),
			SOAP::Data->name(City=> 'Copenhagen'),
			SOAP::Data->name(State=> 'CPH'),
			SOAP::Data->name(CountryCode=> 'DK'),
			SOAP::Data->name(Email=> 'JohnDoe@doe.com'),
			SOAP::Data->name(Phone=> '+45.00000000'),
			SOAP::Data->name(Fax=> '+45.00000000')
			)
		)
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//CreateRegistrantResponse/CreateRegistrantResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	if ($response->{'ResultCode'} == 200) {
		my $registrant = $result->valueof('//CreateRegistrantResponse/registrant');
		print "Handle : $registrant->{'Handle'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}