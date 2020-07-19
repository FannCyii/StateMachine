//
//  KITransition.swift
//  StateMachine
//
//  Created by chengqifan on 2020/7/19.
//  


import Foundation

public struct KITransition {
    var event: KIEvent?
    var sourceState: KIState?
    var destinationState: KIState
    var machion: KIStateMachine
    var useInfo: [String: Any]
}
