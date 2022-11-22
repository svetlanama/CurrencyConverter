//
//  CurrencyBalancesView.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 16.11.2022.
//

import Foundation
import SwiftUI
import UIKit

class CurrencyBalancesDataSource: ObservableObject {
    @Published  var balance: [Balance] = []
    
    init() {
    }
    
    func configure(balance: [Balance]) {
        self.balance = balance
    }
}

struct CurrencyBalancesView: View {
    @ObservedObject var dataSource = CurrencyBalancesDataSource()
    
    init(balance: [Balance] ) {
        dataSource.configure(balance: balance)
    }
    
    var body: some View {
        VStack (spacing: 0) {
            Text("MY BALANCES")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 5) {
                    ForEach(dataSource.balance) { item in
                        Text("\(item.amount.format()) \(item.currency)")
                            .foregroundColor(.black)
                            .font(.headline)
                            .frame(height: 40, alignment: .leading)
                            .padding(.trailing, 50)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
