//
//  Dispatcher.swift
//  ReSwift
//
//  Created by James Thimont on 16/08/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol Dispatching {
    func dispatch(action: Action)
    func dispatch(actionCreator: AnyActionCreator)
}

public class Dispatcher<State: StateType>: Dispatching {
    
    private let store: Store<State>
    
    init(store: Store<State>) {
        self.store = store
    }
    
    public func dispatch(action: Action) {
        store.dispatch(action)
    }
    
    public func dispatch(actionCreator: AnyActionCreator) {
        actionCreator._createActions(currentState: store.state) { action in
            self.store.dispatch(action)
        }
    }
    
}
