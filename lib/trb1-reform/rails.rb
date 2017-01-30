require "trb1-reform/rails/version"
require "trb1-reform/rails/railtie"

module Trb1
  module Reform
    def self.rails3_0?
      ::ActiveModel::VERSION::MAJOR == 3 and ::ActiveModel::VERSION::MINOR == 0
    end
  end
end
