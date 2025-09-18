import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:power_monitor/power_monitor.dart';
import 'package:power_monitor/power_monitor_method_channel.dart';
import 'package:power_monitor/power_monitor_platform_interface.dart';

class MockPowerMonitorPlatform
    with MockPlatformInterfaceMixin
    implements PowerMonitorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void setHandler(Future<void> Function(String?)? handler) {}
}

void main() {
  final PowerMonitorPlatform initialPlatform = PowerMonitorPlatform.instance;

  test('$MethodChannelPowerMonitor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPowerMonitor>());
  });

  test('getPlatformVersion', () async {
    PowerMonitor powerMonitorPlugin = PowerMonitor();
    MockPowerMonitorPlatform fakePlatform = MockPowerMonitorPlatform();
    PowerMonitorPlatform.instance = fakePlatform;

    expect(await powerMonitorPlugin.getPlatformVersion(), '42');
  });
}
