//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/10.
//

import UIKit

import SnapKit

//protocol InputTextFieldDelegate: AnyObject {
//    func textViewDidChange(_ textView: UITextView)
//}

//protocol randumSujectViewProtocol: AnyObject {
//    func configure(with viewModel: RandomSubjectViewModel)
//}

final class ForeignDiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var isRandomTopic = false
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    private let navibarContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 110
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(naviButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        label.text = "English"
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.gray400, for: .normal)
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var randomSubjectView = RandomSubjectView(frame: .zero)
    
    lazy var InputTextView: UITextView = {
        let textView = UITextView()
        textView.setLineSpacing()
        textView.textColor = .gray400
        //        textView.delegate = self
        return textView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "일기를 작성해주세요."
        label.textColor = .gray400
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let thinLine = SeparationLine(height: .thin)
    
    private lazy var randomTopicButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .point
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavigationBar()
        setBackgoundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap(_ gesture: UITapGestureRecognizer) {
        setRandomTopicButtonToggle()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        handleKeyboardChanged(notification: notification, customView: bottomView, isActive: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        handleKeyboardChanged(notification: notification, customView: bottomView, isActive: false)
    }
    
    @objc func naviButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func completionButtonDidTap() {
        //        changeMainRootViewController()
    }
    
    // MARK: - Custom Method
    
    private func setBackgoundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(naviView, InputTextView, bottomView)
        naviView.addSubview(navibarContentStackView)
        navibarContentStackView.addArrangedSubviews(cancelButton, languageLabel, completeButton)
        InputTextView.addSubview(placeHolderLabel)
        bottomView.addSubviews(thinLine, randomTopicButton)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        InputTextView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(convertByHeightRatio(10))
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(navibarContentStackView)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalTo(InputTextView.textInputView)
            $0.leading.equalTo(InputTextView)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(constraintByNotch(87, 53))
        }
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        randomTopicButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(18))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-30))
        }
    }
    
    private func setRandomTopicButtonToggle() {
        isRandomTopic.toggle()
        if isRandomTopic {
            
            view.addSubview(randomSubjectView)
            randomSubjectView.snp.makeConstraints {
                $0.top.equalTo(naviView.snp.bottom).offset(16)
                $0.leading.equalToSuperview()
            }
            
            InputTextView.snp.remakeConstraints {
                $0.top.equalTo(randomSubjectView.snp.bottom).offset(9)
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalTo(bottomView.snp.top)
            }
            
        } else {
            randomSubjectView.removeFromSuperview()
            
            InputTextView.snp.remakeConstraints {
                $0.top.equalTo(naviView.snp.bottom).offset(9)
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalTo(bottomView.snp.top)
            }
        }
    }
    
    private func characterValidation() -> Bool {
        while InputTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 9 {
            return true
        }
        return false
    }
    
    private func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UITextViewDelegate

extension ForeignDiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
            textView.textColor = .smeemBlack
            textView.font = .b4
            textView.setLineSpacing()
            textView.tintColor = .clear
        } else {
            placeHolderLabel.isHidden = true
            textView.font = .b4
            textView.setLineSpacing()
            textView.tintColor = .point
            completeButton.isEnabled = false
            
            if characterValidation() == true {
                completeButton.isEnabled = true
                completeButton.setTitleColor(.smeemBlack, for: .normal)
            } else {
                completeButton.setTitleColor(.gray400, for: .normal)
            }
        }
    }
}

// MARK: - Network
