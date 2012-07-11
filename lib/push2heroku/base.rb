module Push2heroku
  class Base

    attr_accessor :branch_name, :commands, :current_user, :subdomain, :settings, :named_branches
    attr_reader :hard

    def initialize(hard)
      @hard = hard.blank? ? false : true
      git = Git.new
      @branch_name = git.current_branch
      @current_user = git.current_user

      ENV['BRANCH_NAME'] = branch_name
      ENV['HEROKU_APP_NAME'] = 'tweli'
      @named_branches, @settings = ConfigLoader.new('push2heroku.yml').load(branch_name)

      @commands = []
      @subdomain = "#{url_prefix}-#{url_suffix}".downcase.chomp('-')[0..29] #heroku only allows upto 30 characters in name
    end

    def push
      build_commands
      puts "------> http://#{subdomain}.herokuapp.com"
      commands.each { |cmd| puts "*  " + cmd }
      commands.each do |cmd|
        begin
          sh cmd
        rescue Exception => e
          puts e
        end
      end
    end

    private

    def url_suffix
      return branch_name if named_branches.include?(branch_name)

      [branch_name[0..10], current_user[0..5]].join('-').gsub(/[^0-9a-zA-Z]+/,'-').downcase
    end

    def url_prefix
      settings.app_name.gsub(/[^0-9a-zA-Z]+/,'-').downcase
    end

    def build_commands
      commands << settings.pre_config_commands

      build_config_commands

      if Util.hard_push?(self)
        commands << settings.post_config_commands.hard
      else
        commands << settings.post_config_commands.soft
      end

      commands << "bundle exec heroku open --app #{subdomain}"
      commands.flatten!
    end


    def build_config_commands
      return unless settings.config
      cmd = []
      settings.config.each do |key, value|
        cmd << "#{key.upcase}=#{value}"
      end
     commands << "bundle exec heroku config:add #{cmd.join(' ')} --app #{subdomain}"
    end

  end
end
