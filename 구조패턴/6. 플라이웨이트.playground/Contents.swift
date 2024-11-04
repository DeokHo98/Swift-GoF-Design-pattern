import UIKit
import SwiftUI

/*
 동일하거나 유사한 객체들 사이에 가능한 많은 데이터를 서로 공유하여 사용할수있도록해 메모리 사용량을 최소화하는 디자인 패턴이다.
 주로 워드프로세서, 그래픽프로그램, 네트워크 어플리케이션과 같은 유틸리티 유형의 애플리케이션에서 사용된다.

 사용처
 - 유사하거나 같은 객체를 다량으로 생성해야하는 경우
 - 객체간 추출 및 공유할 수 있는 데이터가 있는경우
 
 장점
 - 공유 가능한 상태를 외부화하여 많은 객체가 같은 데이터를 참조할수 있게해 메모리 사용량을 감소시켜 성능을 향상시킨다.

 단점
 - 코드의 복잡도가 늘어난다.
 
 사용빈도
 - 최하
 */

// MARK: - 구조

protocol FlyWeight {
    var sharedState: String { get }
}

class ConcreteFlyweight: FlyWeight {
    var sharedState: String
    
    init(sharedState: String) {
        self.sharedState = sharedState
    }
}

class FlyweightFactory {
    private var flyweights: [String: FlyWeight] = [:]
    
    init(states: [String]) {
        states.forEach { flyweights[$0] = ConcreteFlyweight(sharedState: $0) }
    }
    
    func getFlyweight(state: String) -> FlyWeight {
        guard let flyweight = flyweights[state] else {
            let flyweight = ConcreteFlyweight(sharedState: state)
            flyweights[state] = flyweight
            print("debug 생성 flyweight \(flyweight.sharedState)")
            return flyweight
        }
        return flyweight
    }
}

let factory = FlyweightFactory(states: ["1", "2", "3", "4"])
let flyweight = factory.getFlyweight(state: "2") // 이미존재하는건 생성하지않고 반환
print("debug \(flyweight.sharedState)")

let flyweight2 = factory.getFlyweight(state: "10") //만약 없는걸 삽입하면 생성
print("debug \(flyweight2.sharedState)")


// MARK: - UIImage 캐싱 예시

// 1. UIImage 객체 자체를 flyweight 라고 생각

// 2. FlyweightFactory 구현

struct ImageCache {
    static let shared = ImageCache()
    
    private init() { }
    
    let cache = NSCache<NSString, UIImage>()
}

// 3. 이미지뷰에 메서드 확장
extension UIImageView {
    func setImage(image: UIImage, key: String) {
        guard let image = ImageCache.shared.cache.object(forKey: key as NSString) else {
            ImageCache.shared.cache.setObject(image, forKey: key as NSString)
            print("debug 캐시에 이미지없음")
            self.image = image
            return
        }
        print("debug 캐시에 이미지 있음")
        self.image = image
        return
    }
}

let image = UIImage(systemName: "heart")!
let imageView = UIImageView()
imageView.setImage(image: image, key: "heart")
imageView.setImage(image: image, key: "heart")
imageView.setImage(image: image, key: "heart")
imageView.setImage(image: image, key: "heart")

