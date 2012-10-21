module Push2heroku
  class Base

    attr_accessor :branch_name, :commands, :current_user, :settings, :named_branches
    attr_reader :callbacks, :project_name, :heroku_app_name, :git, :config

    def initialize(callbacks)
      @callbacks = callbacks
      @git = Git.new
      @commands = []
      @config = ConfigLoader.new('push2heroku.yml')
      after_initialize
    end

    def after_initialize
      set_project_name
      set_branch_name
      set_current_user_name
      set_named_branches
      set_settings
      set_heroku_app_name
      set_env
      reload_config
    end

    def reload_config
      @config = ConfigLoader.new('push2heroku.yml')
      set_settings
    end

    def set_project_name
      @project_name = File.basename(Dir.getwd)
    end

    def set_branch_name
      @branch_name = git.current_branch
    end

    def set_current_user_name
      @current_user = git.current_user
    end

    def set_named_branches
      @named_branches = config.named_branches
    end

    def set_settings
      @settings = config.settings(branch_name)
    end

    def set_heroku_app_name
      @heroku_app_name = "#{url_prefix}-#{url_suffix}".downcase.chomp('-')[0..29] #heroku only allows upto 30 characters in name
    end

    def set_env
      ENV['BRANCH_NAME'] = branch_name
      ENV['HEROKU_APP_NAME'] = heroku_app_name
      ENV['HEROKU_APP_URL'] = "http://#{heroku_app_name}.herokuapp.com"
      ENV['APP_URL'] = @settings.app_url ? @settings.app_url : ENV['HEROKU_APP_URL']
    end

    def push
      build_commands
      feedback_to_user
      commands.each_with_index do |cmd, index|
        puts "Going to execute: #{cmd}"
        sh cmd do |ok, result|
          abort "command #{cmd} failed" if (!ok && index > 0)
        end
      end
    end

    private

    def url_suffix
      return branch_name if named_branches.include?(branch_name)

      [branch_name[0..10], current_user[0..5]].join('-').gsub(/[^0-9a-zA-Z]+/,'-').downcase
    end

    def url_prefix
      project_name.gsub(/[^0-9a-zA-Z]+/,'-').downcase
    end

    def build_commands
      commands << settings.pre_config_commands
      build_config_environment_commands
      add_before_every_install
      add_callback_commands
      add_after_every_install

      if public_url = settings.public_url
        commands << "open http://#{public_url}"
      else
        commands << "bundle exec heroku open --app #{heroku_app_name}"
      end

      commands.flatten!.compact!
    end

    def add_before_every_install
      if cmd = settings.post_config_commands.before_every_install
        commands << cmd
      end
    end

    def add_after_every_install
      if cmd = settings.post_config_commands.after_every_install
        commands << cmd
      end
    end

    def add_callback_commands
      callbacks.each do |callback|
        commands << settings.post_config_commands[callback]
      end
    end

    def build_config_environment_commands
      return unless settings.config
      cmd = []
      settings.config.each do |key, value|
        if String === value && !value.strip.empty?
          cmd << "#{key.upcase}=#{value}"
        else
          cmd << "#{key.upcase}=#{value}"
        end
      end
     commands << "bundle exec heroku config:add #{cmd.join(' ')} --app #{heroku_app_name}"
    end

    def feedback_to_user
      puts '='*50
      puts 'The application will be deployed at:'
      puts "http://#{heroku_app_name}.herokuapp.com"
      puts '='*50
      puts ''
      puts '='*50
      puts 'Following commands will be executed:'
      commands.each do |cmd|
        puts cmd
      end
      puts '='*50
      puts ''
    end
  end
end
