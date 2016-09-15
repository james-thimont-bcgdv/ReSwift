//
//  ActionObserver.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 14/09/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol ActionObserver {
    func newAction(action: Action, oldState: StateType, newState: StateType)
}
