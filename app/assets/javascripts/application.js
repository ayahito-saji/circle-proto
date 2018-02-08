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

//JavaScriptサイド
function get_data(data, action_cable){    //データをサーバーから受け取る(data = hash形式), ActionCableでもらったらtrueをもらう
    if (data["body"]["class"] == "redirect")    //class:redirectの場合、指定されたリンクに飛ぶ
        location.href = data["body"]["to"];
    else
        alert("To:Everyone\n" + data['body'] + "\nFrom:" + data['from']);
}
function post_data(data){   //hash形式をサーバーに送る。ActionCableで送れない場合、postしてreloadする。(getリクエストを送る)
    if(!App.room.client_post(data)) {
        $('#post_data').val(JSON.stringify(data));
        $('#post_form').submit();
    }
}
//クライアントサイドのインタプリタ（表示関数）の記述