class CatRentalRequest < ApplicationRecord
  RENTAL_STATUS = %w(PENDING APPROVED DENIED)

  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: RENTAL_STATUS }
  validate :does_not_overlap_approved_request

  belongs_to :cat,
    foreign_key: :cat_id

  def overlapping_requests
    requests = CatRentalRequest
      .where("cat_id = ?
        AND ((? BETWEEN start_date AND end_date OR
        ? BETWEEN start_date AND end_date) OR (start_date BETWEEN ? AND ? OR
        end_date BETWEEN ? AND ?))",
        self.cat_id, self.start_date, self.end_date,
        self.start_date, self.end_date, self.start_date, self.end_date)
  end

  def overlapping_approved_requests
    approved = overlapping_requests
    approved.where("status = ?", 'APPROVED')
  end

  def overlapping_pending_requests
    pending = overlapping_requests
    pending.where("status = ?", 'PENDING')
  end

  def approve!
    CatRentalRequest.transaction do
      return if self.status == "DENIED"
      overlapping_requests.update_all(status: 'DENIED')
      self.update(status: 'APPROVED')
    end
  end

  def deny!
    self.update(status: 'DENIED')
  end

  def pending?
    self.status == "PENDING"
  end

  private

  def does_not_overlap_approved_request
    return if self.status == "DENIED"
    # doesnt exist in here, but exists outside?
    if overlapping_approved_requests.exists?
      errors[:base] << "Conflicts with an already approved request"
    end
  end
end
