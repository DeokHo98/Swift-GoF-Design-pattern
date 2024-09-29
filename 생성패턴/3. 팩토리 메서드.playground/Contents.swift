import UIKit
import Foundation

/*
 팩토리 메서드 패턴은 상위클래스에서 객체를 생성하기 위한 인터페이스를 정의하되 어떤 클래스를 인스턴스화 할지는 서브클래스가 결정하도록 하는 패턴이다.
 
 사용처
 - 객체 생성 로직이 복잡하거나 자주 변경될때
 - 객체 생성 로직을 상위객체와 분리시키고 상위객체에서 구체적인 클래스에 대한 의존성을 줄이고 싶을때

 장점
 - 새로운 객체의 추가가 용이해진다. 상위클래스 코드를 수정하지 않고도 새로운 객체 유형을 추가할 수 있다.
 - 구체적인 클래스에 의존하지 않도록 하여 코드의 유연성을 향상 시킨다.
 - 여러 클래스에서 동일한 메서드르 사용해 객체를 생성할수 있기때문에 코드의 중복을 줄이고 재사용성을 향상시킨다.
 
 단점
 - 과도한 추상화나 설계의 복잡으로 인해 복잡성이 증가하기때문에 작은 객체 생성로직에는 오히려 불필요하다.
 
 사용 빈도
 - 매우 높음
 */

// MARK: - 구조

protocol Product { }

class ConcreteProductA: Product { }
class ConcreteProductB: Product { }

protocol Creator {
    func factoryMethod() -> Product
}

class ConcreteFactoryA: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductA()
    }
}

class ConcreteFactoryB: Creator {
    func factoryMethod() -> Product {
        return ConcreteProductB()
    }
}

let creators: [Creator] = [ConcreteFactoryA(), ConcreteFactoryB()]
creators.forEach {
    let product = $0.factoryMethod()
    print("debug \(type(of: product))")
}

// MARK: - API 호출 객체 응용 예시

// 1. Product 추상화
protocol APIRequest {
    var path: String { get }
    var method: String { get }
}

// 2. Product 구현
struct GetUseRequest: APIRequest {
    let userID: String
    
    var path: String {
        return "/user/\(userID)"
    }
    
    var method: String {
        return "GET"
    }
}

struct PostMessageRequest: APIRequest {
    let message: String
    
    var path: String {
        return "/list/message=\(message)"
    }
    
    var method: String {
        return "POST"
    }
}

// 3. 팩토리 추상화
protocol APIRequestFactory {
    func makeRequest() -> APIRequest
}

// 4. 팩토리 구현
struct GetUserRequestFactory: APIRequestFactory {
    let userID: String
    
    func makeRequest() -> APIRequest {
        return GetUseRequest(userID: userID)
    }
}

struct PostMessageRequestFactory: APIRequestFactory {
    let message: String
    
    func makeRequest() -> APIRequest {
        return PostMessageRequest(message: message)
    }
}

// 5. 사용
final class ViewController: UIViewController {
    
    let factory: APIRequestFactory
    
    init(factory: APIRequestFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        sendRequest()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sendRequest() {
        let request = factory.makeRequest()
        print("debug \(request.path) \(request.method)")
    }
    
}

let vc = ViewController(factory: GetUserRequestFactory(userID: "123"))
let vc2 = ViewController(factory: PostMessageRequestFactory(message: "가나다라마"))
