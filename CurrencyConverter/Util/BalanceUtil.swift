//
//  BalanceUtil.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 21.11.2022.
//

import Foundation

final class BalanceUtil {
    
    static func buildMessage(data:
        (amountToSell: Double,
        amountToReceive: Double,
        calcBalanceSell: (balance: Balance?, amount: Double, commission: Double),
        calcBalanceReceive: (balance: Balance?, amount: Double, commission: Double))
    ) -> String {
        guard let balanceSell = data.calcBalanceSell.balance, let balanceReceive = data.calcBalanceReceive.balance else {
            return ""
        }
        
        let message = "You have converted \(data.amountToSell.format()) \(balanceSell.currency) " +
            " to  \(data.amountToReceive.format())\(balanceReceive.currency). " +
            " Commission Fee - \(data.calcBalanceSell.commission.format()) \(balanceSell.currency)"
        
        return message
    }
}
