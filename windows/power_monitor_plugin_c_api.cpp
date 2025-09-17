#include "include/power_monitor/power_monitor_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "power_monitor_plugin.h"

void PowerMonitorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  power_monitor::PowerMonitorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
