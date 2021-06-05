//
//  UIImage.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Foundation
import SwiftUI
import UIKit

extension UIImage {
    static var bronzeMedal: UIImage {
        UIImage(named: "bronzeMedal")!
    }

    static var silverMedal: UIImage {
        UIImage(named: "silverMedal")!
    }

    static var goldMedal: UIImage {
        UIImage(named: "goldMedal")!
    }

    static var zombieHand: UIImage {
        UIImage(named: "zombieHand")!
    }
}

extension Image {
    static var question: Image {
        Image(systemName: "questionmark.circle")
    }
    static var close: Image {
        Image(systemName: "xmark")
    }
}
