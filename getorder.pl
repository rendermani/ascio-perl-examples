use SOAP::Lite;
$proxy = 'https://awtest.ascio.com/AscioServices';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IOrderService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetOrder')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'MySessionId'),
	SOAP::Data->name(orderId => 'MyOrderId')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetOrderResponse/GetOrderResult');
	$order = $result->valueof('//GetOrderResponse/order');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "OrderId : $order->{'OrderId'}\r\n";
	print "OrderStatus : $order->{'Status'}\r\n";
	print "OrderType : $order->{'Type'}\r\n";
	print "DomainName : $order->{'Domain'}->{'DomainName'}\r\n";
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}