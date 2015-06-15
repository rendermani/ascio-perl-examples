use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite -> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IOrderService', $_[1] } ) -> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('CreateOrder')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(order =>
		\SOAP::Data->value(
			SOAP::Data->name(Type => 'Register_Domain'),
			SOAP::Data->name(Comments => 'Order Test'),
			SOAP::Data->name(Domain =>
				\SOAP::Data->value(
					SOAP::Data->name(DomainName => 'myDomain.com'),
					SOAP::Data->name(RegPeriod => '1'),
					SOAP::Data->name(AuthInfo => 'mysecret'),
					SOAP::Data->name(Comment => 'Domain Test'),
					SOAP::Data->name(Registrant =>
						\SOAP::Data->value(
							SOAP::Data->name(Name=> 'John Doe'),
							SOAP::Data->name(OrgName=> 'Doe Inc'),
							SOAP::Data->name(Address1=> '10 Main Street'),
							SOAP::Data->name(Address2=> ''),
							SOAP::Data->name(City=> 'Copenhagen'),
							SOAP::Data->name(State=> 'CPH'),
							SOAP::Data->name(PostalCode=> '2200'),
							SOAP::Data->name(CountryCode=> 'DK'),
							SOAP::Data->name(Email=> 'JohnDoe@doe.com'),
							SOAP::Data->name(Phone=> '+45.00000000'),
							SOAP::Data->name(Fax=> '+45.00000000')
							)
						),
					SOAP::Data->name(AdminContact =>
						\SOAP::Data->value(
							SOAP::Data->name(Handle => 'myAdminHandle')
							)
						),
					SOAP::Data->name(TechContact =>
						\SOAP::Data->value(
							SOAP::Data->name(Handle => 'myTechHandle')
							) 
						),
					SOAP::Data->name(BillingContact =>
						\SOAP::Data->value(
							SOAP::Data->name(Handle => 'myBillingHandle')
							) 
						),
					SOAP::Data->name(NameServers =>
						\SOAP::Data->value(
							SOAP::Data->name(NameServer1 =>
								\SOAP::Data->value(
									SOAP::Data->name(HostName => 'ns1.ascio.com')
									)
								),
							SOAP::Data->name(NameServer2 =>
								\SOAP::Data->value(
									SOAP::Data->name(HostName => 'ns2.ascio.com')
									)
								)
							)
						)
					)
)
))
);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//CreateOrderResponse/CreateOrderResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//CreateOrderResponse/CreateOrderResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		$order = $result->valueof('//CreateOrderResponse/order');
		print "OrderId : $order->{'OrderId'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}