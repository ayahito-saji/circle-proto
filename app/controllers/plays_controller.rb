class PlaysController < ApplicationController
  before_action :require_login, only: [:new, :show, :post]
  before_action :require_enter, only: [:new, :show, :post]
  before_action :require_playing, only: [:show, :post]
  before_action :reject_playing, only: [:new]
  def show
  end
end
