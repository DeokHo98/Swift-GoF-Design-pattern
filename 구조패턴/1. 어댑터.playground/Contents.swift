import UIKit
import SwiftUI

/*
 서로 다른 호환되지않는 인터페이스를 가진 객체들을 함께 작업할 수 있도록 해주는 패턴
 이해하기 어렵다면 여행지에가서 스마트폰을 충전하려고 봤더니 플러그 규격이 국가마다 다를것이다.
 이럴때 모든 국가에서 사용할수있는 어댑터가 있으면 해결할수 있는것이 바로 어댑터 패턴이다.
 
 주의사항
 나중에 배울 브릿지, 상태, 전략 패턴과 어느정도 유사한 구조로 되어있다.
 하지만 이 패턴들은 서로 다른 문제들을 해결한다는것을 알아야한다.
 
 
 사용처
 - 써드파티 라이브러리를 사용할때와 같은 상황에서는 인터페이스를 제어할수 없는경우가 생긴다.
 이런경우 보통 인터페이스 메서드와 속성 이름이 클라이언트가 기대하는것과 다를수 있다. 이러한 상황에서
 어댑터 패턴을 사용한다.
 - iOS 개발에서는 여러 SNS 로그인을 해야할때 이를 공통으로 처리할 인터페이스를 만들거나 할때도 보통 많이 사용한다.
 

 장점
 - 호환되지 않는 인터페이스를 가진 객체들을 함께사용할수 있기때문에 유연성이 증가한다.
 - 기존 코드를 수정하지않고도 새로운 시스템과 통합할 수 있다.
 - 기존 코드를 수정하지않고 새로운 어댑터를 추가할 수 있어 개방/폐쇄 원칙을 지킨다.
 
 단점
 - 새로운 객체와 인터페이스가 추가되어 코드가 복잡해질수 있다.
 - 때때로 가독성이 더 안좋아질수 있다.
 
 사용빈도
 - 중상
 */

// MARK: - 구조

// 1. 호환되지 않는 인터페이스
protocol Target {
    func reqeust()
}

// 2. 호환되게 도와주는 녀석
class Adaptee {
    func specificRequest() {
        print("Called SpecificRequest")
    }
}

// 3. 호환되지 않는 객체
class Adapter: Target {
    private let adaptee = Adaptee()
    
     func reqeust() {
        adaptee.specificRequest()
    }
}

let target: Target = Adapter()
target.reqeust()

// MARK: - 알라모 파이어와 새로운 가상 네트워킹 라이브러리를 같이 사용하는 예시

// 1. 알라모 파이어를 사용중이라고 가정 위에 구조에서 Target
// 가상의 알라모파이어
class Alamofire {
    static func request(url: String, method: String) -> Data? {
        print("debug alamofire")
        return Data()
    }
}

// 알라모파이어만 사용을 가정해 만든 네트워크 서비스
protocol NetworkServiceProtocol {
    func fetchData(url: String) -> Data?
}
final class NetworkService: NetworkServiceProtocol {
    func fetchData(url: String) -> Data? {
        return Alamofire.request(url: url, method: "GET")
    }
}

// 2. 여기서 새로운 네트워킹 라이브러리를 동시에 사용하기로 함 이게 위에 구조에서 Adaptee
enum HttpMethod: String {
    case GET
    case POST
}

class Newfire {
    // 알라모파이어랑은 파라미터부터 반환 타입까지 아예 다른 구조
    func performRequest(url: URL, httpMethod: HttpMethod) -> Result<Data, Error> {
        print("debug newfire")
        return .success(Data())
    }
}

// NewFire를 기존 NetworkService 인터페이스에 맞게 조정해주는 어댑터 구현
class NewfireAdapter: NetworkServiceProtocol {
    let newFire = Newfire()
    
    func fetchData(url: String) -> Data? {
        guard let url = URL(string: url) else { return nil }
        let reqeust = newFire.performRequest(url: url, httpMethod: .GET)
        switch reqeust {
        case .success(let data):
            return data
        case .failure:
            return nil
        }
    }
}

// 3. 사용

class UserViewModel {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchUserData(url: String) {
        networkService.fetchData(url: url)
    }
}

let alamofireViewModel = UserViewModel(networkService: NetworkService())
let newfireViewModel = UserViewModel(networkService: NewfireAdapter())

alamofireViewModel.fetchUserData(url: "123")
newfireViewModel.fetchUserData(url: "123")
