module Api
  class AttachmentsController < ApplicationController
    before_action :authenticate_user!

    # POST /api/attachments
    def create
      #TODO pundit
      task = Task.find(params[:task_id])
      task.attachments.attach(params[:attachment_file])
      attachment = Attachment.new(task.attachments.last)

      render jsonapi: attachment
    end

    # DELETE /api/attachments/:id
    def destroy
      #TODO pundit
      attachment = ActiveStorage::Attachment.find(params[:id])
      attachment.purge
      
      head :no_content
    end
  end
end
