//
//  Optional.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 20.08.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public class Optional<T> {
    
    // MARK: Public Properties
    
    public private(set) var object: T? = nil
    
    public var isPresent: Bool {
        
        return self.object != nil
    }
    
    
    // MARK: Initialization
    
    public init(_ object: T?) {
        
        self.object = object
    }
    
    
    // MARK: Class Methods
    
    public class func empty<T>() -> Optional<T> {
        
        return Optional<T>(nil)
    }
    
    
    // MARK: Public Methods
    
    public func ifPresent(_ closure: (T) -> ()) -> Optional<T> {
        
        guard self.isPresent else {
            return self
        }
        
        closure(self.object!)
        return self
    }
    
    public func orElse(_ newObject: T) -> Optional<T> {
        guard !self.isPresent else {
            return self
        }
        
        self.object = newObject
        return self
    }
    
    public func orElseGet(_ closure: () -> T) -> Optional<T> {
        guard !self.isPresent else {
            return self
        }
        
        self.object = closure()
        return self
    }
}
