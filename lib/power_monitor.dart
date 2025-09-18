import 'power_monitor_platform_interface.dart';

class PowerMonitor {
  Future<String?> getPlatformVersion() {
    return PowerMonitorPlatform.instance.getPlatformVersion();
  }

  void setHandler(Future<void> Function(String?)? handler) {
    return PowerMonitorPlatform.instance.setHandler(handler);
  }
}
