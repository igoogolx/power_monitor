#include "power_monitor_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace power_monitor {

	// static
	void PowerMonitorPlugin::RegisterWithRegistrar(
		flutter::PluginRegistrarWindows* registrar) {
		auto channel =
			std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
				registrar->messenger(), "power_monitor",
				&flutter::StandardMethodCodec::GetInstance());

		auto plugin = std::make_unique<PowerMonitorPlugin>(registrar);

		channel->SetMethodCallHandler(
			[plugin_pointer = plugin.get()](const auto& call, auto result) {
				plugin_pointer->HandleMethodCall(call, std::move(result));
			});

		registrar->AddPlugin(std::move(plugin));
	}

	PowerMonitorPlugin::PowerMonitorPlugin(flutter::PluginRegistrarWindows* registrar) : registrar_(registrar), notification_channel_(std::move(
		std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
			registrar->messenger(), "power_monitor_notification",
			&flutter::StandardMethodCodec::GetInstance()))) {
		if (window_proc_delegate_id_ == -1) {
			window_proc_delegate_id_ = registrar_->RegisterTopLevelWindowProcDelegate(
				std::bind(&PowerMonitorPlugin::WindowProcDelegate, this,
					std::placeholders::_1, std::placeholders::_2,
					std::placeholders::_3, std::placeholders::_4));
		}

	}

	PowerMonitorPlugin::~PowerMonitorPlugin() {
		if (window_proc_delegate_id_ != -1) {
			registrar_->UnregisterTopLevelWindowProcDelegate(
				static_cast<int32_t>(window_proc_delegate_id_));
		}
	}

	void PowerMonitorPlugin::HandleMethodCall(
		const flutter::MethodCall<flutter::EncodableValue>& method_call,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
		if (method_call.method_name().compare("getPlatformVersion") == 0) {
			std::ostringstream version_stream;
			version_stream << "Windows ";
			if (IsWindows10OrGreater()) {
				version_stream << "10+";
			}
			else if (IsWindows8OrGreater()) {
				version_stream << "8";
			}
			else if (IsWindows7OrGreater()) {
				version_stream << "7";
			}
			result->Success(flutter::EncodableValue(version_stream.str()));
		}
		else {
			result->NotImplemented();
		}
	}

	std::optional<LRESULT> PowerMonitorPlugin::WindowProcDelegate(
		HWND hwnd, UINT iMessage, WPARAM wparam, LPARAM lparam) {
		if (iMessage == WM_QUERYENDSESSION) {
			auto args = std::make_unique<flutter::EncodableValue>("terminate_app");
			notification_channel_->InvokeMethod("on", std::move(args));
		}
		if (iMessage == WM_POWERBROADCAST) {
			if (wparam == PBT_APMSUSPEND) {
				auto args = std::make_unique<flutter::EncodableValue>("sleep");
				notification_channel_->InvokeMethod("on", std::move(args));
			}
			else if (wparam == PBT_APMRESUMEAUTOMATIC) {
				auto args = std::make_unique<flutter::EncodableValue>("woke_up");
				notification_channel_->InvokeMethod("on", std::move(args));
			}
			return TRUE;
		}


		return std::nullopt;
	}




}  // namespace power_monitor
