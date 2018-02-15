App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if $("body").attr("data-controller") == "rooms" || $("body").attr("data-controller") == "plays"
      location.reload()

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if !(typeof(data.except) != "undefined" and data.except.indexOf(current_user.member_id) != -1)
      ac_received(data)

  write: (data) ->
    @perform 'read', data