//
//  PubAnnotationView.swift
//  PubCrawl
//
//  Created by Jacob Bartlett on 21/03/2025.
//

import SwiftUI

struct PubAnnotationView: View {
    let pub: Pub
    let isSelected: Bool
    
    init(pub: Pub, isSelected: Bool) {
        self.pub = pub
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack {
            badge
            icon
        }
        .scaleEffect(isSelected ? 1.8 : 1)
    }
    
    private var badge: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.9),
                        Color.yellow.opacity(0.7),
                        Color.orange.opacity(0.9),
                        Color.brown.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0.8), .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 1)
            .frame(width: 30, height: 30)
    }
    
    private var icon: some View {
        ZStack {
            mug
                .foregroundColor(.black.opacity(0.4))
                .offset(x: 1, y: 1)
                .blendMode(.overlay)
            
            mug
                .foregroundColor(.white.opacity(0.6))
                .offset(x: -0.5, y: -0.5)
                .blendMode(.overlay)
            
            mug
                .foregroundColor(Color.white.opacity(0.25))
        }
        .offset(x: 1, y: 0.5)
    }
    
    private var mug: some View {
        Image(systemName: "mug")
            .font(.title3)
    }
}

#Preview {
    PubAnnotationView(pub: .init(stop: 1,
                                 pubName: "The Shakespeare",
                                 station: "Victoria",
                                 description: "Nice bardy pub",
                                 address: "London", coordinate: .init()),
                      isSelected: false)
}
