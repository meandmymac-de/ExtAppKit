//
//  XStateTransition.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 26.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    This class represents a transitio between two states
*/
open class XStateTransition<S: XStateType> {

    // MARK: Private Type Aliases

    public typealias State = S


    // MARK: Public Type Aliases

    public typealias Condition = (_ transition: XStateTransition<S>, _ context: Any?) -> Bool
    public typealias Callback = (_ transition: XStateTransition<S>, _ context: Any?) -> ()


    // MARK: Private Member Variables

    fileprivate var _fromState      : State!
    fileprivate var _toState        : State!


    // MARK: Public Properties

    /**
        State from which the transition starts
    */
    open var fromState : State {
        enter()

        defer {
            leave()
        }
        return self._fromState
    }

    /**
        Target state of the transition
    */
    open var toState : State {
        enter()

        defer {
            leave()
        }
        return self._toState
    }

    /**
        Condition for the transition
    */
    open var condition : Condition? = nil

    /**
        Function which will be called, when the transition is in progress
    */
    open var inTransition   : Callback? = nil

    /**
        Function which will be called, when the transition is in progress
    */
    open var afterTransition   : Callback? = nil


    // MARK: Initialization

    /**
        Initializes a transition
    
        :param: fromState       Source state of the transition
        :param: toState         Target state of the transition
        :param: condition       Condition for the transition
        :param: inTransition    Function which will be called when the 
                                transition is in progress
        :param: afterTransition Function which will be called after the
                                transition succeeded
    */
    public init(fromState: State, toState: State, condition: Condition? = nil, inTransition: Callback? = nil, afterTransition: Callback? = nil) {

        self._fromState = fromState
        self._toState = toState
        self.condition = condition
        self.inTransition = inTransition
        self.afterTransition = afterTransition
    }


    // MARK: Call Functions

    open func checkCondition(_ context: Any? = nil) -> Bool {
        enter()

        var result = true

        if self.condition != nil {

            result = self.condition!(self, context)
        }

        defer {
            leave()
        }
        return result
    }

    open func doInTransition(_ context: Any? = nil) {
        enter()

        if self.inTransition != nil {

            self.inTransition!(self, context)
        }

        defer {
            leave()
        }
    }

    open func doAfterTransition(_ context: Any? = nil) {
        enter()

        if self.afterTransition != nil {

            self.afterTransition!(self, context)
        }

        defer {
            leave()
        }
    }
}


// MARK: Operators for creating transitions


precedencegroup transitionOperatorLeft {

    associativity: left
}

infix operator => : transitionOperatorLeft


/**
    Create a transition from a source state to a target state
*/
public func => <S: XStateType>(left: S, right: S) -> XStateTransition<S> {
    enter()

    defer {
        leave()
    }
    return XStateTransition(fromState: left, toState: right)
}
