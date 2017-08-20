//
//  StateMachine.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation


public enum StateMachineError: Error {

    case NoTransition
    case NonDeterministic
}


public class StateMachine<S: StateType, E: EventType> {
    
    // MARK: - Public Typealiases
    
    /*!
        Type alias for the states
     */
    public typealias States = S
    
    /*!
        Type alias for the events
     */
    public typealias Events = E
    
    /*!
        Signature for a transition handler that expects a context as parameter.
     */
    public typealias TransitionHandler = (StateMachine<States, Events>, Events?, States, States, Any?) -> Void


    // MARK: - Private Properties

    private var _transitions = [StateMachineTransition<States, Events>]()
    private var _events = [Events:[StateMachineTransition<States, Events>]]()
    private var _enterStateHandlers = [States:[TransitionHandler]]()
    private var _leaveStateHandlers = [States:[TransitionHandler]]()
    private var _eventHandlers = [Events:[TransitionHandler]]()
    private var _performer = performBackgroundAsync
    
    
    // MARK: - Public Properties
    
    /*!
        Call handlers in background or foreground
     */
    public var backgroundHandlers: Bool = true {
        didSet {
            
            self._performer = self.backgroundHandlers ? performBackgroundAsync : performAsync
        }
    }
    
    /*!
        The current state of the stae machine
     */
    public private(set) var state: States

    /*!
        The user info object
     */
    public var userInfo: Any? = nil
    
    
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
     
        @throws StateMachineError.NonDeterministic
                    if there is more than one transition
     */
    public func addTransition(from: States, to: States) throws {
        enter()
    
        let transitions = self.transitions(from: from, to: to)

        guard transitions.count == 0 else {
            throw StateMachineError.NonDeterministic
        }

        let transition = StateMachineTransition<States, Events>(from: from, to: to)
        
        self._transitions.append(transition)
    }

    /*!
        Adds a transtion from one state to another that is taken when the given
        event is fired.

        @param from
                    The source state
        @param from
                    The target state
        @param event
                    The event that triggers the transition

        @throws StateMachineError.NonDeterministic
                    if there is more than one transition with the given source 
                    and target states for the event
     */
    public func addTransition(from: States, to: States, forEvent event: Events) throws {
        enter()

        var eventTransitions = self._events[event]
        let transitions = self.searchTransitions(inTransitions: eventTransitions, from: from, to: to)
        
        guard transitions.count == 0 else {
            throw StateMachineError.NonDeterministic
        }
        
        let transition = StateMachineTransition<States, Events>(from: from, to: to)
        
        if eventTransitions == nil {
            
            eventTransitions = [StateMachineTransition<States, Events>]()
        }
        
        eventTransitions?.append(transition)
        self._events[event] = eventTransitions
    }

    /*!
        Adds a handler to a state that is called when the state is entered.
     
        @param state
                    The state for which the handle shall be added
        @param handler
                    The handler
     */
    public func addEnterStateHandler(state: States, handler: @escaping TransitionHandler) {
        enter()
        
        var handlers = self._enterStateHandlers[state]
        
        if handlers == nil {
            
            handlers = [TransitionHandler]()
        }
        
        handlers!.append(handler)
        self._enterStateHandlers[state] = handlers
    }
    
    public func addLeaveStateHandler(state: States, handler: @escaping TransitionHandler) {
        enter()
        
        var handlers = self._leaveStateHandlers[state]
        
        if handlers == nil {
            
            handlers = [TransitionHandler]()
        }
        
        handlers!.append(handler)
        self._leaveStateHandlers[state] = handlers
    }
    
    public func addEventHandler(event: Events, handler: @escaping TransitionHandler) {
        enter()
        
        var handlers = self._eventHandlers[event]
        
        if handlers == nil {
            
            handlers = [TransitionHandler]()
        }
        
        handlers!.append(handler)
        self._eventHandlers[event] = handlers
    }


    // MARK: - State Transitions

    /*!
        Tries to transition the state machine to the given state. Throws an 
        error, if there is no transition from the current state to the given
        state.

        @param toState
                    The target state
     
        @throws StateMachineError.NoTransition 
                    if there is no transition to the target state
        @throws StateMachineError.NonDeterministic
                    if there is more than one transition

     */
    public func tryTransition(toState: States) throws {
        enter()

        let transitions = self.transitions(from: self.state, to: toState)

        guard transitions.count > 0 else {
            throw StateMachineError.NoTransition
        }

        guard transitions.count < 2 else {
            throw StateMachineError.NonDeterministic
        }

        let trans = transitions.first!
        guard trans.fromState == self.state && trans.toState == toState else {
            throw StateMachineError.NoTransition
        }

        self.callHandlers(self._leaveStateHandlers[self.state], nil, self.state, toState)

        self.state = trans.toState

        self.callHandlers(self._enterStateHandlers[self.state], nil, self.state, toState)
    }
    
    /*!
        Tries to transition from the current state to the next state by firing
        the given event.
     
        @param event
                    The event that shall be fired
     
        @throws StateMachineError.NoTransition
                    if there is no transition to the target state
        @throws StateMachineError.NonDeterministic
                    if there is more than one transition
     */
    public func tryEvent(_ event: Events) throws {
        enter()
        
        let eventTransitions = self._events[event]
        let transitions = self.searchTransitions(inTransitions: eventTransitions, from: self.state)
        
        guard transitions.count > 0 else {
            throw StateMachineError.NoTransition
        }
        
        guard transitions.count < 2 else {
            throw StateMachineError.NonDeterministic
        }
        
        let trans = transitions.first!
        
        self.callHandlers(self._leaveStateHandlers[self.state], event, self.state, trans.toState)
        self.callHandlers(self._eventHandlers[event], event, self.state, trans.toState)

        self.state = trans.toState

        self.callHandlers(self._enterStateHandlers[self.state], event, self.state, trans.toState)
    }


    // MARK: - Private Methods

    private func callHandlers(_ handlerList: [TransitionHandler]?, _ event: Events?, _ from: States, _ to: States) {

        if let handlers = handlerList {

            handlers.forEach{ handler in

                self._performer {
                
                    handler(self, event, from, to, self.userInfo)
                }
            }
        }
    }
    
    private func searchTransitions(inTransitions: [StateMachineTransition<States, Events>]?,
                                   _ included: (StateMachineTransition<States, Events>) -> Bool) -> [StateMachineTransition<States, Events>] {
        enter()
        
        guard let _ = inTransitions else {
            
            return [StateMachineTransition<States, Events>]()
        }
        
        let transitions = inTransitions!.filter(included)
        
        return transitions
    }
    
    private func searchTransitions(inTransitions: [StateMachineTransition<States, Events>]?,
                                   from: States) -> [StateMachineTransition<States, Events>] {
        enter()
        
        let transitions = self.searchTransitions(inTransitions: inTransitions) { transition in
            
            return transition.fromState == from
        }
        
        return transitions
    }
    
    private func searchTransitions(inTransitions: [StateMachineTransition<States, Events>]?,
                                   from: States,
                                   to: States) -> [StateMachineTransition<States, Events>] {
        enter()
        
        let transitions = self.searchTransitions(inTransitions: inTransitions) { transition in
            
            return transition.fromState == from && transition.toState == to
        }
        
        return transitions
    }

    private func transitions(from: States, to: States) -> [StateMachineTransition<States, Events>] {
        enter()
        
        return self.searchTransitions(inTransitions: self._transitions, from: from, to: to)
    }
}


/*!
    Adds a transition from one state to another
 
    @param left
                The state machien to which the transition shall be added.
    @param right
                A tupel consisting of two state with (fromState, toState).
 */
public func +=<S: StateType, E: EventType>(left: StateMachine<S, E>, right: (S, S)) throws {
    enter()
    
    let (fromState, toState) = right
    
    try left.addTransition(from: fromState, to: toState)
}

/*!
    Adds a transition from one state to another takes is taken, if the given
    event is fired.
 
    @abstract This operator throws an error if the transition to the new state
                already exists.

    @param left
                The state machien to which the transition shall be added.
    @param right
                A tupel consisting of two state with (event, fromState, toState).
 */
public func +=<S: StateType, E: EventType>(left: StateMachine<S, E>, right: (E, S, S)) throws {
    enter()

    let (event, fromState, toState) = right

    try left.addTransition(from: fromState, to: toState, forEvent: event)
}


// MARK: - Operator

infix operator =>
infix operator >+
infix operator +>
infix operator <+>


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

public func =><S: StateType, E: EventType>(left: StateMachine<S, E>, right: S) throws {
    enter()

    try left.tryTransition(toState: right)
}

/*!
    Triggers a transition for the given event.

    @abstract This operator throws an error if the event can't be fired in the 
                current state.

    @param left
                The event to be fired
    @param right
                The state machinw to to which the state transition shall be
                applied.
 */
public func =><S: StateType, E: EventType>(left: E, right: StateMachine<S, E>) throws {
    enter()

    try right.tryEvent(left)
}

public func >+<S: StateType, E: EventType>(left: (StateMachine<S, E>, S), right: @escaping StateMachine<S, E>.TransitionHandler) {
    enter()
    
    let (stateMachine, state) = left
    
    stateMachine.addEnterStateHandler(state: state, handler: right)
}

public func +><S: StateType, E: EventType>(left: (StateMachine<S, E>, S), right: @escaping StateMachine<S, E>.TransitionHandler) {
    enter()
    
    let (stateMachine, state) = left
    
    stateMachine.addLeaveStateHandler(state: state, handler: right)
}

public func <+><S: StateType, E: EventType>(left: (StateMachine<S, E>, E), right: @escaping StateMachine<S, E>.TransitionHandler) {
    enter()
    
    let (stateMachine, event) = left
    
    stateMachine.addEventHandler(event: event, handler: right)
}
