class PlaysController < ApplicationController
  before_action :require_login, only: [:new, :show, :post]
  before_action :require_enter, only: [:new, :show, :post]
  before_action :require_playing, only: [:show, :post]
  before_action :reject_playing, only: [:new]
  def show
    gon.member_id = current_user.member_id
    gon.code = play_view_code(current_user)
  end
end
