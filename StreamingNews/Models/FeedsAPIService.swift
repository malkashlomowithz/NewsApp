//
//  FeedsAPIService.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//

import Foundation

struct FeedsAPIService {
    
    static let shared = FeedsAPIService()
    
    let baseURL =  "https://api.rss2json.com/v1/api.json?rss_url=https://www.globes.co.il/webservice/rss/rssfeeder.asmx/FeederNode?iID="
    
    func fetchFeeds(for feedType: FeedType) async throws -> NewsResponse {
        let endpoint = feedType.endpoint
        guard let url = URL(string: baseURL + endpoint) else {
            throw NSError(domain: "Invalid URL", code: 1001, userInfo: nil)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
        }
        do {
            let decoder = JSONDecoder()
            let newsResponse = try decoder.decode(NewsResponse.self, from: data)
            return newsResponse
            
        } catch let error {
            throw error
        }
    }
}
