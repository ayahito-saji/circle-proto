class PlaysController < ApplicationController
  before_action :require_login, only: [:new, :get, :post]
  before_action :require_enter, only: [:new, :get, :post]
  before_action :require_playing, only: [:get, :post]
  before_action :reject_playing, only: [:new]
  def get
    @html_code = play_view
  end
  def new
    play_start
    redirect_to root_path
  end
  def destroy
    play_end
    redirect_to room_path
  end
end
