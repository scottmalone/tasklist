class Task < ApplicationRecord
  # Associations
  belongs_to :user
  has_many_attached :attachments

  # Validations
  validates :description, presence: true
  validates :due, presence: true

  # Callbacks
  before_save :check_max_position, if: :position

  # Other
  acts_as_list scope: :user, add_new_at: :top, top_of_list: 1

  private

    def check_max_position
      if position > bottom_position_in_list
        self.position = bottom_position_in_list + 1
      end
    end
end
