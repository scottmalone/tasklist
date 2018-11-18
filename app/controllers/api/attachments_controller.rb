module Api
  class AttachmentsController < ApplicationController
    before_action :authenticate_user!

    # POST /api/attachments
    def create
      task = Task.find(params[:task_id])
      authorize task, :create_attachment?
      task.attachments.attach(params[:attachment_file])
      attachment = Attachment.new(task.attachments.last)

      render jsonapi: attachment
    end

    # DELETE /api/attachments/:id
    def destroy
      attachment = ActiveStorage::Attachment.find(params[:id])
      authorize attachment
      attachment.purge
      
      head :no_content
    end
  end
end
