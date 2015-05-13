module Preferential
  class Preference < ActiveRecord::Base
    self.table_name = "preferences"

    belongs_to :owner, polymorphic: true

    validates :name, presence: true
    validates :owner_id, uniqueness: { scope: [:owner_type, :name] }
  end
end
