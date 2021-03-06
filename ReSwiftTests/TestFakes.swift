//
//  TestFakes.swift
//  ReSwift
//
//  Created by Benji Encz on 12/24/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import Foundation
import ReSwift

public struct TestAppState: StateType {
    var testValue: Int?

    init() {
        testValue = nil
    }
    
    init(val: Int?) {
        testValue = val
    }
}

struct TestStringAppState: StateType {
    var testValue: String?

    init() {
        testValue = nil
    }
}

struct SetValueAction: StandardActionConvertible {

    let value: Int
    static let type = "SetValueAction"

    init (_ value: Int) {
        self.value = value
    }

    init(_ standardAction: StandardAction) {
        self.value = standardAction.payload!["value"] as! Int
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetValueAction.type, payload: ["value": value],
                                isTypedAction: true)
    }

}

struct SetValueStringAction: StandardActionConvertible {

    var value: String
    static let type = "SetValueStringAction"

    init (_ value: String) {
        self.value = value
    }

    init(_ standardAction: StandardAction) {
        self.value = standardAction.payload!["value"] as! String
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetValueStringAction.type, payload: ["value": value],
                                isTypedAction: true)
    }

}

public struct TestReducer: Reducer {
    
    public typealias  ReducerStateType = TestAppState
    
    public func handleAction(action: Action, state: ReducerStateType) -> ReducerStateType {
                var state = state ?? TestAppState()
        
                switch action {
                case let action as SetValueAction:
                    state.testValue = action.value
                    return state
                default:
                    return state
                }
    }
    
    public func initialState() -> ReducerStateType {
        return TestAppState()
    }
    
}



class TestStoreSubscriber<T: StateType>: StoreSubscriber {
    var receivedStates: [T] = []

    func newState(state: T) {
        receivedStates.append(state)
    }
}

class DispatchingSubscriber: StoreSubscriber {
    var store: Store<TestAppState>

    init(store: Store<TestAppState>) {
        self.store = store
    }

    func newState(state: TestAppState) {
        // Test if we've already dispatched this action to
        // avoid endless recursion
        if state.testValue != 5 {
            self.store.dispatch(SetValueAction(5))
        }
    }
}

class CallbackStoreSubscriber<T: StateType>: StoreSubscriber {

    let handler: (T) -> Void

    init(handler: (T) -> Void) {
        self.handler = handler
    }

    func newState(state: T) {
        handler(state)
    }
}
