import UIKit

/*
 추상 팩토리 패턴은 공통 주제로 연결되거나 관련된 여러 객체를 생성하는 클래스를 제공하는 패턴이다.
 
 사용처
 - 관련된 객체를 함께 생성해야할때
 - 상위객체에서 구체적인 클래스에 대한 의존성을 줄이고 싶을때
 - 객체의 일관성을 보장하고 싶을때

 장점
 - 구체적인 클래스에 의존하지 않기때문에 다른 구현체로 쉽게 교체할수 있다.
 - 기존코드를 변경하지않고(개방패쇄 원칙) 새로운 객체를 쉽게 추가할수 있는 유연성과 확장성이 증가한다.
 - 관련된 여러 객체들의 일관성이 보장된다.
 
 단점
 - 코드의 양과 복잡성이 증가하기때문에 관련성 있는 객체가 많이 생길거라 예상되지 않으면 불필요 하다.
 
 사용빈도
 - 매우높음
 */

// MARK: - 구조

protocol AbstractProductA { }
protocol AbstractProductB {
    func interact(with a: AbstractProductA)
}

final class ProductA1: AbstractProductA { }
final class ProductB1: AbstractProductB {
    func interact(with a: AbstractProductA) {
        print("\(type(of: self)) interacts with \(type(of: a))")
    }
}

final class ProductA2: AbstractProductA { }
final class ProductB2: AbstractProductB {
    func interact(with a: AbstractProductA) {
        print("\(type(of: self)) interacts with \(type(of: a))")
    }
}

protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

final class ConcreateFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ProductA1()
    }
    
    func createProductB() -> AbstractProductB {
        return ProductB1()
    }
}

final class ConcreateFactory2: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ProductA2()
    }
    
    func createProductB() -> AbstractProductB {
        return ProductB2()
    }
}

final class Client {
    private var productA: AbstractProductA
    private var productB: AbstractProductB
    
    init(factory: AbstractFactory) {
        self.productA = factory.createProductA()
        self.productB = factory.createProductB()
    }
    
    func run() {
        productB.interact(with: productA)
    }
}

let factory1: AbstractFactory = ConcreateFactory1()
let client1 = Client(factory: factory1)
client1.run()

let factory2: AbstractFactory = ConcreateFactory2()
let client2 = Client(factory: factory2)
client2.run()

// MARK: - 컴토지셔널 레이아웃을 제공하는 추상 팩토리 패턴

// 아레 예제에선 따로 추상화된 Product는 없고 NSCollectionLayoutSection 이런애들이 Product

// 1. 팩토리 추상화
// 컴포지셔널 레이아웃을 구성하는 요소들을 반환하는 팩토리 프로토콜 (관련된 여러 객체의 모음)
protocol CompositionalLayoutFactory {
    func createLayoutSection() -> NSCollectionLayoutSection
    func createLayoutGroup() -> NSCollectionLayoutGroup
    func createLayoutItem() -> NSCollectionLayoutItem
    
    // 메서드도 같이 사용 가능하다는 예시를 위한 가짜 메서드
    func endRender()
}

// 2. 팩토리 구현
// 만약 새로운 화면의 컴포지셔널 레이아웃이 필요하면 이런 팩토리를 계속 만들면 되는것 (확장에 용이)
final class MainCompositionalLayoutFactory: CompositionalLayoutFactory {
    func createLayoutSection() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: createLayoutGroup())
    }
    func createLayoutGroup() -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(99), heightDimension: .estimated(99)), subitems: [createLayoutItem()])
    }
    func createLayoutItem() -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(9), heightDimension: .estimated(9)))
    }
    func endRender() {
        print("debug end render Main")
    }
}

final class HomeCompositionalLayoutFactory: CompositionalLayoutFactory {
    func createLayoutSection() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: createLayoutGroup())
    }
    func createLayoutGroup() -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(1), heightDimension: .absolute(1)), subitems: [createLayoutItem()])
    }
    func createLayoutItem() -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(10), heightDimension: .absolute(10)))
    }
    func endRender() {
        print("debug end render Home")
    }
}

// 3. 사용
final class CollectionViewController: UICollectionViewController {
    
    let layoutFactory: CompositionalLayoutFactory
    
    init(layoutFactory: CompositionalLayoutFactory) {
        self.layoutFactory = layoutFactory
        super.init(collectionViewLayout: .init())
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let layout = UICollectionViewCompositionalLayout(section: layoutFactory.createLayoutSection())
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        layoutFactory.endRender()
    }
}

let vc = CollectionViewController(layoutFactory: MainCompositionalLayoutFactory())
