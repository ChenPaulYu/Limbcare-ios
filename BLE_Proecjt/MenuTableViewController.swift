//
//  MenuTableViewController.swift
//  LimbCare
//
//  Created by Bernie on 2017/6/28.
//  Copyright © 2017年 PaulChen. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var timer: Timer?


    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.rowHeight = UITableViewAutomaticDimension //隨著文章字數調變tableView高度
//        self.tableView.estimatedRowHeight = 20 //預設tableView的高度
        self.tableView.rowHeight = 150;
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        cell.describe.sizeToFit()
        cell.describe.numberOfLines = 0;
        if(indexPath.row == 0){
            cell.title.text = "療程"
            cell.describe.text = "冷熱敷療程，含冷敷、熱敷、冷熱交替療程"
            cell.titleImage.image = UIImage(named:"care.jpg")
        }else if (indexPath.row == 1){
            cell.title.text = "建議療程"
            cell.describe.text = "透過簡單六個問題，定義自己的腳踝受傷程度"
            cell.titleImage.image = UIImage(named:"suggest.jpg")
        }
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if(indexPath.row == 0){
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }else if (indexPath.row == 1){
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "questionaireViewController") as! questionaireViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
    }
    


}
