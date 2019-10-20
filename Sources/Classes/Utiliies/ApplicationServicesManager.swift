//
//  ApplicationServicesManager.swift
//
//  Created by Fernando Ortiz on 2/24/17.
//  Copyright © 2017 Fernando Martín Ortiz. All rights reserved.
//

#if os(macOS)
import Cocoa
import CloudKit
#elseif os(iOS)
import UIKit
import CloudKit
#endif

#if os(macOS)
public typealias ApplicationDelegate = NSApplicationDelegate
public typealias Window = NSWindow
#elseif os(iOS)
public typealias ApplicationDelegate = UIApplicationDelegate
public typealias Window = UIWindow
#endif


/// This is only a tagging protocol.
/// It doesn't add more functionalities yet.
public protocol ApplicationService: ApplicationDelegate {}

open class PluggableApplicationDelegate: NSObject {
    
    public var window: Window?
    
    open var services: [ApplicationService] { return [] }
    private var _services: [ApplicationService]?
    public var __services: [ApplicationService] {
        if _services == nil {
            _services = services
        }
        return _services!
    }
    
    
}
