App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data["body"]["class"] == "redirect"
      location.href = data["body"]["to"];
    else
      alert "To:Everyone\n" + data['body'] + "\nFrom:" + data['from']

  client_post: (body) ->
    @perform 'server_get', body: body