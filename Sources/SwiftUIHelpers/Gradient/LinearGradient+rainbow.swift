//
//  LinearGradient+rainbow.swift
//  
//
//  Created by Ben Comber on 25/08/2023.
//

import SwiftUI

extension LinearGradient {
    static var rainbow: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(UIColor(hex: "#EE3A32")),
                    Color(UIColor(hex: "#EF803B")),
                    Color(UIColor(hex: "#EBAC38")),
                    Color(UIColor(hex: "#D7C05E")),
                    Color(UIColor(hex: "#ABC770")),
                    Color(UIColor(hex: "#55C1DC")),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
