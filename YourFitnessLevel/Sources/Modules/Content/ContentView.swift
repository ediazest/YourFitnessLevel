//
//  ContentView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var state = ContentViewState()

    init() {
        UITabBar.appearance().barTintColor = UIColor.black
    }

    var body: some View {
        TabView {
            summaryTab
            awardsTab
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
        .onAppear(perform: state.handleOnAppear)
    }

    private var summaryTab: some View {
        SummaryView()
            .tabItem {
                Label("Today", image: "iconRunning")
            }
    }

    private var awardsTab: some View {
        AwardsView()
            .tabItem {
                Label("Your Awards", image: "iconAward")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
