class ActiveStorage::AttachmentPolicy < ApplicationPolicy
  def show?
    task_owner == user
  end

  def destroy?
    task_owner == user
  end

  private

    def task_owner
      Task.find(record.record_id).user
    end
end
