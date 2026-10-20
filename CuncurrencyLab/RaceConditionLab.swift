//
//  RaceConditionLab.swift
//  CuncurrencyLab
//
//  Created by Valeriy Fomin on 20/10/26.
//

import Foundation

final class UnsafeCounter: @unchecked Sendable {
    var value = 0
}

final class SafeCounter: @unchecked Sendable {
    private var value = 0
    private let lock = NSLock()
    
    func increment() {
        lock.lock()
        defer { lock.unlock() }
        
        value += 1
    }
    
    func getValue() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
}

final class RaceConditionLab {
    
    func runUnsafeCounter() {
        let counter = UnsafeCounter()
        let group = DispatchGroup()
        
        for _ in 0..<1000 {
            group.enter()
            
            DispatchQueue.global().async {
                counter.value += 1
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("qqqqq Expected: 1000")
            print("qqqqq Actual: \(counter.value)")
        }
    }
    
    func runSafeCounter() {
        let counter = SafeCounter()
        let group = DispatchGroup()
        
        for _ in 0..<1000 {
            group.enter()
            
            DispatchQueue.global().async {
                counter.increment()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("qqqqq Expected: 1000")
            print("qqqqq Actual: \(counter.getValue())")
        }
        
    }
}

final class SerialCounter: @unchecked Sendable {
    
    private var value = 0
    
    private let queue = DispatchQueue(
        label: "com.concurrencylab.counter"
    )
    
    func increment() {
        queue.sync {
            value += 1
        }
    }
    
    func getValue() -> Int {
        queue.sync {
            value
        }
    }
 }
