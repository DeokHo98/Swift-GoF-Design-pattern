import UIKit
import SwiftUI

/*
 객체 구현 세부 사항을 공개하지 않으면서 객체 내부 상태를 캡쳐하고 복원할수 있는 디자인패턴이다.

 사용처
 - 객체의 상태 스냅샷을 저장하고 복원해야할때
 - undo 기능을 구현해야 할때
 - 롤백이 필요한 데이터베이스를 만들때
 
 장점
 - 캡슐화를 유지하면서 객체 내부의 상태를 저장하는것이 가능
 - 객체의 상태 이력을 쉽게 관리할수 있음
 
 단점
 - 메모리 사용량이 증가
 - 저장하는 상태가 큰경우 성능에 영향
 
 사용빈도
 - 매우 낮음
 */

// MARK: - 구조

class Memento {
    let state: String
    
    init(state: String) {
        self.state = state
    }
}

class Caretaker {
    var memento: Memento?
}

class Originator {
    var state: String = "" {
        didSet {
            print("State = \(state)")
        }
    }
    
    func createMemento() -> Memento {
        return Memento(state: state)
    }
    
    func setMemento(memento: Memento?) {
        guard let memento else { return }
        print("Restoring State")
        self.state = memento.state
    }
}

let originator = Originator()
originator.state = "On"

let caretaker = Caretaker()
caretaker.memento = originator.createMemento()
originator.state = "Off"
originator.setMemento(memento: caretaker.memento)

// MARK: - 그림판 예시

// 상태를 담고있는 객체 Memento
struct DrawingMemento {
    let lines: [CGPoint]
}

// Memento로 부터 가져온 상태를가지고 조작하는 객체 Originator
class DrawingCanvas: UIView {
    private var lines: [CGPoint] = []
    
    func drawLine(point: CGPoint) {
        lines.append(point)
    }
    
    func save() -> DrawingMemento {
        return DrawingMemento(lines: lines)
    }
    
    func restore(memento: DrawingMemento) {
        lines = memento.lines
    }
    
    func printCurrentState() {
        print("Canvas Line \(lines)")
    }
}

// Memento 객체들의 히스토리를 관리하는 객체 Caretaker
class DrawingCaretaker {
    private var mementos: [DrawingMemento] = []
    private var canvas: DrawingCanvas
    
    init(canvas: DrawingCanvas) {
        self.canvas = canvas
    }
    
    func backup() {
        mementos.append(canvas.save())
        print("Backup \(self.mementos.map { "Memento Line \($0.lines)" })")
    }
    
    func undo() {
        guard !mementos.isEmpty else {
            print("Cannot undo: No more history")
            return
        }
        mementos.removeLast() // 현재 상태 제거
        if let lastMemento = mementos.last {
            canvas.restore(memento: lastMemento)
        } else {
            canvas.restore(memento: DrawingMemento(lines: []))
        }
        print("Undo \(self.mementos.map { "Memento Line \($0.lines)" })")
        
    }
}

print("=================================")

let canvas = DrawingCanvas()
let drawingCaretaker = DrawingCaretaker(canvas: canvas)

canvas.printCurrentState()
print("=================================")

canvas.drawLine(point: .init(x: 20, y: 20))
drawingCaretaker.backup()
canvas.printCurrentState()
print("=================================")

canvas.drawLine(point: .init(x: 30, y: 30))
drawingCaretaker.backup()
canvas.printCurrentState()
print("=================================")

canvas.drawLine(point: .init(x: 40, y: 40))
drawingCaretaker.backup()
canvas.printCurrentState()
print("=================================")

drawingCaretaker.undo()
canvas.printCurrentState()
print("=================================")

drawingCaretaker.undo()
canvas.printCurrentState()
print("=================================")

drawingCaretaker.undo()
canvas.printCurrentState()
print("=================================")

drawingCaretaker.undo()
