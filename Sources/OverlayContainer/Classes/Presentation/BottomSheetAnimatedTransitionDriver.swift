//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

// MARK: - BottomSheetAnimatedTransitionDriver

final class BottomSheetAnimatedTransitionDriver: UIPercentDrivenInteractiveTransition {
    // MARK: Private

    private weak var controller: OverlayContainer?

    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        return panGesture
    }()

    // MARK: Initialization

    init(controller: OverlayContainer) {
        self.controller = controller
        super.init()
        wantsInteractiveStart = false
        setupGesture()
    }

    // MARK: Private

    private func setupGesture() {
        controller?.view.addGestureRecognizer(panGesture)
    }

    // MARK: Actions

    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }

        let translation = sender.translation(in: view)
        var progress = translation.y / view.frame.height
        progress = min(max(progress, 0.0), 1.0)

        switch sender.state {
        case .began:
            wantsInteractiveStart = true
            controller?.dismiss(animated: true)
        case .changed:
            update(progress)
        case .ended:
            wantsInteractiveStart = false

            let velocity = sender.velocity(in: view).y

            if progress > 0.5 || velocity > 1000 {
                finish()
            } else {
                cancel()
            }
        case .cancelled, .failed:
            wantsInteractiveStart = false
            cancel()
        default:
            break
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension BottomSheetAnimatedTransitionDriver: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        let velocity = panGesture.velocity(in: nil)

        if velocity.y > 0, abs(velocity.y) > abs(velocity.x) {
            return true
        } else {
            return false
        }
    }
}
