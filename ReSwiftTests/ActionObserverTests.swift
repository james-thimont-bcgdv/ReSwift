//
//  ActionObserverTests.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 14/09/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation
import XCTest
import ReSwift

class ActionObserverTests: XCTestCase {
    
    var store: Store<TestAppState>!
    var reducer: TestReducer!
    var actionObserver: FakeActionObserver!
    
    override func setUp() {
        super.setUp()
        reducer = TestReducer()
        actionObserver = FakeActionObserver()
        
        store = Store<TestAppState>(reducer: reducer, actionObservers: [AnyActionObserver(actionObserver)])
    }

    func testActionObserver() {
        let action = SetValueAction(5)
        
        store.dispatch(action)
        
        let exp = expectationWithDescription("")
        actionObserver.callback = { action, oldState, newState in
            
            guard let action = action as? SetValueAction where oldState.testValue == nil && newState.testValue == 5 else { return }
            
            XCTAssertEqual(action.value, 5)
            exp.fulfill()
        }
        
        waitForFutureExpectations(withTimeout: 1)
    }
    
    
    class FakeActionObserver: ActionObserver {
        
        var callback: ((Action, oldState: TestAppState, newState: TestAppState) -> Void)?
        
        func newAction(action: Action, oldState: TestAppState, newState: TestAppState) {
            callback?(action, oldState: oldState, newState: newState)
        }
        
    }
}
