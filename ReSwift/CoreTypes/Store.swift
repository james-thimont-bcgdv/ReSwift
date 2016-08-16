//
//  Store.swift
//  ReSwift
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

/**
 This class is the default implementation of the `Store` protocol. You will use this store in most
 of your applications. You shouldn't need to implement your own store.
 You initialize the store with a reducer and an initial application state. If your app has multiple
 reducers you can combine them by initializng a `MainReducer` with all of your reducers as an
 argument.
 */



final public class Store<State: StateType>: StoreType {
    
    typealias SubscriptionType = Subscription<State>
    
    let concurrencyQueue = dispatch_queue_create("com.reswift.store.concurrency", DISPATCH_QUEUE_SERIAL)
    
    private var _state: State
    
    public var state: State {
        var state: State!
        dispatch_sync_on_main{
            state = self._state
        }
        return state
    }
    
    private func notifySubscribers(subscribers: [SubscriptionType], newState: State) {

        dispatch_sync_on_main{
            
            subscribers.forEach {
                // if a selector is available, subselect the relevant state
                // otherwise pass the entire state to the subscriber
                $0.subscriber?._newState($0.selector?(newState) ?? newState)
            }
        }
        
    }
    
    
    private var reducer: AnyReducer
    private var _subscriptions: [SubscriptionType] = []
    internal var subscriptions: [SubscriptionType] {
        var s:[SubscriptionType]!
        dispatch_sync_on_main {
            s = self._subscriptions
        }
        return s
    }
    
    
    public convenience init(reducer: AnyReducer) {
        self.init(reducer: reducer, initialState: reducer._initialState() as! State)
    }
    
    internal init(reducer: AnyReducer, initialState: State) {
        
        self._state = initialState
        self.reducer = reducer
        dispatch_set_target_queue(concurrencyQueue, dispatch_get_main_queue())
    }
    
    private func isNewSubscriber(subscriber: AnyStoreSubscriber) -> Bool {
        
        let contains = _subscriptions.contains({ $0.subscriber === subscriber })
        
        if contains {
            print("Store subscriber is already added, ignoring.")
            return false
        }
        
        return true
    }
    
    public func subscribe<S: StoreSubscriber
        where S.StoreSubscriberStateType == State>(subscriber: S) {
        self.subscribe(subscriber, selector: nil)
        
    }
    public func subscribe<SelectedState, S: StoreSubscriber
        where S.StoreSubscriberStateType == SelectedState>
        (subscriber: S, selector: ((State) -> SelectedState)?) {
        
        dispatch_async(concurrencyQueue) {
            
            let state = self._state
            guard self.isNewSubscriber(subscriber) else { return }
            let subscription  = Subscription(subscriber: subscriber, selector: selector)
            self._subscriptions.append(subscription)
            
            self.notifySubscribers([subscription], newState: state)

        }
        
    }
    
    public func unsubscribe(subscriber: AnyStoreSubscriber) {
        
        dispatch_async(concurrencyQueue) { 
        
            if let index = self._subscriptions.indexOf({ return $0.subscriber === subscriber }) {
                self._subscriptions.removeAtIndex(index)
            }
        }
    }
    
    
    
    private func dispatch_sync_on_main(block: dispatch_block_t) {
        
        if NSThread.isMainThread() {
            block()
            return
        }
        dispatch_sync(concurrencyQueue, block)
        
    }
    
}

extension Store: Dispatching {

    public func dispatch(actionCreator: AnyActionCreator) {
        let state = self.state
        actionCreator._createActions(currentState: state){ [weak self] action in
            self?.dispatch(action)
        }
    }
    
    public func dispatch(action: Action){
        
        dispatch_async(concurrencyQueue) {
            
            let state = self._state
            guard let newState = self.reducer._handleAction(action, state: state) as? State else { fatalError("reducer must return \(State.self) type") }
            self._state = newState
            let subscribers = self._subscriptions
            self.notifySubscribers(subscribers, newState: newState)
            
        }
        
    }

}

