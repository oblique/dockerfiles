#!/usr/bin/env ruby

require 'fileutils'

def privileged?
  `ip link add dummy0 type dummy > /dev/null 2>&1`
  return false unless $?.exited? && $?.exitstatus == 0
  `ip link del dummy0 > /dev/null 2>&1`
  return false unless $?.exited? && $?.exitstatus == 0
  true
end

def parse_mode(mode)
  m = mode.downcase.sub('altentry', 'alt').split('-')
  protocol = m[0]&.to_sym
  port = m[1].to_i
  port = nil if port == 0
  altentry = m[1] == 'alt' || m[2] == 'alt' if m.size > 1
  { protocol: protocol, port: port, altentry: altentry }
end

def parse_bool(bool)
  bool = bool.downcase.strip if bool.is_a? String
  ['y', 'yes', 't', 'true', '1', 1, true].include? bool
end

def all_config_files
  configs = []

  Dir.glob("/airvpn/**/*.ovpn") do |x|
    m = x.match(/AirVPN_([^_]+)_([^_]+)_([^\.]+)\.ovpn$/)

    mode = parse_mode(m[3])
    if mode[:protocol] == :ssl
      next unless File.exist? x.sub(/ovpn$/, 'ssl')
      next unless File.exist? "#{File.dirname(x)}/stunnel.crt"
    elsif mode[:protocol] == :ssh
      next unless File.exist? x.sub(/ovpn$/, 'sh')
      next unless File.exist? "#{File.dirname(x)}/sshtunnel.key"
    end

    country = m[1].match(/^([^-]+)/)[1]

    configs << {
      country: country,
      server: m[2],
      mode: mode,
      file: x
    }
  end

  configs
end

def mode_score(mode)
  protocol_order = [:udp, :tcp, :ssl, :ssh]
  ports_order = [1194, 443, 22, 53, 80]

  mode = parse_mode(mode) if mode.is_a? String
  score = 0

  if protocol_order.include? mode[:protocol]
    score += protocol_order.size * 10 - protocol_order.index(mode[:protocol]) * 10
  end

  if ports_order.include? mode[:port]
    score += ports_order.size - ports_order.index(mode[:port])
  end

  score
end

def select_config(mode, server, country)
  mode = parse_mode(mode)
  server = server&.downcase
  country = country&.downcase

  configs = all_config_files.lazy

  # select server or country
  if !server.nil?
    configs = configs.select { |x| server == x[:server].downcase }
  elsif !country.nil?
    configs = configs.select { |x| country == x[:country].downcase }
  end

  # select mode
  configs = configs
    .select { |x| mode[:protocol] == :auto || mode[:protocol] == x[:mode][:protocol] }
    .select { |x| mode[:port].nil? || mode[:port] == x[:mode][:port] }
    .select { |x| mode[:altentry].nil? || mode[:altentry] == x[:mode][:altentry] }

  # if country is not set, the select a random one
  if country.nil?
    configs = configs
      .group_by { |x| x[:country] }
      .to_a
      .shuffle[0][1]
  end

  # select best mode
  configs = configs
    .group_by { |x| x[:mode] }
    .to_a
    .sort { |x, y| mode_score(y[0]) <=> mode_score(x[0]) }[0][1]

  # get a random server from the results
  configs.shuffle[0]
end


unless privileged?
  puts "This container needs to be run with '--privileged' or '--cap-add=NET_ADMIN' option"
  exit 1
end

unless File.exist?('/dev/net/tun')
  FileUtils.mkdir_p('/dev/net')
  `mknod /dev/net/tun c 10 200`
  unless $?.exited? && $?.exitstatus == 0
    puts "Failed to create /dev/net/tun"
    exit 1
  end
end

mode = ENV['MODE'] || 'auto'
insecure_stunnel = parse_bool(ENV['INSECURE_STUNNEL'])
country = ENV['COUNTRY']
server = ENV['SERVER']

puts "Mode: #{mode}" unless mode == 'auto'
if !server.nil?
  puts "Server #{server}"
elsif !country.nil?
  puts "Country: #{country}"
end

config = select_config(mode, server, country)
unless config
  print "Can not find config"
  exit 1
end

ovpn_config = config[:file]
ssl_config = ovpn_config.sub(/ovpn$/, 'ssl')
ssh_script = ovpn_config.sub(/ovpn$/, 'sh')
dir = File.dirname(ovpn_config)

FileUtils.mkdir_p('/config')
FileUtils.cp(ovpn_config, '/config/openvpn.conf')

if File.exist?(ssl_config)
  conf = IO.read(ssl_config)
  conf.sub!(/^verify\s*=.*$/, '') if insecure_stunnel
  IO.write('/config/stunnel.conf', conf)
  FileUtils.cp("#{dir}/stunnel.crt", '/config/stunnel.crt')
end

if File.exist?(ssh_script)
  FileUtils.cp(ssh_script, '/config/sshtunnel.sh')
  FileUtils.cp("#{dir}/sshtunnel.key", '/config/sshtunnel.key')
end

Process.exec('/start_vpn.rb')
