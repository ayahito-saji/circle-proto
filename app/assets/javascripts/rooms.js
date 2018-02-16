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