import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloodconnect/core/network/socket_service.dart';
import 'package:bloodconnect/models/notification_model.dart';

class AlertsProvider extends ChangeNotifier {
  final SocketService _socketService;
  final List<NotificationModel> _alerts = [];
  StreamSubscription? _sub;

  AlertsProvider(this._socketService);

  List<NotificationModel> get alerts => List.unmodifiable(_alerts);

  Future<void> init() async {
    await _socketService.connect();
    _sub = _socketService.urgentAlerts.listen((event) {
      try {
        final n = NotificationModel.fromJson(event);
        _alerts.insert(0, n);
        notifyListeners();
      } catch (e) {
        debugPrint('Alert parse error: $e');
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _socketService.dispose();
    super.dispose();
  }
}
