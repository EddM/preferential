module Preferential
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

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

      def preferences
        @preferences ||= {}
      end

      def has_preferences(preferences_to_define)
        define_associations!

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
