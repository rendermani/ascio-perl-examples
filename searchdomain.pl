use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite
-> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IDomainService', $_[1] } )
-> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('SearchDomain')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name('criteria' =>
		\SOAP::Data->value(
			SOAP::Data->name('Clauses' =>
				\SOAP::Data->value(
					SOAP::Data->name('Clause' =>
						\SOAP::Data->value(
							SOAP::Data->name('Attribute'=> 'DomainName'),
							SOAP::Data->name('Operator'=> 'Like'),
							SOAP::Data->name('Value'=> 'ascio%')
							)
						),
					)
				),
			SOAP::Data->name('Mode'=> 'Strict'),
			SOAP::Data->name('Withstates' =>
				\SOAP::Data->value(
					SOAP::Data->name('string'=> 'active')->attr({xmlns=> 'http://schemas.microsoft.com/2003/10/Serialization/Arrays'})->type(""),
					SOAP::Data->name('string'=> 'deleted')->attr({xmlns=> 'http://schemas.microsoft.com/2003/10/Serialization/Arrays'})->type("")
					)
				)
			)
		)
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//SearchDomainResponse/SearchDomainResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	print "Values: ", join(', ', $result->valueof('//SearchDomainResponse/SearchDomainResult/Values/[>0]')), "\n";
	if ($response->{'ResultCode'} == 200) {
		@results = $result->valueof('//SearchDomainResponse/domains/Domain');
		foreach(@results) {
			print "DomainName : $_->{'DomainName'}\r\n";
			print "Status : $_->{'Status'}\r\n";
		}
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}