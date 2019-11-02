Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  print('message');
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
}
