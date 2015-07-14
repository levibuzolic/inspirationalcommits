# -*- encoding : utf-8 -*-
$LOAD_PATH.unshift File.expand_path('.')

require 'core_ext/class'
require 'mini_magick'
require 'core_ext/mini_magick/utilities'
require 'fileutils'
require 'git'
require 'open3'
require 'methadone'
require 'date'

require 'lolcommits/version'
require 'lolcommits/configuration'
require 'lolcommits/capturer'
require 'lolcommits/git_info'
require 'lolcommits/installation'
require 'lolcommits/plugin'
require 'lolcommits/platform'

Dir[File.dirname(__FILE__) + '/lolcommits/plugins/*.rb'].each do |file|
  require file
end

# require runner after all the plugins have been required
require 'lolcommits/runner'
