part of '_index.dart';

class SimpleWebSocket {
  WebSocketChannel? _channel;
  Function(String)? onUploadComplete;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(String userId, Function(String) onComplete) {
    onUploadComplete = onComplete;
    print('Attempting to connect WebSocket for user: $userId');

    try {
      final wsUrl = "ws://10.71.62.222:8004/ws/$userId/";
      print('WebSocket URL: $wsUrl');

      // Add headers that might help with mobile connections
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['websocket'], // Add WebSocket protocol
      );

      // Handle connection ready
      _channel!.ready.then((_) {
        print('WebSocket connected successfully!');
        _isConnected = true;
      }).catchError((error) {
        print('WebSocket connection failed: $error');
        _isConnected = false;
      });

      // Listen to messages
      _channel!.stream.listen(
        (data) {
          print('Received WebSocket data: $data');
          try {
            final message = jsonDecode(data);
            print('Parsed message: $message');

            if (message['type'] == 'jobs_updated') {
              onUploadComplete?.call(message['message'] ?? 'Upload complete!');
            }
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket stream error: $error');
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
      _isConnected = false;
    }
  }

  void disconnect() {
    if (_channel != null) {
      print('Disconnecting WebSocket...');
      _channel?.sink.close();
      _isConnected = false;
    }
  }
}
