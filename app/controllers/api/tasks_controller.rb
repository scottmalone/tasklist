module Api
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    # POST /api/tasks
    def create
      task = Task.new(task_params.merge(user: current_user))

      if task.save
        render jsonapi: task
      else
        render jsonapi_errors: task.errors
      end
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:position, :completed, :due, :description)
    end
  end
end
