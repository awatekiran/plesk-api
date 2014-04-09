#!/usr/bin/env ruby

require './plesk_api_client'

#host = ENV['REMOTE_HOST']
#login = ENV['REMOTE_LOGIN']
#password = ENV['REMOTE_PASSWORD']

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
				<filter>
					<name>
					#{$domain}
					</name>
				</filter>
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
				<filter>
					<name>
					#{$domain}
					</name>
				</filter>
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

def unsuspend(domain)
	print "Enter the domain to be activated > "
	$domain = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<site>
			<set>
				<filter>
					<name>
					#{$domain}
					</name>
				</filter>
				<values>
					<gen_setup>
						<status>0</status>
					</gen_setup>
				</values>
			</set>
		</site>
	</packet>
eof
	return $domain
	return $request
end

def bak_domain(domain)
	print "Enter the domain name which needs to be backed up > "
	$domain = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<backup-manager>
			<backup-webspace>
				<webspace-name>#{$domain}</webspace-name>
				<local/>
				<description>backup generate with script</description>
				<split-size>0</split-size>
			</backup-webspace>
		</backup-manager>
	</packet>
eof
	return $domain
	return $request
end

def bak_cust(customer)
	print "Enter the customer name > "
	cust = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<backup-manager>
			<customer-login>
			#{cust}
			</customer-login>
			<local/>
			<split-size>0</split-size>
		</backup-manager>
	</packet>
eof
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
	elsif c==4
		unsuspend(domain)
		puts $request
	elsif c==5
		bak_domain(domain)
		puts $request
	elsif c==6
		bak_cust(customer)
		puts $request		
	else
        print "Wrong Choice !!"
	end

	response = $client.request($request)
	puts response.body
end

get_response()