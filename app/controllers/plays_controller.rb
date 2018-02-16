class PlaysController < ApplicationController
  before_action :require_login, only: [:new, :show, :post]
  before_action :require_enter, only: [:new, :show, :post]
  before_action :require_playing, only: [:show, :post]
  before_action :reject_playing, only: [:new]
  def show
    gon.member_id = current_user.member_id
    gon.code = play_view_code
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
