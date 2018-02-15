function input(){
    App.room.write({"class": "input"});
    $('#input').hide();
}

function play_view(){
    if(current_room.var.system.phase == 'title'){
        html_code = "<h1>じゃんけんゲーム</h1>"
        if (!current_user.actioned)
            html_code += "<p><a href='javascript:void(0)' onclick='input()' id='input'>Start</a></p>"
    }
    $("#play_view").html(html_code);
}