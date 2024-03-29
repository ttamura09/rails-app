class Customer < ApplicationRecord
  has_secure_password

  has_many :bookings, dependent: :destroy

  # 名前
  validates :name, presence: true, length: { minimum: 2, maximum: 20, allow_blank: true }

  # アルファベット名
  validates :alph_name, presence: true,
            format: { with: /\A[A-Za-z\s]*\z/, allow_blank: true },
            length: { minimum: 2, maximum: 20, allow_blank: true }

  # ログイン名
  validates :login_name, presence: true,
            format: { with: /\A[A-Za-z][A-Za-z0-9]*\z/, allow_blank: true },
            length: { minimum: 2, maximum: 20, allow_blank: true },
            uniqueness: { case_sensitive: false }

  # 誕生日
  validates :birthday, comparison: { less_than: Time.current.to_date }

  # email
  validates :email, presence: true, email: { allow_blank: true }

  # パスワード
  attr_accessor :current_password
  validates :password, presence: { if: :current_password },
            format: { with: /\A[A-Za-z0-9]*\z/, allow_blank: true },
            length: { minimum: 2, maximum: 20, allow_blank: true }
end
