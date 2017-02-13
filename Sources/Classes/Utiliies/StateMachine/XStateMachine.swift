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
    
    /*!
        Type alias for the states
     */
    public typealias States = S
    
    /*!
        Type alias for the events
     */
    public typealias Events = E
    
    
    // MARK: - Public Properties
    
    /*!
        The current state of the stae machine
     */
    public private(set) var state: States
    
    
    // MARK: - Initialization
    
    /*!
        Initializes the state machine.
     
        @param initialState
                    The initial state of the state machine
     */
    public init(initialState: States) {
        enter()
        
        self.state = initialState
    }
}


/*!
    Adds a transition from one state to another
 
    @param left
                The state machien to which the transition shall be added.
    @param right
                A tupel consisting of two state with (fromState, toState).
 */
public func +=<S: XStateProtocol, E: XEventProtocol>(left: XStateMachine<S, E>, right: (S, S)) {
    enter()
    
}


/*!
    Triggers a transition to the given state.
 
    @abstract This operator throws an error if the transition to the new state
                doesn't exist.
 
    @param left
                The state machinw to to which the state transition shall be 
                applied.
    @param right
                The new state of the state machine.
 */
infix operator =>
public func =><S: XStateProtocol, E: XEventProtocol>(left: XStateMachine<S, E>, right: S) throws {
    enter()
    
}
