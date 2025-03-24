//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

// MARK: - BottomSheetAnimatedTransition

final class BottomSheetAnimatedTransition: NSObject {
    // MARK: Types

    /// Enum to define different types of transitions for view controllers
    enum TransitionType {
        /// Represents the transition type when presenting a view controller
        case present
        /// Represents the transition type when dismissing a view controller
        case dismiss
    }

    // MARK: Properties

    /// The animator responsible for performing the view transition animations.
    private var animator: UIViewPropertyAnimator?
    /// The type of transition to be performed (present or dismiss).
    private let transitionType: TransitionType
    /// The duration of the animation for the transition.
    private let animationDuration: TimeInterval

    // MARK: Initialization

    /// Initializes a new instance of the transition animator.
    ///
    /// - Parameters:
    ///   - transitionType: The type of transition to be performed (present or dismiss).
    ///   - animationDuration: The type of transition to be performed (present or dismiss).
    init(transitionType: TransitionType, animationDuration: TimeInterval) {
        self.transitionType = transitionType
        self.animationDuration = animationDuration
    }
}

// MARK: UIViewControllerAnimatedTransitioning

extension BottomSheetAnimatedTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        animationDuration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func interruptibleAnimator(
        using transitionContext: any UIViewControllerContextTransitioning
    ) -> any UIViewImplicitlyAnimating {
        if let animator { return animator }

        if transitionType == .present {
            if let controller = transitionContext.viewController(forKey: .to) {
                let frame = transitionContext.finalFrame(for: controller)
                controller.view.frame = frame

                transitionContext.containerView.addSubview(controller.view)
                transitionContext.containerView.layoutIfNeeded()

                controller.view.transform = CGAffineTransform(translationX: .zero, y: frame.height)
            }
        }

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            controlPoint1: CGPoint(x: 0.2, y: 1),
            controlPoint2: CGPoint(x: 0.42, y: 1)
        ) {
            let key: UITransitionContextViewKey = self.transitionType == .present ? .to : .from
            guard let view = transitionContext.view(forKey: key) else { return }

            let isPresent = self.transitionType == .present
            view.transform = isPresent ? .identity : CGAffineTransform(translationX: .zero, y: view.frame.height)
        }

        animator.addCompletion { _ in
            if transitionContext.transitionWasCancelled, self.transitionType == .present {
                transitionContext.view(forKey: .to)?.removeFromSuperview()
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        self.animator = animator

        return animator
    }

    func animationEnded(_: Bool) {
        animator = nil
    }
}
