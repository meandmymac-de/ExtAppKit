//
//  EventType.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public protocol EventType: Hashable {
    
}

public enum NoEvents: EventType {

    case any
}
