import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:power_monitor/src/power_monitor_listener.dart';

import 'power_monitor_platform_interface.dart';

const kPowerMonitorEventSleep = 'sleep';
const kPowerMonitorEventWokeUp = 'woke_up';
const kPowerMonitorEventShutdown = 'shutdown';
const kPowerMonitorEventUserChanged = 'user_changed';

/// An implementation of [PowerMonitorPlatform] that uses method channels.
class MethodChannelPowerMonitor extends PowerMonitorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('power_monitor');

  MethodChannelPowerMonitor() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  final ObserverList<PowerMonitorListener> _listeners =
      ObserverList<PowerMonitorListener>();

  @override
  void addListener(PowerMonitorListener listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(PowerMonitorListener listener) {
    _listeners.remove(listener);
  }

  List<PowerMonitorListener> get listeners {
    final List<PowerMonitorListener> localListeners =
        List<PowerMonitorListener>.from(_listeners);
    return localListeners;
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    for (final PowerMonitorListener listener in listeners) {
      if (!_listeners.contains(listener)) {
        return;
      }

      if (call.method != 'on') throw UnimplementedError();

      String eventName = call.arguments;
      Map<String, Function> funcMap = {
        kPowerMonitorEventSleep: listener.onPowerMonitorSleep(),
        kPowerMonitorEventWokeUp: listener.onPowerMonitorWokeUp(),
        kPowerMonitorEventShutdown: listener.onPowerMonitorShutdown(),
        kPowerMonitorEventUserChanged: listener.onPowerMonitorUserChanged(),
      };
      funcMap[eventName]?.call();
    }
  }
}
