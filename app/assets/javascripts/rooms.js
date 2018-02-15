//メンバー一覧表示
function members_list_view(){
    if(current_room == null) return;
    var code;
    code = "メンバー("+current_room.users.length + (current_room.maximum != -1 ? "/"+current_room.maximum : "") +")";
    code += "<ul>"
    for (var i=0;i<current_room.users.length;i++){
        code += "<li>"+current_room.users[i].name+"</li>";
    }
    code += "</ul>"
    $("#members_list").html(code);
}

//検索許可の表示
function allow_search_view(){
    if (current_room == null) return;
    var code;
    if (current_room.allow_search){
        code= "<p>この部屋は検索が許可されています。</p>"
            + "<p>ルーム名:"+current_room.name+"</p>"
            + "<p>ルームキー:"+current_room.password+"</p>";
    }else{
        code="<p>この部屋は検索が許可されていません。</p>";
    }
    $("#allow_search").html(code);
}

//URLをコピー
function copy_room_url(){
    $("#room_url_text").val($("#room_url_text").attr("data-room-url"));
    $("#room_url_text").select();
    document.execCommand('copy');
}

//URLを選択する
function select_room_url(){
    $("#room_url_text").val($("#room_url_text").attr("data-room-url"));
    $("#room_url_text").select();
}