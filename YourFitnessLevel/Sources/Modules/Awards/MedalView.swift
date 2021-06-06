//
//  MedalView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SwiftUI

struct MedalView: View {
    let award: AwardsViewData.Award
    @State private var scale: CGFloat = 1

    private var blur: CGFloat {
        (award.achieved > 0) ? 0 : 8
    }

    private var maskColor: Color {
        (award.achieved > 0) ? .white : .black.opacity(0.5)
    }

    init(award: AwardsViewData.Award) {
        self.award = award
    }

    var body: some View {
        VStack {
            Image(award.image)
                .mask(maskColor)
                .blur(radius: blur)
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
        .onAppear(perform: onTapGesture)
    }

    private func onTapGesture() {
        guard award.achieved > 0 else { return }
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

struct MedalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MedalView(award: .init(id: "some",
                                   image: "bronzeMedal",
                                   title: "Some award",
                                   detail: "hard walk",
                                   achieved: 0)
            )

            MedalView(award: .init(id: "other",
                                   image: "zombieHand",
                                   title: "Other award",
                                   detail: "hard walk",
                                   achieved: 10)

            )
        }
    }
}
