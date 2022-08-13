//
//  PopupViewController.swift
//  CommonUI
//
//  Created by 최동규 on 2022/08/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

public final class PopupViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var firstActionButton: UIButton!
    @IBOutlet private weak var secondActionButton: UIButton!

    private let viewModel: PopupViewModel
    private var cancellables = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    init?(coder: NSCoder, viewModel: PopupViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel.")
    }
}

extension PopupViewController {
    public static func create(viewModel: PopupViewModel) -> PopupViewController? {
        let storyboard = UIStoryboard(name: "PopupViewController", bundle: .init(for: self))
        return storyboard.instantiateViewController(identifier: "PopupViewController") { coder in
            return PopupViewController(coder: coder, viewModel: viewModel)
        }
    }
}

private extension PopupViewController {
    func setView() {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description

        firstActionButton.setTitle(viewModel.firstButtonModel.title, for: .normal)
        secondActionButton.setTitle(viewModel.secondButtonModel.title, for: .normal)

        viewModel.firstButtonModel.style.setView(in: firstActionButton)
        viewModel.secondButtonModel.style.setView(in: secondActionButton)

        firstActionButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.viewModel.firstButtonModel.action?()
                })
            })
            .store(in: &cancellables)

        secondActionButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.viewModel.secondButtonModel.action?()
                })
            })
            .store(in: &cancellables)
    }
}


public struct PopupViewModel {
    let title: String
    let description: String
    let firstButtonModel: PopupActionButtonViewMoodel
    let secondButtonModel: PopupActionButtonViewMoodel

    public init(title: String, description: String, firstButtonModel: PopupActionButtonViewMoodel, secondButtonModel: PopupActionButtonViewMoodel) {
        self.title = title
        self.description = description
        self.firstButtonModel = firstButtonModel
        self.secondButtonModel = secondButtonModel
    }
}

public struct PopupActionButtonViewMoodel {
    public enum ButtonStyle {
        case `default`
        case cancel

        func setView(in button: UIButton) {
            switch self {
            case .default:
                button.backgroundColor = .systemGreen
                button.setTitleColor(.white, for: .normal)
            case .cancel:
                button.backgroundColor = .white
                button.setTitleColor(.systemGray, for: .normal)
            }
        }
    }
    let title: String
    let style: ButtonStyle
    let action: (() -> Void)?

    public init(title: String, style: ButtonStyle = .default, action: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}



