// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require_tree .

var current_room;
var current_user;

//ロード時
$(document).on('turbolinks:load', function(){
    if (typeof(gon) != "undefined"){
        //サーバーから変数を受け取る
        if (typeof(gon.current_room) != "undefined")
            current_room = gon.current_room;
        if (typeof(gon.current_user) != "undefined")
            current_user = gon.current_user;
        if (($("body").attr("data-controller") == "rooms")&&($("body").attr("data-action") == "show")){
            members_list_view();
            allow_search_view();
        }
        if (($("body").attr("data-controller") == "plays")&&($("body").attr("data-action") == "show"))
            play_view();
    }
});

//ケーブルでデータをもらった時
function ac_received(data){
    console.log(data);
    switch (data.class){
        //リダイレクト命令
        case "redirect":
            setTimeout(function(){window.location.href = data.to;}, 100 * ((current_user.member_id - data.from + current_room.users.length) % current_room.users.length));
            break;
        //通知を受け取る
        case "notification":
            switch (data.code) {
                //入室の通知
                case "entered":
                    current_room.users.splice(data.user.member_id, 0, {
                        "id": data.user.id,
                        "name": data.user.name,
                        "is_premium": data.user.is_premium
                    });
                    current_room.maximum = data.room.maximum;
                    members_list_view();
                    break;
                //退出の通知
                case "exited":
                    current_room.users.some(function(elem, index){
                        if (elem.id == data.user.id) current_room.users.splice(index, 1);
                    });
                    current_room.maximum = data.room.maximum;
                    members_list_view();
                    break;
                //部屋情報の更新
                case "room_updated":
                    current_room.name = data.room.name;
                    current_room.password = data.room.password;
                    current_room.allow_search = data.room.allow_search;
                    allow_search_view();
                    break;
                //全員入力した通知
                case "all_inputted":
                    alert("全員押したで");
                    break;
                //誰かが入力した通知
                case "any_inputted":

                    break;
            }
            break;
    }
}