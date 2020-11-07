class ApplicationController < ActionController::API

  def health
    render :json => "reading-life"
  end
end
