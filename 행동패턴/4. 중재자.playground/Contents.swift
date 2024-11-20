import UIKit
import SwiftUI

/*
 중재자 패턴은 프로그램의 구성요소들 간의 결합도를 낮추는 패턴이다.
 이 패턴에서 구성 요소들은 직접 통신하지 않고 특별한 중재자 객체를 통해 간접적으로 통신한다.

 사용처
 - 서로 의존된 객체들이 복잡한 관계를 가지고 있을때
 - 다수의 객체와 통신하는 객체를 만들어야 할때
 - 여러 클래스에 분산된 행동을 많은 서브 클래스를 만들지않고 커스터 마이즈 해야 할때
 
 장점
 - 객체들간의 혼란스러운 의존 관계를 줄여 결합도를 줄인다.
 - 여러 객체들에서 하는 공통된 일을 중재가 처리해 단일 책임원칙을 지킨다.
 - 기존 구성요소를 수정하지않고 새로운 중재자를 도입해 개방 폐쇄 원칙을 지킨다.
 - 중재자를 재사용할수 있는 가능성이 높아 재사용성이 증가한다.
 
 단점
 - 중앙 집중화로 인한 병목현상 가능성이 생긴다.
 
 사용빈도
 - 중하
 */

// MARK: - 구조

protocol Colleague: AnyObject {
    var mediator: Mediator { get }
}

class ConcreteColleague1: Colleague {
    let mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
    }
    
    func send(message: String) {
        print("debug colleague1 send to mediator message: \(message)")
        mediator.send(colleague: self, message: message)
    }
    
    func notify(message: String) {
        print("colleague1 get messsage: \(message)")
    }
}

class ConcreteColleague2: Colleague {
    let mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
    }
    
    func send(message: String) {
        print("debug colleague2 send to mediator message: \(message)")
        mediator.send(colleague: self, message: message)
    }
    
    func notify(message: String) {
        print("colleague2 get message: \(message)")
    }
}

protocol Mediator {
    func send(colleague: Colleague, message: String)
}

class ConcreteMediator: Mediator {
    private var colleague1: ConcreteColleague1?
    private var colleague2: ConcreteColleague2?
    
    func setColleague1(_ colleague: ConcreteColleague1) {
        self.colleague1 = colleague
    }
    
    func setColleague2(_ colleague: ConcreteColleague2) {
        self.colleague2 = colleague
    }
    
    func send(colleague: Colleague, message: String) {
        if let _ = colleague as? ConcreteColleague1 {
            colleague2?.notify(message: message)
        } else {
            colleague1?.notify(message: message)
        }
    }
}

let mediator = ConcreteMediator()
let colleague1 = ConcreteColleague1(mediator: mediator)
let colleague2 = ConcreteColleague2(mediator: mediator)
mediator.setColleague1(colleague1)
mediator.setColleague2(colleague2)

colleague1.send(message: "뭐해?")
colleague2.send(message: "그냥 있어")
colleague2.send(message: "왜?")
colleague1.send(message: "그냥 궁금해서")

// MARK: - Coordinator 패턴 예시
// ViewController 끼리 직접 통신하지않고 Coordinator를 통해서 통신하고 화면전환하는것이 Mediator 패턴을 적용한것

protocol AppMediator: AnyObject {
    func userDidLogin()
    func userDidLogout()
    func userWantsToViewProfile()
    func userWantsToViewSettings()
}

protocol ViewControllerDelegate: AnyObject {
    var mediator: AppMediator? { get set }
    func updateUI()
}

class AppCoordinator: AppMediator {
    private var navigationController: UINavigationController
    private var loginVC: LoginViewController?
    private var homeVC: HomeViewController?
    private var profileVC: ProfileViewController?
    private var settingsVC: SettingsViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.mediator = self
        navigationController.setViewControllers([loginVC], animated: true)
        self.loginVC = loginVC
    }
    
    func userDidLogin() {
        let homeVC = HomeViewController()
        homeVC.mediator = self
        navigationController.setViewControllers([homeVC], animated: true)
        self.homeVC = homeVC
    }
    
    func userDidLogout() {
        showLoginScreen()
    }
    
    func userWantsToViewProfile() {
        let profileVC = ProfileViewController()
        profileVC.mediator = self
        navigationController.pushViewController(profileVC, animated: true)
        self.profileVC = profileVC
    }
    
    func userWantsToViewSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.mediator = self
        navigationController.pushViewController(settingsVC, animated: true)
        self.settingsVC = settingsVC
    }
}

class LoginViewController: UIViewController, ViewControllerDelegate {
    weak var mediator: AppMediator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI
    }
    
    func updateUI() {
        // Update login screen UI
    }
    
    @objc func loginButtonTapped() {
        // Perform login logic
        mediator?.userDidLogin()
    }
}

class HomeViewController: UIViewController, ViewControllerDelegate {
    weak var mediator: AppMediator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI
    }
    
    func updateUI() {
        // Update home screen UI
    }
    
    @objc func profileButtonTapped() {
        mediator?.userWantsToViewProfile()
    }
    
    @objc func settingsButtonTapped() {
        mediator?.userWantsToViewSettings()
    }
    
    @objc func logoutButtonTapped() {
        mediator?.userDidLogout()
    }
}

class ProfileViewController: UIViewController, ViewControllerDelegate {
    weak var mediator: AppMediator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI
    }
    
    func updateUI() {
        // Update profile screen UI
    }
}

class SettingsViewController: UIViewController, ViewControllerDelegate {
    weak var mediator: AppMediator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI
    }
    
    func updateUI() {
        // Update settings screen UI
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
