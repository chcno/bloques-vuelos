class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    enum :role, {
      pending: 0,
      student: 1,
      instructor: 2,
      safety: 3,
      admin: 4
    }
end
