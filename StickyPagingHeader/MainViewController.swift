//
//  MainViewController.swift
//  StickyPagingHeader
//
//  Created by gurjit singh on 05/08/19.
//  Copyright © 2019 gurjit singh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var secmentContainerView: UIView!
    @IBOutlet private weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    // MARK: - Private properties
    
    private var headerHeightWithoutSegment: CGFloat {
        return headerView.frame.size.height - secmentContainerView.frame.size.height
    }
    private var mainPageVC: MainPageViewController?
    
    // MARK: - View Load handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _setUPContainerViews()
    }
    
    // MARK: - Private functions
    
    private func _setUPContainerViews() {
        containerViewHeight.constant = self.mainView.frame.size.height + headerHeightWithoutSegment
        
    }
    
    // MARK: - UI Actions
    
    @IBAction private func segmentControllerDidChangeValue(_ sender: UISegmentedControl) {
        mainPageVC?.scrolltoViewContaoller(atPage: segmentControl.selectedSegmentIndex)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainPageVC = segue.destination as? MainPageViewController {
            self.mainPageVC = mainPageVC
            mainPageVC.pageViewDelegate = self
        }
    }
    
    
}

// MARK: - Main Page View Controller Delegate Methods

extension MainViewController: MainPageViewControllerDelegate {
    func containerScrollViewDidScroll(withHorizontalDifference diff: CGFloat, scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0) ||  (diff < 0 && scrollView.contentOffset.y > 160) {
            return
        }
        var newY = mainScrollView.contentOffset.y + diff
        newY = (newY <= headerHeightWithoutSegment)  ? newY : headerHeightWithoutSegment
        newY = newY > 0 ? newY : 0
        mainScrollView.contentOffset = CGPoint(x: mainScrollView.contentOffset.x, y: newY)
    }
    
    func containerStartBouncingOnTop(scrollView: UIScrollView) {
        mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func mainPage(_ pageVC: MainPageViewController, didUpdatePageIndex index: Int) {
        // Select the tab here
        segmentControl.selectedSegmentIndex = index
    }
    
    
    
}

