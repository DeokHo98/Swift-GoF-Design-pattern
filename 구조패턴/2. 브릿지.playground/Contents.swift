import UIKit

/*
 브리지는 큰 객체나 밀접하게 관련된 객체들의 집합을 두개의 개별 계층구조인 추상화와 구현으로 나눈후
 각각 독립적으로 개발할수 있도록 하는 패턴이다.
 
 사용처
 - 밀접하게 관련된 객체들이 서로 계층구조를 이루고 있을때
 
 장점
 - 관련된 객체의 계층 구조를 독립적으로 확장 할 수 있게 된다.
 - 단일책임원칙과 개방 폐쇄 원칙을 지키게 된다.
 
 단점
 - 객체와 인터페이스가 많아져 코드가 복잡해질수 있다.
 - 초기 설계에 시간과 노력이 좀 들어간다.
 
 사용빈도
 - 중하
 */

// MARK: - 구조

// 여기서의 추상화는 우리가 평소에 구현하던 프로토콜을 말하는것과 다르다. 그렇기때문에 기존의 추상화는 인터페이스라고 부르겠다.

// 구현 인터페이스
protocol Device {
    var battery: Int { get set }
    func getBatteryLevel() -> Int
    func charging(_ value: Int)
}

// 구현 객체
class IPhone: Device {
    var battery: Int = 0
    
    func getBatteryLevel() -> Int {
        self.battery
    }
    
    func charging(_ value: Int) {
        self.battery = value
    }
}

class Radio: Device {
    var battery: Int = 0
    
    func getBatteryLevel() -> Int {
        self.battery
    }
    
    func charging(_ value: Int) {
        self.battery = value
    }
}

// 추상화 인터페이스
protocol Charger {
    var device: Device { get }
    func batteryMaxCharging()
    func checkBattery() -> Int
}

// 추상화 객체
class DefaultCharger: Charger {
    let device: Device
    
    init(device: Device) {
        self.device = device
    }
    
    func batteryMaxCharging() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            print("debug 일반 충전기 100프로 충전 완료")
            self?.device.charging(100)
        }
    }
    
    func checkBattery() -> Int {
        return device.getBatteryLevel()
    }
}

class SuperFastCharger: Charger {
    let device: Device
    
    init(device: Device) {
        self.device = device
    }
    
    func batteryMaxCharging() {
        print("debug 고속충전기 100프로 충전 완료")
        self.device.charging(100)
    }
    
    func checkBattery() -> Int {
        return device.getBatteryLevel()
    }
}

// 사용
let iphone = IPhone()
let defaultCharger = DefaultCharger(device: iphone)
defaultCharger.batteryMaxCharging()

let radio = Radio()
let fastCharger = SuperFastCharger(device: radio)
fastCharger.batteryMaxCharging()

// 만약 여기서 디바이스를 확장시킨다면 충전기에 영향이 가지않는다.
// 또한 충전기를 확장시킨다고 디바이스에 영향이 가지 않는다.

// MARK: - API 통신할때 필요한 객체와 통신자체를 하는 객체 예시

// 1. 구현 인터페이스
protocol APIRequest {
    var url: String { get }
    var method: String { get }
}

// 2. 구현 객체
class UserProfileAPIRequest: APIRequest {
    var url: String {
        "https://ex/user"
    }
    
    var method: String {
        "GET"
    }
}

class PostChatAPIRequest: APIRequest {
    var url: String {
        "https://ex/chat"
    }
    
    var method: String {
        "POST"
    }
}

// 3. 추상화 인터페이스
protocol NetworkService {
    var apiRequest: APIRequest { get }
    func send()
}

// 4. 추상화 객체
class URLSessionNetworkService: NetworkService {
    let apiRequest: APIRequest
    
    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
    }
    
    func send() {
        print("debug \(apiRequest.url) \(apiRequest.method) URLSession Send")
    }
}

class AlamofireNetworkService: NetworkService {
    let apiRequest: APIRequest
    
    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
    }
    
    func send() {
        print("debug \(apiRequest.url) \(apiRequest.method) Alamofire Send")
    }
}

// 5. 사용
let userProfileAPIRequest = UserProfileAPIRequest()
let postChatAPIRequest = PostChatAPIRequest()
URLSessionNetworkService(apiRequest: userProfileAPIRequest).send()
AlamofireNetworkService(apiRequest: userProfileAPIRequest).send()
URLSessionNetworkService(apiRequest: postChatAPIRequest).send()
AlamofireNetworkService(apiRequest: postChatAPIRequest).send()


