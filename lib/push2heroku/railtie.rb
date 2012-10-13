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
      task :push2server, [:project, :branch, :callbacks, :host] do |t, args|
        args.with_defaults(host: 'http://ec2-23-20-192-49.compute-1.amazonaws.com/heroku', project: 't-ec2', branch: 'master')
        response = Net::HTTP.post_form(URI.parse(args[:host]), {project: args[:project], branch: args[:branch], 'options[callbacks]' => args[:callbacks]})
        if response.code == '200'
          puts 'You will deploy to:'
          puts MultiJson.load(response.body)['heroku_url']
        else
          puts 'Something goes wrong'
        end
      end
    end

  end
end

