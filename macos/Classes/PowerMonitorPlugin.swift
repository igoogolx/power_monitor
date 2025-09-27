import Cocoa
import FlutterMacOS

public class PowerMonitorPlugin: NSObject, FlutterPlugin {
    var methodChannel: FlutterMethodChannel?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "power_monitor", binaryMessenger: registrar.messenger)
        let instance = PowerMonitorPlugin()
        instance.methodChannel=channel;
        instance.observeNotification()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        default:
            result(FlutterMethodNotImplemented)
        }
    }


    public func observeNotification() {

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(notificationListener(_:)),
                                                          name: NSWorkspace.willSleepNotification, object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(notificationListener(_:)),
                                                          name: NSWorkspace.didWakeNotification, object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(notificationListener(_:)),
                                                          name: NSWorkspace.sessionDidResignActiveNotification, object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(notificationListener(_:)),
                                                          name: NSWorkspace.willPowerOffNotification, object: nil)

    }


    @objc public func notificationListener(_ aNotification: Notification) {

        if aNotification.name == NSWorkspace.willSleepNotification {
            methodChannel?.invokeMethod("on", arguments: "sleep")
            NSLog("Going to sleep")
        } else if aNotification.name == NSWorkspace.didWakeNotification {
            methodChannel?.invokeMethod("on", arguments: "woke_up")
            NSLog("Woke up")
        }
        else if aNotification.name == NSWorkspace.sessionDidResignActiveNotification {
            methodChannel?.invokeMethod("on", arguments: "user_changed")
            NSLog("User changed")
        }
        else if aNotification.name == NSWorkspace.willPowerOffNotification {
            methodChannel?.invokeMethod("on", arguments: "shutdown")
            NSLog("Shutdown")
        }else {
            NSLog("Some other event other than the first two")
        }
    }
}
