class PlaysController < ApplicationController
  before_action :require_login, only: [:get, :post]
  before_action :require_enter, only: [:get, :post]
  before_action :require_playing, only: [:get, :post]
  def get
  end
  def post
    render 'get'
  end
end
