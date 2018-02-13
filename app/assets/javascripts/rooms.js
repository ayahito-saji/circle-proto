//ロード時
$(document).on('turbolinks:load', function(){
    if (typeof(gon) != "undefined"){
        //サーバーから変数を受け取る
        room = gon.room;
        members_list_view();
        allow_search_view();
    }
});

//メンバー一覧表示
function members_list_view(){
    if(room == null) return;
    var code;
    code = "メンバー("+room.users.length + (room.maximum != -1 ? "/"+room.maximum : "") +")";
    code += "<ul>"
    for (var i=0;i<room.users.length;i++){
        code += "<li>"+room.users[i].name+"</li>";
    }
    code += "</ul>"
    $("#members_list").html(code);
}

//検索許可の表示
function allow_search_view(){
    if (room == null) return;
    var code;
    if (room.allow_search){
        code= "<p>この部屋は検索が許可されています。</p>"
            + "<p>ルーム名:"+room.name+"</p>"
            + "<p>ルームキー:"+room.password+"</p>";
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