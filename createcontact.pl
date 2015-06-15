use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IContactService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('CreateContact')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(contact=>
		\SOAP::Data->value(
			SOAP::Data->name(FirstName=> 'John'),
			SOAP::Data->name(LastName=> 'Doe'),
			SOAP::Data->name(Address1=> '10 Main Street'),
			SOAP::Data->name(Address2=> ''),
			SOAP::Data->name(PostalCode=> '2200'),
			SOAP::Data->name(City=> 'Copenhagen'),
			SOAP::Data->name(State=> 'CPH'),
			SOAP::Data->name(CountryCode=> 'DK'),
			SOAP::Data->name(Email=> 'JohnDoe@doe.com'),
			SOAP::Data->name(Phone=> '+45.12345678'),
			SOAP::Data->name(Fax=> '+45.12345679')
			)
		)
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//CreateContactResponse/CreateContactResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	if ($response->{'ResultCode'} == 200) {
		my $contact = $result->valueof('//CreateContactResponse/contact');
		print "Handle : $contact->{'Handle'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}