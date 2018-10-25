class HealthcheckController < ApplicationController
  def index
    render plain: "Hi\n"
  end
end
