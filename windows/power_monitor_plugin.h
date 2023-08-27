#ifndef FLUTTER_PLUGIN_POWER_MONITOR_PLUGIN_H_
#define FLUTTER_PLUGIN_POWER_MONITOR_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace power_monitor {

class PowerMonitorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PowerMonitorPlugin();

  virtual ~PowerMonitorPlugin();

  // Disallow copy and assign.
  PowerMonitorPlugin(const PowerMonitorPlugin&) = delete;
  PowerMonitorPlugin& operator=(const PowerMonitorPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace power_monitor

#endif  // FLUTTER_PLUGIN_POWER_MONITOR_PLUGIN_H_
