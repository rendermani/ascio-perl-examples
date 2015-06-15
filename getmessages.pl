use SOAP::Lite;
$proxy = 'https://awtest.ascio.com/AscioServices';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IOrderService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetMessages')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(orderId=> 'myOrderId')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetMessagesResponse/GetMessagesResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	@messages = $result->valueof('//GetMessagesResponse/messages/[>0]');
	foreach(@messages) {
		print "Created : $_->{'Created'}\r\n";
		print "Subject : $_->{'Subject'}\r\n";
		print "Body : $_->{'Body'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}