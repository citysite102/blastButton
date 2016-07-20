//
//  ViewController.swift
//  blastButton_s
//
//  Created by YU CHONKAO on 2016/7/15.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 237/255, alpha: 1.0);
        let button = submitButton.init(frame: CGRectMake(100, 100, 160, 60));
        button.addTarget(self, action: #selector(ViewController.test));
        self.view.addSubview(button);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func test() {
        print("GGWP");
    }


}

