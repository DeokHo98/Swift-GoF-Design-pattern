import UIKit

/*
 복잡한 객체의 구성과 그 표현을 분리하여 다양한 유형의 객체를 쉽게 생성할수 있도록하는 패턴이다.
 이 패턴없이 객체를 다양하게 생성할수 있도록하려면 괴물같은 파라미터를가진 생성자가 생길것이고 if 구문도 많이 생길것이다.
 
 사용처
 - 복잡한 객체의 생성과정을 분리하고싶을때

 장점
 - 유형과 내용만 지정하여 객체를 생성할수 있게하기때문에 클라이언트는 작업이 어떻게 이루어지는 못한채 수행되기때문에 클라이언트 코드는 단순화 된다.
 - 기존코드를 변경하지않고(개방패쇄 원칙) 새로운 객체를 쉽게 추가할수 있는 유연성과 확장성이 증가한다.
 - 관련된 여러 객체들의 일관성이 보장된다.
 
 단점
 - 코드의 양과 복잡성이 증가한다.
 - 추가적인 객체가 많이 생겨 관리의 어려움이 생길수도 있다.
 
 사용빈도
 - 낮음
 */

// MARK: - 구조

class Product {
    private var parts: [String] = []
    
    func add(part: String) {
        parts.append(part)
    }
    
    func show() {
        print("Product Parts ----------------")
        parts.forEach { print("\($0)") }
    }
}

protocol Builder {
    func buildPartA()
    func buildPartB()
    func getResult() -> Product
}

class Director {
    func construct(builder: Builder) {
        builder.buildPartA()
        builder.buildPartB()
    }
}

class ConcreateBuilder: Builder {
    private var product = Product()
    
    func buildPartA() {
        product.add(part: "PartA")
    }
    
    func buildPartB() {
        product.add(part: "PartB")
    }
    
    func getResult() -> Product {
        return product
    }
}

let director = Director()
let builder = ConcreateBuilder()

director.construct(builder: builder)
let product = builder.getResult()
product.show()

// MARK: - UIAlertController에 적용된 빌더 패턴
// 아래 예제에서의 Product는 UIAlertController

// 프로토콜로 추상화를 하면 더 다양한 Director를 만들수 있음
// 1. 빌더 추상화
protocol AlertBuilder {
    func setTitle(_ title: String) -> Self
    func setMessage(_ message: String) -> Self
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> Self
    func build() -> UIAlertController
}

// 2. 빌더 객체 구현
final class AlertDirector: AlertBuilder {
    private var title: String?
    private var message: String?
    private var actions: [UIAlertAction] = []
    
    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    func setMessage(_ message: String) -> Self {
        self.message = message
        return self
    }
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.actions.append(action)
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
}

// 3. 사용
final class ViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        showAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showAlert() {
        // 타이틀하고 메시지만 있는 얼럿
        let alert = AlertDirector()
            .setTitle("경고")
            .setMessage("에러가 발생했습니다")
            .build()
        print("debug \(alert.title)")
        print("debug \(alert.actions.count)")
        present(alert, animated: true)
        
        // 타이틀만있고 액션이 취소 확인이 있는 얼럿
        let alert2 = AlertDirector()
            .setTitle("재시도 하시겠습니까?")
            .addAction(title: "확인", style: .default, handler: nil)
            .addAction(title: "취소", style: .cancel, handler: nil)
            .build()
        print("debug \(alert2.title)")
        print("debug \(alert2.actions.count)")
        present(alert2, animated: true)
    }
}

let vc = ViewController()

/*
아래 처럼 하는게 훨씬더 보기 좋은거 아니냐? 라고 할수도 있다.
하지만 이는 단적으로 Alert만 봤을때만 그렇다 여기서 생성과정이 더 많이 늘어난다고 가정해보자
그경우 함수의 파라미터는 수십개가 될수도 있다 그럴때일수록 빌더 패턴이 더 적잡하다고 볼 수 있다.
 */
extension UIAlertController {
    static func createAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction] = []) -> Self {
        let alert = Self(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
}
