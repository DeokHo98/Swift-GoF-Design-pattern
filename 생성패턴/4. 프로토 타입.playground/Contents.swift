import UIKit
import Foundation

/*
 만약 어떤 객체의 똑같은 복사본을 만든다고 생각해보자 새 객체를 생성하고 기존객체의 프로퍼티를 하나하나 옮겨야할것이다.
 일부 Private 프로퍼티는 어떻게할것인가? 이럴때 사용할수 있다.
 프로토 타입패턴은 코드를 객체에 의존하지않은 그 객체를 복사할수 있도록 하는 패턴이다.
 
 사용처
 - 객체 생성과정이 복잡한 생성
 - 동일한 객체 반복 생성

 장점
 - 복잡한 객체를 매번 생성하는대신 기존 객체를 복제함으로써 객체 생성 비용을 절감
 - 객체 생성 방법이나 복잡성을 알 필요없이 복제된 객체를 쉽게 사용 가능
 
 부작용
 - 객체를 복제하는 과정에서 객체의 상태를 유지할 수 없을수도 있음
 
 사용빈도
 - 중간
 */

// MARK: - 구조

protocol Prototype {
    var id: String { get }
    func copy() -> Prototype
}

class ConcretePrototype: Prototype {
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func copy() -> Prototype {
        return ConcretePrototype(id: self.id) as Prototype
    }
}

let origin = ConcretePrototype(id: "ProtoType")
if var copy = origin.copy() as? ConcretePrototype {
    print("debug origin \(origin.id)")
    print("debug copy \(copy.id)")
    copy.id = "Copy"
    print("debug change origin \(origin.id)")
    print("debug change copy \(copy.id)")
}

print("=================================================")

// MARK: - ViewModel 응용 예시

// 1. 프로토타입 추상화
protocol ViewModelPrototype {
    var buttonIsHidden: Bool { get set }
    var labelText: String { get set }
    var count: Int { get set }
    
    func copy() -> ViewModelPrototype
}

// 2. 프로토타입 구현
class AViewModel: ViewModelPrototype {
    var buttonIsHidden: Bool
    var labelText: String
    var count: Int
    
    init(buttonIsHidden: Bool, labelText: String, count: Int) {
        self.buttonIsHidden = buttonIsHidden
        self.labelText = labelText
        self.count = count
    }
    
    func copy() -> ViewModelPrototype {
        return AViewModel(buttonIsHidden: self.buttonIsHidden, labelText: self.labelText, count: self.count) as ViewModelPrototype
    }
}


// 3. 사용
var viewModel = AViewModel(buttonIsHidden: false, labelText: "text", count: 1)
var copyViewModel = viewModel.copy()
print("debug origin \(viewModel.count)")
print("debug copy \(copyViewModel.count)")
viewModel.count = 10
print("debug origin count update")
print("debug origin \(viewModel.count)")
print("debug copy \(copyViewModel.count)")
copyViewModel.count = 90
print("debug copy count update")
print("debug origin \(viewModel.count)")
print("debug copy \(copyViewModel.count)")
