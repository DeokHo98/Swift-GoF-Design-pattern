import UIKit
import SwiftUI

/*
 실행될 동작을 객체로 표현하고, 객체에 실행에 필요한 모든정보를 포함시키는 디자인 패턴

 사용처
 - 작업을 객체로 매개변수화 해야 할 때
 - 작업을 큐에 저장하거나 로그로 기록해야할 때
 - 작업의 실행을 지연시키거나 원격으로 실행해야 할때
 - 실행 취소 undo 다시 실행 redo 기능을 구현해야할때
 
 장점
 - 클라이언트 코드를 변경하지않고 명령을 쉽게 교체할수 있다.
 - 기존코드를 수정하지않고 새로운 명령을 추가할 수 있다.
 - Undo Redo 기능을 쉽게 구현할 수 있다.
 
 단점
 - 추가적인 클래스와 참조로 코드의 복잡도 및 양 향상
 
 사용빈도
 - 중상
 */

// MARK: - 구조

protocol Command  {
    func execute()
}

class Light {
    func turnOn() {
        print("Light is on")
    }
    
    func turnOff() {
        print("Light is off")
    }
}

class LightOnCommand: Command {
    private var light: Light
    
    init(light: Light) {
        self.light = light
    }
    
    func execute() {
        light.turnOn()
    }
}

class LightOffCommand: Command {
    private var light: Light
    
    init(light: Light) {
        self.light = light
    }
    
    func execute() {
        light.turnOff()
    }
}

class RemoteControl {
    private var command: Command?
    
    func setCommand(command: Command) {
        self.command = command
    }
    
    func pressButton() {
        command?.execute()
    }
}

let livingRoomLight = Light()
let livingRoomLightOn = LightOnCommand(light: livingRoomLight)
let liveingRoomLightOff = LightOffCommand(light: livingRoomLight)
let remote = RemoteControl()

remote.setCommand(command: livingRoomLightOn)
remote.pressButton()

remote.setCommand(command: liveingRoomLightOff)
remote.pressButton()

// MARK: - 텍스트 편집기 예시

struct Todo {
    var id: UUID
    var title: String
    var isComplted: Bool
}

protocol TodoCommand {
    func execute()
    func undo()
}

class AddTodoCommand: TodoCommand {
    private let title: String
    var addedTodo: Todo?
    
    init(title: String) {
        self.title = title
    }
    
    func execute() {
        let newTodo = Todo(id: UUID(), title: self.title, isComplted: false)
        self.addedTodo = newTodo
        // 데이터베이스 추가 메서드
        print("debug \(newTodo) 새로 추가되었습니다.")
    }
    
    func undo() {
        guard let todoToRemove = addedTodo else { return }
        // 데이터베이스 삭제 메서드
        print("debug \(todoToRemove) 추가가 취소 되었습니다.")
    }
}

class DeleteTodoComaand: TodoCommand {
    private let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    func execute() {
        // 데이터베이스 삭제 메서드
        print("debug \(self.todo) 삭제 되었습니다")
    }
    
    func undo() {
        // 데이터베이스 추가 메서드
        print("debug \(self.todo) 삭제가 취소 되었습니다.")
    }
}

class TodoManager {
    private var commandStack: [TodoCommand] = []
    
    func excuteCommand(command: TodoCommand) {
        command.execute()
        commandStack.append(command)
    }
    
    func undoLastCommand() {
        guard let lastCommand = commandStack.popLast() else {
            print("debug 취소할 명령이 없습니다")
            return
        }
        lastCommand.undo()
    }
}

let todoManager = TodoManager()

let addCommand1 = AddTodoCommand(title: "밥하기")
let addCommand2 = AddTodoCommand(title: "반찬하기")
todoManager.excuteCommand(command: addCommand1)
todoManager.excuteCommand(command: addCommand2)
todoManager.undoLastCommand()
todoManager.excuteCommand(command: addCommand2)

if let addedTodo = addCommand1.addedTodo {
    let deleteCommand = DeleteTodoComaand(todo: addedTodo)
    todoManager.excuteCommand(command: deleteCommand)
    todoManager.undoLastCommand()
}

