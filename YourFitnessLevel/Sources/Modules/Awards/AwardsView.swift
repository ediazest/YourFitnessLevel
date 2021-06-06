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
        .animation(.default)
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
                    .bold()
                    .font(.system(.title2))
                    .foregroundColor(.white)

                Spacer()

                if state.viewData.shouldDisplayHelpButton {
                    Button(action: state.handleHelpButtonTap) {
                        Image.question
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .animation(nil)

            Text("\(state.viewData.points)")
                .modifier(NumberView(number: state.viewData.points))
                .frame(maxWidth: .infinity, idealHeight: 50, alignment: .center)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .frame(height: 50)

            Text("We know you have been working hard lately, here you can see "
                    + "your achievements in the running month")
                .font(.system(.body))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .animation(nil)
        }
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

    private let columns: [GridItem] =
        [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
}

private struct MedalView: View {
    let award: AwardsViewData.Award
    @State private var scale: CGFloat = 1

    var body: some View {
        VStack {
            Image(award.image)
                .scaleEffect(scale)

            Text("\(award.title)")
                .bold()
                .foregroundColor(.white)

            Text("\(award.detail)")
                .foregroundColor(.white)

            Text("\(award.achieved)")
                .padding(5)
                .background(Color.gray)
                .clipShape(Circle())
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .onTapGesture(perform: onTapGesture)
        .padding(.horizontal)
        .padding()
        .background(Color.white.opacity(0.3))
        .shadow(radius: 20)
        .cornerRadius(8)
    }

    private func onTapGesture() {
        withAnimation(Animation.easeOut(duration: 0.25)) {
            scale += scale * 0.20
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(Animation.easeIn(duration: 0.2)) {
                scale = 1
            }
        }
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
                points: 0,
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
