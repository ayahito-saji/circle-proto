class RoomsController < ApplicationController
  #部屋の作成、閲覧、編集、削除を担当するコントローラ
  before_action :require_login
  before_action :reject_enter, only: [:create]
  before_action :require_enter, only: [:show, :edit, :update]

  #部屋を最初に作成する場合、何も入力することなくトークンと共に作成できる
  def create
    #部屋を新規作成する（この時点でトークンも生成される）
    @room = Room.new
    #プレミアム会員ならば最大人数-1(制限なし)にする
    @room.maximum = -1 if current_user.premium?
    #ルームは検索許可が降りてないので、ルーム名とパスワードがnilでもOK
    @room.skip_search_validation = true
    if @room.save #ルームをセーブする
      enter @room #作った部屋に早速ログインする
      redirect_to root_path #ルーム画面へ
    else
      flash[:danger] = "ルーム作成に失敗しました"
      redirect_to root_path #エンター画面に飛ぶ？
    end
  end

  #部屋を表示する
  def show
  end

  #部屋の設定する
  def edit
  end
  def update
    #部屋の検索許可が下りているならバリデーション（ルーム名かぶりなし、パスワード空白ダメ）を行う
    current_room.skip_search_validation = room_params[:allow_search].to_i.zero?
    if current_room.update_attributes(room_params)
      flash[:success] = "ルーム設定を正しく保存できました"
      redirect_to root_path
    else #部屋の設定に失敗した場合、ルーム名がすでに使用されている
      flash.now[:danger] = "ルーム名、パスワードが空白か、そのルーム名は既に使用されています"
      render 'edit'
    end
  end

  private
  def room_params
    params.require(:room).permit(:name, :password, :allow_search)
  end
end
