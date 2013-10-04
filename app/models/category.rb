class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy
  accepts_nested_attributes_for :products
end
