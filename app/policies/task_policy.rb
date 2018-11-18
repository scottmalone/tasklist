class TaskPolicy < ApplicationPolicy
  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def create_attachment?
    record.user == user
  end
end
