class Payment < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  attr_accessor :redirect_url

  after_create :create_seed_and_shop_id

  scope :verified, -> { where(verified: true) }

  # AFTER_CREATE???
  def start_pay
    self.new_record? and return nil
    @unicredit = Unicredit.new(self)
    payment_id, redirect_url = @unicredit.ask(100, "Siamis payment for #{user.to_s}")
    self.payment_id = payment_id
    self.save!
    @redirect_url = redirect_url
  end

  def verify
    if res = Unicredit.new(self).verify
      self.update_attribute(:verified, true)
    end
    res
  end

  private

  def create_seed_and_shop_id
    self.seed = SecureRandom.hex(10)
    self.shop_id = "#{self.id}-#{self.seed}"
    self.save
  end
end

