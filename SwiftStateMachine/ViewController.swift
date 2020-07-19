//
//  ViewController.swift
//  SwiftStateMachine
//
//  Created by chengqifan on 2020/7/19.
//  Copyright © 2020 fann. All rights reserved.


import UIKit
import StateMachine

class ViewController: UIViewController {
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("primitive", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self,
                         action: #selector(ViewController.buttonAction(_:)),
                         for: .touchUpInside)
        return button
    }()
    private let machine = KIStateMachine()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        setupMachine()
    }

    @objc
    private func buttonAction(_ sender: UIButton) {
//        machine.fire(event: "toYellow", userInfo: [:])//fired
//        machine.fire(event: "toRed", userInfo: [:])// fired
        machine.fire(event: "black", userInfo: [:])// not fired
    }

    private func setupMachine() {
        let redState = KIState(name: "red", userInfo: ["colorInfo": "this is red"])
        redState.didEnterState = {[weak self] _, _ in
            self?.button.backgroundColor = UIColor.red
        }

        let yellowState = KIState(name: "yellow", userInfo: ["colorInfo": "this is yellow"])
        yellowState.didEnterState = {[weak self] _, _ in
            self?.button.backgroundColor = UIColor.yellow
        }
        let greenState = KIState(name: "green", userInfo: ["colorInfo": "this is green"])
        greenState.didEnterState = {[weak self] _, _ in
            self?.button.backgroundColor = UIColor.green
        }
        let blackState = KIState(name: "black", userInfo: ["colorInfo": "this is black"])
        blackState.didEnterState = {[weak self] _, _ in
            self?.button.backgroundColor = UIColor.black
        }

        self.machine.add(states: [redState, yellowState, greenState, blackState])

        let event1 = KIEvent(name: "toRed", sourceStates: [greenState, yellowState], destinationState: redState)
        let event2 = KIEvent(name: "toGreen", sourceStates: [blackState, blackState], destinationState: greenState)
        let event3 = KIEvent(name: "toBlack", sourceStates: [redState, greenState], destinationState: blackState)
        let event4 = KIEvent(name: "toYellow", sourceStates: [greenState], destinationState: yellowState)

        self.machine.add(events: [event1, event2, event3, event4])

        //set a primitive state
        machine.setCurrentState(greenState)
    }


}

