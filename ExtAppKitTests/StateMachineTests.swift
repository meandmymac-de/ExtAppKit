//
//  StateMachineTests.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import XCTest
import ExtAppKit

class StateMachineTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTransition() {
        
        enum States: Int, XStateProtocol {
            case State0 = 0
            case State1 = 1
        }
        
        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)
        
        stateMachine += (.State0, .State1)
        try! stateMachine => .State1
        
        XCTAssert(stateMachine.state == .State1, "State Machine is not in .State1")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
