
<p align="left">
  <img width="100" alt="image" src="https://github.com/chaeondev/Timo/assets/80023607/cb587299-64f0-457b-ad8b-40fc3d2c340a"> &nbsp&nbsp&nbsp 
  <a href="https://apps.apple.com/kr/app/timo-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EA%B4%80%EB%A6%AC-%EB%B0%8F-%ED%85%8C%EC%8A%A4%ED%81%AC-%ED%83%80%EC%9D%B4%EB%A8%B8%EC%95%B1/id6469586508?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/ko-kr?size=250x83&amp;releaseDate=1697673600" alt="Download on the App Store" style="border-radius: 13px; width: 200px; height: 63px;"></a>
</p>

# Timo - 프로젝트 관리 및 테스크 타이머 앱

<img width="800" alt="image" src="https://github.com/chaeondev/Timo/assets/80023607/2c3b70c7-8243-46bd-af7a-2e03e773b644">

<br></br>

## 프로젝트 소개

> 앱 소개

- 프로젝트 단위로 공수산정을 진행할 수 있는 앱
- 프로젝트 별로 작업들을 관리할 수 있음
- 작업별로 수행시간을 타이머로 측정 가능
- 총 수행률, 프로젝트 전체 작업시간 등을 제공

---


> 주요기능

- Realm DB를 **Repository Pattern**을 활용해 **N:M 스키마** 대응
- **RunLoop모드**를 통한 **Timer** 모니터링, Realm을 활용해 Timer **Background** 시간 추적
- TableView, CollectionView의 **Custom Cell**를 사용해 화면 구성, pull down gesture를 통한 menu 구현
- **enum**으로 화면 재사용, **ReusableView**를 통한 재사용성 향상
- 한국어, 영어 **다국어 대응**을 통한 **Localization** 처리
---


> 기술스택

- **프레임워크** : UIKit
- **디자인패턴** : MVVM, Repository Pattern
- **라이브러리** : RealmSwift, SnapKit, Firebase, IQKeyboardManager
- **의존성관리** : Swift Package Manager
- **ETC** : CodabaseUI, Localization

---


> 개발환경

- **iOS Deployment Target** : iOS 15.0
- **Xcode** : v14.3.1
- **Swift** : v5.8.1

---


> 서비스
- **개발인원** : 1인 기획, 디자인, 개발
- **개발기간** : 2023.9.25 - 2023.10.18 (업데이트 진행 중)
- **협업툴** : Git, Figma

---

<br> </br>

## 트러블 슈팅

### 1. 백그라운드 상황에서 타이머 측정 이슈

#### Issue
Foreground에서 타이머가 실행되는 중에 앱을 **Background로 넘기면 타이머의 동작이 멈추게 되는 이슈**가 생겼습니다.
단순히 백그라운드 모드를 타이머에 사용하는 것은 Resource 측면에서도 적합한 솔루션이 아니라고 판단했습니다.
또한 앱이 강제로 종료되어 Suspended 상태로 넘어갔을 경우에 대한 고려가 필요했습니다.


#### Solution
Background, Suspended 상태와 상관없이 동일하게 작동하도록 하기 위해 타이머의 `start`와 `stop`시간을 Task Realm DB에 저장했습니다.
Timer의 Counting여부를 UserDefaults에 저장해뒀습니다. 
타이머를 실행한 상태에서 앱을 백그라운드로 돌리거나 강제종료 한 경우, Counting값이 true로 저장되어 있기 때문에 타이머를 다시 생성할때 `start`시간과 `재생성 시점` 시간의 diff를 타이머에 반영해줌으로서 문제를 해결했습니다.
`diff`를 반영할 때는 타이머의 생성 시점의 시간에서 누적시간을 뺀 값을 `start`시간으로 설정함으로서 사용자가 계속해서 누적시간을 확인할 수 있도록 관리했습니다.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    startTime = taskData.timerStart
    stopTime = taskData.timerStop
    timerCounting = userDefaults.bool(forKey: UserKey.TimeData.countingKey) //Default값 false

    if timerCounting {
        viewModel.createTimer()
    } else {
        viewModel.cancelTimer()
        if let start = startTime, let stop = stopTime {
            let time = viwwModel.calRestartTime(start: start, stop: stop)
            let diff = Date().timeIntervalSince(time)
            viewModel.setTimeLabel(Int(diff))
        }
        viewModel.startTimer()
    }
    
}

```
```swift
func createTimer() {
    if timer == nil {
        updateTimer()
        let newTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        newTimer.tolerance = 0.1
        RunLoop.current.add(newTimer, forMode: .common)
        self.timer = newTimer
        
        setTimerCounting(true) // Timer on 상태 UserDefaults 저장
    }
}

@objc func updateTimer() {
    
    if let start = startTime {
        let diff = Date().timeIntervalSince(start)
        setTimeLabel(Int(diff))
    } else {
        cancelTimer()
        setTimeLabel(0)
    }
}
```



### 2. 타이머 측정 도중 앱 강제종료 시, 재시작할 때 타이머 측정 화면 전환 이슈

