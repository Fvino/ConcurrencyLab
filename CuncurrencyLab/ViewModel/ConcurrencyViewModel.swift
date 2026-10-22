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
    private(set) var heavyProgress = 0
    private(set) var isHeavyRunning  = false
    
    private let raceLab = RaceConditionLab()
    
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
    
    // unsafe
    func testUnsafeCounter() {
        raceLab.runUnsafeCounter()
    }
    
    // safe
    func testSafeCounter() {
        raceLab.runSafeCounter()
    }
    
    // serial
    func runSerialCounter() {
        let counter = SerialCounter()
        let group = DispatchGroup()
        
        for _ in 0..<1000 {
            group.enter()
            
            DispatchQueue.global().async {
                counter.increment()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Expected: 1000")
            print("Actual: \(counter.getValue())")
        }
    }
    
    // MARK: - async/await
    
    func startAsyncWork() async {
        guard !isRuning else { return }
        
        isRuning = true
        progress = 0
        
        defer {
            isRuning = false
        }
        
        do {
            for step in 1...5 {
                try await Task.sleep(for: .seconds(1))
                progress = step
            }
        } catch {
            print("Task cancelled: \(error)")
        }
    }
    
    // MARK: - Task cancellation
    
    private var workTask: Task<Void, Never>?
    
    func startCancellableWork() {
        guard !isRuning else { return }
        
        isRuning = true
        progress = 0
        
        workTask = Task { [weak self] in
            guard let self else { return }
            
            defer {
                self.isRuning = false
                self.workTask = nil
            }
            
            do {
                for step in 1...5 {
                    try await Task.sleep(for: .seconds(1))
                    self.progress = step
                }
                print("Task completed")
                
            } catch is CancellationError {
                print("Task cancelled, progress: \(progress)")
                
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func cancelWork() {
        workTask?.cancel()
    }
    
    // MARK: - Yield work
    
    func startYieldWork() async {
        guard !isHeavyRunning else { return }
        
        isHeavyRunning = true
        heavyProgress = 0
        
        defer {
            isHeavyRunning = false
        }
        
        for index in 1...1_000_000 {
            if Task.isCancelled {
                break
            }
            
            if index.isMultiple(of: 10_000) {
                heavyProgress = index
                await Task.yield()
            }
        }
    }
}
