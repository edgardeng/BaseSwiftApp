//
//  ViewController.swift
//  BaseSwiftApp
//
//  Created by 邓曦曦 on 16/3/18.
//  Copyright © 2016年 Edgar Deng. All rights reserved.
//

import UIKit

class UIHome: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UIHome,viewDidLoad")
        
        // Do any additional setup after loading the view, typically from a nib.
//        let client = ClientManager();
//        client._AsynGet()
//        client._Get()
    }
    override func viewDidAppear(animated: Bool) {
        
     print("UIHome,viewDidAppear")
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        NSLog("UIHome prepareForSegue - %@", segue.identifier!);
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }


}

