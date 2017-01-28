#!/usr/bin/env ruby

require 'etc'
require 'fileutils'

def get_ip_mask(ifname)
  m = `ip addr list dev #{ifname}`.match(/^\s+inet\s+(\S+)/)
  m[1] if m
end

def reset_network
  # remove dns settings
  `echo > /etc/resolv.conf`
  # reset iptables rules
  `iptables -F`
  # deny all connections
  `iptables -I INPUT -i eth0 -j DROP`
  `iptables -I OUTPUT -o eth0 -j DROP`
  # allow connections from internal IPs
  ip_mask = get_ip_mask('eth0')
  `iptables -I INPUT -i eth0 -s #{ip_mask} -d #{ip_mask} -j ACCEPT`
  `iptables -I OUTPUT -o eth0 -s #{ip_mask} -d #{ip_mask} -j ACCEPT`
  # add ext-input and ext-output chains
  `iptables -N ext-input > /dev/null 2>&1`
  `iptables -F ext-input`
  `iptables -I INPUT -j ext-input`
  `iptables -N ext-output > /dev/null 2>&1`
  `iptables -F ext-output`
  `iptables -I OUTPUT -j ext-output`
end

def allow_external_ip(ip)
  eth0_ip = get_ip_mask('eth0').split('/')[0]
  `iptables -I ext-input -i eth0 -s #{ip} -d #{eth0_ip} -j ACCEPT`
  `iptables -I ext-output -o eth0 -s #{eth0_ip} -d #{ip} -j ACCEPT`
end

def start_stunnel
  puts 'Starting stunnel'
  pid = Process.fork do
    nobody = Etc.getpwnam('nobody')
    Process.gid = nobody.gid
    Process.uid = nobody.uid
    Kernel.exec('stunnel', 'stunnel.conf')
  end
  sleep 1
  pid
end

def start_sshtunnel
  puts 'Starting SSH tunnel'
  pid = Process.fork do
    nobody = Etc.getpwnam('nobody')
    Process.gid = nobody.gid
    Process.uid = nobody.uid

    FileUtils.chown(nobody.uid, nobody.gid, './sshtunnel.key')
    FileUtils.chmod(0600, './sshtunnel.key')
    cmd = IO.read('./sshtunnel.sh').match(/(^ssh .*)/)[1]
    # it is safe to disable strict checking since we login with a private key.
    cmd << ' -o StrictHostKeyChecking=no'

    Kernel.exec(*cmd.split)
  end
  sleep 3
  pid
end

def start_openvpn
  puts 'Starting openvpn'
  Process.fork do
    Kernel.exec('openvpn', '--script-security', '2',
                '--up', '/etc/openvpn/up.sh',
                '--down', '/etc/openvpn/down.sh',
                '--config', 'openvpn.conf')
  end
end

def start_dante()
  puts 'Starting dante'
  Process.fork { Kernel.exec('sockd') }
end


Dir.chdir('/config')

if File.exist?('stunnel.conf')
  server_ip = IO.read('stunnel.conf').match(/^connect\s*=\s*([^:]+)/)[1]
elsif File.exist?('sshtunnel.sh')
  server_ip = IO.read('sshtunnel.sh').match(/sshtunnel@(\S+)/)[1]
else
  server_ip = IO.read('openvpn.conf').match(/^remote\s+(\S+)/)[1]
end

reset_network
allow_external_ip(server_ip)

stunnel_pid = nil
sshtunnel_pid = nil
ovpn_pid = nil
dante_pid = nil

catch :exit_signaled do
  signal_exit = -> _ do
    Signal.trap('TERM', 'IGNORE')
    Signal.trap('INT', 'IGNORE')
    throw :exit_signaled
  end

  Signal.trap('TERM', &signal_exit)
  Signal.trap('INT', &signal_exit)

  loop do
    stunnel_pid = nil if stunnel_pid && Process.wait(stunnel_pid, Process::WNOHANG)
    sshtunnel_pid = nil if sshtunnel_pid && Process.wait(sshtunnel_pid, Process::WNOHANG)
    ovpn_pid = nil if ovpn_pid && Process.wait(ovpn_pid, Process::WNOHANG)
    dante_pid = nil if dante_pid && Process.wait(dante_pid, Process::WNOHANG)

    stunnel_pid ||= start_stunnel if File.exist?('stunnel.conf')
    sshtunnel_pid ||= start_sshtunnel if File.exist?('sshtunnel.sh')
    ovpn_pid ||= start_openvpn
    dante_pid ||= start_dante

    sleep 1
  end
end

puts
puts 'Exiting...'

[stunnel_pid, sshtunnel_pid, ovpn_pid, dante_pid].each do |pid|
  if pid
    Process.kill('KILL', pid)
    Process.wait(pid)
  end
end
