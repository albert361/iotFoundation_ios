//
//  ViewController.swift
//  iotFoundation
//
//  Created by WangAlbert on 2015/8/10.
//  Copyright (c) 2015年 Rab2it. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    private var pageViewController: UIPageViewController?

    private let pages = ["PageItemControlsController",
                         "PageItemConnInfoController"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        
        createPageViewController()
        setupPageControl()
//        
//        let str = "456"
//        switch str {
//        case "123":
//            print("aaaa\r\n")
//            break
//        case "456":
//            print("bbbb\r\n")
//            break
//        default:
//            print("cccc\r\n")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createPageViewController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        pageController.definesPresentationContext = true
        pageController.extendedLayoutIncludesOpaqueBars = false
        pageController.edgesForExtendedLayout = UIRectEdge.None
        pageController.automaticallyAdjustsScrollViewInsets = false
        
        if pages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: Array<UIViewController> = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    /**
     * Get corresponded page by its name
     **/
    private func getItemController(itemIndex: Int) -> PageItemController? {
        if itemIndex < pages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier(pages[itemIndex]) as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.itemName = pages[itemIndex]
//            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
//            pageItemController.itemIndex = itemIndex
//            pageItemController.imageName = pages[itemIndex]
            return pageItemController
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < pages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

