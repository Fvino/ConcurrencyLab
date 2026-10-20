//
//  ContentView.swift
//  CuncurrencyLab
//
//  Created by Valeriy Fomin on 08/10/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ConcurrencyViewModel()
    
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Concurrency Lab")
                .font(.title)
            
            Text("Counter: \(viewModel.counter)")
                .font(.title2)
                .monospacedDigit()
            
            Button("+ counter") {
                viewModel.incrementCounter()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Progress: \(viewModel.progress)")
            
            Button("Start blocking work") {
                viewModel.startBlockWork()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isRuning)
            
            Button("Start background work") {
                viewModel.startBackgroundWork()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isRuning)
            
            Button("Test sync") {
                viewModel.testSync()
            }
            .buttonStyle(.bordered)
            
            Button("Test async") {
                viewModel.testAsync()
            }
            .buttonStyle(.bordered)
            
            Button("Serial Queue") {
                viewModel.startSerialTasks()
            }
            .buttonStyle(.bordered)
            
            Button("Concurrent Queue") {
                viewModel.startConcurrentTasks()
            }
            .buttonStyle(.bordered)
            
            Button("Concurrent Group") {
                viewModel.startConcurrentWithGroup()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
