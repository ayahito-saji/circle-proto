class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include EntrancesHelper
  include PlaysHelper
  include RoomsHelper
  include UsersHelper
end
