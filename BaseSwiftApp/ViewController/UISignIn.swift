//
//  BSSignInViewController.swift
//  BaseSwiftApp
//
//  Created by 邓曦曦 on 16/4/12.
//  Copyright © 2016年 Edgar Deng. All rights reserved.
//

import UIKit

class UISignIn: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func exit(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(" -- exit -- ");
        print(segue)
        print(sender)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}