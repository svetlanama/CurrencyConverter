//
//  AppRootView.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 13.11.2022.
//

import SwiftUI

struct AppRootView: View {
    
    var body: some View {
        return AnyView(CurrencyConverterControllerView())
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
