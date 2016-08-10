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

        store.subscribe(subscriber!)
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
        store.dispatch(SetValueAction(3), completion: { 
           expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(subscriber.receivedStates.last?.testValue, 3)
    }

    /**
     it allows dispatching from within an observer
     */
//    func testAllowDispatchWithinObserver() {
//        store = Store(reducer: reducer, initialState: TestAppState())
//        let subscriber = DispatchingSubscriber(store: store)
//
//        store.subscribe(subscriber)
//        store.dispatch(SetValueAction(2))
//
//        waitFor(0.2)
//        
//        XCTAssertEqual(store.state.testValue, 5)
//    }

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
        store.dispatch(SetValueAction(20), completion: {
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(1, handler: nil)
        
        XCTAssertEqual(subscriber.receivedStates.count, 5)
        guard subscriber.receivedStates.count == 5 else { return }
        XCTAssertNil(subscriber.receivedStates[subscriber.receivedStates.count - 5].testValue)
        XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 4].testValue, 5)
        XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 3].testValue, 10)
        XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 2].testValue, 25)
        XCTAssertEqual(subscriber.receivedStates[subscriber.receivedStates.count - 1].testValue, 20)
    }

    /**
     it ignores identical subscribers
     */
    func testIgnoreIdenticalSubscribers() {
        store = Store(reducer: reducer, initialState: TestAppState())
        let subscriber = TestSubscriber()

        store.subscribe(subscriber)
        store.subscribe(subscriber)

        XCTAssertEqual(store.subscriptions.count, 1)
    }

    /**
     it ignores identical subscribers that provide substate selectors
     */
    func testIgnoreIdenticalSubstateSubscribers() {
        store = Store(reducer: reducer, initialState: TestAppState())
        let subscriber = TestSubscriber()

        store.subscribe(subscriber) { $0 }
        store.subscribe(subscriber) { $0 }

        XCTAssertEqual(store.subscriptions.count, 1)
    }
}



