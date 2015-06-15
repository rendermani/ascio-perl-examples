use SOAP::Lite;
$proxy = 'https://awstest.ascio.com/2012/01/01/AscioService.svc';
$namespace = 'http://www.ascio.com/2007/01';
$soap = SOAP::Lite -> on_action( sub { join '/', 'http://www.ascio.com/2007/01/IDomainService', $_[1] } ) -> proxy($proxy);
$soap->autotype(0);
$method = SOAP::Data->name('GetDomain')
->attr({xmlns => $namespace});
@query = (
	SOAP::Data->name(sessionId => 'mySessionId'),
	SOAP::Data->name(domainHandle => 'myDomainHandle')
	);
$result = $soap->call($method => @query);
unless ($result->fault) {
	$response = $result->valueof('//GetDomainResponse/GetDomainResult');
	print "ResultCode : $response->{'ResultCode'}\r\n";
	print "Message : $response->{'Message'}\r\n";
	if ($response->{'ResultCode'} == 200) {
		my $domain = $result->valueof('//GetDomainResponse/domain');
		print "DomainName : $domain->{'DomainName'}\r\n";
		print "DomainHandle : $domain->{'DomainHandle'}\r\n";
		print "DomainStatus : $domain->{'Status'}\r\n";
		print "Registrant-Handle : $domain->{'Registrant'}->{'Handle'}\r\n";
		print "Registrant-Name : $domain->{'Registrant'}->{'Name'}\r\n";
		print "Admin-Handle : $domain->{'AdminContact'}->{'Handle'}\r\n";
		print "Tech-Handle : $domain->{'TechContact'}->{'Handle'}\r\n";
		print "Billin-gHandle : $domain->{'BillingContact'}->{'Handle'}\r\n";
		print "NameServer1-HostName : $domain->{'NameServers'}->{'NameServer1'}->{'HostName'}\r\n";
		print "NameServer2-HostName : $domain->{'NameServers'}->{'NameServer2'}->{'HostName'}\r\n";
	}
}
else {
	print join ', ',
	$result->faultcode,
	$result->faultstring,
	$result->faultdetail;
}