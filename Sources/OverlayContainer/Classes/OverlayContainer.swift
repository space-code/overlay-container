//
// overlay-container
// Copyright © 2024 Space Code. All rights reserved.
//

import UIKit

// MARK: - OverlayContainer

public final class OverlayContainer: UIViewController {
    // MARK: Properties

    /// Controller responsible for managing the presentation of the bottom sheet.
    private var bottomSheetController: BottomSheetPresentationController?
    /// Driver responsible for handling the animated transitions of the bottom sheet.
    private var transitionDriver: BottomSheetAnimatedTransitionDriver?
    /// The view controller that contains the content to be presented in the bottom sheet.
    private let contentContainer: UIViewController
    /// The view that holds the content to be displayed in the bottom sheet.
    private let contentView = UIView()
    /// The view that provides a visual handle for dragging the bottom sheet.
    private let grabberView = GrabberView()
    /// Configuration settings for the appearance and behavior of the bottom sheet.
    private let configuration: Configuration

    // MARK: Initialization

    /// Create a new `OverlayContainer` instance.
    ///
    /// - Parameters:
    ///   - contentContainer: The view controller that contains the content to be presented in the bottom sheet.
    ///   - configuration: Configuration settings for the appearance and behavior of the bottom sheet.
    public init(contentContainer: UIViewController, configuration: Configuration = .init()) {
        self.contentContainer = contentContainer
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        transitionDriver = BottomSheetAnimatedTransitionDriver(controller: self)

        view.layoutIfNeeded()
    }

    override public func systemLayoutFittingSizeDidChange(forChildContentContainer container: any UIContentContainer) {
        super.systemLayoutFittingSizeDidChange(forChildContentContainer: container)
        presentationController?.systemLayoutFittingSizeDidChange(forChildContentContainer: container)
    }

    override public func preferredContentSizeDidChange(forChildContentContainer container: any UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        let grabberHeight = grabberView.intrinsicContentSize.height
        var preferredContentSize = container.preferredContentSize

        preferredContentSize.height += grabberHeight
    }

    // MARK: Public

    public func present(viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }

    // MARK: Private

    private func setupLayout() {
        addChild(contentContainer)

        view.addSubview(grabberView)
        view.addSubview(contentView)

        contentContainer.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer.view)

        grabberView.backgroundColor = configuration.backgroundColor
        grabberView.cornerRadius = configuration.cornerRadius
        grabberView.grabberColor = configuration.grabberColor
        grabberView.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = configuration.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                grabberView.topAnchor.constraint(equalTo: view.topAnchor),
                grabberView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: grabberView.trailingAnchor),

                contentView.topAnchor.constraint(equalTo: grabberView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                contentContainer.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentContainer.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: contentContainer.view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: contentContainer.view.bottomAnchor),
            ]
        )

        contentContainer.didMove(toParent: self)
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension OverlayContainer: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source _: UIViewController
    ) -> UIPresentationController? {
        bottomSheetController = BottomSheetPresentationController(
            configuration: configuration,
            presentedViewController: presented,
            presentingViewController: presenting
        )
        return bottomSheetController
    }

    public func animationController(
        forDismissed _: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        BottomSheetAnimatedTransition(
            transitionType: .dismiss,
            animationDuration: configuration.animationDuration
        )
    }

    public func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        BottomSheetAnimatedTransition(
            transitionType: .present,
            animationDuration: configuration.animationDuration
        )
    }

    public func interactionControllerForDismissal(
        using _: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        transitionDriver?.wantsInteractiveStart == true ? transitionDriver : nil
    }
}
