//
//  StoreSubscriptionTests.swift
//  ReSwift
//
//  Created by Benjamin Encz on 11/27/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import XCTest
/**
 @testable import for internal testing of `Store.subscriptions`
 */
@testable import ReSwift

class StoreSubscriptionTests: XCTestCase {

    typealias TestSubscriber = TestStoreSubscriber<TestAppState>

    var store: Store<TestAppState>!
    var reducer: TestReducer!

    override func setUp() {
        super.setUp()
        reducer = TestReducer()
        store = Store(reducer: reducer, initialState: TestAppState())
    }

    /**
     It does not strongly capture an observer
     */
    func testStrongCapture() {
        store = Store(reducer: reducer, initialState: TestAppState())
        var subscriber: TestSubscriber? = TestSubscriber()

        let exp = expectationWithDescription("")
        store.subscribe(subscriber!)
        dispatch_async(dispatch_get_main_queue()) { 
            exp.fulfill()
        }
        waitForFutureExpectations(withTimeout: 1)
        XCTAssertEqual(store.subscriptions.flatMap({ $0.subscriber }).count, 1)

        subscriber = nil
        XCTAssertEqual(store.subscriptions.flatMap({ $0.subscriber }).count, 0)
    }


    /**
     it dispatches initial value upon subscription
     */
    func testDispatchInitialValue() {
        
        let expectation = expectationWithDescription("testDispatchInitialValue")
        store = Store(reducer: reducer, initialState: TestAppState())
        let subscriber = TestSubscriber()

        store.subscribe(subscriber)
        store.dispatch(SetValueAction(3))
        
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(subscriber.receivedStates.last?.testValue, 3)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
        
    }

    /**
     it does not dispatch value after subscriber unsubscribes
     */
    func testDontDispatchToUnsubscribers() {
        
        let subscriber = TestSubscriber()

        store.subscribe(subscriber)
        store.dispatch(SetValueAction(5))
        store.dispatch(SetValueAction(10))

        store.unsubscribe(subscriber)

        // Following value is missed due to not being subscribed:
        store.dispatch(SetValueAction(15))
        store.dispatch(SetValueAction(25))
        store.subscribe(subscriber)

        let expectation = expectationWithDescription("")
        store.dispatch(SetValueAction(20))
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            XCTAssertEqual(subscriber.receivedStates.count, 5)
            guard subscriber.receivedStates.count == 5 else {
                expectation.fulfill()
                return
            }
            XCTAssertNil(subscriber.receivedStates[subscriber.receivedStates.count - 5].testValue)
            XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 4].testValue, 5)
            XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 3].testValue, 10)
            XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 2].testValue, 25)
            XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 1].testValue, 20)
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
        
    }

    /**
     it ignores identical subscribers
     */
    func testIgnoreIdenticalSubscribers() {
        store = Store(reducer: reducer, initialState: TestAppState())
        let subscriber = TestSubscriber()

        store.subscribe(subscriber)
        store.subscribe(subscriber)

        let exp = expectationWithDescription("")
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(self.store.subscriptions.count, 1)
            exp.fulfill()
        }
        waitForFutureExpectations(withTimeout: 1)

    }

    /**
     it ignores identical subscribers that provide substate selectors
     */
    func testIgnoreIdenticalSubstateSubscribers() {
        store = Store(reducer: reducer, initialState: TestAppState())
        let subscriber = TestSubscriber()

        store.subscribe(subscriber) { $0 }
        store.subscribe(subscriber) { $0 }

        let exp = expectationWithDescription("")
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(self.store.subscriptions.count, 1)
            exp.fulfill()
        }
        waitForFutureExpectations(withTimeout: 1)

        
    }
}



