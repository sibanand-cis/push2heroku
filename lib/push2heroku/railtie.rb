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
      task :push2hpusher, [:project, :branch, :host] do |t, args|
        response = Net::HTTP.post_form(URI.parse(args[:host]), {project: args[:project], branch: args[:branch], 'options[callbacks]' => ENV['CALLBACKS']})
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

