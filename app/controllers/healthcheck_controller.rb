class HealthcheckController < ApplicationController
  def index
    render plain: "Hi"
  end
end
