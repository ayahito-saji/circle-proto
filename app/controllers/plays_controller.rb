class PlaysController < ApplicationController
  before_action :require_playing, only: [:get, :post]
  before_action :reject_playing, only: [:new]
  before_action :require_enter, only: [:new, :get, :post]
  before_action :require_login, only: [:new, :get, :post]
  def get
  end
  def post
    render 'get'
  end
  def new
    play_start
    redirect_to root_path
  end
end
