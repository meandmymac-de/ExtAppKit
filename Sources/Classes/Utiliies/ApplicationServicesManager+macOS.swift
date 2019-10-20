//
//  File.swift
//  ExtAppKit-macOS
//
//  Created by Thomas Bonk on 19.10.19.
//  Copyright © 2019 Thomas Bonk Softwareentwicklung. All rights reserved.
//

#if os(macOS)
import Cocoa
import CloudKit

public extension PluggableApplicationDelegate {
    @available(OSX 10.13, *)
    func application(_ application: NSApplication, open urls: [URL]) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, open: urls)
            }
        }
    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(sender, openFile: filename) ?? true
        }

        return result
    }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(sender, openFiles: filenames)
            }
        }
    }

    func application(_ sender: NSApplication, openTempFile filename: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(sender, openTempFile: filename) ?? true
        }

        return result
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        var result = true

        for service in __services {
            result = result && service.applicationShouldOpenUntitledFile?(sender) ?? true
        }

        return result
    }

    func applicationOpenUntitledFile(_ sender: NSApplication) -> Bool {
        var result = true

        for service in __services {
            result = result && service.applicationOpenUntitledFile?(sender) ?? true
        }

        return result
    }

    func application(_ sender: Any, openFileWithoutUI filename: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(sender, openFileWithoutUI: filename) ?? true
        }

        return result
    }

    func application(_ sender: NSApplication, printFile filename: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(sender, printFile: filename) ?? true
        }

        return result
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        var result = true

        for service in __services {
            result = result && service.applicationShouldTerminateAfterLastWindowClosed?(sender) ?? true
        }

        return result
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        var result = true

        for service in __services {
            result = result && service.applicationShouldHandleReopen?(sender, hasVisibleWindows: flag) ?? true
        }

        return result
    }

    @available(OSX 10.7, *)
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            }
        }
    }

    @available(OSX 10.7, *)
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
            }
        }
    }

    @available(OSX 10.7, *)
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, didReceiveRemoteNotification: userInfo)
            }
        }
    }

    @available(OSX 10.7, *)
    func application(_ app: NSApplication, willEncodeRestorableState coder: NSCoder) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(app, willEncodeRestorableState: coder)
            }
        }
    }

    @available(OSX 10.7, *)
    func application(_ app: NSApplication, didDecodeRestorableState coder: NSCoder) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(app, didDecodeRestorableState: coder)
            }
        }
    }

    @available(OSX 10.10, *)
    func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(application, willContinueUserActivityWithType:userActivityType) ?? true
        }

        return result
    }

    @available(OSX 10.10, *)
    func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? true
        }

        return result
    }

    @available(OSX 10.10, *)
    func application(_ application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
            }
        }
    }

    @available(OSX 10.10, *)
    func application(_ application: NSApplication, didUpdate userActivity: NSUserActivity) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, didUpdate: userActivity)
            }
        }
    }

    @available(OSX 10.12, *)
    func application(_ application: NSApplication, userDidAcceptCloudKitShareWith metadata: CKShare.Metadata) {
        for service in __services {
            DispatchQueue.main.async {
                service.application?(application, userDidAcceptCloudKitShareWith: metadata)
            }
        }
    }

    func application(_ sender: NSApplication, delegateHandlesKey key: String) -> Bool {
        var result = true

        for service in __services {
            result = result && service.application?(sender, delegateHandlesKey: key) ?? true
        }

        return result
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillFinishLaunching?(notification)
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidFinishLaunching?(notification)
            }
        }
    }

    func applicationWillHide(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillHide?(notification)
            }
        }
    }

    func applicationDidHide(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidHide?(notification)
            }
        }
    }

    func applicationWillUnhide(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillUnhide?(notification)
            }
        }
    }

    func applicationDidUnhide(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidUnhide?(notification)
            }
        }
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillBecomeActive?(notification)
            }
        }
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidBecomeActive?(notification)
            }
        }
    }

    func applicationWillResignActive(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillResignActive?(notification)
            }
        }
    }

    func applicationDidResignActive(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidResignActive?(notification)
            }
        }
    }

    func applicationWillUpdate(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillUpdate?(notification)
            }
        }
    }

    func applicationDidUpdate(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidUpdate?(notification)
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationWillTerminate?(notification)
            }
        }
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidChangeScreenParameters?(notification)
            }
        }
    }

    @available(OSX 10.9, *)
    func applicationDidChangeOcclusionState(_ notification: Notification) {
        for service in __services {
            DispatchQueue.main.async {
                service.applicationDidChangeOcclusionState?(notification)
            }
        }
    }
}

#endif
