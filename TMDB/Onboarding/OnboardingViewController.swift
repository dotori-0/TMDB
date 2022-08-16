//
//  OnboardingViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/16.
//

import UIKit


class OnboardingViewController: UIPageViewController {
    
    // 뷰 컨트롤러 배열
    var pageViewControllers: [UIViewController] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPageViewControllers()
        configurePageViewController()
    }
    
    
    func createPageViewControllers() {
        let sb = UIStoryboard(name: "Onboarding", bundle: nil)
        
        guard let vc1 = sb.instantiateViewController(withIdentifier: FirstViewController.reuseIdentifier) as? FirstViewController else {
            print("Cannot find FirstViewController")
            return
        }
        
        guard let vc2 = sb.instantiateViewController(withIdentifier: SecondViewController.reuseIdentifier) as? SecondViewController else {
            print("Cannot find SecondViewController")
            return
        }
        
        guard let vc3 = sb.instantiateViewController(withIdentifier: ThirdViewController.reuseIdentifier) as? ThirdViewController else {
            print("Cannot find ThirdViewController")
            return
        }
        
        pageViewControllers = [vc1, vc2, vc3]
    }

    
    func configurePageViewController() {
        dataSource = self
//        delegate = self
        
        // display 하고자 하는 뷰를 시작점으로
        guard let first = pageViewControllers.first else { return }
        
        setViewControllers([first], direction: .forward, animated: true)
    }
}


extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 페이지 뷰 컨트롤러에 보이는 뷰컨의 인덱스
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            print("Cannot find the index of the current view controller")
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 현재 페이지 뷰 컨트롤러에 보이는 뷰컨의 인덱스
        guard let viewControllerIndex = pageViewControllers.firstIndex(of: viewController) else {
            print("Cannot find the index of the current view controller")
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllers.count ? nil : pageViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = pageViewControllers.firstIndex(of: first) else { return 0 }
        print("====", index)
        
        return index
    }
}


//extension OnboardingViewController: UIPageViewControllerDelegate {
//
//}
