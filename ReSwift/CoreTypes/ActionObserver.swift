//
//  ActionObserver.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 14/09/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public struct AnyActionObserver<S: StateType>: ActionObserver {
    
    private let _newAction: (Action, S, S) -> Void
    
    public init<O: ActionObserver where O.State == S>(_ base: O) {
        self._newAction = base.newAction
    }
    
    public func newAction(action: Action, oldState: S, newState: S) {
        _newAction(action, oldState, newState)
    }
    
}

public protocol ActionObserver {
    associatedtype State: StateType
    func newAction(action: Action, oldState: State, newState: State)
}
