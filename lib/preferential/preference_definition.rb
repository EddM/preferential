module Preferential
  # +PreferenceDefinition+ encapsulates one preference defined
  # in a +has_preferences+ call.
  class PreferenceDefinition
    attr_reader :name, :default

    def initialize(name, options = {})
      @name = name
      @default = options[:default]
      @type = options[:type]
    end

    def type
      @type || inferred_type
    end

    private

    def inferred_type
      case @default
      when TrueClass, FalseClass
        :boolean
      when String, Symbol
        :string
      when Float
        :float
      when Fixnum, Numeric
        :integer
      end
    end
  end
end
