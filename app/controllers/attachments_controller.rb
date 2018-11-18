class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  # GET /attachments/1
  def show
    attachment = ActiveStorage::Attachment.find(params[:id])
    authorize attachment
    send_data attachment.download, disposition: 'inline', filename: attachment.filename.to_s
  end
end
