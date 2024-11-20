import UIKit
import SwiftUI

/*
 알고리즘군을 정의하고 각각을 캡슐화하여 교환해서 사용할 수 있도록 만드는 행위 패턴이다.
 이 패턴을 사용하면 알고리즘을 사용하는 클라이언트와는 독립적으로 알고리즘을 변경할 수 있다.

 사용처
 - 관련된 알고리즘군이 존재하고, 이들을 동적으로 교체해야 할 때
 - 알고리즘의 변형이 자주 일어날 때
 - 알고리즘이 클라이언트에 독립적이어야 할 때
 
 장점
 - 알고리즘의 변경이 클라이언트 코드에 영향을 미치지 않음
 - 새로운 알고리즘을 쉽게 추가할 수 있음
 - 조건문을 제거하여 코드를 간결하게 만듦
 - 동적으로 알고리즘을 교체할 수 있음
 
 단점
 - 많은 전략 클래스가 생성될 수 있어 관리가 복잡해질 수 있음
 - 클라이언트가 구체적인 전략을 알아야 함
 - 간단한 로직에 적용하면 오버엔지니어링이 될 수 있음
 
 사용빈도
 - 최상
 */

// MARK: - 구조

protocol Strategy {
    func algorithmInterface()
}

class ConcreteStrategyA: Strategy {
    func algorithmInterface() {
        print("Called ConcreteStrategyA.algorithmInterface()")
        
    }
}

class ConcreteStrategyB: Strategy {
    func algorithmInterface() {
        print("Called ConcreteStrategyB.algorithmInterface()")
    }
}

class ConcreteStrategyC: Strategy {
    func algorithmInterface() {
        print("Called ConcreteStrategyC.algorithmInterface()")
    }
}

class Context {
    private var strategy: Strategy
    
    init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    func contextInterface() {
        strategy.algorithmInterface()
    }
}

var context: Context
context = Context(strategy: ConcreteStrategyA())
context.contextInterface()
context = Context(strategy: ConcreteStrategyB())
context.contextInterface()
context = Context(strategy: ConcreteStrategyC())
context.contextInterface()

// MARK: - 정렬 알고리즘 전략패턴 예시

protocol SortStrategy {
    func sort(data: [Int]) -> [Int]
}

class BubbleSort: SortStrategy {
    func sort(data: [Int]) -> [Int] {
        return data.sorted()
    }
}

class SelectionSort: SortStrategy {
    func sort(data: [Int]) -> [Int] {
        return data.sorted(by: >)
    }
}

class ExcludeSort: SortStrategy {
    
    let excludeValue: Int
    
    init(excludeValue: Int) {
        self.excludeValue = excludeValue
    }
    
    func sort(data: [Int]) -> [Int] {
        return data.sorted().filter { $0 != excludeValue }
    }
}

class Sorter {
    private var strategy: SortStrategy
    
    init(strategy: SortStrategy) {
        self.strategy = strategy
    }
    
    func changeStrategy(strategy: SortStrategy) {
        self.strategy = strategy
    }
    
    func performSort(data: [Int]) -> [Int] {
        return strategy.sort(data: data)
    }
}

let sorter = Sorter(strategy: BubbleSort())
let data = [10, 1, 3, 5]
print("\(sorter.performSort(data: data))")
sorter.changeStrategy(strategy: SelectionSort())
print("\(sorter.performSort(data: data))")
sorter.changeStrategy(strategy: ExcludeSort(excludeValue: 10))
print("\(sorter.performSort(data: data))")
