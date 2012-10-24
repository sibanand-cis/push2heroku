module Push2heroku
  class Engine < Rails::Engine

    rake_tasks do
      desc "pushes to heroku"
      task :push2heroku => :environment do
        callbacks = (ENV['CALLBACKS'] || '').split(',')
        config_path = Rails.root.join('config')
        Base.new(config_path, callbacks).push
      end
    end

  end
end

