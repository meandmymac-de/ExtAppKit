//
//  StateMachineTests.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import XCTest
import ExtAppKit

enum States: Int, XStateType {
    case State0 = 0
    case State1 = 1
    case State2 = 2
}

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
        
        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)
        
        stateMachine += (.State0, .State1)

        do {

            try stateMachine => .State1
            XCTAssert(stateMachine.state == .State1, "State Machine is not in .State1")
        }
        catch {

            XCTFail("State Machine threw error while transitioning from .State0 to .State1")
        }
    }

    func testTransitionFails() {

        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)

        stateMachine += (.State0, .State1)

        do {

            try stateMachine => .State2
            XCTFail("State Machine didn't threw error while transitioning from .State0 to .State2")
        }
        catch {}
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
