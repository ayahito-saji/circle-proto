class PlaysController < ApplicationController
  before_action :require_login, only: [:new, :show, :post]
  before_action :require_enter, only: [:new, :show, :post]
  before_action :require_playing, only: [:show, :post]
  before_action :reject_playing, only: [:new]
  def show
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
