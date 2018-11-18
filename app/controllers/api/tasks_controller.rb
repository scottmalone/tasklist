module Api
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:update, :destroy]

    # POST /api/tasks
    def create
      task = Task.new(task_params.merge(user: current_user))

      if task.save
        render jsonapi: task
      else
        render jsonapi_errors: task.errors
      end
    end

    # PUT /api/tasks/:id
    def update
      authorize @task
      if @task.update(task_params)
        render jsonapi: @task
      else
        render jsonapi_errors: @task.errors
      end
    end

    # DELETE /api/tasks/:id
    def destroy
      authorize @task
      @task.destroy
      
      head :no_content
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
