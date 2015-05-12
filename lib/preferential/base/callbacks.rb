module Preferential
  module Base
    module Callbacks
      def register_callbacks(name, options)
        after_create do |_record|
          preferences.create! name: name, value: options[:default]
        end
      end
    end
  end
end
