class Category < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has many :recipes, through: :bookmarks
  has_one_attached :photo
  validates :name, uniqueness: true
end
