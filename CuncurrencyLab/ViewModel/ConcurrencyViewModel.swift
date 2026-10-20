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
    
    // serial queue
    func startSerialTasks() {
        let queue = DispatchQueue(
            label: "com.lab.serial"
        )
        
        for index in 1...3 {
            queue.async {
                print("qqqqq Start serial \(index)")
                Thread.sleep(forTimeInterval: 2)
                print("qqqqq END serial \(index)")
            }
        }
    }
    
    // concurrent queue
    func startConcurrentTasks() {
        let queue = DispatchQueue(
            label: "com.lab.concurrent",
            attributes: .concurrent
        )
        
        for index in 1...3 {
            queue.async {
                print("qqqqq Start concurrent \(index)")
                Thread.sleep(forTimeInterval: 2)
                print("qqqqq END concurrent \(index)")
            }
        }
    }
    
    // concurrent with group
    func startConcurrentWithGroup() {
        let queue = DispatchQueue(
            label: "com.lab.concurrent",
            attributes: .concurrent
        )
        
        let group = DispatchGroup()
        let startTime = Date()
        
        for index in 1...3 {
            group.enter()
            
            queue.async {
                print("qqqqq Start \(index)")
                Thread.sleep(forTimeInterval: 2)
                print("qqqqq End \(index)")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let elapsed = Date().timeIntervalSince(startTime)
            print("qqqqq Total: \(elapsed) seconds")
        }
    }
}
