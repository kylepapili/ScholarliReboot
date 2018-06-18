//
//  WelcomePageViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController , UIPageViewControllerDelegate , UIPageViewControllerDataSource {

    lazy var orderedViewControllers : [UIViewController] = {
        return [self.newVc(viewController: "welcomeVcOne") ,
                self.newVc(viewController: "welcomeVcTwo") ,
                self.newVc(viewController: "welcomeVcThree"),
                self.newVc(viewController: "welcomeVcFour"),
                self.newVc(viewController: "welcomeVcFive")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func newVc(viewController : String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

}
