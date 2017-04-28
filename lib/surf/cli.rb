# frozen_string_literal: true

require 'bundler'
require 'thor'

module Surf
  class CLI < Thor
    default_task :start

    desc 'start', 'Starts Surf'
    def start
      Surf.run
    end
  end
end
