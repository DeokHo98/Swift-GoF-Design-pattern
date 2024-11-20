import UIKit
import SwiftUI

/*
 객체간의 일대 다 종속성을 정의하는 방법이다.
 이 패턴에서 한 객체의 상태가 변경되면 그 객체에 의존하는 모든 객체들이 자동으로 상태가 변경되었다는 알림? 이벤트를 받는다
 
 RxSwift, NotificationCenter, Combine 등등

 사용처
 - 한 객체의 상태변화가 다른 객 여러 객체들에게 영향을 미칠때
 - 어떤 객체가 다른 객체에게 자신의 변경사항을 알려야할때
 
 장점
 - 알림을 보내는 객체와 받는객체는 서로 독립적을 변경가능해 느슨한 결합을 가진다.
 - 새로운 알림을 보내는 객체를 추가하기도 쉽고, 알림을 받는 객체도 추가하기 쉽다.
 - 실시간 업데이트로 어플리케이션의 데이터의 변경 등을 전달하기 쉽다.
 
 단점
 - 많은 객체들이 생길경우 예측하기 어려운 덥데이트 순서를 가지게된다.
 - 객체간의 결합을 해제하지않으면 메모리 누수가 발생할수도 있다.
 
 사용빈도
 - 최상
 */

// MARK: - 구조

protocol Observer: AnyObject {
    func update()
}

class ConcreteObserver1: Observer {
    func update() {
        print("observer1 update")
    }
}

class ConcreteObserver2: Observer {
    func update() {
        print("observer2 update")
    }
}

protocol Subject: AnyObject {
    var observers: [Observer] { get set }
}

extension Subject {
    func attachObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    func detachObserver(_ observer: Observer) {
        self.observers = observers.filter {
            guard ($0 === observer) == false else {
                print("debug Delete \(type(of: $0))")
                return false
            }
            return true
        }
    }
    
    func notifiy() {
        self.observers.forEach { $0.update() }
    }
}

class ConcreteSubject: Subject {
    var observers: [Observer] = []
}

let subject = ConcreteSubject()
let observer1 = ConcreteObserver1()
let observer2 = ConcreteObserver2()

subject.attachObserver(observer1)
subject.attachObserver(observer2)
subject.notifiy()
subject.detachObserver(observer1)
subject.notifiy()

// MARK: - 실제로 옵저버 패턴은 iOS 개발자라면 여러 방면으로 많이 사용해봤을거로 생각해 예시코드는 생략
// iOS 앱개발에서 아주 자주 사용하는 Delegate 패턴또한 옵저버 패턴의 일종
// NotificationCenter 또한 옵저버 패턴의 일종
// RxSwift나 Combine 또한 옵저버 패턴의 일종
