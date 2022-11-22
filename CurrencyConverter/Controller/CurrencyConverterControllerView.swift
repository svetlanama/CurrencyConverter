//
//  CurrencyConverterView.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import Foundation
import SwiftUI
import UIKit

class CurrencyConverterControllerViewDataSource: ObservableObject {
    
    @Published var balance: [Balance] = []
    
    init() {
        Task { [weak self] in
            await self?.populateBalance()
        }
    }
    
    func populateBalance() async {
        let _balance = await BalanceManager.sharedInstance.getBalances()
        DispatchQueue.main.async { [weak self] in
            self?.balance = _balance
        }
    }
    
    func update(exchangeData: ExchangeData) async throws -> (success: Bool, response: (
        amountToSell: Double,
        amountToReceive: Double,
        calcBalanceSell: (balance: Balance?, amount: Double, commission: Double),
        calcBalanceReceive: (balance: Balance?, amount: Double, commission: Double)
    )) {
        do {
            let result = try await BalanceManager.sharedInstance.exchange(exchangeData: exchangeData)
            
            await populateBalance()
            return result
        } catch{
            throw error
        }
    }
}

struct CurrencyConverterControllerView: View {
    fileprivate let apiService = APIService.sharedInstance
    
    @ObservedObject var dataSource = CurrencyConverterControllerViewDataSource()
    @State fileprivate var exchangeData: ExchangeData
    
    init() {
        self.exchangeData = ExchangeData(amountToSell: 0.0, amountToReceive: 0.0, currencyToSell: Currency.EUR, currencyToReceive: Currency.USD)
    }
    
    var body: some View {
        NavigationView {
            List {
                CurrencyBalancesView(balance: dataSource.balance)
                    .listRowSeparator(.hidden)
                
                CurrencyConverterView(exchangeData: exchangeData, actionPerformed: changeCurrency)
                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .leading)
                    .listRowSeparator(.hidden)
         
                
                HStack {
                    Button("SUBMIT") {
                        Task {
                            await save()
                        }
                    }
                    .buttonStyle(BlueButton())
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .listRowSeparator(.hidden)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .listStyle(.plain)
            .navigationBarTitle("Currency converter", displayMode: .inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color(UIColor(named: .havelockBlueApprox)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

extension CurrencyConverterControllerView {
    func changeCurrency(_ amount: Double, _ from: Currency, _ to: Currency) -> Void {
        Task {
            await startExchange(amount: amount, from: from, to: to)
        }
    }
    
    func startExchange(amount: Double, from: Currency, to: Currency) async -> Void {
        if let data = await apiService.exchange(amount: amount, from: from.sign(), to: to.sign()) as? ConvertCurrencyResponse {
            self.exchangeData = ExchangeData(amountToSell: amount, amountToReceive: data.amount.toDouble(), currencyToSell: from, currencyToReceive: to)
            print("Exchange res: ", data)
        }
    }
    
    func save() async -> Void {
        Task {
            do {
                let result = try await dataSource.update(exchangeData: self.exchangeData)
                let message = BalanceUtil.buildMessage(data: result.response)
                self.displayStandardAlert(title: "Currency converted", message: message)
            } catch {
                self.displayStandardAlert( title: "Error", message: error.localizedDescription)
            }
        }
    }
}
