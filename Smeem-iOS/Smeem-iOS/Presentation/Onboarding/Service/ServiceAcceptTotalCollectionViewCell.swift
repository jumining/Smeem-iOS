//
//  ServiceAcceptTotalCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

import SnapKit

final class ServiceAcceptTotalCollectionViewCell: UICollectionViewCell {
    
    private let identifier = "ServiceAcceptCollectionViewCell"
    
    var selectedCell = false {
        didSet {
            if selectedCell {
                goalLabel.font = .b1
                goalLabel.textColor = .point
                layer.borderColor = UIColor.point.cgColor
                checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
            } else {
                goalLabel.font = .b3
                goalLabel.textColor = .gray600
                layer.borderColor = UIColor.gray100.cgColor
                checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
            }
        }
    }
    
    static let identifier = "OnboardingGoalCollectionViewCell"
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .b3
        label.text = "전체 동의하기"
        label.textColor = .gray600
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setCellSelected(selectedCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    func setData(_ text: String) {
        goalLabel.text = text
    }
    
    private func setCellSelected(_ selected: Bool) {
        if selected {
            goalLabel.font = .b1
            goalLabel.textColor = .point
            layer.borderColor = UIColor.point.cgColor
            checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
        } else {
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            layer.borderColor = UIColor.gray100.cgColor
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
        }
    }
    
    // MARK: - Layout
    
    private func setUI() {
        makeRoundCorner(cornerRadius: 6)
        layer.borderWidth = 1.5
    }
    
    private func setLayout() {
        addSubviews(checkButton, goalLabel)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        goalLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
