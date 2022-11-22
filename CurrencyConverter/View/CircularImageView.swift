//
//  CircularImage.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation
import SwiftUI

struct CircularImageView: View {
    var name: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: name)
                .foregroundColor(.white)
        }
        .padding(8)
        .background(color)
        .clipShape(Circle())
    }
}
