//
//  ContentView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var state = ContentViewState()

    var body: some View {
        TabView {
            summaryTab
            awardsTab
        }
        .onAppear(perform: state.handleOnAppear)
    }

    private var summaryTab: some View {
        SummaryView()
            .tabItem {
                Label("Summary", systemImage: "list.dash")
            }
    }

    private var awardsTab: some View {
        Text("Hello, world!")
            .padding()
            .tabItem {
                Label("Your Awards", systemImage: "list.dash")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
