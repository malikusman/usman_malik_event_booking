# frozen_string_literal: true

# A User in the system
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy # TODO: association spec to be added

  validates :first_name, presence: true
  validates :last_name, presence: true
end
