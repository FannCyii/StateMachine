//
//  KIStateMachine.swift
//  StateMachine
//
//  Created by chengqifan on 2020/7/19.
//  

import Foundation

public class KIStateMachine {
    private var states = [String: KIState]()
    private var events = [String: KIEvent]()
    private(set) var currentState: KIState?
    private(set) var primitiveState: KIState?
    var isActive: Bool {
        return currentState != nil
    }
    public init(primitiveState: KIState? = nil){
        self.primitiveState = primitiveState
    }

    func activeIfNeeded() {
        guard !isActive else {
            return
        }
        guard let primitiveState = primitiveState else {
            assertionFailure("KIStateMachine: must has a primitive state or set a current state!s")
            return
        }
        setCurrentState(primitiveState)
    }

    public func setCurrentState(_ state: KIState) {
        let transition = KITransition(
            event: nil,
            sourceState: nil,
            destinationState: state,
            machion: self,
            useInfo: [:]
        )
        state.willEnterState?(state, transition)
        currentState = state
        state.didEnterState?(state, transition)
    }
}

// MARK: - state handle
extension KIStateMachine {
    public func isIn(state: KIStateIdentifier) -> Bool {
        return states.contains { (_, item) -> Bool in
            return item.uniqueKey == state.uniqueKey
        }
    }

    public func stateOfName(_ name: KIStateIdentifier) -> KIState? {
        return states[name.uniqueKey]
    }

    public func add(state: KIState) {
        states[state.uniqueKey] = state
    }

    public func add(states stateLists: [KIState]) {
        stateLists.forEach {
            self.add(state: $0)
        }
    }
}

// MARK: - event handle
extension KIStateMachine {
    public func add(event: KIEvent) {
        events[event.uniqueKey] = event
    }

    public func add(events: [KIEvent]) {
        events.forEach {
            self.add(event: $0)
        }
    }

    public func eventOf(name: KIStateIdentifier) -> KIEvent? {
        return events[name.uniqueKey]
    }

    public func canFire(event: KIEventIdentifier) -> Bool {
        let resultEvent = events.first { (key, _) -> Bool in
            return key == event.uniqueKey
        }
        return resultEvent != nil
    }

    @discardableResult
    public func fire(event: KIEventIdentifier, userInfo: KIStateUserInfo) -> Result<Bool, KIStateError> {
        guard let event = event as? KIEvent ?? eventOf(name: event) else {
            print("KIStateMachine: not fire! event not exist")
            return .failure(.eventNotExist)
        }
        guard let currentState = self.currentState else {
            print("KIStateMachine: not fire!")
            return .failure(.noCurrentState)
        }
        guard event.source.contains(currentState) else {
            print("KIStateMachine: not fire! current state can't action the event")
            return .failure(.eventNotMatchCurrenSource)
        }

        let transition = KITransition(
            event: event,
            sourceState: currentState,
            destinationState: event.destination,
            machion: self,
            useInfo: userInfo
        )
        if let sholdFireHandle = event.shouldFireEvent,
            !sholdFireHandle(event, transition) {
            print("KIStateMachine: event should fire block result is false!")
            return .success(false)
        }
        if let eventDelegate = event.delegate,
            !eventDelegate.event(event, shouldFire: transition) {
            print("KIStateMachine: event should fire delegate result is false!")
            return .success(false)
        }

        let oldState = currentState
        let newState = event.destination
        var notifactionInfo = userInfo
        notifactionInfo[KIStateUserInfoKey.transion.rawValue] = transition
        //notify state will changed
        NotificationCenter.default.post(name: .stateWillChangedNotifcation, object: nil, userInfo: notifactionInfo)

        //event and states life cycle
        event.willFireEvent?(event, transition)
        event.delegate?.event(event, willFire: transition)

        oldState.willExitState?(oldState, transition)
        oldState.delegate?.state(oldState, willExit: transition)

        newState.willEnterState?(newState, transition)
        newState.delegate?.state(newState, willEnter: transition)

        //transion current state to next state
        self.currentState = newState

        event.didFireEvent?(event, transition)
        event.delegate?.event(event, didFire: transition)

        newState.didEnterState?(newState, transition)
        newState.delegate?.state(newState, didEnter: transition)

        oldState.didExitState?(oldState, transition)
        oldState.delegate?.state(oldState, didExit: transition)
        //notify state did changed
        NotificationCenter.default.post(name: .stateDidChangedNotifcation, object: nil, userInfo: notifactionInfo)
        return .success(true)
    }
}
