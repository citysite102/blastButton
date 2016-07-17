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
        
        let button = blastButton.init(frame: CGRectMake(100, 100, 60, 60));
        self.view.addSubview(button);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

