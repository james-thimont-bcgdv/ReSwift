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

    init(reducer: AnyReducer, actionObservers: [ActionObserver])
    
    /// The current state stored in the store.
    var state: State { get }

    
 
}


public protocol Subscribing {

    associatedtype State: StateType
    
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
    
    
    func subscribe<S: StoreSubscriber where S.StoreSubscriberStateType == State>(subscriber: S, selector: ((State, State) -> Bool)?)
    
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

    
}