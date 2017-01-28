//
//  XStateMachine.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 26.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


/**
    This class implements a generic state machine
*/
open class XStateMachine<S: XStateType, E: XStateEventType> {

    // MARK: Private Type Aliases

    public typealias State = S
    public typealias Event = E
    public typealias TransitionCondition = XStateTransition<S>.Condition
    public typealias TransitionCallback = XStateTransition<S>.Callback


    // MARK: Public Type Aliases

    /**
        Callback closure must have this signature.
    */
    public typealias Callback = (XStateMachine<State, Event>) -> ()

    /**
        Closure for an event handler.
    */
    public typealias EventHandler = (XStateMachine<State, Event>, Event, Any?) -> ()


    // MARK: Private Member Variables

    fileprivate var _state              : State! = nil
    fileprivate var _stateToTransitions = [State : [XStateTransition<State>]]()
    fileprivate var _eventToTransitions = [Event : [XStateTransition<State>]]()
    fileprivate var _eventHandlers      = [Event : [EventHandler]]()
    fileprivate var _eventQ             : DispatchQueue!


    // MARK: Public Properties

    /**
        :var:       currentState
        :abstract:  This is the current state of the state machine
    */
    open var state : S {
        enter()

        defer {
            leave()
        }
        return self._state
    }


    // MARK: Initialization/Deinitiakization

    /**
        Initialization of the state machine
    
        :param: initialState    Initial state of the state machine
        :param: initialization  Closure which will be invoke as soon as the 
                                state machine is ready to be initialized.
    */
    public init(initialState: State, initialization: Callback? = nil) {
        enter()

        self._state = initialState
        self._eventQ = DispatchQueue(label: "", attributes: [])

        if initialization != nil {

            initialization!(self)
        }

        defer {
            leave()
        }
    }

    deinit {
        enter()

        self._eventQ = nil

        defer {
            leave()
        }
    }


    // MARK: Add Transitions and Handlers

    /**
        Adds a transition to the state machine.
    
        :param: transition      The transition to be added
        :param: condition       Condition for the transition
        :param: inTransition    Function which will be called when the
                                transition is in progress
    */
    open func addTransition(_ transition: XStateTransition<State>,
                    forEvent: Event? = nil,
                    condition: TransitionCondition? = nil,
                    inTransition: TransitionCallback? = nil,
                    afterTransition: TransitionCallback? = nil) -> XStateTransition<S> {
        enter()

        transition.condition = condition
        transition.inTransition = inTransition
        transition.afterTransition = afterTransition

        if self._stateToTransitions[transition.fromState] != nil {

            self._stateToTransitions[transition.fromState]?.append(transition)
        }
        else {

            self._stateToTransitions.updateValue([transition], forKey: transition.fromState)
        }

        if forEvent != nil {

            if self._eventToTransitions[forEvent!] != nil {

                self._eventToTransitions[forEvent!]?.append(transition)
            }
            else {

                self._eventToTransitions.updateValue([transition], forKey: forEvent!)
            }
        }

        defer {
            leave()
        }
        return transition
    }

    /**
        Adds an event handler which will be called, whenever the event fires.

        :param: event   The event
        :param: handler The handler
    */
    open func addEventHandler(_ event: Event, handler: @escaping EventHandler) {
        enter()

        if self._eventHandlers[event] != nil {

            self._eventHandlers[event]?.append(handler)
        }
        else {
            self._eventHandlers.updateValue([handler], forKey: event)
        }

        defer {
            leave()
        }
    }


    // MARK: Do Transitions

    /**
        This method executes a transition to a target state.
    
        :param: state   Target state
        :param: context The context for the transition
    
        :returns: true if the transition succeeded, otherwise false
    */
    open func tryState(_ state: State, context: Any? = nil) -> Bool {
        enter()

        var transitioned = false
        let transitions : [XStateTransition<State>]? = self._stateToTransitions[self.state]

        transitioned = self.tryTransition(transitions,
            context: context,
            transitionTest: { transition in
                return transition.toState == state
            })

        defer {
            leave()
        }
        return transitioned
    }

    /**
        This method executes a transition based on an event.

        :param: event   Event which triggers the transition
        :param: context The context for the transition

        :returns: true if the transition succeeded, otherwise false
    */
    open func tryEvent(_ event: Event, context: Any? = nil) -> Bool {
        enter()

        var transitioned = false
        let transitions  : [XStateTransition<State>]? = self._eventToTransitions[event]
        var handlers     : [EventHandler]? = self._eventHandlers[event]

        if handlers != nil {

            DispatchQueue.concurrentPerform(iterations: handlers!.count, execute: { index in

                let handler = handlers?[Int(index)]

                handler!(self, event, context)
            })
        }

        transitioned = self.tryTransition(transitions,
            context: context,
            transitionTest: { transition in
                return transition.fromState == self.state
            })

        defer {
            leave()
        }
        return transitioned
    }

    fileprivate func tryTransition(_ transitions: [XStateTransition<State>]?,
        context: Any? = nil,
        transitionTest: (XStateTransition<State>) -> Bool) -> Bool {

        var transitioned = false

        if transitions != nil {

            for transition in transitions! {

                if transitionTest(transition) {

                    if transition.checkCondition(context) {

                        transition.doInTransition(context)
                        self._state = transition.toState
                        transition.doAfterTransition(context)
                        transitioned = true

                        break
                    }
                }
            }
        }

        return transitioned
    }
}


// MARK: Transition Operators

precedencegroup transitionOperatorRight {

    associativity: right
}

infix operator <- : transitionOperatorRight


/**
    This operator executes a transition to a target state.
*/
public func <- <S: XStateType, E: XStateEventType>(machine: XStateMachine<S, E>, state: S) -> Bool {
    enter()

    defer {
        leave()
    }
    return machine.tryState(state)
}

/**
    This operator executes a transition to a target state with a context.
*/
public func <- <S: XStateType, E: XStateEventType>(machine: XStateMachine<S, E>, tuple: (S, Any?)) -> Bool {
    enter()

    defer {
        leave()
    }
    return machine.tryState(tuple.0, context: tuple.1)
}

/**
    This operator executes a transition to a target state by firing an event.
*/
public func <- <S: XStateType, E: XStateEventType>(machine: XStateMachine<S, E>, event: E) -> Bool {
    enter()

    defer {
        leave()
    }
    return machine.tryEvent(event)
}

/**
    This operator executes a transition to a target state by firing an event
    with a context.
*/
public func <- <S: XStateType, E: XStateEventType>(machine: XStateMachine<S, E>, tuple: (E, Any?)) -> Bool {
    enter()

    defer {
        leave()
    }
    return machine.tryEvent(tuple.0, context: tuple.1)
}
