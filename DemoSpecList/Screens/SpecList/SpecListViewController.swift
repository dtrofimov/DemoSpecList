//
//  SpecListViewController.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import UIKit

typealias SpecListTableViewCell = UITableViewCell

class SpecListViewController: UIViewController {
    var docDocApiClient: DocDocApiClient!
    
    @IBOutlet private var cannotLoadBannerLabel: UILabel!
    @IBOutlet private var cannotLoadBannerContainer: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var placeholderScrollView: UIScrollView!
    @IBOutlet private var placeholderLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var tableRefreshControl: UIRefreshControl!
    private var placeholderRefreshControl: UIRefreshControl!
    fileprivate var request: GetSpecsRequest?
    fileprivate var specs: [Spec]?
    fileprivate var cannotLoad = false
    fileprivate var timerToHideCannotLoadBanner: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Specialities", comment: "")
        
        self.setupCannotLoadBanner()
        self.setupRefreshControls()
        self.setupTableView()
        self.updateView(animated: false)
    }
    
    private func setupCannotLoadBanner() {
        self.cannotLoadBannerLabel.text = NSLocalizedString("Cannot load specialities. Please, check your internet connection or try again later.", comment: "")
        self.cannotLoadBannerLabel.layoutIfNeeded()
    }
    
    private func setupRefreshControls() {
        self.tableRefreshControl = UIRefreshControl()
        self.tableRefreshControl.addTarget(self, action: #selector(pullToRefreshDidHappen), for: .valueChanged)
        self.tableView.insertSubview(self.tableRefreshControl, at: 0)
        
        self.placeholderRefreshControl = UIRefreshControl()
        self.placeholderRefreshControl.addTarget(self, action: #selector(pullToRefreshDidHappen), for: .valueChanged)
        self.placeholderScrollView.insertSubview(self.placeholderRefreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.specs == nil) {
            self.startLoading(forced: false)
        }
    }
    
    fileprivate func updateView(animated: Bool = true, reload: Bool = true) {
        enum ContentType {
            case none // before opening, anything is hidden
            case someSpecs
            case emptySpecs
            case cannotLoad
            case loading
        }
        let contentType: ContentType = {
            if let specs = self.specs {
                return specs.count > 0 ? .someSpecs : .emptySpecs
            } else {
                return self.cannotLoad ? .cannotLoad :
                    self.request != nil ? .loading :
                    .none
            }
        }()
        let showRefreshControl = self.request != nil && contentType != .loading
        let showPlaceholderScrollView = contentType != .someSpecs
        let showCannotLoadBanner = self.cannotLoad && contentType != .cannotLoad
        
        func updateBanner() {
            self.cannotLoadBannerContainer.alpha = showCannotLoadBanner ? 1 : 0
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: updateBanner)
        } else {
            updateBanner()
        }
        self.tableView.isHidden = contentType != .someSpecs
        if (contentType == .someSpecs && reload) {
            self.tableView.reloadData()
        }
        self.placeholderScrollView.isHidden = !showPlaceholderScrollView
        self.activityIndicator.isHidden = contentType != .loading
        for refreshControl: UIRefreshControl in [self.tableRefreshControl, self.placeholderRefreshControl] {
            if refreshControl.isRefreshing != showRefreshControl {
                if showRefreshControl {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
            }
        }
        let placeholderText: String? = {
            switch contentType {
            case .emptySpecs: return NSLocalizedString("There're no specialities", comment: "")
            case .cannotLoad: return self.cannotLoadBannerLabel.text
            default: return nil
            }
        }()
        self.placeholderLabel.text = placeholderText
    }
    
    fileprivate func fillTableViewCell(cell: SpecListTableViewCell, spec: Spec) {
        cell.textLabel?.text = spec.name
    }
}

// MARK: - Controller methods

extension SpecListViewController {
    @objc fileprivate func pullToRefreshDidHappen() {
        self.startLoading(forced: true)
    }
    
    fileprivate func startLoading(forced: Bool) {
        if self.request != nil { return }
        if self.specs != nil && !forced { return }
        
        let request = GetSpecsRequest()
        request.docDocApiClient = self.docDocApiClient
        request.useCache = !forced
        self.request = request
        request.perform { (result, urlResponse) in
            self.request = nil
            let success = result.value != nil
            self.cannotLoad = !success
            if let specs = result.value {
                self.specs = specs
            }
            self.updateView(reload: success)
            self.resetTimerToHideCannotLoadBanner()
        }
        self.updateView(reload: false)
    }
    
    private func resetTimerToHideCannotLoadBanner() {
        if let timer = self.timerToHideCannotLoadBanner {
            timer.invalidate()
            self.timerToHideCannotLoadBanner = nil
        }
        guard self.cannotLoad else { return }
        self.timerToHideCannotLoadBanner = Timer.scheduledTimer(withTimeInterval: Constants.CannotLoadBanner.duration, repeats: false) { (timer) in
            if (self.specs != nil) {
                self.cannotLoad = false
                self.updateView(reload: false)
            }
        }
    }
}

// MARK: - TableView controller methods

extension SpecListViewController: UITableViewDataSource {
    private static let cellReuseId = "cell"
    
    fileprivate func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: SpecListViewController.cellReuseId)
        self.tableView.tableFooterView = UIView() // to prevent odd separators
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let specs = self.specs else { return 0 }
        return specs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SpecListViewController.cellReuseId)! as SpecListTableViewCell
        self.fillTableViewCell(cell: cell, spec: self.specs![indexPath.row])
        return cell
    }
}
