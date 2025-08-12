//
//  FeedModel.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let feed: Feed
    let items: [NewsItem]
}

struct Feed: Codable {
    let url: String
    let title: String
    let link: String
    let author: String
    let description: String
    let image: String
}

struct NewsItem: Codable {
    let title: String
    let pubDate: String
    let link: String
    let guid: String
    let author: String
    let thumbnail: String
    let description: String
    let content: String
    let enclosure: Enclosure
    let categories: [String]
}

struct Enclosure: Codable {
    let link: String
    let type: String
}

enum FeedType: String {
    case realEstate
    case homePage
    case law
    
    var endpoint: String {
        switch self {
        case .realEstate:
            return "607"
        case .homePage:
            return "2"
        case .law:
            return "829"
        }
    }
}
