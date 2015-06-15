use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IDomainService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('AvailabilityCheck')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name('domains' =>
		\SOAP::Data->value(
			SOAP::Data->name('string'=> 'myDomain'),
			SOAP::Data->name('string'=> 'myDomain2')
			)
		),
	SOAP::Data->name('tlds' =>
		\SOAP::Data->value(
			SOAP::Data->name('string'=> 'com'),
			SOAP::Data->name('string'=> 'net'),
			SOAP::Data->name('string'=> 'info')
			)
		),
	SOAP::Data->name(quality => 'Live')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//AvailabilityCheckResponse/AvailabilityCheckResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//AvailabilityCheckResponse/AvailabilityCheckResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		@results = $result->valueof('//AvailabilityCheckResponse/results/AvailabilityCheckResult');
		foreach(@results) {
			print "DomainName : $_->{'DomainName'}\r\n";
			print "StatusCode : $_->{'StatusCode'}\r\n";
			print "StatusMessage : $_->{'StatusMessage'}\r\n";
			print "Quality : $_->{'Quality'}\r\n";
		}
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}