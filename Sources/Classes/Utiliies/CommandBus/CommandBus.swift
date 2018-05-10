//
//  CommandBus.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 03.11.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/** 
    Class that provides a CommandBus implementation.
*/
open class CommandBus {

    // MARK: Class Constants

    private static let _instance : CommandBus = { CommandBus() }()


    // MARK: Public Types

    public typealias CommandHandler = (Command) -> ()


    // MARK: Private Types

    fileprivate typealias CommandHandlerTuple = (AnyObject, CommandHandler)


    // MARK: Private Properties

    fileprivate var _commandHandlerDirectory = [String:Array<CommandHandlerTuple>]()


    // MARK: Singleton Property

    /**
        :var:       sharedInstance
        :abstract:  Retrieve the singleton instance of the command bus.
    */
    open class var sharedInstance : CommandBus {
        enter()

        defer {
            leave()
        }

        return CommandBus._instance
    }
    
    
    // MARK: Initialization for local command bus
    
    public init() {
        
    }


    // MARK: Public Methods

    open func registerHandler(_ object: AnyObject, commandHandler: @escaping CommandHandler, command: AnyClass) throws {
        enter()

        guard let _ = command as? Command.Type else {

            throw CommandBusError.classNotACommand
        }

        let mirror = Mirror(reflecting: command)
        let commandId = String(describing: mirror.subjectType).split{$0 == "."}.map(String.init)[0]
        var handlers: Array<CommandHandlerTuple>? = nil

        if self._commandHandlerDirectory.keys.contains(commandId) {

            handlers = self._commandHandlerDirectory[commandId]
        }
        else {

            handlers = Array<CommandHandlerTuple>()
        }

        handlers?.append((object, commandHandler))
        self._commandHandlerDirectory[commandId] = handlers

        defer {
            leave()
        }
    }

    open func removeHandler(_ object: AnyObject, command: AnyClass) throws {
        enter()

        guard let _ = command as? Command.Type else {

            throw CommandBusError.classNotACommand
        }

        let mirror = Mirror(reflecting: command)
        let commandId = String(describing: mirror.subjectType).split{$0 == "."}.map(String.init)[0]

        guard self._commandHandlerDirectory.keys.contains(commandId) else {

            throw CommandBusError.commandNotRegistered
        }

        var handlers = self._commandHandlerDirectory[commandId]

        handlers = handlers!.filter({ $0.0 !== object })

        if handlers?.count > 0 {

            self._commandHandlerDirectory[commandId] = handlers
        }
        else {

            self._commandHandlerDirectory.removeValue(forKey: commandId)
        }

        defer {
            leave()
        }
    }

    open func sendCommand(_ command: Command) {
        enter()

        let mirror = Mirror(reflecting: command.self)
        let commandId = String(describing: mirror.subjectType)

        if let handlers = self._commandHandlerDirectory[commandId] {

            for handler in handlers {

                performAsync {

                    handler.1(command)
                }
            }
        }

        defer {
            leave()
        }
    }
    
    open func callHandler(forCommand command: Command) {
        enter()
        
        let mirror = Mirror(reflecting: command.self)
        let commandId = String(describing: mirror.subjectType)
        
        if let handlers = self._commandHandlerDirectory[commandId] {
            
            for handler in handlers {
                
                handler.1(command)
            }
        }
        
        defer {
            leave()
        }
    }
}
