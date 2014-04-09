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

client = PleskApiClient.new(host)
client.set_credentials(login, password)

request = <<eof
<packet version="1.6.5.0">
  <server>
    <get_protos/>
  </server>
</packet>
eof

response = client.request(request)
puts response.body

