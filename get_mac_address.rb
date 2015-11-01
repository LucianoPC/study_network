#!/usr/bin/env ruby

if ARGV.count < 1
  puts "Usage: sudo -E get_mac_address.rb <ip>"
  abort
end

ip = ARGV[0]
ip_split = ip.split('.')
ip_mask = "#{ip_split[0]}.#{ip_split[1]}.#{ip_split[2]}"

pcs_info = `sudo nmap -sU --script nbstat.nse -p137 #{ip_mask}.1-254`
pcs_info = pcs_info.split("\n")[2..(pcs_info.split("\n").size)].join("\n").split("\n\n")

pc_info = nil

pcs_info.each do |info|
  if info.split("\n")[0].include?(ip)
    pc_info = info
  end
end

if pc_info.nil?
  puts "MAC ADRESS of this IP is not founded"
  abort
end

pc_info.split("\n").each do |line|
  if line.start_with?("MAC Address:")
    puts line.split[2]
    abort
  end
end

puts "This is your IP, please use another IP"
