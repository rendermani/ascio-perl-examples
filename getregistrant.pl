use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IRegistrantService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetRegistrant')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(registrantHandle=> 'myRegistrantHandle')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetRegistrantResponse/GetRegistrantResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	if ($response->{'ResultCode'} == 200) {
		my $registrant = $result->valueof('//GetRegistrantResponse/registrant');
		print "Name : $registrant->{'Name'}\r\n";
		print "OrgName : $registrant->{'OrgName'}\r\n";
		print "Address1 : $registrant->{'Address1'}\r\n";
		print "Address2 : $registrant->{'Address2'}\r\n";
		print "City : $registrant->{'City'}\r\n";
		print "PostalCode : $registrant->{'PostalCode'}\r\n";
		print "State : $registrant->{'State'}\r\n";
		print "Country : $registrant->{'CountryCode'}\r\n";
		print "Email : $registrant->{'Email'}\r\n";
		print "Phone : $registrant->{'Phone'}\r\n";
		print "Fax : $registrant->{'Fax'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}