part of '_index.dart';

// Make sure AppRoutes is imported in your _index.dart file
// Add this line to your _index.dart: export 'path/to/your/routes.dart';

class SimpleWebSocket {
  WebSocketChannel? _channel;
  Function(String)? onUploadComplete;
  bool _isConnected = false;
  bool _isUploading = false;
  String? _userId;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _reconnectDelay = Duration(seconds: 2);

  bool get isConnected => _isConnected;
  bool get isUploading => _isUploading;

  void connect(
      String userId, BuildContext context, Function(String)? onComplete,
      {String homeRoute = '/home'}) {
    onUploadComplete = onComplete;
    _userId = userId;
    print('DEBUG: WebSocket connect called with userId: $userId');
    // print('DEBUG: Context mounted: ${context.mounted}');
    // print('DEBUG: HomeRoute: $homeRoute');

    _establishConnection();
  }

  void _establishConnection() {
    if (_userId == null) return;

    try {
      final wsUrl = "$wsbaseUrl/ws/$_userId/";
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
        _reconnectAttempts =
            0; // Reset reconnect attempts on successful connection
      }).catchError((error) {
        print('DEBUG: ❌ WebSocket connection failed: $error');
        _isConnected = false;
        _scheduleReconnect();
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

              // Mark upload as complete
              _isUploading = false;

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
          if (_isUploading) {
            _scheduleReconnect();
          }
        },
        onDone: () {
          print('DEBUG: 🔌 WebSocket connection closed');
          _isConnected = false;
          if (_isUploading) {
            _scheduleReconnect();
          }
        },
      );
    } catch (e) {
      print('DEBUG: ❌ WebSocket connection exception: $e');
      _isConnected = false;
      if (_isUploading) {
        _scheduleReconnect();
      }
    }
  }

  void _scheduleReconnect() {
    if (!_isUploading || _reconnectAttempts >= _maxReconnectAttempts) {
      print(
          'DEBUG: Max reconnect attempts reached or not uploading, stopping reconnection');
      return;
    }

    _reconnectAttempts++;
    print(
        'DEBUG: Scheduling reconnect attempt $_reconnectAttempts in ${_reconnectDelay.inSeconds} seconds');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_isUploading && !_isConnected) {
        print('DEBUG: Attempting reconnect...');
        _establishConnection();
      }
    });
  }

  void startUpload() {
    _isUploading = true;
    _reconnectAttempts = 0;
    print('DEBUG: Upload started, WebSocket will stay connected');
  }

  void stopUpload() {
    _isUploading = false;
    _reconnectTimer?.cancel();
    print('DEBUG: Upload stopped, WebSocket reconnection disabled');
  }

  void disconnect() {
    if (_channel != null) {
      print('Disconnecting WebSocket...');
      _isUploading = false;
      _reconnectTimer?.cancel();
      _channel?.sink.close();
      _isConnected = false;
    }
  }
}
