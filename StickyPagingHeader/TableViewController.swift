//
//  TableViewController.swift
//  StickyPagingHeader
//
//  Created by gurjit singh on 05/08/19.
//  Copyright © 2019 gurjit singh. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: - Public Access veriables
    
    weak var scrolDelegate: ContainerScrollingDelegate?
    
    // MARK: - Private properties
    
    private var previousContantOffset = CGPoint()
    
    // MARK: - UI Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - View Load handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}

// MARK: - UITableViewDataSource

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Row: \(indexPath.row + 1)"
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension TableViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = scrollView.contentOffset.y - previousContantOffset.y
        previousContantOffset.y = scrollView.contentOffset.y
        self.scrolDelegate?.containerScrollViewDidScroll(withHorizontalDifference: diff, scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let isScrollingDown = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0
        if previousContantOffset.y <= 0 && isScrollingDown {
            scrolDelegate?.containerStartBouncingOnTop(scrollView: scrollView)
        }
    }
}

