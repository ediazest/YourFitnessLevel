//
//  AppDelegate.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    private let dependencyContainer: DependencyContainer

    override convenience init() {
        self.init(dependencyContainer: AppContainer())
    }

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        DependencyContainerProvider.container = self.dependencyContainer
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        injectDependencies(into: dependencyContainer)

        return true
    }
}
