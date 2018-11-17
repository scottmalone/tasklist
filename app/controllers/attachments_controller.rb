class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  # GET /attachments/1
  def show
    #TODO pundit
    attachment = ActiveStorage::Attachment.find(params[:id])
    send_data attachment.download, disposition: 'inline', filename: attachment.filename.to_s
  end
end
