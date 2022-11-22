//
//  CurrencyConverterCellView.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation
import SwiftUI

enum CellType: String {
    case Sell = "Sell"
    case Receive  = "Receive"
    
    var title: String { return self.rawValue }
    
    var icon: String {
        switch self {
        case .Sell:
            return "arrow.up"
        case .Receive:
            return "arrow.down"
        }
    }
    
    var color: Color {
        switch self {
        case .Sell:
            return .red
        case .Receive:
            return .green
        }
    }
}

class CurrencyConverterCellViewDataSource: ObservableObject {
    let convertDebouncer = debounce(
        delay: .milliseconds(Constants.debounceDelay),
        action: { (callback: () -> ()) in
            callback()
        })
    
    @Published var currency: Currency = Currency.EUR
    @Published var amount: Double = 0.0  {
        didSet (newValue) {
            if newValue == amount {
                return
            }
            if newValue.toInt() <= 0 {
                return
            }
            convertDebouncer({ [weak self] in
                guard let _self = self else {
                    return
                }
                _self.performActionAmountChanged(_self.amount)
            })
        }
    }
    
    @Published var amountChanged: ((_ amount: Double) -> Void)?
    
    init() { }
    
    
    func configure(amount: Double, currency: Currency, amountChanged:  @escaping ((_ amount: Double) -> Void)) {
        self.amount = amount // .format()
        self.currency = currency
        
        self.amountChanged = amountChanged
    }
    
    func  performActionAmountChanged(_ amount: Double) {
        amountChanged?(amount)
    }
}

struct CurrencyConverterCellView: View  {
    @ObservedObject var ds = CurrencyConverterCellViewDataSource()
    
    private var cellType = CellType.Sell
    private let currencyTypes = [
        Currency.USD,  Currency.EUR, Currency.JPY,
    ]
    
    private var actionChanged: ((_ amount: Double, _ currency: Currency) -> Void)? = nil
    
    
    init(cellType: CellType, amount: Double,
         currency: Currency,
         actionChanged: @escaping ((_ amount: Double, _ currency: Currency) -> Void),
         amountChanged: @escaping ((_ amount: Double) -> Void)) {
        
        self.cellType = cellType
        self.actionChanged = actionChanged
        self.ds.configure(amount: amount, currency: currency, amountChanged: amountChanged)
    }

    var body: some View {
        HStack {
            CircularImageView(name: cellType.icon, color: cellType.color)
            
            Text(cellType.title)
                .font(.callout)
            Spacer()
            
            HStack(alignment: .lastTextBaseline){
                TextField("", value: ($ds.amount), formatter: cellType == CellType.Sell ? FormatterUtil.numberFormatter :  FormatterUtil.numberFormatterSign, onEditingChanged: {_ in
                }, onCommit: {
                    
                })
                .disabled(cellType == CellType.Receive)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundColor(cellType == CellType.Sell ? .black : .green)
                    
                
                Picker("", selection: $ds.currency) {
                    ForEach(currencyTypes, id: \.self) {
                        Text($0.sign())
                    }
                }
                .onChange(of: ds.currency) { item in
                    performActionChanged(ds.amount, item)
                }
                .frame(width: 90, alignment: .trailing)
                .pickerStyle(.menu)
                .accentColor(.black)
                .disabled(false)
                
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
    }
}

extension CurrencyConverterCellView {
    func  performActionChanged(_ amount: Double, _ currency: Currency) {
        actionChanged?(amount, currency)
    }
}


