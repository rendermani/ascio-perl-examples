use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite -> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IContactService', $_[1] } ) -> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetContact')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(contactHandle=> 'myContactHandle')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetContactResponse/GetContactResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	if ($response->{'ResultCode'} == 200) {
		my $contact = $result->valueof('//GetContactResponse/contact');
		print "Name : $contact->{'FirstName'} $contact->{'LastName'}\r\n";
		print "OrgName : $contact->{'OrgName'}\r\n";
		print "Address1 : $contact->{'Address1'}\r\n";
		print "Address2 : $contact->{'Address2'}\r\n";
		print "City : $contact->{'City'}\r\n";
		print "PostalCode : $contact->{'PostalCode'}\r\n";
		print "State : $contact->{'State'}\r\n";
		print "Country : $contact->{'CountryCode'}\r\n";
		print "Email : $contact->{'Email'}\r\n";
		print "Phone : $contact->{'Phone'}\r\n";
		print "Fax : $contact->{'Fax'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}