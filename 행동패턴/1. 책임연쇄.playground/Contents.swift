import UIKit
import SwiftUI

/*
 여러 핸들러를 하나의 체인을 연결하여 요청을 처리하는 방식이다.

 사용처
 - 다양한 종류의 요청을 처리해야 하는 경우
 - 특정 순서로 여러 핸들러를 실행해야 하는 경우
 
 장점
 - 핸들러를 쉽게 추가하거나 제거할 수 있어 유연성을 제공한다.
 - 새로운 핸들러를 추가하여 쉽게 기능을 확장할 수 있다.
 - 동일한 핸들러를 여러곳에서 재사용 할 수 있다.

 단점
 - 체인을 따라 요청을 전달하는 로직이 추가되므로 코드가 복잡해질 수 있다.
 
 사용빈도
 - 중하
 */

// MARK: - 구조

protocol Handler {
    var nextHandler: Handler? { get set }
    func handle(request: String) -> String?
}

class ConcreteHandlerA: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "A" {
            return "Handler A: \(request)"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class ConcreteHandlerB: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "B" {
            return "Handler B: \(request)"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

func handle(handler: Handler) {
    let food = ["A", "B", "C"]
    food.forEach {
        guard let result = handler.handle(request: $0) else {
            return
        }
        print("debug \(result)")
    }
}

let handlerA = ConcreteHandlerA()
let handlerB = ConcreteHandlerB()
handlerA.nextHandler = handlerB
handle(handler: handlerA)
handle(handler: handlerB)

// MARK: - String을 검증하는 Validator 예시

// 검증기 프로토콜 정의
protocol StringValidator: AnyObject {
    var next: StringValidator? { get set }
    func validate(_ input: String) -> Bool
}

// 비밀번호 길이 검증기
class PasswordLengthValidator: StringValidator {
    weak var next: StringValidator?
    
    func validate(_ input: String) -> Bool {
        if input.count < 8 {
            print("비밀번호는 최소 8자 이상이어야 합니다.")
            return false
        }
        print("비밀번호 길이 OK")
        return next?.validate(input) ?? true
    }
}

// 특수문자 포함 검증기
class SpecialCharacterValidator: StringValidator {
    weak var next: StringValidator?

    func validate(_ input: String) -> Bool {
        let specialCharRegex = ".*[^A-Za-z0-9].*"
        let specialCharPredicate = NSPredicate(format:"SELF MATCHES %@", specialCharRegex)
        if !specialCharPredicate.evaluate(with: input) {
            print("비밀번호는 최소 하나의 특수문자를 포함해야 합니다.")
            return false
        }
        print("특수문자 포함된 비밀번호")
        return next?.validate(input) ?? true
    }
}

// 검증 체인 사용 예시
class ValidationManager {
    private let passwordLengthValidator = PasswordLengthValidator()
    private let specialCharValidator = SpecialCharacterValidator()
    private let validationChain: StringValidator

    init() {
        passwordLengthValidator.next = specialCharValidator
        validationChain = passwordLengthValidator
    }

    func validateInput(_ input: String) -> Bool {
        return validationChain.validate(input)
    }
}

// 사용 예시
let validationManager = ValidationManager()

// 비밀번호 검증
let passwordResult = validationManager.validateInput("password123!")
print("비밀번호 검증 결과: \(passwordResult)")

// 비밀번호 검증에 예를들어 대문자가 포함되어야 한다면? 쉽게 추가가 가능
