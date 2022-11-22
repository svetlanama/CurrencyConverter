//
//  TimeInterval+Extension.swift
//  CurrencyConverter
//
//  Created by Svitlana Moiseyenko on 20.11.2022.
//

import Foundation

func debounce<T>(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
    var currentWorkItem: DispatchWorkItem?
    return { (p1: T) in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action(p1) }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}
