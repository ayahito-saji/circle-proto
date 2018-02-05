class UsersController < ApplicationController
  # ユーザーの作成、閲覧、編集を行うコントローラ
  before_action :reject_login, only: [:new, :create]
  before_action :require_login, only: [:show, :edit, :update, :destroy]

  # ユーザーの新規登録を行う
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      login@user
      if !params[:p].nil?
        redirect_to append_query(enter_path, p: params[:p])
      else
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  # ユーザーアカウントページ
  def show
  end

  # ユーザー設定の編集ページ
  def edit
  end
  def update
    if current_user.update_attributes(user_params)
      flash[:success] = "アカウント設定を正しく保存できました"
      redirect_to account_path
    else
      flash.now[:danger] = "アカウント情報に誤りがあります"
      render 'edit'
    end
  end

  # ユーザー削除ページ
  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end