require "push2heroku/version"
require "hashr"

module Push2heroku
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :ConfigLoader
  autoload :Git
  autoload :Util
end

require 'push2heroku/railtie'
