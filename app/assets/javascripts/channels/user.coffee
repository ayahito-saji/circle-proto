App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    ac_connected()

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if $("body").attr("data-controller") == "rooms" || $("body").attr("data-controller") == "plays"
      location.reload();

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    ac_received(data)

  write: (data) ->
    @perform 'read', data