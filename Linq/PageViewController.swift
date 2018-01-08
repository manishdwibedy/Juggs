//
//  PageViewController.swift
//  Linq
//
//  Created by Quinton Askew on 9/13/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    
    
    let walkThroughImages = ["WTS", "WTF", "WTD", "WTW", "WTB", "WTP"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let startVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }

  

    
    // MARK: - Navigation

     func nextPageWithIndex()
     {
//        let pageContentViewController = self.viewControllerAtIndex(5)
        let startVC = self.viewControllerAtIndex(index: 5)
        self.setViewControllers([startVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
     }
     
     func viewControllerAtIndex(index: Int) -> WalkThrough?
     {
        
        if index == NSNotFound || index < 0 || index >= self.walkThroughImages.count {
            return nil
        }
        
        if let walkThruVC = storyboard?.instantiateViewController(withIdentifier: "WalkThroughViewController") as? WalkThrough {
            walkThruVC.imageName = walkThroughImages[index]
            walkThruVC.index = index
            
            return walkThruVC
        }
        
        return nil
     }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

    // MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkThrough).index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkThrough).index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
}
