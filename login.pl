use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/ISessionService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('LogIn')
->attr({xmlns => $namespace});
$query = SOAP::Data
->name(session =>
	\SOAP::Data->value(
		SOAP::Data->name(Account => 'myusername'),
		SOAP::Data->name(Password => 'mypassword')
		));
$result = $soap->call($method => $query);
unless ($result->fault) {
	my $response = $result->valueof('//LogInResponse/LogInResult');
	my $sessionId= $result->valueof('//LogInResponse/sessionId');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "SessionId is $sessionId\r\n";
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}