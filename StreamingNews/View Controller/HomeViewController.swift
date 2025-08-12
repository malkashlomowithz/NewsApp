//
//  HomeViewController.swift
//  StreamingNews
//
//  Created by Malky on 10/08/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lasrFeedViewed: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        timeLabel.text = getTime()
        lasrFeedViewed.text = LastFeedState.shared.lastFeed ?? "No feed viewed"
    }
    
    
    func getTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  
        return formatter.string(from: date)
    }
}


