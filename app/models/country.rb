class Country
  include Mongoid::Document
  field :name, type: String
  field :code, type: String
  field :flag, type: String

  validates :name, presence: true
  validates :code, presence: true
end
