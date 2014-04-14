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

def sus_site(domain)
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

def unsus_site(domain)
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

def sus_cust(customer)
	print "Enter the customer name > "
	cust = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<customer>
			<filter>
				<login>#{cust}</login>
			</filter>
			<values>
				<gen_info>
					<status>16</status>
				</gen_info>
			</values>
		<customer>
	</packet>
eof
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
				<description>backup generated with script</description>
				<split-size>0</split-size>
			</backup-webspace>
		</backup-manager>
	</packet>
eof
	return $domain
	return $request
end

def bak_list($domain)
	print "Enter the domain name > "
	$domain = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<backup-manager>
			<get-local-backup-list>
				<webspace-name>#{$domain}</webspace-name>
			</get-local-backup-list>
		</backup-manager>
	</packet>
eof
	return $domain
	return $request
end

def down_bak(domain)
	print "Enter the domain name > "
	$domain = gets.chomp()
	print "Enter filename > "
	fname = gets.chomp()
	$request = <<eof
	<packet version="1.6.5.0">
		<backup-manager>
			<download-file>
				<webspace-name>#{$domain}</webspace-name>
				<filename>#{fname}</filename>
			</download-file>
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
	3. Suspend the domain
	4. Unsuspend the domain
	5. Suspend customer
	6. List present backup
	7. Backup domain name
	8. Download backup file
	9. Backup custmer"

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
        sus_site($domain)
        puts $request
	elsif c==4
		unsus_site($domain)
		puts $request
	elsif c==5
		sus_cust(customer)
		puts $request
	elsif c==6
		bak_list($domain)
		puts $request
	elsif c==7
		bak_domain($domain)
		puts $request
	elsif c==8
		down_bak($domain)
		puts $request
	elsif c==9
		bak_cust(customer)
		puts $request		
	else
        print "Wrong Choice !!"
	end

	response = $client.request($request)
	puts response.body
end

get_response()
