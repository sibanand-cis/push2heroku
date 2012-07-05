module Push2heroku
  class Engine < Rails::Engine

    rake_tasks do
      desc "pushes to heroku"
      task :push2heroku => :environment do
        hard = ENV['HARD']
        Base.new(hard).push
      end
    end

  end
end

