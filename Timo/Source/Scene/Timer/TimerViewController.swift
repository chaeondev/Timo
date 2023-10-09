//
//  TimerViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/08.
//

import UIKit

class TimerViewController: BaseViewController {
    
    private lazy var timeLabel = UILabel.labelBuilder(text: "00:00:00", font: .boldSystemFont(ofSize: 44), textColor: Design.BaseColor.border!, numberOfLines: 1, textAlignment: .center)
    private lazy var stopButton = TimerButton.timerButtonBuilder(imageSystemName: "pause.circle.fill", pointSize: 50)
    
    //샘플버튼
    private lazy var startButton = TimerButton.timerButtonBuilder(imageSystemName: "play.circle.fill", pointSize: 50)
    
    var timer: Timer?
    var elapsedTime: TimeInterval = 0 // TODO: 나중에 누적시간으로 변경 필요
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    
    var taskData: TaskTable?
    
    // TODO: 나중에 밖으로 빼기
    enum TimeData {
        static let startTimeKey = "startTime"
        static let stopTimeKey = "stopTime"
        static let countingKey = "countingKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonClicked), for: .touchUpInside)
        
        //UserDefaults 저장값 
        startTime = userDefaults.object(forKey: TimeData.startTimeKey) as? Date
        stopTime = userDefaults.object(forKey: TimeData.stopTimeKey) as? Date
        timerCounting = userDefaults.bool(forKey: TimeData.countingKey)
        
        if timerCounting {
            createTimer()
        }
        else {
            cancelTimer()
            if let start = startTime, let stop = stopTime {
                let time = calRestartTime(start: start, stop: stop)
                let diff = Date().timeIntervalSince(time)
                setTimeLabel(Int(diff))
            }
        }
        
    }
    
    override func configure() {
        super.configure()
        view.addSubview(timeLabel)
        view.addSubview(stopButton)
        view.addSubview(startButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        stopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(30)
            make.size.equalTo(55)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stopButton.snp.bottom).offset(30)
            make.size.equalTo(55)
        }
    }
    
    @objc func startButtonClicked() {
        if !timerCounting
        {
            if let stop = stopTime
            {
                let restartTime = calRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }
            
            createTimer()
        }
    
    }
    
    @objc func stopButtonClicked() {
        
        if timerCounting {
            setStopTime(date: Date())
            cancelTimer()
        }
    }
}

extension TimerViewController {
    func calRestartTime(start: Date, stop: Date) -> Date {
        
        let diff = start.timeIntervalSince(stop) // negative value
        return Date().addingTimeInterval(diff)
    }
    
    func setTimeLabel(_ val: Int) {
        let hours = val / 3600
        let minutes = val / 60 % 60
        let seconds = val % 60
        
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


// MARK: - Timer
extension TimerViewController {
    func createTimer() { //startTimer
        if timer == nil {
            let newTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            newTimer.tolerance = 0.1
            RunLoop.current.add(newTimer, forMode: .common) // TODO: 유무에 따른 차이점..? UI와 상호작용하는 동안에도 타이머가 실행됨
            self.timer = newTimer
            
            setTimerCounting(true) // Timer on 상태 저장
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
    
    /*
    func updateTimerOld() {
        guard let timer else { return }
        elapsedTime += timer.timeInterval

        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60

        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    */
    
    func cancelTimer() { //stopTimer
        timer?.invalidate()
        timer = nil
        
        setTimerCounting(false)
    }
    
    //youtube
    func startStopAction() {
        if timerCounting {
            setStopTime(date: Date())
            cancelTimer()
        } else {
            createTimer()
        }
    }
    //
}

// MARK: UserDefaults
extension TimerViewController {
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: TimeData.startTimeKey)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(stopTime, forKey: TimeData.stopTimeKey)
    }
    
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: TimeData.countingKey)
    }
}













