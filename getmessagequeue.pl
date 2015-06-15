use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IMessageQueueService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetMessageQueue')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(msgId => myMsgId)
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetMessageQueueResponse/GetMessageQueueResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//GetMessageQueueResponse/GetMessageQueueResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		$item = $result->valueof('//GetMessageQueueResponse/item');
		print "MessageId : $item->{'MsgId'}\r\n";
		print "OrderId : $item->{'OrderId'}\r\n";
		print "OrderStatus : $item->{'OrderStatus'}\r\n";
		print "DomainHandle : $item->{'DomainHandle'}\r\n";
		print "DomainName : $item->{'DomainName'}\r\n";
		print "MessageType : $item->{'MsgType'}\r\n";
		foreach($item->{'StatusList'}->{'CallbackStatus'}) {
			print "$_->{'Status'} : $_->{'Message'}";
		}
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}