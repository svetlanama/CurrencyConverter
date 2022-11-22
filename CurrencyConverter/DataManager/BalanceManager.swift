//
//  BalanceManager.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 14.11.2022.
//

import Foundation

class BalanceManager: ObservableObject {
    
    static let sharedInstance = BalanceManager()
    
    private var balance: [Balance] = []
    private let coreDataManager = CoreDataManager.sharedInstance
    private let commissionManager  = CommissionManager.sharedInstance
    
    private init() {
    }
    
    private let initialBalances = [
        (currency: Currency.EUR, amount: 1000.0),
        (currency: Currency.USD, amount: 0),
        (currency: Currency.JPY, amount: 0),
    ]
 
    func initBalances() async {
        let _balance = await coreDataManager.getBalance()
        guard _balance.count == 0 else {
            self.balance = _balance
            return
        }
        
        await coreDataManager.initBalance(data: initialBalances)
        self.balance = await coreDataManager.getBalance()
    }
    
    func getBalances() async -> [Balance] {
        if balance.count == 0 {
            await initBalances()
        }
        return balance
    }
    
    func calculateExchange(amountTo: Double, currency: String, isSell: Bool) async -> (balance: Balance?, amount: Double, commission: Double) {
        var amount = 0.0
        var commission = 0.0
        let _balance = await coreDataManager.getBalance()
        
        guard _balance.count > 0 else {
            return (nil, amount, commission)
        }
        
        guard amountTo > 0 else {
            return (nil, amountTo, commission)
        }
        
        let balance = _balance.first(where: { $0.currency == currency})
        if(isSell) {
            amount = (balance?.amount ?? 0) - amountTo
            commission = Double(amountTo * self.commissionManager.getCommision()).rounded(toPlaces: 2)
        } else {
            amount = (balance?.amount ?? 0) + amountTo
        }
        
        return (balance: balance, amount: amount, commission: commission)
    }
    
    func exchange(exchangeData: ExchangeData) async throws -> (success: Bool, response: (
        amountToSell: Double,
        amountToReceive: Double,
        calcBalanceSell: (balance: Balance?, amount: Double, commission: Double),
        calcBalanceReceive: (balance: Balance?, amount: Double, commission: Double)
    )) {
        let amountToSell: Double = exchangeData.amountToSell
        let amountToReceive: Double = exchangeData.amountToReceive
        let currencyToSell: String = exchangeData.currencyToSell.sign()
        let currencyToReceive: String = exchangeData.currencyToReceive.sign()
        
        let calcBalanceSell = await calculateExchange(amountTo: amountToSell, currency: currencyToSell, isSell: true)
        let calcBalanceReceive = await calculateExchange(amountTo: amountToReceive, currency: currencyToReceive, isSell: false)
        
        // Validation
        let validation = ValidationUtil.isValidConvertion(sell: calcBalanceSell, receive: calcBalanceReceive)
        guard validation.valid else {
            throw Utils.cutomError(code: 500, message:  validation.message)
        }
        
        // Update DB
        guard let balanceSell = calcBalanceSell.balance, let balanceReceive = calcBalanceReceive.balance else {
            throw Utils.cutomError(code: 500, message: "Some error occurs")
            
        }
        await coreDataManager.updateBalance(balance: balanceSell, amount: calcBalanceSell.amount - calcBalanceSell.commission)
        await coreDataManager.updateBalance(balance: balanceReceive, amount: calcBalanceReceive.amount)
        
        // Commission management
        self.commissionManager.increaseConversionsCount()
        
        return (success: true, response: (
            amountToSell: amountToSell,
            amountToReceive: amountToReceive,
            calcBalanceSell: calcBalanceSell,
            calcBalanceReceive: calcBalanceReceive
        ))
    }
    
}

