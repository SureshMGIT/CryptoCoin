//
//  ViewModelTests.swift
//  CryptoCoinTests
//
//  Created by Suresh M on 01/12/24.
//

import XCTest
@testable import CryptoCoin

final class ViewModelTests: XCTestCase {
    
    var viewModel: ViewModel!
    var mockDelegate: MockViewModelDelegate!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDelegate = MockViewModelDelegate()
        mockNetworkManager = MockNetworkManager()
        viewModel = ViewModel(delegate: mockDelegate, networManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockDelegate = nil
        mockNetworkManager = nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testFetchCoinsSuccess() {
        let mockCoins = [
            CoinModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
            CoinModel(name: "Ethereum", symbol: "ETH", isNew: true, isActive: false, type: .token)
        ]
        mockNetworkManager.mockResult = .success(mockCoins)
        
        viewModel.fetchCoins()
        
        XCTAssertGreaterThan(viewModel.coinList.count, 0)
        XCTAssertGreaterThan(viewModel.currentCoinList.count, 0)
        XCTAssertGreaterThan(viewModel.listFilter.count, 0)
        XCTAssertTrue(mockDelegate.coinListFetchedSuccessCalled)
    }
    
    func testFetchCoinsFailure() {
        mockNetworkManager.mockResult = .failure(.error("Network error"))
        
        viewModel.fetchCoins()
        
        XCTAssertFalse(mockDelegate.coinListFetchedSuccessCalled)
        XCTAssertTrue(mockDelegate.coinListFetchedFailCalled)
    }
    
    func testUpdateFilterSelectionTogglesFilter() {
        XCTAssertTrue(viewModel.coinFilterArray[0].isSelected)
        
        viewModel.updateFilterSelection(selectedIndex: 0)
        
        XCTAssertFalse(viewModel.coinFilterArray[0].isSelected)
    }
    
    func testCreateCoinListForFilterFiltersActiveCoins() {
        viewModel.coinList = [
            CoinModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
            CoinModel(name: "Ethereum", symbol: "ETH", isNew: false, isActive: false, type: .token)
        ]
        viewModel.coinFilterArray[0].isSelected = true
        
        viewModel.createCoinListForFilter()
        
        XCTAssertEqual(viewModel.currentCoinList.count, 2)
        XCTAssertEqual(viewModel.currentCoinList.first?.name, "Bitcoin")
    }
    
    func testFilterListForSearchFiltersByName() {
        viewModel.listFilter = [
            CoinModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
            CoinModel(name: "Ethereum", symbol: "ETH", isNew: false, isActive: false, type: .token)
        ]
        
        viewModel.filterListForSearch(text: "bit")
        
        XCTAssertEqual(viewModel.currentCoinList.count, 1)
        XCTAssertEqual(viewModel.currentCoinList.first?.name, "Bitcoin")
    }
    
    func testFilterListForSearchEmptyTextReturnsAll() {
        let mockCoins = [
            CoinModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
            CoinModel(name: "Ethereum", symbol: "ETH", isNew: false, isActive: false, type: .token)
        ]
        viewModel.coinList = mockCoins
        
        viewModel.filterListForSearch(text: "")
        
        XCTAssertEqual(viewModel.currentCoinList.count, 0)
    }
}

final class MockViewModelDelegate: ViewModelDelegate {
    var coinListFetchedSuccessCalled = false
    var coinListFetchedFailCalled = false
    
    func coinListFetchedSuccess(list: [CoinModel]) {
        coinListFetchedSuccessCalled = true
    }
    
    func coinListFetchedFail(error: String) {
        coinListFetchedFailCalled = true
    }
    
    func updateList() {}
}

final class MockNetworkManager: NetworkManagerProtocol {
    var mockResult: Result<[CoinModel], NetworkError>?
    
    func fetchCoins(completionHandler: @escaping (Result<[CoinModel], NetworkError>) -> Void) {
        if let result = mockResult {
            completionHandler(result)
        }
    }
}
