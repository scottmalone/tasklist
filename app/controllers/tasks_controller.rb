class TasksController < ApplicationController
  before_action :authenticate_user!

  # GET /tasks
  def index
    @tasks = Task.with_attached_attachments.where(user: current_user).order(position: :asc)
  end
end
