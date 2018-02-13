class EntrancesController < ApplicationController
  # 入室、退室を担当するコントローラ
  before_action :require_login, only: [:create]
  before_action :reject_enter, only: [:create]
  before_action :require_enter, only: [:destroy]
  def new # 入室する
    if login?
      if !params[:p].nil? # ログインしていて部屋トークンを記憶しているならば
        # 該当するトークンをもつ部屋が存在するか調べる
        room = Room.find_by(token: params[:p])
        if !room.nil? # 該当する部屋が存在する場合
          # 現在のルームと同じ部屋に入ろうとしていたら入室の必要はないのでrootパス(=部屋)へと移動する
          if enter? and current_room.id == room.id
            redirect_to root_path
            return
          end
          # そうでないなら入室しようとする。
          if enter room
            #RoomChannel.broadcast_to(current_user.room_id, body: "Entered", from: current_user.name)
            broadcast_to_room(current_room, "Entered", except: [current_user])
            redirect_to root_path
            return
          else # 入室失敗の原因は部屋が満員なので、その場合は部屋を探すビューをうつす
            flash.now[:danger] = "ルームに入ることができませんでした。ルームが満員(7/7)か、プレイ中です。"
          end
        else # 該当するトークンをもつ部屋が存在しない場合、部屋を探すビューをうつす
          flash.now[:danger] = "そのURLをもつルームが存在しません。"
        end
      end
    else # ログインしてない場合はrootパス(=ログイン画面)へ遷移する
      redirect_to append_query(login_path, p: params[:p])
      return
    end
  end

  def create
    # ルームにルーム名とルームキーで入室する
    # 検索許可が出ている部屋のリストから名前で検索
    room = Room.where(allow_search: true).find_by(name: enter_params[:name])
    #ルームが存在して、かつルームパスワードが一致した場合、入室を試みる
    if !room.nil? && room.password == enter_params[:password]
      if enter room
        #RoomChannel.broadcast_to(current_user.room_id, body: "Entered", from: current_user.name)
        broadcast_to_room(current_room, "Entered", except: [current_user])
        redirect_to root_path
        return
      else# ルームに入れないときは満員なので、表示する
        flash.now[:danger] = "ルームに入ることができませんでした。ルームが満員(7/7)か、プレイ中です。"
      end
    else# ルームが存在しない、またはパスワードが間違っている場合エラーを吐く
      flash.now[:danger] = "該当するルーム名とルームキーをもつルームが存在しません。"
    end
    render 'new'
  end

  def show
  end

  def destroy
    broadcast_to_room(current_room, "Exited", except: [current_user])
    exit
    redirect_to root_path
  end
  def enter_params
    params.require(:entrance).permit(:name, :password)
  end
end
