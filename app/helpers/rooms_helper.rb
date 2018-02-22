module RoomsHelper
  # メンバーリストを表示するjsコードを表示する
  def members_list_view
    code = "<ul>"
    current_room.users.order(:member_id).each do |user|
      code += "<li>#{user.name}{#{user.play_data}}</li>"
    end
    code += "</ul>"
    return "$('#members_list').html('#{code}');"
  end
  # ルームデータの表示
  def allow_search_view
    if current_room.allow_search?
      code = "<p>この部屋は検索が許可されています。</p>"
      code += "<p>ルーム名:#{current_room.name}</p>"
      code += "<p>ルームキー:#{current_room.password}</p>"
    else
      code = "<p>この部屋は検索が許可されていません。</p>"
    end
    return "$('#allow_search').html('#{code}');"
  end
end
