Examples
---

Simple Example

```
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
        
        ```
        
        Fire State:
        ```
        //        machine.fire(event: "toYellow", userInfo: [:])//fired
//        machine.fire(event: "toRed", userInfo: [:])// fired
        machine.fire(event: "black", userInfo: [:])// not fired
        ```