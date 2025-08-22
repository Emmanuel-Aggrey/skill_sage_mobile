part of '_index.dart';

// Make sure AppRoutes is imported in your _index.dart file
// Add this line to your _index.dart: export 'path/to/your/routes.dart';

class SimpleWebSocket {
  WebSocketChannel? _channel;
  Function(String)? onUploadComplete;
  BuildContext? _context; // Add context to enable navigation
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(
      String userId, BuildContext context, Function(String)? onComplete,
      {String homeRoute = '/home'}) {
    _context = context; // Store context for navigation
    onUploadComplete = onComplete;
    print('DEBUG: WebSocket connect called with userId: $userId');
    // print('DEBUG: Context mounted: ${context.mounted}');
    // print('DEBUG: HomeRoute: $homeRoute');

    try {
      final wsUrl = "$wsbaseUrl/ws/$userId/";
      print('DEBUG: Attempting WebSocket connection to: $wsUrl');

      // Add headers that might help with mobile connections
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['websocket'], // Add WebSocket protocol
      );

      // Handle connection ready
      _channel!.ready.then((_) {
        print('DEBUG: ✅ WebSocket connected successfully!');
        _isConnected = true;
      }).catchError((error) {
        print('DEBUG: ❌ WebSocket connection failed: $error');
        _isConnected = false;
      });

      // Listen to messages
      _channel!.stream.listen(
        (data) {
          // print('DEBUG: 📨 Received WebSocket data: $data');
          try {
            final message = jsonDecode(data);
            // print('DEBUG: 📋 Parsed message: $message');

            if (message['type'] == 'jobs_updated') {
              final uploadMessage =
                  message['message'] ?? 'CV processing complete! Jobs updated.';
              // print('DEBUG: 🎯 Jobs updated message received: $uploadMessage');

              // Call the callback (UserProvider will handle navigation)
              onUploadComplete?.call(uploadMessage);
            }
          } catch (e) {
            // print('DEBUG: ❌ Error parsing WebSocket message: $e');
            print('DEBUG: Raw data was: $data');
          }
        },
        onError: (error) {
          print('DEBUG: ❌ WebSocket stream error: $error');
          _isConnected = false;
        },
        onDone: () {
          print('DEBUG: 🔌 WebSocket connection closed');
          _isConnected = false;
        },
      );
    } catch (e) {
      print('DEBUG: ❌ WebSocket connection exception: $e');
      _isConnected = false;
    }
  }

  void disconnect() {
    if (_channel != null) {
      print('Disconnecting WebSocket...');
      _channel?.sink.close();
      _isConnected = false;
      _context = null; // Clear context reference
    }
  }
}
