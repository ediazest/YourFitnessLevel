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

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                header
                medals
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all), alignment: .center)
        .sheet(isPresented: $state.presentHelp) {
            HelpView()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("Your points")
                    .font(.system(.title2))
                    .foregroundColor(.white)

                Spacer()

                if state.viewData.shouldDisplayHelpButton {
                    Button(action: state.handleHelpButtonTap) {
                        Image.question
                            .foregroundColor(.white)
                    }
                }
            }

            Text("2000")
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("We know you have been working hard lately, here you can see "
                    + "your achievements within the current month")
                .font(.system(.body))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var medals: some View {
        VStack(alignment: .leading) {
            Text("Your achivements")
                .font(.system(.title2))
                .foregroundColor(.white)

            LazyVGrid(columns: columns) {
                ForEach(state.viewData.awards, id: \.id) {
                    MedalView(award: $0)
                }
            }
        }
    }

    private let columns: [GridItem] =
        [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
}

private struct MedalView: View {
    let award: AwardsViewData.Award

    var body: some View {
        VStack {
            Image(uiImage: award.image)
            Text("\(award.title)")
                .foregroundColor(.white)
            Text("\(award.achieved)")
                .padding(5)
                .background(Color.gray)
                .clipShape(Circle())
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        .padding()
        .background(Color.white.opacity(0.3))
        .shadow(radius: 20)
        .cornerRadius(8)
    }
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
                        .init(id: "some", image: .bronzeMedal, title: "Some award", achieved: 2),
                        .init(id: "other", image: .zombieHand, title: "Other award", achieved: 10)
                    ]
            )
        }
    }
}
