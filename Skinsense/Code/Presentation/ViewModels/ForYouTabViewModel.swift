//
//  ForYouTabViewModel.swift
//  Skinsense
//
//  Created by Rainer Regan on 14/11/23.
//

import Foundation

class ForYouTabViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var showSearch: Bool = true
    @Published var isLoading: Bool = false
    @Published var searchedProduct: [Product] = []
    @Published var productHistory: [ProductHistory]?
    @Published var scanHistoyry: [ScanHistory]?
    @Published var scanHistoryAnalysisModel: [AnalysisModel]?
    
    private var productRepository: ProductRepository = ProductRepository()
    
    func searchProduct(query: String) {
        self.isLoading = true
        productRepository.searchProduct(query: query) { res in
            switch res {
            case .success(let data):
                self.searchedProduct = data
            case .failure(let failure):
                self.searchedProduct = []
                print(failure)
            }
            self.isLoading = false
        }
    }
    
    func fetchProductHistory() {
        let productHistory = CoreDataManager.shared.fetchProductHistory()
        self.productHistory = productHistory
    }
    
    func fetchScanHistory() {
        let scanHistory = CoreDataManager.shared.fetchScanHistory()
        self.scanHistoyry = scanHistory
        let decoder = JSONDecoder()
        
        do {
            var analysisResultList : [AnalysisModel] = []
            for history in scanHistory {
                guard let data = history.jsonString?.data(using: .utf8) else { continue }
                let result = try decoder.decode(AnalysisModel.self, from: data)
                analysisResultList.append(result)
            }
            
            if !analysisResultList.isEmpty {
                self.scanHistoryAnalysisModel = analysisResultList
            }
        } catch {
            print(error)
        }
    }
    
    func clearProductHistory() {
        if CoreDataManager.shared.clearHistoryData() {
            self.productHistory = nil
        }
    }
}
