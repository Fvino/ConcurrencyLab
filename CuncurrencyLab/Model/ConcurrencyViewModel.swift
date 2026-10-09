//
//  ConcurrencyViewModel.swift
//  CuncurrencyLab
//
//  Created by Valeriy Fomin on 08/10/2026.
//

import Observation
import Foundation

@Observable
@MainActor
final class ConcurrencyViewModel {
    
    private(set) var counter = 0
    private(set) var progress = 0
    private(set) var isRuning = false
    
    func incrementCounter() {
        counter += 1
    }
    
    func startBlockWork() {
        guard !isRuning else { return }
        
        isRuning = true
        progress = 0
        
        for step in 1...5 {
            Thread.sleep(forTimeInterval: 1)
            progress = step
        }
        
        isRuning = false
    }
}
