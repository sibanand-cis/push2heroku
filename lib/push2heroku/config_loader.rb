module Push2heroku
  class ConfigLoader

    attr_reader :filename, :hash

    def initialize(filename)
      @filename = filename
      @hash = load_config
    end

    def settings(branch_name)
      common_hash = hash['common'] || {}
      env_hash = hash[branch_name.to_s] || {}
      final_hash = common_hash.deep_merge(env_hash)
      Hashr.new(final_hash)
    end

    def named_branches
      hash.keys - ['common']
    end

    private

    def load_config
      file            = Rails.root.join('config', filename)

      unless File.exists? file
        puts "you do not have config/push2heroku.yml file. Please execute "
        puts "rails generate push2heroku:install"
        abort
      end
      YAML.load(ERB.new(File.read(file)).result)
    end


  end
end
