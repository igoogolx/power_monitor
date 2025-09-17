import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'power_monitor_method_channel.dart';

abstract class PowerMonitorPlatform extends PlatformInterface {
  /// Constructs a PowerMonitorPlatform.
  PowerMonitorPlatform() : super(token: _token);

  static final Object _token = Object();

  static PowerMonitorPlatform _instance = MethodChannelPowerMonitor();

  /// The default instance of [PowerMonitorPlatform] to use.
  ///
  /// Defaults to [MethodChannelPowerMonitor].
  static PowerMonitorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PowerMonitorPlatform] when
  /// they register themselves.
  static set instance(PowerMonitorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
