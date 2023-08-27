
import 'power_monitor_platform_interface.dart';

class PowerMonitor {
  Future<String?> getPlatformVersion() {
    return PowerMonitorPlatform.instance.getPlatformVersion();
  }
}
