module Push2heroku
  class Engine < Rails::Engine

    rake_tasks do
      require 'net/http'
      require 'uri'
      require 'multi_json'

      desc "pushes to heroku"
      task :push2heroku => :environment do
        callbacks = (ENV['CALLBACKS'] || '').split(',')
        config_path = Rails.root.join('config')
        Base.new(config_path, callbacks).push
      end

      desc "pushes to heroku via external server"
      task :push2hpusher, [:project, :branch] do |t, args|
        unless args[:project] && args[:branch]
          puts "Usage: rake push2server['tweli','master'] CALLBACKS=reset_db_using_fixtures"
        end
        host_url = ['http://74.207.237.77/heroku'].join
        response = Net::HTTP.post_form(URI.parse(host_url), {project: args[:project], branch: args[:branch], 'options[callbacks]' => ENV['CALLBACKS']})
        if response.code == '200'
          puts 'The appliction will be deployed to:'
          puts MultiJson.load(response.body)['heroku_url']
        else
          puts 'Something has gone wrong'
        end
      end
    end

  end
end

