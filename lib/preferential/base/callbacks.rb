module Preferential
  module Base
    module Callbacks
      def register_callbacks(name, options)
        after_create do |_record|
          # Create a set of preference records with the defaults as set
          # at the time of the owner's creation
          preferences.create! name: name, value: options[:default]
        end
      end
    end
  end
end
