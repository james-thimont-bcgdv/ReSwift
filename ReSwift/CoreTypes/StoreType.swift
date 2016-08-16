//
//  StoreType.swift
//  ReSwift
//
//  Created by Benjamin Encz on 11/28/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

/**
 Defines the interface of Stores in ReSwift. `Store` is the default implementation of this
 interface. Applications have a single store that stores the entire application state.
 Stores receive actions and use reducers combined with these actions, to calculate state changes.
 Upon every state update a store informs all of its subscribers.
 */
public protocol StoreType {

    associatedtype State: StateType

    init(reducer: AnyReducer)
    
    /// The current state stored in the store.
    var state: State { get }

    /**
     Subscribes the provided subscriber to this store.
     Subscribers will receive a call to `newState` whenever the
     state in this store changes.

     - parameter subscriber: Subscriber that will receive store updates
     */
    #if swift(>=3)
    func subscribe<S: StoreSubscriber where S.StoreSubscriberStateType == State>(_ subscriber: S)
    #else
    func subscribe<S: StoreSubscriber where S.StoreSubscriberStateType == State>(subscriber: S)
    #endif

    /**
     Unsubscribes the provided subscriber. The subscriber will no longer
     receive state updates from this store.

     - parameter subscriber: Subscriber that will be unsubscribed
     */
    #if swift(>=3)
    func unsubscribe(_ subscriber: AnyStoreSubscriber)
    #else
    func unsubscribe(subscriber: AnyStoreSubscriber)
    #endif

    /**
     Dispatches an action. This is the simplest way to modify the stores state.

     Example of dispatching an action:

     ```
     store.dispatch( CounterAction.IncreaseCounter )
     ```

     - parameter action: The action that is being dispatched to the store
     - returns: By default returns the dispatched action, but middlewares can change the
     return type, e.g. to return promises
     */
    #if swift(>=3)
    func dispatch(_ action: Action)
    #else
    func dispatch(action: Action)
    #endif

 
}
