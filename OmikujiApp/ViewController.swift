//
//  ViewController.swift
//  OmikujiApp
//
//  Created by Ngos on 2023/09/02.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // 下の1行を追加。結果を表示したときに音を出すための再生オブジェクトを格納します。
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var stickLabel: UILabel!
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    @IBOutlet weak var stickBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var bigLabel: UILabel!
    
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        // Do any additional setup after loading the view.
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        // If motion is except motion shake
        // Or when display overview
        if motion != UIEvent.EventSubtype.motionShake || overView.isHidden == false {
            // Don't work except shake
            return
        }
        
        let resultNum = Int( arc4random_uniform(UInt32(resultTexts.count)) )
        stickLabel.text = resultTexts[resultNum]
        stickBottomMargin.constant = stickHeight.constant * -1
        
        UIView.animate(withDuration: 1.5, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: { (finished: Bool) in
            //Display same word to big label same as Omikuji label
            self.bigLabel.text = self.stickLabel.text
            // Change overview nodisplay to display
            self.overView.isHidden = false
            // Play sound
            self.resultAudioPlayer.play()
        })
        
    }
    
    
    @IBAction func tapRetryButton(_ sender: Any) {
        overView.isHidden = true
        stickBottomMargin.constant = 0
    }
    
    func setupSound() {
        // if Reading drum mp3 file
        if let sound = Bundle.main.path(forResource: "drum", ofType: "mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            
            resultAudioPlayer.prepareToPlay()
        }
    }
}
