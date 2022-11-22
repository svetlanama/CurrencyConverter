//
//  BlueButton.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 21.11.2022.
//

import Foundation
import SwiftUI


struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.leading, 120)
            .padding(.trailing, 120)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color(UIColor(named: .havelockBlueApprox)))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
