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

var room;

//ケーブル接続時
function ac_connected(){

}

function ac_received(data){
    console.log(data);
    switch (data.class){
        //リダイレクト命令
        case "redirect":
            window.location.href = data.to;
            break;
        //通知を受け取る
        case "notification":
            switch (data.code) {
                //入室の通知
                case "entered":
                    room.users.splice(data.user.member_id, 0, {
                        "id": data.user.id,
                        "name": data.user.name,
                        "is_premium": data.user.is_premium
                    });
                    room.maximum = data.room.maximum;
                    members_list_view();
                    break;
                //退出の通知
                case "exited":
                    room.users.some(function(elem, index){
                        if (elem.id == data.user.id) room.users.splice(index, 1);
                    });
                    room.maximum = data.room.maximum;
                    members_list_view();
                    break;
                //部屋情報の更新
                case "room_updated":
                    room.name = data.room.name;
                    room.password = data.room.password;
                    room.allow_search = data.room.allow_search;
                    allow_search_view();
                    break;
                case "all_inputted":

                    break;
            }
            break;
    }
}