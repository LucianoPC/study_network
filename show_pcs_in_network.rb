#!/usr/bin/env ruby

if ARGV.count < 1
  puts "Usage: sudo -E show_pcs_in_network.rb <network_type>"
  puts "<network_type> exemple: eth0, lo, wlan0"
  abort
end

network_type = ARGV[0]

begin
  user_ip = ic = `sudo ifconfig`.split("\n\n").select{|line| line.start_with?("wlan0")}.first.split("\n").select{|line| line.strip.start_with?("inet")}.first.strip.split[1].strip
rescue => error
  puts error
  puts "Use a valid network_type"
  puts ""
  puts "Usage: sudo -E show_pcs_in_network.rb <network_type>"
  puts "<network_type> exemple: eth0, lo, wlan0"
  abort
end

ip_split = user_ip.split('.')
ip_mask = "#{ip_split[0]}.#{ip_split[1]}.#{ip_split[2]}"

puts(`sudo nmap -sU --script nbstat.nse -p137 #{ip_mask}.1-254`)
