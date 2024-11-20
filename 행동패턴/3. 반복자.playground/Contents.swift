import UIKit
import SwiftUI

/*
 컬렉션의 요소들을 내부 구조를 노출하지 않고 그들을 하나씩 순회하는 방법을 제공하는 디자인 패턴
 컬렉션의 주요책임은 효율적인 데이터 저장 및 관리의 역할을 하는데
 컬렉션에 여러 순회 로직들을 추가하면 컬렉션의 주요 책임이 무엇인지 점점 명확해지지 않게 된다.
 이러한 로직들을 특정한 클래스에 구현하는것이다.
 
 Swift에서는 이미 이런 기능을 제공하는데 ItertorPorotocl 이라는 프로토콜이 존재한다.
 그래서 배열과 같은 Swift의 컬렉션타입에서 for문을 통해 순차적인 접근을 할수 있는것도 내부적으로 이미 이러한 패턴이 적용되어 있는것이다.
 사실 그렇기 때문에 어떤 특정한 순회알고리즘(BFS, DFS)을 모두 제공해야하는 컬렉션 타입을 구현하는것이 아닌이상은 실제로 이것을 구현해서 사용할일은 많이 없다.

 사용처
 - 집합체의 내부 구조를 드러내지 않고 순차적으로 요소에 접근해야 할 때
 - 여러 종류의 컬렉션에 대해 일관된 순회 방법을 제공하고 싶을 때
 - 복잡한 데이터 구조를 가진 객체의 요소에 접근할대
 
 장점
 - 순회로직을 별도의 객체로 분리해 단일책임원칙을 지킴
 - 기존 코드 없이 새로운 순회 방법추가가 가능해 개방 폐쇄 원칙을 지킴
 - 여러 반복자를 동시에 사용 가능
 
 단점
 - 간단한 컬렉션의 경우 과도한 복잡성이 증가
 
 사용빈도
 - 매우높음
 */

// MARK: - 구조

struct Book {
    let title: String
    let author: String
}

class LibraryIterator: IteratorProtocol {
    private var current = 0
    private let books: [Book]
    
    init(books: [Book]) {
        self.books = books
    }
    
    func next() -> Book? {
        guard current < books.count else {
            return nil
        }
        defer { current += 1 }
        return books[current]
    }
}

class Library: Sequence {
    private var books: [Book] = []
    
    func add(book: Book) {
        books.append(book)
        print("debug \(books.count)")
    }
    
    func makeIterator() -> LibraryIterator {
        return LibraryIterator(books: books)
    }
}

let library = Library()
library.add(book: Book(title: "1984", author: "George Orwell"))
library.add(book: Book(title: "To Kill a Mockingbird", author: "Harper Lee"))

let iterator = library.makeIterator()
print("debug \(iterator.next())")
print("debug \(iterator.next())")
print("debug \(iterator.next())")
