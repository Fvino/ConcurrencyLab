//
//  ConcurrencyViewModel.swift
//  CuncurrencyLab
//
//  Created by Valeriy Fomin on 08/10/2026.
//

import Observation

@Observable
@MainActor
final class ConcurrencyViewModel {
    
    private(set) var counter = 0
    
    func incrementCounter() {
        counter += 1
    }
}
