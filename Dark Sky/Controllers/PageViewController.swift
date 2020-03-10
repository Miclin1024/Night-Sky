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
    var currentLocationVC: ViewController!
    
    var orderedVC:[ViewController]!
    
    func getOrderedVC() -> [ViewController] {
        var res: [ViewController] = [self.currentLocationVC]
        for i in 1 ..< Manager.shared.userLocations.count {
            res.append(self.newVC(index: i))
        }
        
        return res
    }
    
    func newVC(index: Int) -> ViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "custom") as! ViewController
        sb.selfLocation = Manager.shared.userLocations[index]
        return sb
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedVC.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.lightGray
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstVC = pendingViewControllers.first as! ViewController
        let index = firstVC.selfLocation.selfIndex
        self.pageControl.currentPage = index
        Manager.shared.currActiveIndex = index
        Manager.shared.userLocations[index].delegate = firstVC
        Weather.forcast(withLocation: Manager.shared.userLocations[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        let firstVC = previousViewControllers.first as! ViewController
        let prevIndex = firstVC.selfLocation.selfIndex
        Manager.shared.userLocations[prevIndex].delegate = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dataSource = nil
            self.dataSource = self
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        let currIndex = vc.selfLocation.selfIndex
        if currIndex <= 0 {
            return nil
        } else {
            return orderedVC[currIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ViewController
        let currIndex = vc.selfLocation.selfIndex
        if currIndex >= orderedVC.count - 1 {
            return nil
        } else {
            return orderedVC[currIndex + 1]
        }
    }
    
    func didAddUserLocation() {
        self.orderedVC.append(newVC(index: orderedVC.count))
        self.pageControl.numberOfPages = orderedVC.count
        DispatchQueue.main.async() {
            self.dataSource = nil
            self.dataSource = self
        }
    }
    
    func didDelUserLocation(delIndex: Int) {
        self.orderedVC.remove(at: delIndex)
        Manager.shared.userLocations.remove(at: delIndex)
        Manager.shared.delUserLocation(atIndex: delIndex)
        self.pageControl.numberOfPages = self.orderedVC.count
        setViewControllers([orderedVC[delIndex - 1]], direction: .reverse, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        currentLocationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "currentLocation")
        currentLocationVC.selfLocation = Manager.shared.userLocations[0]
        self.orderedVC = getOrderedVC()
        
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
    func didDelUserLocation(delIndex: Int)
}
