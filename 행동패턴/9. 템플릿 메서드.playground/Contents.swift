import UIKit
import SwiftUI

/*
 부모 클래스에서 알고리즘 골격을 정의하지만 해당 알고리즘의 구조를 변경하지 않고
 자식 클래스들이 알고리즘의 특정 단계들을 재정의 할수 있도록하는 패턴

 사용처
 - 비슷한 알고리즘이나 프로세스를 가진 클래스가 여러개 있을때
 - 코드 중복을 피하고 공통된 작업의 구조를 정의하고 싶을떄
 - 특정단계들만 서브 클래스에서 재정의 하고 싶을때
 
 장점
 - 코드 중복 감소
 - 코드 재사용성 증가
 - 알고리즘 구조를 쉽게 변경 가능
 - 서브클래스에서 특정 부분만 구현하면 되므로 개발시간의 단축
 
 단점
 - 계층 구조가 복잡해질수록 유지보수에 어려움
 - 상속을 하다보니 부모클래스에 의존이 생김
 
 사용빈도
 - 중간
 */

// MARK: - 구조

class AbstractClass {
    func primitiveOperation1() {
        
    }
    func primitiveOperation2() {
        
    }
    func templateMethod() {
        primitiveOperation1()
        primitiveOperation2()
    }
}

class ConcreteClassA: AbstractClass {
    override func primitiveOperation1() {
        print("ConcreteClassA.primitiveOperation1()")
    }
    
    override func primitiveOperation2() {
        print("ConcreteClassA.primitiveOperation2()")
    }
}

class ConcreteClassB: AbstractClass {
    override func primitiveOperation1() {
        print("ConcreteClassB.primitiveOperation1()")
    }
    
    override func primitiveOperation2() {
        print("ConcreteClassB.primitiveOperation2()")
    }
}

let aA: AbstractClass = ConcreteClassA()
aA.templateMethod()

let aB: AbstractClass = ConcreteClassB()
aB.templateMethod()

// MARK: - 모든 ViewController가 공통적으로 수행해야하는 작업에 대한 예시

class BaseViewController: UIViewController {
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    func setADView() {
        fatalError("서브클래스에서 필수 구현해야함")
    }
}

class ViewController: BaseViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setNavigationBar()
        setADView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        print("debug navigationBar Hidden")
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setADView() {
        print("debug set AD View")
    }
}

let vc = ViewController()

