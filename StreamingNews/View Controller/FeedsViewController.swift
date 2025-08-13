//
//  FeedsViewController.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//

import Foundation
import UIKit

class FeedsViewController: UIViewController, FeedsVMDelegate, FeedsVMDelegateForIndicator {

    let viewModel = FeedsVM()
    var feedArray: [NewsItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fetchingIndicator: UIActivityIndicatorView!
    
    @IBAction func newsSegment(_ sender: Any) {
        viewModel.isHomePageSelected.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        initializeDelegatesAndTimers()
    }
    
    func setUpTableView() {
        let nib = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FeedCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func initializeDelegatesAndTimers() {
        viewModel.delegate = self
        viewModel.IndicatorDelegate = self
        viewModel.startTimers(isFirstTime: true)
    }

    func feedsDidUpdate(items: [NewsItem]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.feedArray = items
            self.tableView.reloadData()
        }
    }
    
    func checkIfFetching(isfetching isFetching: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if isFetching {
                self.fetchingIndicator.startAnimating()
            } else {
                self.fetchingIndicator.stopAnimating()
            }
            self.fetchingIndicator.isHidden = !isFetching
        }
    }

}

extension FeedsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.configure(with: feedArray[indexPath.row])
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil) 
         if let descriptionVC = storyboard.instantiateViewController(withIdentifier: "DescriptionVC") as? DescriptionVC {

             descriptionVC.feedItem = feedArray[indexPath.row]
             navigationController?.pushViewController(descriptionVC, animated: true)
         }
         tableView.deselectRow(at: indexPath, animated: true)
     }
}
