module Api
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:edit, :update, :destroy]

    # POST /api/tasks
    def create
      #formatted_date = Date.strptime(task_params[:due], '%m/%d/%Y')
      #task = Task.new(task_params.merge(user: current_user, due: formatted_date))
      task = Task.new(task_params.merge(user: current_user))

      if task.save
        render jsonapi: task
      else
        render jsonapi_errors: task.errors
      end
    end

    # PUT /api/tasks/:id
    def update
      task = Task.find(params[:id])

      if task.update(task_params)
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
