require "preferential/base/associations"
require "preferential/base/attributes"
require "preferential/base/callbacks"
require "preferential/base"
require "preferential/preference"
require "preferential/preference_definition"

require "generators/preferential/migration_generator"

module Preferential
  def self.cast_value(value, type = nil)
    case type
    when :boolean
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean value
    when :float
      value.to_f
    when :integer
      value.to_i
    else
      value
    end
  end
end

ActiveRecord::Base.send :include, Preferential::Base
