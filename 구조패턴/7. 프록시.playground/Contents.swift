import UIKit
import SwiftUI

/*
 프록시 패턴은 객체의 대리인 역할을 하는 디자인 패턴으로 실제 객체에 대한 접근을 제어하기 위해 대리자 객체를 제공하는 패턴이다.

 사용처
 - 객체 생성 비용이 큰 객체의 생성을 지연 시킬때
 - 격채에 대한 접근을 제어하고 싶을때
 
 장점
 - 클라이언트의 접근을 제어할수 있어 접근제한을 쉽게 구현할수 있다.
 - 지연초기화를해 자원소비를 줄이고 성능을 향상 시킬 수 있다.
 - 클라이언트는 프록시와 상호작용하므로 실제 객체 구현을 변경해 생기는 영향을 최소화하낟.

 단점
 - 새로운 객체를 많이 생성해야하므로 코드가 복잡해질수 있다.
 - 프록시를 거치면서 응답이 약간 지연될 수 있다.
 
 사용빈도
 - 중상
 */

// MARK: - 구조

protocol Subject {
    func request()
}

class RealSubject: Subject {
    func request() {
        print("debug Called RealSubject.request()")
    }
}

class Proxy: Subject {
    private let realSubject: RealSubject
    
    init(realSubject: RealSubject) {
        self.realSubject = realSubject
    }
    
    func request() {
        realSubject.request()
    }
}

let proxy = Proxy(realSubject: .init())
proxy.request()

// MARK: - 네트워킹 오프라인 캐시 예시

protocol NetworkService {
    func fetchData(url: String) -> Data?
}

class RealNetworkService: NetworkService {
    func fetchData(url: String) -> Data? {
        print("debug real server fetch \(url)")
        return Data()
    }
}

class NetworkProxy: NetworkService {
    private let realService: NetworkService
    private var cache: [String: Data?] = [:]
    var isOfflineMode: Bool = false
    
    init(realService: NetworkService) {
        self.realService = realService
    }
    
    func fetchData(url: String) -> Data? {
        if isOfflineMode {
            guard let cacheData = cache[url] else { return nil }
            print("debug offline cache fetch \(url)")
            return cacheData
        } else {
            guard let cacheData = cache[url] else {
                let data = realService.fetchData(url: url)
                self.cache[url] = data
                return data
            }
            return cacheData
        }
    }
}

// 온라인모드에서 데이터 가져오기
let networkProxy = NetworkProxy(realService: RealNetworkService())
let url = "https://example.com"
print("debug isOfflineModel \(networkProxy.isOfflineMode)")
networkProxy.fetchData(url: url)
networkProxy.isOfflineMode = true
print("debug isOfflineModel \(networkProxy.isOfflineMode)")
networkProxy.fetchData(url: url)
