# frozen_string_literal: true

require 'bundler'
require 'thor'

require 'surf/config_builder'

module Surf
  class CLI < Thor
    DEFAULT_CONFIG_PATH = 'config/default_config.yml'
    default_task :start

    desc 'start', 'Starts Surf'
    def start(config = DEFAULT_CONFIG_PATH)
      config = File.read(config)
      Surf::ConfigBuilder.new(config).build!
      Surf.run
    end
  end
end
