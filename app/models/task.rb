class Task < ApplicationRecord
  belongs_to :user

  acts_as_list scope: :user, add_new_at: :top, top_of_list: 1

  validates :description, presence: true
  validates :due, presence: true

  before_save :check_max_position, if: :position

  private

  def check_max_position
    if position > bottom_position_in_list
      self.position = bottom_position_in_list + 1
    end
  end
end
