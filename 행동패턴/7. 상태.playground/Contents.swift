import UIKit
import SwiftUI

/*
 상태 패턴은 객체의 내부 상태가 변경될대 해당 객체의 행동이 변경되도록 허용하는 디자인 패턴을 말한다.

 사용처
 - 객체의 행동이 상태에 따라서 달라져야 할때
 - 상태에 따른 조건문이 많이 발생할때
 - 상태 전환 규칙이 복잡할때
 
 장점
 - 각 상태별 코드가 분리되기때문에 단일책임원칙을 준수
 - 새로운 상태 추가가 용이해 개방 폐쇄 원칙 준수
 - 상태 전환 로직이 명확해진다.
 - 상태별로 코드 관리가 용이해진다.
 
 단점
 - 상태 수가 적을경우 오버 엔지니어링 위험이 증가
 - 객체가 굉장히 많이 증가하게 된다.
 
 사용빈도
 - 중간
 */

// MARK: - 구조

class Context {
    var state: State {
        didSet {
            print("Change State \(type(of: state))")
        }
    }
    
    init(state: State) {
        self.state = state
    }
    
    func request() {
        state.handle(context: self)
    }
}

protocol State {
    func handle(context: Context)
}

class ConcreteStateA: State {
    func handle(context: Context) {
        context.state = ConcreteStateB()
    }
}

class ConcreteStateB: State {
    func handle(context: Context) {
        context.state = ConcreteStateA()
    }
}

let context = Context(state: ConcreteStateA())
context.request()
context.request()
context.request()
context.request()

// MARK: - 주문앱 예시

// Context
class Order {
    private var state: OrderState = PendingState()
    let id: UUID
    var items: [String]
    var totalAmount: Double
    
    init(id: UUID, items: [String], totalAmount: Double) {
        self.id = id
        self.items = items
        self.totalAmount = totalAmount
    }
    
    func changeState(state: OrderState) {
        self.state = state
    }
    
    func handleState() {
        self.state.handle(context: self)
    }
    
    func cancelState() {
        self.state.cancel(context: self)
    }
}

// State
protocol OrderState {
    func handle(context: Order)
    func cancel(context: Order)
}

//Concrete States
class CancelState: OrderState {
    func handle(context: Order) {
        print("debug 주문 취소 \(context.id)")
    }
    func cancel(context: Order) {
        print("debug 이미 취소되었습니다. 처음부터 다시해주세요")
    }
}

class PendingState: OrderState {
    func handle(context: Order) {
        print("debug 주문 접수 \(context.id)")
        context.changeState(state: PaymentState())
    }
    
    func cancel(context: Order) {
        print("debug 주문 접수 취소 \(context.id)")
        context.changeState(state: CancelState())
    }
}

class PaymentState: OrderState {
    func handle(context: Order) {
        print("debug 결제 \(context.id)")
        context.changeState(state: DeliverState())
    }
    
    func cancel(context: Order) {
        print("debug 결제 취소 \(context.id)")
        context.changeState(state: CancelState())
    }
    
    
}

class DeliverState: OrderState {
    func handle(context: Order) {
        print("debug 배송시작 \(context.id)")
    }
    
    func cancel(context: Order) {
        print("debug 배송 취소 \(context.id)")
        context.changeState(state: CancelState())
    }
}

let orderContext = Order(id: UUID(), items: [""], totalAmount: 200.12)
orderContext.handleState()
orderContext.handleState()
orderContext.handleState()
orderContext.cancelState()
orderContext.cancelState()
