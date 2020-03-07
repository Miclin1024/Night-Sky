//
//  PageViewController.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/6/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedVC:[ViewController] = {
        var res: [ViewController] = [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "currentLocation")]
        for i in 1 ..< Manager.shared.userLocations.count {
            res.append(self.newVC(index: i))
        }
        
        return res
    }()
    
    func newVC(index: Int) -> ViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "custom") as! ViewController
        sb.activeLocationIndex = index
        return sb
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstVC = pendingViewControllers.first as! ViewController
        let index = firstVC.activeLocationIndex
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        if let currentVC = orderedVC.first {
            Manager.shared.userLocations[0].delegate = currentVC
            setViewControllers([currentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}
