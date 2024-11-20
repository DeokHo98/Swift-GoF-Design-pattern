import UIKit
import SwiftUI

/*
 알고리즘을 알고리즘이 작동하는 객체들에서 분리시키는 패턴을 말한다.
 실제 로직을 가지고 있는 비지터 객체가 로직을 적용할 객체를 방문하면서 작업을 수행한다.

 사용처
 - 복잡한 객체 구조에서 각 객체마다 다른 처리가 필요할 때
 - 기존 코드를 변경하지 않고 새로운 동작을 추가해야 할 때
 - 관련된 동작들을 한 클래스에 모아서 관리하고 싶을 때
 
 장점
 - 새로운 동작을 추가할 때 기존 코드를 수정하지 않아도 됨
 - 관련된 동작들을 한 곳에서 관리할 수 있음
 - 데이터 구조와 알고리즘을 분리할 수 있음
 - 각 객체의 책임을 명확히 분리할 수 있음
 
 단점
 - 객체 구조가 자주 변경되면 모든 비지터를 수정해야 함
 - 객체의 내부 구현을 비지터에 노출해야 할 수 있음
 - 코드가 복잡해질 수 있음
 
 사용빈도
 - 중
 */

// MARK: - 구조

protocol Element {
    func accept(visitor: Visitor)
}

protocol Visitor {
    func visitConcreteElementA(element: ConcreteElementA)
    func visitConcreteElementB(element: ConcreteElementB)
}

class ConcreteElementA: Element {
    func accept(visitor: Visitor) {
        visitor.visitConcreteElementA(element: self)
    }
    
    func operationA() {
        print("Operation A")
    }
}

class ConcreteElementB: Element {
    func accept(visitor: Visitor) {
        visitor.visitConcreteElementB(element: self)
    }
    
    func operationB() {
         print("Operation B")
     }
}

class ConcreteVisitor: Visitor {
    func visitConcreteElementA(element: ConcreteElementA) {
        print("Visiting Concrete Element A")
        element.operationA()
    }
    
    func visitConcreteElementB(element: ConcreteElementB) {
        print("Visiting Concrete Element B")
        element.operationB()
    }
}

let elements: [Element] = [ConcreteElementA(), ConcreteElementB()]
let visitor = ConcreteVisitor()

elements.forEach {
    $0.accept(visitor: visitor)
}

// MARK: - UI 요소들에 무언가 설정하는 비지터 패턴 예시

protocol UIElement {
    func accept(visitor: UIVisitor)
}

protocol UIVisitor {
    func visit(view: UIView)
}

class CustomButton: UIButton, UIElement {
    func accept(visitor: UIVisitor) {
        visitor.visit(view: self)
    }
}

class CustomLabel: UILabel, UIElement {
    func accept(visitor: UIVisitor) {
        visitor.visit(view: self)
    }
}

class DarkModeVisitor: UIVisitor {
    func visit(view: UIView) {
        view.backgroundColor = .black
        view.tintColor = .white
        print("\(type(of: view)) 다크모드 설정")
    }
}

class AccessibilityVisitor: UIVisitor {
    
    func visit(view: UIView) {
        print("\(type(of: view)) 접근성 설정")
    }
}

let button = CustomButton()
let label = CustomLabel()

let darModeVisitor = DarkModeVisitor()
let accessibilityVisitor = AccessibilityVisitor()

button.accept(visitor: darModeVisitor)
button.accept(visitor: accessibilityVisitor)

label.accept(visitor: darModeVisitor)
label.accept(visitor: accessibilityVisitor)
