module Preferential
  module Base
    module Attributes
      def synthesize_preference_predicate(name)
        method_name = :"#{name}?"
        if self.respond_to?(method_name)
          raise "Method ##{method_name} already exists on #{self}"
        end

        define_method(method_name) { !!preference(name) }
      end

      def synthesize_preference_accessor(name, default)
        if self.respond_to?(name)
          raise "Method ##{name} already exists on #{self}"
        end

        define_method(name) { preference(name, default) }
      end

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
