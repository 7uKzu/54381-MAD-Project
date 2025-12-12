import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:bloodconnect/core/env/env.dart';
import 'package:bloodconnect/core/storage/secure_storage.dart';
import 'package:bloodconnect/core/network/api_client.dart';

class SocketService {
  io.Socket? _socket;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _pollTimer;

  Stream<Map<String, dynamic>> get urgentAlerts => _controller.stream;

  Future<void> connect() async {
    final token = await SecureStorage.accessToken;
    try {
      _socket = io.io(
          AppEnv.baseUrl,
          io.OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNew()
              .setAuth({'token': token})
              .build());

      _socket!.on('connect', (_) => debugPrint('Socket connected'));
      _socket!.on('urgent_alert', (data) {
        if (data is Map) _controller.add(Map<String, dynamic>.from(data));
      });
      _socket!.on('disconnect', (_) => debugPrint('Socket disconnected'));
    } catch (e) {
      debugPrint('Socket error: $e');
      _startPollingFallback();
    }
  }

  void _startPollingFallback() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final resp = await ApiClient.I.get('/notifications/urgent');
        if (resp.data is List) {
          for (final item in (resp.data as List)) {
            if (item is Map) _controller.add(Map<String, dynamic>.from(item));
          }
        }
      } catch (e) {
        debugPrint('Polling error: $e');
      }
    });
  }

  Future<void> dispose() async {
    await _controller.close();
    _pollTimer?.cancel();
    _socket?.dispose();
  }
}
