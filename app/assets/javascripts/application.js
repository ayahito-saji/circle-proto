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
//ロード時
$(document).on('turbolinks:load', function(){
    if (typeof(gon) != "undefined"){
        //サーバーからjavascriptコードを受け取って実行して、受け取ったコードは破棄する
        if (typeof(gon.code) != "undefined")
            console.log(gon.code);
            eval(gon.code);
            delete gon.code;
    }
});

var loaded = false;
//データを受け取り時
function ac_received(data) {
    if (data.class == "load" && loaded) return;
    if (data.class == "load") loaded = true;
    console.log(data.code);
    eval(data.code);
}