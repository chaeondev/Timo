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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonClicked), for: .touchUpInside)
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
        createTimer()
    }
    
    @objc func stopButtonClicked() {
        cancelTimer()
    }
}

// MARK: - Timer
extension TimerViewController {
    func createTimer() {
        if timer == nil {
            let newTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            newTimer.tolerance = 0.1
            RunLoop.current.add(newTimer, forMode: .common) // TODO: 유무에 따른 차이점..? UI와 상호작용하는 동안에도 타이머가 실행됨
            self.timer = newTimer
        }
    }
    
    @objc func updateTimer() {
        
        guard let timer else { return }
        elapsedTime += timer.timeInterval
        
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}
