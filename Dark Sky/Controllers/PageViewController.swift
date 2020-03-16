//
//  PageViewController.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/6/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
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
        sb.pageViewController = self
        Weather.forcast(withLocation: sb.selfLocation)
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

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstVC = pendingViewControllers.first as! ViewController
        let index = firstVC.selfLocation.selfIndex
        self.pageControl.currentPage = index
        Manager.shared.currActiveIndex = index
        firstVC.selfLocation.delegate = firstVC
        firstVC.didUpdateWeather(sender: firstVC.selfLocation)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dataSource = nil
            self.dataSource = self
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
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
}

extension PageViewController: PageViewUpdateDelegate {
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
        setViewControllers([orderedVC[delIndex - 1]], direction: .reverse, animated: true, completion: { _ in
            // Re-enable swipe gesture after the transition
            self.isPagingEnabled = true
        })
    }
}

protocol PageViewUpdateDelegate: AnyObject {
    func didAddUserLocation()
    func didDelUserLocation(delIndex: Int)
}
