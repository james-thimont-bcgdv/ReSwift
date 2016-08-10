//
//  ActionCreator.swift
//  ReSwift
//
//  Created by Jonathan Ellis on 10/08/2016.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol ActionCreator {
    
    associatedtype State
    
    func execute(dispatcher: Dispatching, state: State)
}


