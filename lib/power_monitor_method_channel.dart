import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'power_monitor_platform_interface.dart';

/// An implementation of [PowerMonitorPlatform] that uses method channels.
class MethodChannelPowerMonitor extends PowerMonitorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('power_monitor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
