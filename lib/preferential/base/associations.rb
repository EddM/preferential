module Preferential
  module Base
    module Associations
      def define_associations!
        unless reflections[:preferences]
          has_many :preferences, as: :owner,
                                 dependent: :destroy,
                                 class_name: Preferential::Preference
        end
      end
    end
  end
end
