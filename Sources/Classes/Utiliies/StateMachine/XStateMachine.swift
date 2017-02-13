//
//  XStateMachine.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public class XStateMachine<S: XStateProtocol, E: XEventProtocol> {
    
    // MARK: - Public Typealiases
    
    public typealias State = S
    public typealias Event = E
    
}
