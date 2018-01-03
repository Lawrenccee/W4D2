class Cat < ApplicationRecord
  CAT_COLORS = %w(black white brown)

  validates :birth_date, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :sex, presence: true, inclusion: { in: %w(M F) }
  validates :color, presence: true, inclusion: { in: CAT_COLORS }

  has_many :cat_rental_requests,
    foreign_key: :cat_id,
    dependent: :destroy,
    class_name: :CatRentalRequest

  def age
    now = Date.today
    dob = self.birth_date

    year = now.year - dob.year

    year - ((now.month > dob.month ||
      (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
