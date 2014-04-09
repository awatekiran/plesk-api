#!/usr/bin/env ruby

require './plesk_api_client'

#host = ENV['REMOTE_HOST']
#login = ENV['REMOTE_LOGIN']
#password = ENV['REMOTE_PASSWORD']
#host = ENV['172.16.142.83']
#login = ENV['admin']
#password = ENV['qwedsa@123']
print "Enter host IP > "
host = gets.chomp()

login = "Admin"

print "Enter password for the host > "
password = gets.chomp()

$client = PleskApiClient.new(host)
$client.set_credentials(login, password)

puts $client

#request = <<eof
#<packet version="1.6.5.0">
#  <server>
#    <get_protos/>
#  </server>
#</packet>
#eof
$request = ''
$domain = ''

def api()
$request = <<eof
<packet version="1.6.5.0">
<server>
<get_protos/>
</server>
</packet>
eof
return $request
end

def stat(domain)
print "Enter domain name > "
$domain = gets.chomp()
$request = <<eof
<packet version="1.6.5.0">
<site>
<get>
<filter><name>#{$domain}</name></filter>
<dataset>
<gen_info/>
</dataset>
</get>
</site>
</packet>
eof
return $domain
return $request
end

def suspend(domain)
print "Enter domain to be suspended > "
$domain = gets.chomp()
$request = <<eof
<packet version="1.6.5.0">
<site>
<set>
<filter><name>#{$domain}</name></filter>
<values>
<gen_setup>
<status>8</status>
</gen_setup>
</values>
</set>
</site>
</packet>
eof
return $domain
return $request
end

def get_response()
puts "1. Check API
2. Check domain stat
3. Suspend the domain"

print "Enter your choice > "
input = gets.chomp()
c = Integer(input)

if c==1
	api()
	print $request
elsif c==2
	stat($domain)
	print $request
elsif c==3
	suspend($domain)
	puts $request
else 
	print "Wrong Choice !!"
end	

response = $client.request($request)
puts response.body
end
get_response()
