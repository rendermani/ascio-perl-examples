use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/INameServerService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetNameServer')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name('nameServerHandle' => 'myNameServerHandle')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetNameServerResponse/GetNameServerResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//GetNameServerResponse/GetNameServerResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'}==200) {
		$nameServer= $result->valueof('//GetNameServerResponse/nameServer');
		print "NameServer Handle : $nameServer->{'Handle'}\r\n";
		print "NameServer HostName : $nameServer->{'HostName'}\r\n";
		print "NameServer IPAddress : $nameServer->{'IpAddress'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}