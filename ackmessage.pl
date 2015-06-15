use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IMessageQueueService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('AckMessage')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(msgId => myMsgId)
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//AckMessageResponse/AckMessageResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//AckMessageResponse/AckMessageResult/Values/[>0]')), "\n";
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}