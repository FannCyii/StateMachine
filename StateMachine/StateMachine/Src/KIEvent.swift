//
//  KIEvent.swift
//  StateMachine
//
//  Created by chengqifan on 2020/7/19.
//  

import Foundation

public protocol KIEventDelegate: AnyObject {
    func event(_ event: KIEvent, shouldFire transition: KITransition) -> Bool
    func event(_ event: KIEvent, willFire transition: KITransition) -> Void
    func event(_ event: KIEvent, didFire transition: KITransition) -> Void
}

public class KIEvent {
    public var shouldFireEvent: ((_ event: KIEvent, _ transition: KITransition) -> Bool)?
    public var willFireEvent: ((_ event: KIEvent, _ transition: KITransition) -> Void)?
    public var didFireEvent: ((_ event: KIEvent, _ transition: KITransition) -> Void)?
    public let name: KIStateIdentifier
    let source: [KIState]
    let destination: KIState
    public weak var delegate: KIEventDelegate?
    public init(name: KIStateIdentifier, sourceStates: [KIState], destinationState: KIState) {
        self.name = name
        self.source = sourceStates
        self.destination = destinationState
    }
}

extension KIEvent: KIStateIdentifier {
    public var uniqueKey: String {
        return name.uniqueKey
    }
}

extension KIEvent: Hashable {
    public static func == (lhs: KIEvent, rhs: KIEvent) -> Bool {
        return lhs.name.uniqueKey == rhs.name.uniqueKey
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name.uniqueKey)
    }
}
