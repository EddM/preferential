module Preferential
  module Base
    module Attributes
      # Defines a predicate (i.e. +preference?+) method that returns a boolean
      # representation of the preference's value
      def synthesize_preference_predicate(name)
        method_name = :"#{name}?"
        if self.respond_to?(method_name)
          raise "Method ##{method_name} already exists on #{self}"
        end

        define_method(method_name) { !!preference(name) }
      end

      # Defines a "getter" method on the model for the given preference name
      # so it can be called as if it were a regular ActiveRecord attribute.
      #   class User < ActiveRecord::Base
      #     has_preference :time_zone
      #   end
      #
      #   user.time_zone # => "JST"
      def synthesize_preference_accessor(name, default)
        if self.respond_to?(name)
          raise "Method ##{name} already exists on #{self}"
        end

        define_method(name) { preference(name, default) }
      end

      # Defines a "setter" method on the model for the given preference name
      # so it can be set as if it were a regular ActiveRecord attribute.
      #   class User < ActiveRecord::Base
      #     has_preference :time_zone
      #   end
      #
      #   user.time_zone = "JST"
      def synthesize_preference_mutator(name)
        method_name = :"#{name}="

        if self.respond_to?(method_name)
          raise "Method ##{method_name} already exists on #{self}"
        end

        define_method method_name do |value|
          if preference = preferences.where(name: name).first
            preference.update_attribute :value, value
          else
            preferences.create name: name, value: value
          end
        end
      end
    end
  end
end
