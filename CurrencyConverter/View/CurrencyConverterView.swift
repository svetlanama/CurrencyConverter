//
//  CurrencyConverteView.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 16.11.2022.
//

import SwiftUI

struct ExchangeData {
    var amountToSell: Double = 0.0
    var amountToReceive: Double = 0.0
    var currencyToSell: Currency = Currency.EUR
    var currencyToReceive: Currency = Currency.USD
    
    init(amountToSell: Double  = 0.0, amountToReceive: Double  = 0.0, currencyToSell: Currency, currencyToReceive: Currency) {
        self.amountToSell = amountToSell
        self.amountToReceive = amountToReceive
        self.currencyToSell = currencyToSell
        self.currencyToReceive = currencyToReceive
    }
}

class CurrencyExchangeDataSource: ObservableObject {
    @Published var exchangeData: ExchangeData
    
    init() {
        exchangeData = ExchangeData(currencyToSell: Currency.EUR, currencyToReceive: Currency.USD)
    }
    
    func configure(exchangeData: ExchangeData) {
        self.exchangeData = exchangeData
    }
}

struct CurrencyConverterView: View {
    @ObservedObject var ds = CurrencyExchangeDataSource()
    
    fileprivate let apiService = APIService.sharedInstance
    
    fileprivate var actionPerformed: ((_ amount: Double, _ from: Currency, _ to: Currency) -> Void)
    
    @State var selectedUnits = 0
    
    init(exchangeData: ExchangeData, actionPerformed: @escaping ((_ amount: Double, _ from: Currency, _ to: Currency) -> Void)) {
        self.actionPerformed = actionPerformed
        self.ds.configure(exchangeData: exchangeData)
    }
    
    func amountDataChanged(_ amount: Double) -> Void {
        actionPerformed(amount, ds.exchangeData.currencyToSell, ds.exchangeData.currencyToReceive)
    }
    
    func sellCurrencyChanged(_ amount: Double, _ currency: Currency) -> Void {
        actionPerformed(amount, currency, ds.exchangeData.currencyToReceive)
    }
    
    func receiveCurrencyChanged(_ amount: Double, _ currency: Currency) -> Void {
        actionPerformed(ds.exchangeData.amountToSell, ds.exchangeData.currencyToSell, currency)
    }
    
    var body: some View {
        List {
            Text("CURRENCY EXCHANGE")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets())
            
            
            CurrencyConverterCellView(cellType: CellType.Sell,
                                      amount: ds.exchangeData.amountToSell,
                                      currency: ds.exchangeData.currencyToSell,
                                      actionChanged: sellCurrencyChanged,
                                      amountChanged: amountDataChanged)
            
            CurrencyConverterCellView(cellType: CellType.Receive,
                                      amount: ds.exchangeData.amountToReceive,
                                      currency: ds.exchangeData.currencyToReceive,
                                      actionChanged: receiveCurrencyChanged,
                                      amountChanged: amountDataChanged)
            
        }
        .environment(\.defaultMinListRowHeight, 50)
        .listStyle(.plain)
        .background(.white)
        .padding(0)
    }
}




