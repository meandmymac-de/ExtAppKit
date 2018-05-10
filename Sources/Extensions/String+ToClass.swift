//
//  String+ToClass.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 10.05.18.
//  Copyright © 2018 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public extension String {
    
    func toClass<T>() -> T.Type? {
        return toClass(from: Bundle.main)
    }
    
    func toClass<T>(from bundle: Bundle) -> T.Type?  {
        return StringClassConverter<T>.convert(bundle: bundle, className: self)
    }
}

private class StringClassConverter<T> {
    
    static func convert(bundle: Bundle, className: String) -> T.Type? {
        guard let nameSpace = bundle.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        
        guard let aClass: T.Type = NSClassFromString("\(nameSpace).\(className)") as? T.Type else {
            return nil
        }
        
        return aClass
        
    }
    
}
