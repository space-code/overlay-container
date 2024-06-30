//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

/// A struct to configure the appearance and behavior of a UI component.
public struct Configuration {
    // MARK: Properties

    /// The dimming color for the component.
    public let dimmingColor: UIColor
    /// The background color of the component.
    public let backgroundColor: UIColor
    /// The duration of the animation for the component.
    public let animationDuration: TimeInterval
    /// The corner radius of the component.
    public let cornerRadius: CGFloat
    /// The color of the grabber pin view.
    public let grabberColor: UIColor

    // MARK: Initialization

    /// Initializes a new `Configuration` instance with specified properties.
    ///
    /// - Parameters:
    ///   - dimmingColor: The dimming color for the component.
    ///   - backgroundColor: The background color of the component.
    ///   - animationDuration: The duration of the animation for the component.
    ///   - cornerRadius: The corner radius of the component.
    ///   - grabberColor: The color of the grabber pin view.
    public init(
        dimmingColor: UIColor = .black.withAlphaComponent(0.4),
        backgroundColor: UIColor = .white,
        animationDuration: TimeInterval = 0.35,
        cornerRadius: CGFloat = 16.0,
        grabberColor: UIColor = .gray
    ) {
        self.dimmingColor = dimmingColor
        self.backgroundColor = backgroundColor
        self.animationDuration = animationDuration
        self.cornerRadius = cornerRadius
        self.grabberColor = grabberColor
    }
}
