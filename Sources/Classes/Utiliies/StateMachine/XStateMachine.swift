//
//  XStateMachine.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation


public enum XStateMachineError: Error {

    case NoTransition
    case NonDeterministic
}


public class XStateMachine<S: XStateType, E: XEventType> {
    
    // MARK: - Public Typealiases
    
    /*!
        Type alias for the states
     */
    public typealias States = S
    
    /*!
        Type alias for the events
     */
    public typealias Events = E


    // MARK: - Private Properties

    private var _transitions = [XStateMachineTransition<States, Events>]()
    
    
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
    
    
    // MARK: - Define State Machine

    /*!
        Adds a transtion from one state to another.

        @param from
                    The source state
        @param from
                    The target state
     */
    public func addTransition(from: States, to: States) throws {
        enter()

        let transitions = self.transitions(from: from, to: to)

        guard transitions.count == 0 else {
            throw XStateMachineError.NonDeterministic
        }

        let transition = XStateMachineTransition<States, Events>(from: from, to: to)
        
        self._transitions.append(transition)
    }


    // MARK: - State Transitions

    /*!
        Tries to transition the state machine to the given state. Throws an 
        error, if there is no transition from the current state to the given
        state.

        @param toState
                    The target state
     
        @throws XStateMachineError.NoTransition 
                    if there is no transition to the target state
        @throws XStateMachineError.NonDeterministic
                    if there is more than one transition

     */
    public func tryTransition(toState: States) throws {
        enter()

        let transitions = self.transitions(from: self.state, to: toState)

        guard transitions.count > 0 else {
            throw XStateMachineError.NoTransition
        }

        guard transitions.count < 2 else {
            throw XStateMachineError.NonDeterministic
        }

        let trans = transitions.first!
        guard trans.fromState == self.state && trans.toState == toState else {
            throw XStateMachineError.NoTransition
        }

        self.state = transitions.first!.toState
    }


    // MARK: - Private Methods

    private func transitions(from: States, to: States) -> [XStateMachineTransition<States, Events>] {
        enter()

        let transitions = self._transitions.filter { transition in

            return transition.fromState == from && transition.toState == to
        }

        return transitions
    }
}


/*!
    Adds a transition from one state to another
 
    @param left
                The state machien to which the transition shall be added.
    @param right
                A tupel consisting of two state with (fromState, toState).
 */
public func +=<S: XStateType, E: XEventType>(left: XStateMachine<S, E>, right: (S, S)) throws {
    enter()
    
    let (fromState, toState) = right
    
    try left.addTransition(from: fromState, to: toState)
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
public func =><S: XStateType, E: XEventType>(left: XStateMachine<S, E>, right: S) throws {
    enter()

    try left.tryTransition(toState: right)
}
