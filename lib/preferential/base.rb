module Preferential
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    # Gets the value for a given preference name (cast to the most appropriate
    # type). This method transparently creates a preference record with the
    # given default if no preference record exists. It is recommended to use
    # the synthesized getter methods for individual preferences over
    # directly calling +#preference+ on an object.
    def preference(name, default = nil)
      preference = preferences.where(name: name).first

      if !preference
        preference = preferences.create name: name, value: default
      end

      prefs = self.class.instance_variable_get "@preferences"
      preference_definition = prefs[name]
      Preferential.cast_value preference.value, preference_definition.type
    end

    module ClassMethods
      include Base::Associations
      include Base::Attributes
      include Base::Callbacks

      # +has_preferences+ gives the model it is called in accessor and mutator
      # methods for a set of "virtual" attributes that are, transparently,
      # stored in a separate table. Preferences can be defined as hash (with
      # extended options), an array of strings/symbols denoting preference
      # names, or just a single string or symbol that names a single preference.
      #
      #   has_preferences :time_zone
      #   has_preferences :time_zone, :language
      #   has_preferences time_zone: { default: "JST" }
      #
      # The extended options that can be provided in the hash format are:
      #
      # * +default+: The default value for that preference (preferences without
      #   a default will default to +nil+)
      # * +type+: The data type expected of this preference (valid options
      #   are +:string+, +:integer+, +:float+ and +:boolean+). If no type is
      #   provided, but a default is, type will be inferred from the default.
      #
      # Also aliased as +has_preference+ for when you only want to define
      # a single preference.
      def has_preferences(preferences_to_define)
        define_associations!

        # Turn argument into a hash if it can be done sensibly
        case preferences_to_define
        when Symbol, String
          preferences_to_define = { preferences_to_define.to_sym => {} }
        when Array
          preferences_to_define = preferences_to_define.map do |preference|
            { preference => {} }
          end
        end

        preferences_to_define.symbolize_keys.each &method(:define_preference)
      end

      alias_method :has_preference, :has_preferences

      private

      def preferences
        @preferences ||= {}
      end

      def define_preference(name, options)
        register_callbacks(name, options)
        synthesize_preference_accessor(name, options[:default])
        synthesize_preference_mutator(name)
        synthesize_preference_predicate(name)
        preferences[name] ||= PreferenceDefinition.new(name, options)
      end
    end
  end
end
