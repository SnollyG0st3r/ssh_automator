#!/usr/bin/env ruby
# encoding: utf-8
#SSH AUTOMATOR RUNS COMMANDS FOR YOU!!@1212121212
#Written by Rich A for maximum lazyness

require 'pp'
require 'logger'
require 'net/ssh'
require 'colorize'
require 'trollop'

@hostname = "10.10.10.10"
@username = "techsupport"
@password = "w0ntcr@ckme12"

def arguments
  @opts = Trollop::options do
    version "ssh_automater v0.9".light_blue
    banner <<-EOS
    weeeeeee
    EOS

    opt :host,   "Provide a single host at the command line - host:port", :type => String, :short => "-h"
    opt :user,   "Provide a username",  :type => String, :short => "-u"
    opt :pass,   "Provide a password",  :type => String, :short => "-p"
    opt :cmds,   "Provide a list of commands", :type => String, :short => "-c", :default => "commands.txt"

    if ARGV.empty?
      puts "Try ./ssh_automater.rb --help"
    end
  end
  @opts
end

def cmdrun
  log = Logger.new('debug.log')
  cmd = TTY::Command.new(printer: :pretty)
end

def commands
  cmds = File.readlines(@opts[:cmds]).map(&:chomp &&:strip)
end

def execute_commands
  ssh = Net::SSH.start(@opts[:host], @opts[:user], :password => @opts[:pass]) do |ssh|
    commands.each do |command|
      desc = command.split(":")[0]
      cmd  = command.split(":")[1]
      puts "\n\n#{desc} with command: #{cmd}".green.bold
      out = ssh.exec!(cmd)
      out.each_line do |line|
        unless line.scrub =~ /find:/
          puts line
        end
      end
    end
    ssh.close
  end
end

arguments
execute_commands
