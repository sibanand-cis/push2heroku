module Push2heroku
  class Base

    attr_accessor :branch_name, :commands, :current_user, :heroku_app_name, :settings, :named_branches
    attr_reader :hard, :project_name

    def initialize(hard)
      @project_name = File.basename(Dir.getwd)
      @hard = hard.blank? ? false : true

      git = Git.new
      @branch_name = git.current_branch
      @current_user = git.current_user

      ENV['BRANCH_NAME'] = branch_name
      ENV['HEROKU_APP_NAME'] = project_name
      @named_branches, @settings = ConfigLoader.new('push2heroku.yml').load(branch_name)

      @commands = []
      @heroku_app_name = "#{url_prefix}-#{url_suffix}".downcase.chomp('-')[0..29] #heroku only allows upto 30 characters in name
    end

    def push
      build_commands
      puts "------> http://#{heroku_app_name}.herokuapp.com"
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
      project_name.gsub(/[^0-9a-zA-Z]+/,'-').downcase
    end

    def build_commands
      commands << settings.pre_config_commands
      build_config_commands
      commands << ( Util.hard_push?(self) ?  settings.post_config_commands.hard : settings.post_config_commands.soft )
      commands << "bundle exec heroku open --app #{heroku_app_name}"
      commands.flatten!
    end

    def build_config_commands
      return unless settings.config
      cmd = []
      settings.config.each do |key, value|
        cmd << "#{key.upcase}=#{value}"
      end
     commands << "bundle exec heroku config:add #{cmd.join(' ')} --app #{heroku_app_name}"
    end

  end
end
