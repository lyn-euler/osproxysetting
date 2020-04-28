import Flutter
import UIKit

public class SwiftOsproxysettingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "osproxysetting", binaryMessenger: registrar.messenger())
        let instance = SwiftOsproxysettingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let proxySettings = SwiftOsproxysettingPlugin.systemProxySettings()
        result(proxySettings)
    }
    /// 获取系统代理设置
    public static func systemProxySettings() -> [String: String] {
        
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() else {
            return [String: String]()
        }
        let count = Int(CFDictionaryGetCount(proxySettings))
        let keys = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: count)
        let values = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: count)
        CFDictionaryGetKeysAndValues(proxySettings, keys, values)
        var systemProxySettings = [String: String]()
        for i in 0 ..< count {
            guard let key = stringFromPointer(keys[i]) else {
                break
            }
            guard let value = stringFromPointer(values[i]) else {
                break
            }
            systemProxySettings[key] = value
        }
        return systemProxySettings
    }

    static func stringFromPointer(_ pointer: UnsafeRawPointer?) -> String? {
        guard let p = pointer else {
            return nil
        }
        let obj = Unmanaged<AnyObject>.fromOpaque(p).takeUnretainedValue()
//        return obj
        if CFGetTypeID(obj) == CFStringGetTypeID() {
            return obj as? String
        }else if CFGetTypeID(obj) == CFNumberGetTypeID() {
            let i =  obj as? Int ?? 0
            return String(describing: i)
        }else if CFGetTypeID(obj) == CFArrayGetTypeID() {
            let arr = obj as? Array<UnsafeRawPointer> ?? []
            var result = [String]()
            for item in arr {
                if let str = stringFromPointer(item) {
                    result.append(str)
                }
            }
            return "\(result)"
        }
        return nil
    }
}
