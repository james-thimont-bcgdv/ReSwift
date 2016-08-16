//
//  Reducer.swift
//  ReSwift
//
//  Created by Benjamin Encz on 12/14/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol AnyReducer {
    func _handleAction(action: Action, state: StateType) -> StateType
    func _initialState() -> StateType
}

public protocol Reducer: AnyReducer {
    associatedtype ReducerStateType: StateType
    func handleAction(action: Action, state: ReducerStateType) -> ReducerStateType
    func initialState() -> ReducerStateType
}

extension Reducer {
    public func _handleAction(action: Action, state: StateType) -> StateType {
        return withSpecificTypes(action, state: state, function: handleAction)
    }
    public func _initialState() -> StateType {
        return initialState()
    }
}
