use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IOrderService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('SearchOrder')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name('orderType' =>
		\SOAP::Data->value(
			SOAP::Data->name('OrderType' => 'Register_Domain'),
			SOAP::Data->name('OrderType' => 'Contact_Update')
			)
		),
	SOAP::Data->name('orderStatus' =>
		\SOAP::Data->value(
			SOAP::Data->name('OrderStatusType' => 'Completed'),
			SOAP::Data->name('OrderStatusType' => 'Failed')
			)
		),
	SOAP::Data->name(domainName=> 'mydomain.com')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//SearchOrderResponse/SearchOrderResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//SearchOrderResponse/SearchOrderResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		@results = $result->valueof('//SearchOrderResponse/orders/Order');
		foreach(@results) {
			print "OrderId : $_->{'OrderId'}\r\n";
			print "OrderStatus : $_->{'Status'}\r\n";
			print "OrderType : $_->{'Type'}\r\n";
		}
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}