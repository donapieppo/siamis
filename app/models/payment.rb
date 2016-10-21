class Payment < ApplicationRecord
  belongs_to :user
  has_one :registration

  validates :user_id, presence: true

  attr_accessor :redirect_url

  after_create :create_seed_and_shop_id,
               :start_pay

  scope :verified, -> { where(verified: true) }

  def description
    "Siam-IS18 registration: #{user.to_s} <#{user.email}>"
  end

  # AFTER_CREATE???
  def start_pay
    self.new_record? and return nil
    @unicredit = Unicredit.new(self)
    payment_id, redirect_url = @unicredit.ask(100, description)
    self.payment_id = payment_id
    self.save!
    @redirect_url = redirect_url
  end

  def verify
    if res = Unicredit.new(self).verify
      self.update_attribute(:verified, true)
      # FIXME 
      self.user.registration = Registration.new(payment: self)
    end
    res
  end

  private

  def create_seed_and_shop_id
    self.seed = SecureRandom.hex(8)
    self.shop_id = "Siam-#{self.id}-#{self.seed}"
    self.save
  end
end

