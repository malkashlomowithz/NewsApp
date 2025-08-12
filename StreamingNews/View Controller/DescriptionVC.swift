//
//  DescriptionVC.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//

import Foundation
import UIKit

class DescriptionVC: UIViewController {
    
    var feedItem: NewsItem? = nil
    
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var pubDate: UILabel!
    @IBOutlet weak var allInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LastFeedState.shared.lastFeed = feedItem?.title
    }
    
    func setUpView() {
        guard let item = feedItem else { return }
        newsTitle.text = item.title
        author.text = item.author
        pubDate.text = item.pubDate
        allInfo.text = item.description
        
        if let thumbnailURL = URL(string: item.enclosure.link) {
            newsImage.kf.setImage(
                with: thumbnailURL,
                placeholder: UIImage(systemName: "photo.fill"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            newsImage.image = UIImage(systemName: "photo.fill")
        }
    }
    
}
