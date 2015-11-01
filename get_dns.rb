#!/usr/bin/env ruby

require 'net/dns'


if ARGV.count < 1
  puts "Usage: get_dns.rb <host_name> <name_server>"
  abort
end

host_name = ARGV[0]
name_server = ARGV[1] if ARGV.count >= 2

resolver = Net::DNS::Resolver.new
resolver.nameservers = [name_server] if name_server

result = resolver.query(host_name)

puts "DNS: #{resolver.nameservers.first}"
puts ''
puts "Result:"
puts result
