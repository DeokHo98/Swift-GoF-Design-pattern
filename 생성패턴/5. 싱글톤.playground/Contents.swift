import UIKit

/*
 객체가 오직 하나의 인스턴스만 가지도록 보장하고 해당 인스턴스에 대한 전역 접근성을 제공하는 패턴
 
 사용처
 - 설정관리나 이미지캐시 등 어플리케이션 전체에서 사용하거나 관리하는 리소스를 관리하는 객체

 장점
 - 어플리케이션 전체에서 단일 인스턴스에 쉽게 전근할 수 있고 리소스를 공유할수 있다.
 - 어플리케이션 전체에서 일관된 상태를 유지할 수 있다.
 
 부작용
 - 전역객체는 테스트가 어렵다
 - 코드 전체가 싱글톤 객체에 의존하게되어 결합도가 높아진다.
 - 멀티스레드 환경에서 동시성 문제가 발생하지않으려면 따로 작업을 해줘야한다.
 
 사용빈도
 - 중상
 
 Swift에서의 싱글톤
 - UserDefault.standard
 - URLSession.Shared
 - NotificationCenter.default
 - UIApplication.shared
 - FireManager.default
 */

// MARK: - 네트워크 통신객체 응용 예시

class Singleton {
    static let shared = Singleton()
    
    private init() { }
}

// MARK: - 실제사용

final class NetworkManager {
    static let shared = NetworkManager() // 단 하나만 존재하는 인스터스를 생성
    
    private init() { } // 외부에서 새 인스턴스를 생성할수 없도록해 실수를 미연에 방지
    
    func fechData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        // 네트워크 요청 로직
    }
}

let url = URL(string: "ex")!
NetworkManager.shared.fechData(url: url) { data, error in
    // 네트워크 응답 처리 로직
}

