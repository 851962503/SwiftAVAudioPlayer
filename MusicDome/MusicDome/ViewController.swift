//
//  ViewController.swift
//  MusicDome
//
//  Created by mopucheng on 2018/7/3.
//  Copyright © 2018年 mopucheng. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var isPlay:Bool = true
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }

    func configView() ->  Void {
        view.addSubview(self.playBtn)
        view.addSubview(self.signBtn)
        self.musicName = "笛子声音 - 51铃声馆"
//        self.audioPlayer.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playBtn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        signBtn.frame = CGRect(x: 100, y: 100+50+30, width: 100, height: 50)
    }
    
    lazy var playBtn: UIButton = {
        () -> UIButton in
        let _playBtn = UIButton.init()
        _playBtn.setTitle("播放", for: .normal)
        _playBtn.setTitleColor(UIColor.black, for: .normal)
        _playBtn.backgroundColor = UIColor.red
        _playBtn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        return _playBtn
    }()
    
    lazy var signBtn: UIButton = {
        () -> UIButton in
        let _signBtn = UIButton.init()
        _signBtn.setTitle("保存", for: .normal)
        _signBtn.backgroundColor = UIColor.red
        _signBtn.addTarget(self, action: #selector(signBtnClick), for: .touchUpInside)
        return _signBtn
    }()
    
    
    @objc func playBtnClick() -> Void {
        if self.isPlay {
            self.audioPlayer.pause()
        } else {
            self.audioPlayer.play()
        }
        self.isPlay = !self.isPlay
    }
    
    @objc func signBtnClick() -> Void {
        
        let rang = CMTimeRange.init(start: CMTimeMake(3, 1), end: CMTimeMake(15, 1))
        let path:String? = Bundle.main.path(forResource: "笛子声音 - 51铃声馆", ofType: ".m4r")
        let url:NSURL? = NSURL(fileURLWithPath: path!)
        
        let videoAsset = AVURLAsset(url: url! as URL)
        let exportSession:AVAssetExportSession? = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetAppleM4A)
        let tempFile = self.craetFilePathByFileName() + self.getNowTimeTimestamp()
        exportSession?.outputURL = NSURL(fileURLWithPath: tempFile) as URL
        exportSession?.outputFileType = .m4a
        exportSession?.timeRange = rang
        print(NSHomeDirectory())
        exportSession?.exportAsynchronously(completionHandler: {
            print("成功")
        })
    }
    
    var musicName: String? {
        didSet {
            let filePath: String? = Bundle.main.path(forResource: musicName, ofType: ".m4r")
            
            if filePath != nil {
                let fileUrl = NSURL(fileURLWithPath: filePath!)
                do {
                    audioPlayer = try
                        AVAudioPlayer(contentsOf:fileUrl as URL)
                    audioPlayer?.numberOfLoops = 0
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                }
                catch let error as NSError {
                    print("Could not create audioPlayer:\(error)")
                }
            }
            
        }
    }
    
    func craetFilePathByFileName() -> String {
        
        let pathStr:String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recodPath:String? = pathStr! + "tailorFile"
        return recodPath!
    }
    
    func getNowTimeTimestamp() -> String {
//        let formatter = DateFormatter.init()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        let timeZone = NSTimeZone(name: "Asia/Beijing")
//        formatter.timeZone = timeZone! as TimeZone
//        let datenow = Date()
        let date = NSDate()
        let timeInterval = date.timeIntervalSince1970 * 1000
        let timeSp:String? = "\(timeInterval)"
        
        
        
        return timeSp!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension ViewController : AVAudioPlayerDelegate {
    
}

