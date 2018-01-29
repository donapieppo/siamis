class ManualPayment < ApplicationRecord
  self.table_name = 'payments'

  belongs_to :user
  has_one :conference_registration

  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }
end

