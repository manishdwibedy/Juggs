//
//  MyPageView.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class MyPageView: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    
    lazy var bioAndMyJuggs: [UIViewController] = {
        
        return [self.ViewControllerInstance(name: "MyBio"),
                self.ViewControllerInstance(name: "MyJuggTable")]
    }()
    
    
    private func ViewControllerInstance(name: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        loadBioViewController()
        
    }
    
    func loadBioViewController() {
        
        if let bioVC = bioAndMyJuggs.first {
            setViewControllers([bioVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = bioAndMyJuggs.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return bioAndMyJuggs.last
        }
        
        guard bioAndMyJuggs.count > previousIndex else {
            return nil
        }
        
        return bioAndMyJuggs[previousIndex]
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = bioAndMyJuggs.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < bioAndMyJuggs.count else {
            return bioAndMyJuggs.first
        }
        
        guard bioAndMyJuggs.count > nextIndex else {
            return nil
        }
        
        return bioAndMyJuggs[nextIndex]
    }
    
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return bioAndMyJuggs.count
    }
    
    public  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first, let vcIndex = bioAndMyJuggs.index(of: firstVC) else {
            return 0
        }
        return vcIndex
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


