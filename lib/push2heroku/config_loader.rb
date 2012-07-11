module Push2heroku
  class ConfigLoader

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def load(key)
      file            = Rails.root.join('config', filename)

      unless File.exists? file
        puts "you do not have config/push2heroku.yml file. Please execute "
        puts "rails generate push2heroku:install"
        abort
      end

      hash            = YAML.load(ERB.new(File.read(file)).result)

      named_branches = hash.keys - ['common']

      common_hash = hash['common'] || {}
      env_hash = hash[key.to_s] || {}

      final_hash = common_hash.deep_merge(env_hash)
      h = Hashr.new(final_hash)

      [named_branches, h]
    end
  end
end
