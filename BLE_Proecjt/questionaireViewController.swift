//
//  questionaireViewController.swift
//  LimbCare
//
//  Created by Bernie on 2017/6/28.
//  Copyright © 2017年 PaulChen. All rights reserved.
//

import UIKit

class questionaireViewController: UIViewController {

    
    var questionArray = ["請問距離您受傷的時間\n大約過了幾小時呢?\n（一天以上用小時制算）","請問患部是否有發紅、腫ˋ漲、發熱嗎？","請問患部在靜止且未作運動時是否仍會感到疼痛呢？","患部在走路運動時是否有緊實及壓迫的感覺呢？"]
    
    var count = 0;
    
    

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func question1(_ sender: Any) {
        
        count += 1
        if(count == 4){
            print("here")
            DispatchQueue.main.async() {
                let alert = UIAlertController(title: "療程健診建議", message: "經過LimbCare系統的計算後，您目前的狀態屬於「急性期」，適合「冰敷」", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "確認", style: .default) { action in
                    self.back()
                })
                self.present(alert, animated: true)
            }

        }
        else{
            titleLabel.text = questionArray[count]
        }
        
        
    }
    @IBAction func checked(_ sender: Any) {
        count += 1
        button1.isHidden = false
        button2.isHidden = false
        textfield.isHidden = true
        checking.isHidden = true
        textfield.text = "2"
        titleLabel.text = questionArray[count]

    }
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var checking: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = questionArray[count]
        button1.isHidden = true
        button2.isHidden = true
        textfield.isHidden = false
        checking.isHidden = false
        let queue = DispatchQueue.global()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    


}
