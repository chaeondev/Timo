//
//  TimerViewController.swift
//  Timo
//
//  Created by Chaewon on 2023/10/08.
//

import UIKit
import RealmSwift

protocol TimerDelegate: AnyObject {
    func updateTimerTableView()
}

class TimerViewController: BaseViewController {
    
    private lazy var ovalView = CustomOvalView(frame: .zero)
    private lazy var taskTitle = UILabel.labelBuilder(text: "Task title", font: .systemFont(ofSize: 28, weight: .heavy), numberOfLines: 0)
    private lazy var timeLabel = UILabel.labelBuilder(text: "00:00:00", font: .boldSystemFont(ofSize: 48), textColor: Design.BaseColor.mainBackground!, numberOfLines: 1, textAlignment: .center)
    private lazy var stopButton = TimerButton.timerButtonBuilder(imageSystemName: "pause.circle.fill", pointSize: 60)
    
    
    var timer: Timer?
    var elapsedTime: TimeInterval = 0 // TODO: 나중에 누적시간으로 변경 필요
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    
    var projectID: ObjectId?
    var taskData: TaskTable?
    let taskRepository = TaskTableRepository()
    
    var delegate: TimerDelegate?
    
    // TODO: 나중에 밖으로 빼기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        stopButton.addTarget(self, action: #selector(stopButtonClicked), for: .touchUpInside)
        
        guard let taskData else { return }
        taskTitle.text = taskData.title
        
        startTime = taskData.timerStart
        stopTime = taskData.timerStop
        timerCounting = taskData.timerCounting
        
        if timerCounting {
            createTimer()
        } else {
            cancelTimer()
            if let start = startTime, let stop = stopTime {
                let time = calRestartTime(start: start, stop: stop)
                let diff = Date().timeIntervalSince(time)
                setTimeLabel(Int(diff))
            }
            startTimer()
        }
        
    }
    
    override func configure() {
        super.configure()
        view.addSubview(taskTitle)
        view.addSubview(ovalView)
        view.addSubview(timeLabel)
        view.addSubview(stopButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        //taskTitle.backgroundColor = .blue
        taskTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(65)
        }
        
        ovalView.backgroundColor = Design.BaseColor.mainPoint
        ovalView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(taskTitle.snp.bottom)
            make.width.equalTo(350)
            make.height.equalTo(300)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(ovalView)
        }
        
        stopButton.tintColor = Design.BaseColor.mainPoint?.withAlphaComponent(0.5)
        stopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ovalView.snp.bottom).offset(20)
            make.size.equalTo(80)
        }
        
        
    }
    
    func startTimer() {
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
    
    @objc func startButtonClicked() {
        startTimer()
    
    }
    
    @objc func stopButtonClicked() {
        
        if timerCounting {
            //stop 시간 Realm에 업데이트
            setStopTime(date: Date())
            
            //stop시 누적시간 계산해서 Realm에 업데이트
            if let taskData, let start = taskData.timerStart, let stop = taskData.timerStop
            {
                let diff = stop.timeIntervalSince(start) // 누적시간
                taskRepository.updateItem
                {
                    taskData.realTime = Int(diff)
                }
            }

            //Timer invalidate
            cancelTimer()
        }
        delegate?.updateTimerTableView()
        navigationController?.popViewController(animated: true)
    }
}

extension TimerViewController {
    func calRestartTime(start: Date, stop: Date) -> Date {
        
        let diff = stop.timeIntervalSince(start) // 누적시간
        
        if let taskData
        {
            taskRepository.updateItem
            {
                taskData.realTime = Int(diff)
            }
            if let realTime = taskData.realTime
            {
                let timeInterval = TimeInterval(-realTime)
                return Date().addingTimeInterval(timeInterval)
            }
            else
            {
                return Date()
            }
        }
        else
        {
            return Date()
        }

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
            
            setRealmTimerCounting(true) // Timer on 상태 저장
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
    
    func cancelTimer() { //stopTimer
        timer?.invalidate()
        timer = nil
        
        setRealmTimerCounting(false)
    }

}

// MARK: UserDefaults, Realm
extension TimerViewController {
    
    func setStartTime(date: Date?) {
        guard let taskData else { return }
        startTime = date
        taskRepository.updateItem {
            taskData.timerStart = startTime
        }
    }
    
    func setStopTime(date: Date?) {
        guard let taskData else { return }
        stopTime = date
        taskRepository.updateItem {
            taskData.timerStop = stopTime
        }
    }
    func setRealmTimerCounting(_ val: Bool) {
        timerCounting = val
        taskRepository.updateItem {
            taskData?.timerCounting = timerCounting
        }
    }
    
//    func setUserDefaultsTimerCounting(_ val: Bool) {
//        timerCounting = val
//        userDefaults.set(timerCounting, forKey: UserKey.TimeData.countingKey)
//    }
    
    func setProjectID(id: ObjectId?) {
        userDefaults.set(id, forKey: UserKey.TimeData.projectKey)
    }
    
    func setTaskID(task: TaskTable?) {
        guard let task else { return }
        let taskID = task._id
        userDefaults.set(taskID, forKey: UserKey.TimeData.taskKey)
    }
}













