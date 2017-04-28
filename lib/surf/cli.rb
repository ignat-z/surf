# frozen_string_literal: true

require 'bundler'
require 'thor'

require 'surf/config_builder'

module Surf
  class CLI < Thor
    default_task :start

    desc 'start', 'Starts Surf'
    def start(config = 'default_config.yml')
      config = File.read(config)
      Surf::ConfigBuilder.new(config).build!
      Surf.run
    end
  end
end
