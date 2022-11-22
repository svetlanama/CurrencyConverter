//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterTests: XCTestCase {
    
    let initialBalances = [
        (currency: Currency.EUR, amount: 1000.0),
        (currency: Currency.USD, amount: 1000.0),
        (currency: Currency.JPY, amount: 1000.0),
    ]
    
    let balances: [[(currency: Currency, amount: Double)]] = [
        [(currency: Currency.EUR, amount: 200.0),
         (currency: Currency.USD, amount: 700.0),
         (currency: Currency.JPY, amount: 800.0)],
        
        [(currency: Currency.EUR, amount: 500.0),
         (currency: Currency.USD, amount: 800.0),
         (currency: Currency.JPY, amount: 200.0)],
        
        [(currency: Currency.EUR, amount: 0.0),
         (currency: Currency.USD, amount: 0.0),
         (currency: Currency.JPY, amount: 0.0)],
    ]

    let exchangeDataArray = [
        ExchangeData(amountToSell: 100.0, amountToReceive: 102.56,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD),
        ExchangeData(amountToSell: 200.0, amountToReceive: 220.0,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD),
        ExchangeData(amountToSell: 100.0, amountToReceive: 14474.0,  currencyToSell: Currency.EUR, currencyToReceive: Currency.JPY),
        ExchangeData(amountToSell: 100.0, amountToReceive: 7.05,  currencyToSell: Currency.JPY, currencyToReceive: Currency.USD),
    ]
    
    let exchangeDataArrayNegative = [
        ExchangeData(amountToSell: 1000.0, amountToReceive: 1006.00,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD),
        ExchangeData(amountToSell: 1000.0, amountToReceive: 956.01,  currencyToSell: Currency.USD, currencyToReceive: Currency.EUR),
        ExchangeData(amountToSell: 1000.0, amountToReceive: 7.05,  currencyToSell: Currency.JPY, currencyToReceive: Currency.USD),
    ]
    
    func setUpWithError() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        await CoreDataManager.sharedInstance.clearAllData()
        SettingsManager.sharedInstance.resetConversionsCount()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    //MARK: MOCK DATA
    func testConvertCurrencyBalance() async throws {
        SettingsManager.sharedInstance.resetConversionsCount()
        
        for exchangeData in exchangeDataArray {
            await CoreDataManager.sharedInstance.clearAllData()
            await CoreDataManager.sharedInstance.initBalance(data: initialBalances)
            let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
            
            let initBalanceSell = initialBalances.first(where: { $0.currency.sign() == result.response.calcBalanceSell.balance?.currency})
            let initBalanceReceive = initialBalances.first(where: { $0.currency.sign() == result.response.calcBalanceReceive.balance?.currency})
            
            XCTAssertEqual(result.response.calcBalanceSell.balance?.amount, initBalanceSell!.amount - result.response.amountToSell - result.response.calcBalanceSell.commission)
            XCTAssertEqual(result.response.calcBalanceReceive.balance?.amount, initBalanceReceive!.amount + result.response.amountToReceive)
        }
    }
    
    func testConvertCurrencyNegativeBalance() async throws {
        SettingsManager.sharedInstance.resetConversionsCount()
        
        for exchangeData in exchangeDataArrayNegative {
            await CoreDataManager.sharedInstance.clearAllData()
            await CoreDataManager.sharedInstance.initBalance(data: initialBalances)
            
            do {
                _ = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
            } catch {
                XCTAssertEqual(error.localizedDescription, "Balance can't be negative after conversion.")
            }
        }
    }
    
    func testConvertCurrencyBalanceWithCommission() async throws {
        SettingsManager.sharedInstance.updateConversionsCount(count: 6)
        
        for exchangeData in exchangeDataArray {
            await CoreDataManager.sharedInstance.clearAllData()
            await CoreDataManager.sharedInstance.initBalance(data: initialBalances)
            let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
            
            let initBalanceSell = initialBalances.first(where: { $0.currency.sign() == result.response.calcBalanceSell.balance?.currency})
            let initBalanceReceive = initialBalances.first(where: { $0.currency.sign() == result.response.calcBalanceReceive.balance?.currency})
            
            XCTAssertEqual(result.response.calcBalanceSell.balance?.amount, initBalanceSell!.amount - result.response.amountToSell - result.response.calcBalanceSell.commission)
            XCTAssertEqual(result.response.calcBalanceReceive.balance?.amount, initBalanceReceive!.amount + result.response.amountToReceive)
        }
    }
    
    
    func testConvertCurrencyBalances() async throws {
        SettingsManager.sharedInstance.resetConversionsCount()
        
        for balance in balances {
            for exchangeData in exchangeDataArray {
                await CoreDataManager.sharedInstance.clearAllData()
                await CoreDataManager.sharedInstance.initBalance(data: balance)
               
                do {
                    let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
                    
                    let initBalanceSell = balance.first(where: { $0.currency.sign() == result.response.calcBalanceSell.balance?.currency})
                    let initBalanceReceive = balance.first(where: { $0.currency.sign() == result.response.calcBalanceReceive.balance?.currency})
                    
                    XCTAssertEqual(result.response.calcBalanceSell.balance?.amount, initBalanceSell!.amount - result.response.amountToSell - result.response.calcBalanceSell.commission)
                    XCTAssertEqual(result.response.calcBalanceReceive.balance?.amount, initBalanceReceive!.amount + result.response.amountToReceive)
                } catch {
                    XCTAssertEqual(error.localizedDescription, "Balance can't be negative after conversion.")
                }
            }
        }
    }
 
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testConvertCurrencyWithNoData() async throws {
        let exchangeData: ExchangeData = ExchangeData(amountToSell: 0.0, amountToReceive: 0.0,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD)
        do {
            _ = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
        } catch {
            XCTAssertEqual(error.localizedDescription, "Please enter exchange values.")
        }
    }
    
    func testConvertCurrencyWithSameCurrencies() async throws {
        let exchangeData: ExchangeData = ExchangeData(amountToSell: 100.0, amountToReceive: 100.0,  currencyToSell: Currency.EUR, currencyToReceive: Currency.EUR)
        do {
            _ = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
        } catch {
            XCTAssertEqual(error.localizedDescription, "Exchange currencies should not be equal.")
        }
    }
    
    func testConvertCurrencyCommissionFree() async throws {
        SettingsManager.sharedInstance.resetConversionsCount()
        let exchangeData: ExchangeData = ExchangeData(amountToSell: 100.0, amountToReceive: 102.56,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD)
        
        let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
        XCTAssertEqual(result.response.calcBalanceSell.commission, 0.0)
        
    }
    
    func testConvertCurrencyWithCommission() async throws {
        SettingsManager.sharedInstance.updateConversionsCount(count: 6)
        let exchangeData: ExchangeData = ExchangeData(amountToSell: 100.0, amountToReceive: 102.56,  currencyToSell: Currency.EUR, currencyToReceive: Currency.USD)
        
        let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
        XCTAssertEqual(result.response.calcBalanceSell.commission, 0.70)
        
    }
}
