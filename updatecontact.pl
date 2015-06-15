use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite -> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IContactService', $_[1] } ) -> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('UpdateContact')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(contact=>
		\SOAP::Data->value(
			SOAP::Data->name(Handle=> 'myContactHandle'),
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
	$response = $result->valueof('//UpdateContactResponse/UpdateContactResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}