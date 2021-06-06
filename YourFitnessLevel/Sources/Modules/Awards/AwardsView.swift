//
//  AwardsView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Foundation
import SwiftUI

struct AwardsView: View {
    @StateObject var state: AwardsViewState = AwardsViewState()
    @State var points: Int = 0

    init(state: AwardsViewState = AwardsViewState()) {
        _state = StateObject(wrappedValue: state)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 30) {
                        header
                        medals
                    }
                }
            }
            .navigationTitle("Your Awards")
            .toolbar(content: { helpButton })
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all), alignment: .center)
        }
        .onReceive(state.$viewData, perform: animateChanges)
        .accentColor(.white)
        .foregroundColor(.white)
        .sheet(isPresented: $state.presentHelp) {
            HelpView()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 30) {

            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text("\(points)")
                    .modifier(NumberView(number: points))
                    .font(.system(size: 50, weight: .light, design: .default))
                    .foregroundColor(.white)

                Text("points")
                    .bold()
                    .font(.system(.title2))
                    .foregroundColor(.white)
                    .animation(nil)
            }.frame(maxWidth: .infinity, alignment: .center)

            Text("We know you have been working hard lately, here you can see "
                    + "your achievements in the running month")
                .font(.system(.body))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .animation(nil)
        }
    }

    private var helpButton: AnyView? {
        guard state.viewData.shouldDisplayHelpButton else { return nil }

        return Button(action: state.handleHelpButtonTap) {
            Image.question
                .foregroundColor(.white)
                .padding()
        }
        .foregroundColor(.white)
        .asAnyView
    }

    private var medals: some View {
        VStack(alignment: .leading) {
            Text("Your achivements")
                .font(.system(.title2))
                .bold()
                .foregroundColor(.white)
                .animation(nil)

            LazyVGrid(columns: columns) {
                ForEach(state.viewData.awards, id: \.id) {
                    MedalView(award: $0)
                }
            }
        }
    }

    private func animateChanges(viewData: AwardsViewData) {
        withAnimation {
            self.points = viewData.points
        }
    }

    private let columns: [GridItem] =
        [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView(state: AwardsViewStateMock())
    }

    private class AwardsViewStateMock: AwardsViewState {
        init() {
            super.init()

            viewData = .init(
                points: 100,
                shouldDisplayHelpButton: true,
                awards:
                    [
                        .init(id: "some",
                              image: "bronzeMedal",
                              title: "Some award",
                              detail: "hard walk",
                              achieved: 2),
                        .init(id: "other",
                              image: "zombieHand",
                              title: "Other award",
                              detail: "hard walk",
                              achieved: 10)
                    ]
            )
        }
    }
}
