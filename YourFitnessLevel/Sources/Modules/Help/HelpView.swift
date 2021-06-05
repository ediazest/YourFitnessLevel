//
//  HelpView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation
import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) private var presentationMode

    @StateObject var state: HelpViewState

    init(state: HelpViewState = HelpViewState()) {
        _state = StateObject(wrappedValue: state)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        header
                        goals
                    }
                    .padding()
                }
            }
            .navigationTitle("This is how we do it")
            .toolbar(content: {
                Button(action: state.handleDismissButtonTap) {
                    Image.close
                }
            })
        }
        .accentColor(.white)
        .foregroundColor(.white)
        .onReceive(state.dismissPublisher) { [presentationMode] in
            presentationMode.wrappedValue.dismiss()
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("We do not store or share your activity data, "
                    + "only your achivements.")
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Every time you open the app we get fresh data from "
                    + "the current month and run our highly complex algorithm🙄.")
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Our points are based on your running and walking workous " +
                    "and steps")
                .font(.system(.body))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var goals: some View {
        ForEach(state.viewData.goals) {
            GoalView(goal: $0)
        }
    }
}

private struct GoalView: View {
    let goal: HelpViewData.Goal

    var body: some View {
        HStack {
            Image(goal.image)
            VStack(alignment: .leading, spacing: 10) {
                Text(goal.title)
                    .font(.title2)
                    .bold()

                Text(goal.description)
                    .font(.callout)
                    .lineLimit(4)

                Text("Points ").font(.title2)
                    + Text("\(goal.points)")
                    .font(.title2)
                    .bold()
            }
        }

        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.3))
        .shadow(radius: 20)
        .cornerRadius(8)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(state: HelpViewStatePreview())
    }

    private class HelpViewStatePreview: HelpViewState {
        init() {
            super.init()
            viewData = .init(goals: [
                .init(id: "some", title: "Some", description: "Running for 5km", points: 10, image: "bronzeMedal"),
                .init(id: "other", title: "Other", description: "Running for 10km", points: 20, image: "silverMedal")
            ])
        }
    }
}
