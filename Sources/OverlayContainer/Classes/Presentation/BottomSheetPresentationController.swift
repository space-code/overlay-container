//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

// MARK: - BottomSheetPresentationController

/// A controller that manages the presentation of a bottom sheet.
final class BottomSheetPresentationController: UIPresentationController {
    // MARK: Types

    /// Represents the different states of the bottom sheet presentation lifecycle.
    private enum State {
        /// The bottom sheet is dismissed and not visible.
        case dismissed
        /// The bottom sheet is in the process of being presented.
        case presenting
        /// The bottom sheet is fully presented and visible.
        case presented
        /// The bottom sheet is in the process of being dismissed.
        case dismissing
    }

    // MARK: Properties

    /// The current state of the bottom sheet's presentation lifecycle.
    private var state: State = .dismissed
    /// The current frame of the bottom sheet.
    private var currentFrame: CGRect = .zero
    /// A view that dims the background to highlight the bottom sheet.
    private var dimmingView: UIView?

    // Dependencies

    /// The configuration settings for the appearance and behavior of the bottom sheet.
    private let configuration: Configuration

    // MARK: Initialization

    /// Initializes a new instance of `BottomSheetPresentationController` with the specified configuration and view controllers.
    ///
    /// - Parameters:
    ///   - configuration: The configuration settings for the appearance and behavior of the bottom sheet.
    ///   - presentedViewController: The view controller being presented as a bottom sheet.
    ///   - presentingViewController: The view controller that is presenting the bottom sheet.
    init(
        configuration: Configuration,
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: UIPresentationController

    override var shouldPresentInFullscreen: Bool {
        false
    }

    override func presentationTransitionWillBegin() {
        state = .presenting
        setupDimmingView()

        performAlongsideTransition {
            self.dimmingView?.alpha = 1
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .presented
        } else {
            state = .dismissed

            presentedView?.removeFromSuperview()
            dimmingView?.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        state = .dismissing

        performAlongsideTransition {
            self.dimmingView?.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .dismissed
            removeDimmingView()
        } else {
            state = .presented
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }

        let frame = super.frameOfPresentedViewInContainerView
        let windowInsets = presentedView?.window?.safeAreaInsets ?? .zero

        var preferredContentSize = presentedViewController.preferredContentSize

        if preferredContentSize == .zero {
            preferredContentSize = presentedViewController.view.systemLayoutSizeFitting(
                CGSize(width: frame.width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        }

        let preferredHeight = preferredContentSize.height
        let maxHeight = containerView.bounds.height - windowInsets.top

        let height = min(preferredHeight, maxHeight)

        return CGRect(
            x: .zero,
            y: containerView.bounds.height - height,
            width: containerView.bounds.width,
            height: height
        )
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        dimmingView?.frame = containerView?.frame ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: any UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        invalidateOverlayMetrics()
    }

    override func systemLayoutFittingSizeDidChange(forChildContentContainer container: any UIContentContainer) {
        super.systemLayoutFittingSizeDidChange(forChildContentContainer: container)
        invalidateOverlayMetrics()
    }

    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: any UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate { _ in
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }
    }

    // MARK: Private

    private func setupDimmingView() {
        guard let containerView else { return }

        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = configuration.dimmingColor
        dimmingView.alpha = .zero

        containerView.addSubview(dimmingView)

        NSLayoutConstraint.activate(
            [
                dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: dimmingView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: dimmingView.bottomAnchor),
            ]
        )

        let tapGesture = UITapGestureRecognizer()
        dimmingView.addGestureRecognizer(tapGesture)

        tapGesture.addTarget(self, action: #selector(handleTapGesture))

        self.dimmingView = dimmingView
    }

    private func removeDimmingView() {
        dimmingView?.removeFromSuperview()
        dimmingView = nil
    }

    private func dismissIfPossible() {
        let canBeDismissed = state == .presented

        if canBeDismissed {
            presentedViewController.dismiss(animated: true)
        }
    }

    private func performAlongsideTransition(_ animation: @escaping () -> Void) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            animation()
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            animation()
        })
    }

    private func invalidateOverlayMetrics() {
        guard let containerView else { return }

        let frame = containerView.frame

        if frame != currentFrame {
            containerView.setNeedsLayout()

            currentFrame = frame

            UIView.animate(withDuration: .animationDuration) {
                containerView.layoutIfNeeded()
            }
        }
    }

    // MARK: Actions

    @objc
    private func handleTapGesture() {
        dismissIfPossible()
    }
}

// MARK: - Constants

private extension TimeInterval {
    static let animationDuration = 0.25
}
