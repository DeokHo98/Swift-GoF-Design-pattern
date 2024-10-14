import UIKit

/*
 컴포지트 패턴은 객체들을 트리 구조들로 구성한후 개별 객체 처럼 작업 할 수 있도록 하는 구조패턴이다.
 군대를 생각하면 편하다. 육군 -> 사단 -> 여단 -> 소대 -> 분대 이런식으로 객체를 구현하는것을 말한다.
 
 사용처
 - 트리와 같은 계층적 구조를 표현할때 유용하다. (파일 시스템에서 폴더와 파일의 관계같은것 또는 조직도나 메뉴시스템 같은 계층적 구조일때)
 - 재귀적 구조를 만들때 (복잡한 객체를 더 작은 동일한 타입의 객체로 구성할 수 있다)

 장점
 - 다형성과 재귀를 유리하게 사용해 복잡한 트리구조를 더 편리하게 작업할 수 있다.
 - 객체 트리에 다른 코드를 훼손하지 않고 새로운 유형을 도입할 수 있다.
 
 단점
 - 기능이 너무 다른 객체들에는 공통 인터페이스를 제공하기 어려울수도 있다.
 - 어떤 경우 이해하기 어려운 코드를 만든다.
 
 사용빈도
 - 중상
 */

// MARK: - 구조

// Component 추상화
protocol AbstractComponent {
    var name: String { get }
    func display()
}

// Component
class Component: AbstractComponent {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func display() {
        print("debug file \(name)")
    }
}

// Composite
class Composite: AbstractComponent {
    var name: String
    private var contents: [AbstractComponent] = []
    
    init(name: String) {
        self.name = name
    }
    
    func add(item: AbstractComponent) {
        contents.append(item)
    }
    
    func display() {
        print("debug directory \(name)")
        contents.forEach {
            print("debug directory \(name) in \($0.name)")
            if let directory = $0 as? Composite {
                directory.display()
            }
        }
    }
}

let root = Composite(name: "최상위폴더")

let child1 = Composite(name: "그안에폴더1")
child1.add(item: Component(name: "파일1"))
child1.add(item: Component(name: "파일2"))

let child2 = Composite(name: "그안에폴더2")
child2.add(item: Component(name: "파일3"))
child2.add(item: Component(name: "파일4"))

root.add(item: child1)
root.add(item: child2)
root.add(item: Component(name: "파일5"))

root.display()

// MARK: - 테이블뷰 설정화면에서의 응용 예시

// 1. 설정 아이템 추상화
protocol SettingItem {
    var title: String { get }
    func createCell() -> UITableViewCell
    func didSelect(navigation: UINavigationController?)
}

// 2. 트리구조를 보여줄 View
class SettingsViewController: UITableViewController {
    
    private let items: [SettingItem]
    
    init(items: [SettingItem], title: String) {
        self.items = items
        super.init(style: .grouped)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return items[indexPath.row].createCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].didSelect(navigation: self.navigationController)
    }
}

// 3. 최상위 객체 구현
class SettingsGroup: SettingItem {
    let title: String
    private var items: [SettingItem]
    
    init(title: String, items: [SettingItem]) {
        self.title = title
        self.items = items
    }
    
    func createCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "GroupCell")
        cell.textLabel?.text = title
        return cell
    }
    
    func didSelect(navigation: UINavigationController?) {
        // 설정 선택시 새로운 설정 화면으로 이동
        let viewController = SettingsViewController(items: items, title: title)
        navigation?.pushViewController(viewController, animated: true)
    }
}

class ToggleSettings: SettingItem {
    let title: String
    var isOn: Bool
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
    
    func createCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "ToggleCell")
        cell.textLabel?.text = title
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        cell.accessoryView = toggle
        return cell
    }
    
    func didSelect(navigation: UINavigationController?) {
        // 토글 설정 Cell은 선택시 아무 동작 X
    }
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        isOn = sender.isOn
        print("\(title) is now \(isOn ? "on" : "off")")
    }
}

class ActionSetting: SettingItem {
    let title: String
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    func createCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ActionCell")
        cell.textLabel?.text = title
        return cell
    }
    
    func didSelect(navigation: UINavigationController?) {
        action
    }
}

let rootItems: [SettingItem] = [
    SettingsGroup(title: "알림 설정", items: [
        ToggleSettings(title: "공지 알림 받기", isOn: false),
        ToggleSettings(title: "당첨 알림 받기", isOn: false)
    ]),
    ActionSetting(title: "캐시 제거", action: {
        //캐시 제거 코드
    })
]

let vc = SettingsViewController(items: rootItems, title: "앱 설정")
