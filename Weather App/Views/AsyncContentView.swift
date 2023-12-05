//
//  AsyncContentView.swift
//  Weather App
//
//  Created by Tim Gunnarsson on 2023-12-05.
//


import Foundation
import SwiftUI

enum ViewState: Equatable {
    case loading
    case completed
    case failure(error: Error)
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.completed, .completed): return true
        case (.loading, .loading): return true
        case (.failure(error: _), .failure(error: _)):
            return true
        default: return false
        }
    }
}

struct AsyncContentView<Content: View>: View {
    
    var viewState: ViewState
    let content: () -> Content
    let onRetry: () -> Void
    
    var body: some View {
        switch viewState {
        case .loading:
            ProgressView()
        case .completed:
            AnyView(content())
        case .failure(let error):
            VStack(spacing: 20) {
                Text(error.localizedDescription)
                Button(action: {
                    onRetry()
                }, label: {
                    Text("Retry")
                })
            }
        }
    }
}

