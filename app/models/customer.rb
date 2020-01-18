require 'bcrypt'
class Customer < ApplicationRecord
  attr_accessor :password_salt, :password_hash
  include BCrypt
  self.table_name = "customer"
  has_many :reviews


  before_save :encrypt_password
  before_save { self.email = email.downcase }
  before_save { self.name = name.strip }
  before_save { self.credit_card = credit_card.gsub(/[^0-9\s]/i, "") if credit_card }
  after_save { self.credit_card = mask_number(credit_card) if credit_card }
  VALID_PHONE_NUMBER_REGEX = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :credit_card, allow_blank: true, credit_card_number: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_format_of :day_phone, :eve_phone, :mob_phone, allow_blank: true, length: { maximum: 15 }, with: VALID_PHONE_NUMBER_REGEX
  validates :password,
            presence: true,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
              

  def encrypt_password
    if password.present?
      self.password = BCrypt::Password.create(password)
    end
  end

  def mask_number(number)
    number.to_s.size < 5 ? number.to_s : (('*' * number.to_s[0..-5].length) + number.to_s[-4..-1])
  end

  def self.find_or_create_with_facebook_access_token(profile)
    data = {
      name: profile['name'],
      email: profile['email'],
      password: SecureRandom.urlsafe_base64
    }
    if @customer = Customer.find_by_email(data[:email])
      @customer
    else
      @customer = Customer.new(data)

      if @customer.save
        @customer
      end
    end
  end
  
end
