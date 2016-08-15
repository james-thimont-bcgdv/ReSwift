//
//  ActionCreator.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 10/08/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol ActionParametersType {}

public protocol ActionCreator {
    
    associatedtype State: StateType
    associatedtype Parameters: ActionParametersType
    /**
     Generates one or more new actions from the current state.  May be implemented asynchronously or synchronously
     - parameter actionBlock This may be called more than once with different actions
     */
    func createActions(parameters: Parameters, currentState state: State, actionBlock:(Action -> Void))
    
    /**
     Prevents any further `actionBlocks` being executed.  Cancels the operation.
     */
    func cancel()
    
}


