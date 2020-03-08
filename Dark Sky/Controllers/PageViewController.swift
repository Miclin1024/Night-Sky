//
//  PageViewController.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/6/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, pageViewUpdateDelegate {
    
    var pageControl = UIPageControl()
    
    var orderedVC:[ViewController] {
        get {
            var res: [ViewController] = [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "currentLocation")]
            for i in 1 ..< Manager.shared.userLocations.count {
                res.append(self.newVC(index: i))
            }
            
            return res
        }
    }
    
    func newVC(index: Int) -> ViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "custom") as! ViewController
        sb.activeLocationIndex = index
        return sb
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedVC.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.lightGray
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstVC = pendingViewControllers.first as! ViewController
        let index = firstVC.activeLocationIndex
        self.pageControl.currentPage = index
        Manager.shared.currActiveIndex = index
        Manager.shared.userLocations[index].delegate = firstVC
        Weather.forcast(withLocation: Manager.shared.userLocations[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let firstVC = previousViewControllers.first as! ViewController
        let prevIndex = firstVC.activeLocationIndex
        Manager.shared.userLocations[prevIndex].delegate = nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if Manager.shared.currActiveIndex <= 0 {
            return nil
        } else {
            return orderedVC[Manager.shared.currActiveIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if Manager.shared.currActiveIndex >= orderedVC.count - 1 {
            return nil
        } else {
            return orderedVC[Manager.shared.currActiveIndex + 1]
        }
    }
    
    func didAddUserLocation() {
        self.pageControl.numberOfPages = orderedVC.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        Manager.shared.delegate = self
        configurePageControl()
        if let currentVC = orderedVC.first {
            Manager.shared.userLocations[0].delegate = currentVC
            setViewControllers([currentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

protocol pageViewUpdateDelegate: AnyObject {
    func didAddUserLocation()
}
