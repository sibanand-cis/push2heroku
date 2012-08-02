module Push2heroku
  class Engine < Rails::Engine

    rake_tasks do
      desc "pushes to heroku"
      task :push2heroku => :environment do
        callbacks = (ENV['CALLBACKS'] || '').split(',')
        Base.new(callbacks).push
      end
    end

  end
end

