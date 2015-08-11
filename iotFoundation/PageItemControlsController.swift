//
//  PageItemControlsController.swift
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/11.
//  Copyright © 2015年 Rab2it. All rights reserved.
//

import Foundation
import UIKit

class PageItemControlsController: PageItemController {
    
    @IBOutlet weak var uiButtonOn: UIButton!
    @IBOutlet weak var uiButtonOff: UIButton!
    var brcast: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiButtonOn.backgroundColor = UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1)
        uiButtonOff.backgroundColor = UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1)
        var ip_dict:NSMutableDictionary = ["ip":"", "mask":"", "brcast":""]
        getIPAddress(ip_dict)
        brcast = ip_dict["brcast"] as! String
    }
    
    @IBAction func uiButtonOn(sender: AnyObject) {
        self.sendCommand("on", ui: sender as! UIButton)
    }
    
    @IBAction func uiButtonOff(sender: AnyObject) {
        self.sendCommand("off", ui: sender as! UIButton)
    }

    private func sendCommand(cmd: String, ui: UIButton)
    {
        ui.enabled = false
        sendUDPCommand(cmd, address: brcast)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var waitSeconds: Int = 3
            while (self.isUDPCommandFinished() != true) {
                sleep(1)
                waitSeconds--
                if (waitSeconds == 0) {
                    dispatch_async(dispatch_get_main_queue()) {
                        ui.backgroundColor = UIColor(red: 255.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1)
                        ui.enabled = true
                    }
                    return
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                ui.enabled = true
                ui.backgroundColor = UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1)
            }
        })
        
    }
}