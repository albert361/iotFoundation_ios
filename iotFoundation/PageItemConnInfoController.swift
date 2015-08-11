//
//  PageItemConnectionInfoController.swift
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/11.
//  Copyright © 2015年 Rab2it. All rights reserved.
//

import Foundation
import UIKit

class PageItemConnInfoController: PageItemController {
    @IBOutlet weak var uiLabelSSID: UILabel!
    @IBOutlet weak var uiLabelBSSID: UILabel!
    @IBOutlet weak var uiLabelIP: UILabel!
    @IBOutlet weak var uiLabelBrCast: UILabel!
    @IBOutlet weak var uiLabelMask: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ip_dict:NSMutableDictionary = ["ip":"", "mask":"", "brcast":""]
        
        getIPAddress(ip_dict)
        uiLabelIP.text = ip_dict["ip"] as! String
        uiLabelMask.text = ip_dict["mask"] as! String
        uiLabelBrCast.text = ip_dict["brcast"] as! String
        
        let ssidinfo = fetchSSIDInfo()
        if ssidinfo != nil {
            uiLabelSSID.text = ssidinfo["SSID"] as! String
            uiLabelBSSID.text = ssidinfo["BSSID"] as! String
        }
        
    }
}