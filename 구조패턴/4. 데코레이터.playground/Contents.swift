import UIKit
import SwiftUI

/*
 객체들을 새로운 행동들을 포함한 특수 래퍼 객체들 내에 넣어서 객체들을 연결시키는 디자인 패턴이다.
 쉽게 말하면 객체를 객체로 감싸면서 확장하는 방법이다
 
 사용처
 - 상속을 사용하지않고 기능을 확장 하고 싶을때
 - 객체의 기능을 유연하게 확장해야할때
 - 객체의 책임을 동적으로 추가하거나 제거해야할때

 장점
 - 각 데코레이터는 특정 기능에대해서만 책임을지기때문에 단일책임원칙을 지킨다.
 - 실행중인 객체의 동작을 동적으로 변경할 수 있다
 - 여러 데코레이터로 래핑하면 여러 행동들을 합성할 수 있다.
 - 상속의 대안으로 사용 가능하다.
 - 기존코드를 수정하지 않고도 새로운 기능을 추가하는 개팡폐쇄 원칙을 지킨다.

 단점
 - 초기 계층 설정 코드가 가독성이 떨어진다.
 - 순서가 중요하다. 데코레이터 적용 순서가 결과에 영향을 준다.
 
 사용빈도
 - 중
 */

// MARK: - 구조

// 객체 추상화
protocol Hamburger {
    func cost() -> Int
    func description() -> String
}

// 객체 구현
class DefaultHamburger: Hamburger {
    func cost() -> Int {
        return 2000
    }
    
    func description() -> String {
        return "고기 야채만 들어간 햄버거"
    }
}

// 데코레이터 객체 생성
protocol HamburgerDecorator: Hamburger {
    var hamburger: Hamburger { get }
    func cost() -> Int
    func description() -> String
}

class CheeseDecorator: HamburgerDecorator {
    let hamburger: Hamburger
    
    init(hamburger: Hamburger) {
        self.hamburger = hamburger
    }
    
    func cost() -> Int {
        hamburger.cost() + 500
    }
    
    func description() -> String {
        hamburger.description() + " + 치즈추가"
    }
}

class BaconDecorator: HamburgerDecorator {
    let hamburger: Hamburger
    
    init(hamburger: Hamburger) {
        self.hamburger = hamburger
    }
    
    func cost() -> Int {
        hamburger.cost() + 1000
    }
    
    func description() -> String {
        hamburger.description() + " + 베이컨추가"
    }
}

let defaultBuger = DefaultHamburger()
let baconCheeseBuger = BaconDecorator(hamburger: CheeseDecorator(hamburger: defaultBuger))

print("debug \(baconCheeseBuger.cost())")
print("debug \(baconCheeseBuger.description())")

// MARK: - 네트워크 통신객체에 각각 특수 기능들을 넣은 예시

protocol NetworkService {
    func request(url: String, completion: @escaping (Data?, Error?) -> Void)
}

class BaseNetworkService: NetworkService {
    func request(url: String, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            completion(data, error)
        }.resume()
    }
}

protocol NetworkServiceDecorator: NetworkService {
    var service: NetworkService { get }
    func request(url: String, completion: @escaping (Data?, Error?) -> Void)
}

class LoggingNetworkDecorator: NetworkServiceDecorator {
    
    let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func request(url: String, completion: @escaping (Data?, (any Error)?) -> Void) {
        print("debug request Start")
        service.request(url: url) { data, error in
            if let error = error {
                print("debug Request failed: \(error.localizedDescription)")
            } else {
                print("debug Request succeeded")
            }
            completion(data, error)
        }
    }
}

class CachingNetworkDecorator: NetworkServiceDecorator {
    let service: NetworkService
    private var cache: [String: Data] = [:]
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func request(url: String, completion: @escaping (Data?, (any Error)?) -> Void) {
        print("debug cache \(cache)")
        if let cachedData = cache[url] {
            completion(cachedData, nil)
            return
        }
        
        service.request(url: url) { [weak self] data, error in
            if let data = data {
                self?.cache[url] = data
            }
            completion(data, error)
        }
    }
}

let service = CachingNetworkDecorator(service: LoggingNetworkDecorator(service: BaseNetworkService()))
service.request(url: "123") { _, _ in }
