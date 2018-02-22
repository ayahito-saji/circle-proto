App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    if $("body").attr("data-controller") == "plays"
      App.room.write({'class': 'load'})
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if $("body").attr("data-controller") == "rooms" || $("body").attr("data-controller") == "plays"
      location.reload()

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
      ac_received(data.code)

  write: (data) ->
    @perform 'read', params: data