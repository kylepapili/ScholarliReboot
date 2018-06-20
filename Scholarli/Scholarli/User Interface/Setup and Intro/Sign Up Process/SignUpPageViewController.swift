//
//  SignUpPageViewController.swift
//  Scholarli
//
//  Created by Kyle Papili on 6/18/18.
//  Copyright © 2018 Scholarli. All rights reserved.
//

import UIKit

//Global Variables
var newUserData : [String : Any] = [:]

class SignUpPageViewController: UIPageViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate {

    lazy var orderedViewControllers : [UIViewController] = {
        return [self.newVc(viewController: "signUpVcOne") ,
                self.newVc(viewController: "signUpVcTwo") ,
                self.newVc(viewController: "signUpVcThree"),
                self.newVc(viewController: "signUpVcFour"),
                self.newVc(viewController: "signUpVcFive")]
    }()
    
    func newVc(viewController : String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle : nil).instantiateViewController(withIdentifier: viewController)
    }
    
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
