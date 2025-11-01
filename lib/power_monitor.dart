import 'package:power_monitor/src/power_monitor_listener.dart';

import 'power_monitor_platform_interface.dart';

export 'src/power_monitor_listener.dart';

class PowerMonitor {
  Future<String?> getPlatformVersion() {
    return PowerMonitorPlatform.instance.getPlatformVersion();
  }

  static final PowerMonitor instance = PowerMonitor();

  void addListener(PowerMonitorListener listener) {
    PowerMonitorPlatform.instance.addListener(listener);
  }

  void removeListener(PowerMonitorListener listener) {
    PowerMonitorPlatform.instance.removeListener(listener);
  }
}

final powerMonitor = PowerMonitor.instance;
