//
//  Utils.swift
//  StateMachine
//
//  Created by chengqifan on 2020/7/19.
//  

import Foundation

public enum KIStateError: Error {
    //event
    case eventNotExist

    //state
    case machineDeactive
    case noCurrentState
    case stateNotExist
    case eventNotMatchCurrenSource
}


public typealias KIStateUserInfo = [String: Any]


// MARK: - Notification
public extension Notification.Name {
    static let stateDidChangedNotifcation = Notification.Name(rawValue: "ki.state.did.changed")
    static let stateWillChangedNotifcation = Notification.Name(rawValue: "ki.state.did.changed")
}

public enum KIStateUserInfoKey: String {
    case oldState = "didchanged.oldState"
    case newState = "didchanged.newState"
    case transion = "state.transition"
}

public protocol KIStateIdentifier {
    var uniqueKey: String { get }
}

public typealias KIEventIdentifier = KIStateIdentifier

extension String: KIStateIdentifier {
    public var uniqueKey: String {
        return self
    }
}
