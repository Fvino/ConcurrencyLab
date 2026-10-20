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
            print("Step: \(step)")
            print("Main thread: \(Thread.isMainThread)")
            
            Thread.sleep(forTimeInterval: 1)
            progress = step
        }
        
        isRuning = false
    }
    
    func startBackgroundWork() {
        guard !isRuning else { return }
        
        isRuning = true
        progress = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
            for step in 1...5 {
                Thread.sleep(forTimeInterval: 1)
                
                DispatchQueue.main.async {
                    self.progress = step
                }
            }
            
            DispatchQueue.main.async {
                self.isRuning = false
            }
            
        }
    }
    // sync
    func testSync() {
        print("qqqqq start sync")
        DispatchQueue.global().sync {
            print("qqqqq Background START")
            Thread.sleep(forTimeInterval: 2)
            print("qqqqq Background END")
        }
        print("qqqqq END sync")
    }
    
    // async
    func testAsync() {
        print("qqqqq START async")
        DispatchQueue.global().async {
            print("qqqqq Background START")
            Thread.sleep(forTimeInterval: 2)
            print("qqqqq Background END")
        }
        print("qqqqq END async")
    }
}
