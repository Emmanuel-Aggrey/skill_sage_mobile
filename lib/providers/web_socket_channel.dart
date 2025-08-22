part of '_index.dart';

// Make sure AppRoutes is imported in your _index.dart file
// Add this line to your _index.dart: export 'path/to/your/routes.dart';
final wsbaseUrl = dotenv.env['WS_BASE_URL']!;
// final ws_baseUrl = "ws://10.107.131.222:8004";

class SimpleWebSocket {
  WebSocketChannel? _channel;
  Function(String)? onUploadComplete;
  BuildContext? _context; // Add context to enable navigation
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(
      String userId, BuildContext context, Function(String)? onComplete) {
    _context = context; // Store context for navigation
    onUploadComplete = onComplete;
    print('Attempting to connect WebSocket for user: $userId');

    try {
      final wsUrl = "$wsbaseUrl/ws/$userId/";
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
              final uploadMessage = message['message'] ?? 'Upload complete!';

              // Call the callback if provided
              onUploadComplete?.call(uploadMessage);

              // Navigate to home route
              if (_context != null && _context!.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  _context!,
                  '/home',
                  (route) => false, // This removes all previous routes
                );
              }
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
      _context = null; // Clear context reference
    }
  }
}
