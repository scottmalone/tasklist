class TasksController < ApplicationController
  before_action :authenticate_user!

  # GET /tasks
  def index
    @tasks = current_user.tasks
  end
end
