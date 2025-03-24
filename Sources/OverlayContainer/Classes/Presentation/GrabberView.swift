//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

// MARK: - GrabberView

final class GrabberView: UIView {
    // MARK: Properties

    private let grabberLayer = CALayer()

    var cornerRadius: CGFloat = 16.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }

    var grabberColor: UIColor = .systemGray {
        didSet {
            grabberLayer.backgroundColor = grabberColor.cgColor
            setNeedsLayout()
        }
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override var alignmentRectInsets: UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: .zero, bottom: max(cornerRadius * 2 - CGSize.size.height, 0), right: .zero)
    }

    override var intrinsicContentSize: CGSize {
        .size
    }

    // MARK: Life Cycle

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                grabberLayer.backgroundColor = grabberColor.cgColor
            }
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        let origin = CGPoint(x: (layer.bounds.width - CGSize.grabberSize.width) / 2, y: 8)
        grabberLayer.frame = CGRect(origin: origin, size: .grabberSize)
    }

    // MARK: Private

    private func configure() {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
            grabberLayer.cornerCurve = .continuous
        }

        grabberLayer.backgroundColor = grabberColor.cgColor
        grabberLayer.cornerRadius = 2
        layer.addSublayer(grabberLayer)
    }
}

// MARK: - Constants

private extension CGSize {
    static let size = CGSize(width: 48, height: 20)
    static let grabberSize = CGSize(width: 40, height: 4)
}
