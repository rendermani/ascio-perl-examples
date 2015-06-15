use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IDomainService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('Whois')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(domainName => 'myDomain.com')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//WhoisResponse/WhoisResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//WhoisResponse/WhoisResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		$whoisData = $result->valueof('//WhoisResponse/whoisData');
		print "Whois : $whoisData";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}