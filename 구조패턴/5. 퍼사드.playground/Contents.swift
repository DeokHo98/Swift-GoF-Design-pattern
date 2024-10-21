import UIKit
import SwiftUI

/*
 복잡한 시스템의 인터페이스를 단순화해 클라이언트가 더 쉽게 접근 할 수 있도록 도와주는 디자인패턴이다.
 클라이언트는 복잡한 내부 구현을 알필요 없이 시스템을 사용할 수 있게된다.
 
 사용처
 - 라이브러리나 프레임워크속 광범위한 객체들이 얽혀있는경우 퍼사드를 만들어 필요한 기능을 쉽게 사용하게 한다.

 장점
 - 클라이언트가 복잡한 하위 시스템에 대해 알 필요 없이 쉽게 사용할수 있게 해준다.
 - 클라이언트와 시스템간의 의존성을 줄여 결합도를 줄인다.

 단점
 - 모든 기능을 퍼사드에 통합하려다보면 퍼사드가 비대해져 유지보수가 어려워질 수 있다.
 
 사용빈도
 - 최상
 */

// MARK: - 구조

// 복잡한 하위 시스템
class AudioPlayer {
    func loadAudio() {
        print("debug 오디오 파일 로드 ")
    }
    
    func play() {
        print("debug 오디오 재생")
    }
}

class Equalizer {
    func setLowFreq() {
        print("debug 저주파 설정")
    }
    
    func setHighFreq() {
        print("debug 중주파 설정")
    }
}

class VolumControl {
    func setVolum(level: Int) {
        print("debug 볼륨 설정 \(level)")
    }
}

// 퍼사드 구현
class MusicPlayerFacade {
    private let audioPlayer = AudioPlayer()
    private let equalizer = Equalizer()
    private let volumeControl = VolumControl()
    
    func playMusic() {
        audioPlayer.loadAudio()
        equalizer.setLowFreq()
        equalizer.setHighFreq()
        volumeControl.setVolum(level: 10)
        audioPlayer.play()
    }
}

let musicPlayer = MusicPlayerFacade()
musicPlayer.playMusic()

// MARK: - 유저 정보를 받아오는 API 예시

// 1. 복잡한 시스템 구현
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

class NetworkService {
    func fetchUser() -> Data {
        print("debug fetch User")
        return Data()
    }
}

class DataParser {
    func parse<T: Codable>(data: Data) -> T? {
        print("debug parse \(type(of: T.self))")
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

class LocalStorage {
    func saveUser(_ user: User?) {
        print("debug save User")
        guard let user else { return }
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: "savedUser")
        }
    }
}

// 2. 퍼사드 구현
class DataManagementFacade {
    private let networkService = NetworkService()
    private let dataParser = DataParser()
    private let localStorage = LocalStorage()
    
    func fetchAndSaveUser() {
        let data = networkService.fetchUser()
        let user: User? = dataParser.parse(data: data)
        localStorage.saveUser(user)
    }
}

let dataManagement = DataManagementFacade()
dataManagement.fetchAndSaveUser()
