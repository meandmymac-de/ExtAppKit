//
//  Logger.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 18.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


// MARK: Enums

/**
    All available log levels. They are hierarchical, i.e. if log level Trace
    is set, all messages with a Debug, Info, ... will be logged.
 */
public enum LogLevel : Int, CustomStringConvertible
{
    case trace   = 1
    case debug   = 2
    case info    = 4
    case warn    = 8
    case error   = 16
    case fatal   = 32
    case none    = 0xffff

    public var description : String {
        get {
            switch(self) {

                case .trace:
                    return "TRACE"

                case .debug:
                    return "DEBUG"

                case .info:
                    return "INFO"

                case .warn:
                    return "WARN"

                case .error:
                    return "ERROR"

                case .fatal:
                    return "FATAL"

                default:
                    return "NONE"

            }
        }
    }
}


// MARK: Type Aliases

/**
    Format a message

    :param: logLevel     The log level of the message
    :param: timestamp    The timestamp of the message
    :param: area         The application area of the message
    :param: message      The message which shall be logged
    :param: functionName Name of the function from which the message is logged
    :param: fileName     Name of the file which the message is logged
    :param: lineNumber   Line number of the log command

    :returns: The formatted message
*/
public typealias LogFormatter = (_ logLevel: LogLevel,
                                 _ timestamp: Date,
                                      _ area: String,
                                   _ message: String,
                              _ functionName: String,
                                  _ fileName: String,
                                _ lineNumber: Int) -> String

/**
    Write the log message to a sink.

    :param: message The message to write
*/
public typealias LogWriter = (_ message: String) -> ()


/**
    Get the Type name of an object
 */
public func TypeName(of obj: Any) -> String {
    return String(describing: type(of: obj))
}


open class Logger {

    private static let _dispatchQ : DispatchQueue = {

            let q = DispatchQueue.global()

            q.resume()
            return q
        }()

    // MARK: Public Properties

    /**
        The log level
     */
    open var logLevel : LogLevel = .info

    /**
        Closure which formmats a message
     */
    open var formatter : LogFormatter!

    /**
        Closure which writes a message
     */
    open var writer   : LogWriter!


    // MARK: Private Properties

    fileprivate var _areaLogLevel = Dictionary<String, LogLevel>()


    // MARK: Initialization

    public init() {

        self.formatter = self.format
        self.writer   = self.write
    }


    // MARK: - Default Instance

    open class func defaultInstance() -> Logger {

        struct statics {
            static let instance: Logger = Logger()
        }

        return statics.instance
    }

    /**
        Set the log level for a specific area.

        :param: area        The area
        :param: logLevel    The log level
    */
    open func setAreaLogLevel(_ area: String, logLevel: LogLevel) {

        self._areaLogLevel[area] = logLevel
    }


    // MARK: Check Methods

    /**
        Checks whether the given log level is enabled.

        :param: logLevel The log level
        :param: area     Are for which the log level shall be checked.

        :returns: true if the log level is enabled, otherwise false
    */
    open func isLogLevelEnabled(_ logLevel: LogLevel, area: String? = nil) -> Bool {

        var level     : LogLevel! = nil
        var isEnabled : Bool

        if area != nil {

            if let lvl = self._areaLogLevel[area!] {

                level = lvl
            }
        }

        if level == nil {

            level = self.logLevel
        }

        isEnabled = level.rawValue <= logLevel.rawValue

        return isEnabled
    }


    // MARK: Log Methods

    /**
        Log a message for the given area.
    
        :param: logLevel     The log level of the message
        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
     */
    open func log(_ logLevel: LogLevel,
                        area: String,
                     message: String,
                functionName: String = #function,
                    fileName: String = #file,
                  lineNumber: Int = #line) {

        if self.isLogLevelEnabled(logLevel) {

            let timestamp = Date()
            let formatedMessage = self.formatter(logLevel, timestamp, area, message, functionName, fileName, lineNumber)

            self.writer(formatedMessage)
        }
    }

    /**
        Log a Trace message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func trace(_ area: String,
                   message: String,
                   functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.trace,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log a Debug message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func debug(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.debug,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Info message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func info(_ area: String,
                  message: String,
             functionName: String = #function,
                 fileName: String = #file,
               lineNumber: Int = #line) {

            self.log(.info,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Info message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func warn(_ area: String,
                  message: String,
             functionName: String = #function,
                 fileName: String = #file,
               lineNumber: Int = #line) {

            self.log(.warn,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Error message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func error(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.error,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log a Fatal message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func fatal(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.fatal,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }


    // MARK: Closure Execution

    /**
        Execute a closure, if the log level is enabled.

        :param: logLevel The log level
        :param: closure  The closure to execute
    */
    open func execute(_ logLevel: LogLevel, closure: () -> () = {}) {

        if self.isLogLevelEnabled(logLevel) {

            closure()
        }
    }

    open func traceExec(_ closure: () -> () = {}) {

        self.execute(.trace, closure: closure)
    }

    open func debugExec(_ closure: () -> () = {}) {

        self.execute(.debug, closure: closure)
    }

    open func infoExec(_ closure: () -> () = {}) {

        self.execute(.info, closure: closure)
    }

    open func warnExec(_ closure: () -> () = {}) {

        self.execute(.warn, closure: closure)
    }

    open func errorExec(_ closure: () -> () = {}) {

        self.execute(.error, closure: closure)
    }

    open func fatalExec(_ closure: () -> () = {}) {

        self.execute(.fatal, closure: closure)
    }


    // MARK: Default Closure Methods

    fileprivate func format(_ logLevel: LogLevel,
                       timestamp: Date,
                            area: String,
                         message: String,
                    functionName: String,
                        fileName: String,
                      lineNumber: Int) -> String {

       //
       return "[\(timestamp)] [\(logLevel)] [\(area)] [\(message)] [\(functionName)] [\(fileName)] [\(lineNumber)]"
    }

    fileprivate func write(_ message: String) {

        Logger._dispatchQ.async {

            NSLog("%@", message)
        }
    }
}


// MARK: Convenience Functions

public func trace(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().trace(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func debug(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().debug(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func info(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().info(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func warn(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().warn(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func error(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().error(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func fatal(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().fatal(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func traceExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.trace, closure: closure)
}

public func debugExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.debug, closure: closure)
}

public func infoExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.info, closure: closure)
}

public func warnExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.warn, closure: closure)
}

public func errorExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.error, closure: closure)
}

public func fatalExec(_ closure: () -> () = {}) {

    Logger.defaultInstance().execute(.fatal, closure: closure)
}

public func enter(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().trace("TRACE", message: "ENTER_FUNCTION", functionName: functionName,fileName: fileName, lineNumber: lineNumber)
}

public func leave(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    Logger.defaultInstance().trace("TRACE", message: "LEAVE_FUNCTION", functionName: functionName,fileName: fileName, lineNumber: lineNumber)
}
