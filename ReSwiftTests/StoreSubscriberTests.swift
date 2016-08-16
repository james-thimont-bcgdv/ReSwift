//
//  StoreSubscriberTests.swift
//  ReSwift
//
//  Created by Benji Encz on 1/23/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import XCTest
import ReSwift

class StoreSubscriberTests: XCTestCase {

    //TODO: Implement this
    
    /**
     it allows to pass a state selector closure
     */
//    func testAllowsSelectorClosure() {
//        let reducer = TestReducer()
//        let store = Store(reducer: reducer, initialState: TestAppState())
//        let subscriber = TestFilteredSubscriber()
//
//        store.subscribe(subscriber) {
//            $0.testValue
//        }
//        store.dispatch(SetValueAction(3))
//
//        XCTAssertEqual(subscriber.receivedValue, 3)
//    }

    /**
     it supports complex state selector closures
     */
//    func testComplexStateSelector() {
//        let reducer = TestComplexAppStateReducer()
//        let store = Store(reducer: reducer, initialState: TestComplexAppState())
//        let subscriber = TestSelectiveSubscriber()
//
//        store.subscribe(subscriber) { ($0.testValue, $0.otherState?.name) }
//        store.dispatch(SetValueAction(5))
//        store.dispatch(SetOtherStateAction(
//            otherState: OtherState(name: "TestName", age: 99)
//        ))
//
//        XCTAssertEqual(subscriber.receivedValue.0, 5)
//        XCTAssertEqual(subscriber.receivedValue.1, "TestName")
//    }
}

struct IntState: StateType {
    let receivedValue: Int?
    
}



class TestFilteredSubscriber: StoreSubscriber {
    var receivedValue: IntState?

    func newState(state: IntState) {
        receivedValue = state
    }

}

/**
 Example of how you can select a substate. The return value from
 `selectSubstate` and the argument for `newState` need to match up.
 */

struct IntStringState: StateType {
    let receivedValue: (Int?, String?)?
}
class TestSelectiveSubscriber: StoreSubscriber {
    
    var receivedValue: IntStringState?

    func newState(state: IntStringState) {
        receivedValue = state
    }
}

struct TestComplexAppState: StateType {
    var testValue: Int?
    var otherState: OtherState?
}

struct OtherState {
    var name: String?
    var age: Int?
}

struct TestComplexAppStateReducer: Reducer {
    
    typealias ReducerStateType = TestComplexAppState
    func handleAction(action: Action, state: TestComplexAppState) -> TestComplexAppState {
        var state = state ?? TestComplexAppState()

        switch action {
        case let action as SetValueAction:
            state.testValue = action.value
            return state
        case let action as SetOtherStateAction:
            state.otherState = action.otherState
        default:
            break
        }

        return state
    }

    func initialState() -> ReducerStateType {
        return TestComplexAppState()
    }
    
    
}

struct SetOtherStateAction: Action {
    var otherState: OtherState
}
