//
//  KIState.swift
//  StateMachine
//
//  Created by chengqifan on 2020/7/19.
//  


import Foundation

public protocol KIStateDelegate: AnyObject {
    func state(_ state: KIState, willEnter transition: KITransition)
    func state(_ state: KIState, didEnter transition: KITransition)
    func state(_ state: KIState, willExit transition: KITransition)
    func state(_ state: KIState, didExit transition: KITransition)
}

public class KIState {
    public var willEnterState: ((_ event: KIState, _ transition: KITransition) -> Void)?
    public var didEnterState: ((_ event: KIState, _ transition: KITransition) -> Void)?
    public var willExitState: ((_ event: KIState, _ transition: KITransition) -> Void)?
    public var didExitState: ((_ event: KIState, _ transition: KITransition) -> Void)?
    public let name: KIStateIdentifier
    public weak var delegate: KIStateDelegate?
    public private(set) var userInfo = [String: Any]()
    public convenience init(name: KIStateIdentifier) {
        self.init(name: name, userInfo: [:])
    }
    public init(name: KIStateIdentifier, userInfo: [String: Any]) {
        self.name = name
        self.userInfo = userInfo
    }
}

extension KIState: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "KIState: name=\(uniqueKey)"
    }
}

extension KIState: KIStateIdentifier {
    public var uniqueKey: String {
        return self.name.uniqueKey
    }
}

extension KIState: Hashable {
    public static func == (lhs: KIState, rhs: KIState) -> Bool {
        return lhs.name.uniqueKey == rhs.name.uniqueKey
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name.uniqueKey)
    }
}
