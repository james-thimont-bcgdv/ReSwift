//
//  ActionCreator.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 10/08/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol ActionCreatorType: AnyActionCreator {
    
    associatedtype State: StateType
    /**
     Generates one or more new actions from the current state.  May be implemented asynchronously or synchronously
     - parameter actionBlock This may be called more than once with different actions
     */
    func createActions(currentState state: State, actionBlock:(Action -> Void))
    
    /**
     Prevents any further `actionBlocks` being executed.  Cancels the operation.
     */
    func cancel()
    
}

public protocol AnyActionCreator {
    func _createActions(currentState state: StateType, actionBlock:(Action -> Void))
}

extension ActionCreatorType {
    public func _createActions(currentState state: StateType, actionBlock:(Action -> Void)) {
        guard let st = state as? Self.State else { fatalError() }
        createActions(currentState: st, actionBlock: actionBlock)
    }
}

