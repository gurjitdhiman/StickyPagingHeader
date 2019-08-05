//
//  MainPageViewController.swift
//  StickyPagingHeader
//
//  Created by gurjit singh on 05/08/19.
//  Copyright © 2019 gurjit singh. All rights reserved.
//

import UIKit

protocol ContainerScrollingDelegate: class {
    func containerScrollViewDidScroll(withHorizontalDifference diff: CGFloat, scrollView: UIScrollView)
    func containerStartBouncingOnTop(scrollView: UIScrollView)
}

protocol MainPageViewControllerDelegate: ContainerScrollingDelegate {
    func mainPage(_ pageVC: MainPageViewController, didUpdatePageIndex index: Int)
    
}

class MainPageViewController: UIPageViewController {
    
    weak var pageViewDelegate: MainPageViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var openedVCs: [UIViewController] = []
    private var numberOfPages = 2
    private var curretPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        _setupInitialPage()
    }
    
    // MARK: - Private Methods
    
    func scrolltoViewContaoller(atPage page: Int) {
        guard let vc = _getViewController(forPageNumer: page) else {
            return
        }
        var direction: UIPageViewController.NavigationDirection = .forward
        if let currentPage = viewControllers?.first?.view.tag, currentPage > page {
            direction = .reverse
        }
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    @objc fileprivate func _setupInitialPage() {
        guard let vc = _getViewController(forPageNumer: 0) else { return }
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    
    /**
     Method to get view controller at perticular page position
     */
    fileprivate func _getViewController(forPageNumer pageNumber: Int)-> UIViewController? {
        guard pageNumber < numberOfPages else {
            return nil
        }
        if let feedsTableVC = openedVCs.filter( { $0.view.tag == pageNumber } ).first {
            return feedsTableVC
        } else if let tableVC = self.storyboard?.instantiateViewController(withIdentifier: "tableView") as? TableViewController {
            tableVC.scrolDelegate = self.pageViewDelegate
            tableVC.view.tag = pageNumber
            curretPage = pageNumber
            openedVCs.append(tableVC)
            return tableVC
        }
        return nil
    }
    
    /**
     Notifies that the current page index was updated.
     */
    fileprivate func _notifyOfNewIndex() {
        if let pageNumber = viewControllers?.first?.view.tag {
            self.pageViewDelegate?.mainPage(self, didUpdatePageIndex: pageNumber)
        }
    }
    
}

// MARK: - UIPageViewControllerDelegate Methods

extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        _notifyOfNewIndex()
    }
}

// MARK: - UIPageViewControllerDataSource Methods

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageNumber = viewController.view.tag
        guard pageNumber > 0 else {
            return nil
        }
        return _getViewController(forPageNumer: pageNumber - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageNumber = viewController.view.tag
        guard pageNumber < numberOfPages - 1 else {
            return nil
        }
        return _getViewController(forPageNumer:pageNumber + 1)
    }
    
    
}
