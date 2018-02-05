class SessionsController < ApplicationController
  # ログインログアウトを担当するコントローラ
  before_action :reject_login, only: [:create]
  before_action :require_login, only: [:destroy]

  # ログイン
  def new
    if login? # reject_loginの特殊な形
      if !params[:p].nil? # ログインしていてかつ入室パラメータがある場合はエンターが実行される
        redirect_to append_query(enter_path, p: params[:p])
        return
      else
        redirect_to append_query(root_path, p: params[:p])
        return
      end
    end
  end
  def create
    # メールアドレス(小文字)でユーザーを検索
    user = User.find_by(email: login_params[:email].downcase)
    if !user.nil? && user.authenticate(login_params[:password])
      login user
      if !params[:p].nil? # 入室トークンを覚えていたら入室する
        redirect_to append_query(enter_path, p: params[:p])
      else # そうでなければ、rootパスに飛ぶ
        redirect_to root_path
      end
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います"
      render 'new'
    end
  end

  # ログアウト
  def destroy
    logout
    redirect_to root_path
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end

end
