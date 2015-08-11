//
//  PageItemController.swift
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/11.
//  Copyright © 2015年 Rab2it. All rights reserved.
//

import Foundation
import UIKit

class PageItemController : UITableViewController {
    // MARK: - Variables
    var itemIndex: Int = 0 // ***
    var itemName: String = ""
//    var imageName: String = "" {
//        didSet {
//            if let imageView = contentImageView {
//                imageView.image = UIImage(named: imageName)
//            }
//        }
//    }
    
//    @IBOutlet var contentImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        contentImageView!.image = UIImage(named: imageName)
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
    }
}