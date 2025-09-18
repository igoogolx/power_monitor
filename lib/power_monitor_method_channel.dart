import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'power_monitor_platform_interface.dart';

/// An implementation of [PowerMonitorPlatform] that uses method channels.
class MethodChannelPowerMonitor extends PowerMonitorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('power_monitor');
  final notificationMethodChannel = const MethodChannel(
    'power_monitor_notification',
  );

  static Future<void> Function(String?)? _handler;

  MethodChannelPowerMonitor() {
    notificationMethodChannel.setMethodCallHandler((call) async {
      if (call.method == 'on') {
        if (_handler != null) {
          await _handler!(call.arguments);
        }
      }
      return null;
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  void setHandler(Future<void> Function(String?)? handler) {
    _handler = handler;
  }
}
