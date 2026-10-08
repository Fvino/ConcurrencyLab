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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
