//
//  FeedsVM.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//

import Foundation

protocol FeedsVMDelegate: AnyObject {
    func feedsDidUpdate(items: [NewsItem])
}

protocol FeedsVMDelegateForIndicator: AnyObject {
    func checkIfFetching(isfetching: Bool)
}

class FeedsVM {
    
    var realEstate: [NewsItem] = []
    var homePage: [NewsItem] = []
    var law: [NewsItem] = []
    weak var delegate: FeedsVMDelegate?
    weak var IndicatorDelegate: FeedsVMDelegateForIndicator?
    
    var isfetchingRealEstate: Bool = false {
        didSet {
            IndicatorDelegate?.checkIfFetching(isfetching: isfetchingRealEstate)
        }
    }
    var isFetchingHomePage: Bool = false {
        didSet {
            IndicatorDelegate?.checkIfFetching(isfetching: isFetchingHomePage)
        }
    }
    
    var isfetchingLaw: Bool = false {
        didSet {
            IndicatorDelegate?.checkIfFetching(isfetching: isfetchingLaw)
        }
    }
    
    var isHomePageSelected: Bool = true {
        didSet {
            delegate?.feedsDidUpdate(items: isHomePageSelected ? homePage : law + realEstate)
        }
    }

    func getData(withEndPoint feedType: FeedType) async -> [NewsItem] {
        
        do {
            setDataFetchingState(to: true, for: feedType)
            let data = try await FeedsAPIService.shared.fetchFeeds(for: feedType)
            setDataFetchingState(to: false, for: feedType)
            return data.items
        } catch {
            print("no data")
            return []
        }
    }
    
    
    func startTimers(isFirstTime: Bool) {
        Task { [weak self] in
            await self?.fetchLoop(feedType: .realEstate, delay: isFirstTime ? 0 : 5)
        }
        Task { [weak self] in
            await self?.fetchLoop(feedType: .homePage, delay: isFirstTime ? 0 : 5)
        }
        Task { [weak self] in
            await self?.fetchLoop(feedType: .law, delay: isFirstTime ? 0 : 5)
        }
    }

    private func fetchLoop(feedType: FeedType, delay: UInt64) async {
        var currentDelay = delay
        while true {
            try? await Task.sleep(nanoseconds: currentDelay * 1_000_000_000)
            currentDelay = 5 

            switch feedType {
            case .realEstate:
                realEstate = await getData(withEndPoint: .realEstate)
                if !isHomePageSelected {
                    delegate?.feedsDidUpdate(items: realEstate + law)
                }
            case .homePage:
                homePage = await getData(withEndPoint: .homePage)
                if isHomePageSelected {
                    delegate?.feedsDidUpdate(items: homePage)
                }
            case .law:
                law = await getData(withEndPoint: .law)
                if !isHomePageSelected {
                    delegate?.feedsDidUpdate(items: realEstate + law)
                }
            }
        }
    }
    
    func setDataFetchingState(to isFetching: Bool, for feedType: FeedType) {
        switch feedType {
        case .realEstate:
            isfetchingRealEstate = isFetching
        case .homePage:
            isFetchingHomePage = isFetching
        case .law:
            isfetchingLaw = isFetching
        }
    }
}
