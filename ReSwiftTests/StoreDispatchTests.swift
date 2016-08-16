//
//  StoreDispatchTests.swift
//  ReSwift
//
//  Created by Karl Bowden on 20/07/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import XCTest
import ReSwift

class StoreDispatchTests: XCTestCase {

    typealias TestSubscriber = TestStoreSubscriber<TestAppState>
    typealias CallbackSubscriber = CallbackStoreSubscriber<TestAppState>

    var store: Store<TestAppState>!
    var reducer: TestReducer!

    override func setUp() {
        super.setUp()
        reducer = TestReducer()
        store = Store<TestAppState>(reducer: reducer)
    }


    /**
     it throws an exception when a reducer dispatches an action
     */
    
    // TODO: implement this
    func testThrowsExceptionWhenReducersDispatch() {
        // Expectation lives in the `DispatchingReducer` class
//        self.store = Store<TestAppState>(reducer: Reducer<TestAppState>(reducerFn: { (action, state) -> TestAppState in
//            var state = state
//            if let action = action as? SetValueAction {
//                state.testValue = action.value
//                self.store.dispatch(action)
//            }
//            return state
//        }), initialState: TestAppState())
//        
//
//        self.store.dispatch(SetValueAction(10))
        
    }

}

// Needs to be class so that shared reference can be modified to inject store
