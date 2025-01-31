//
//  BottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit

import SnapKit

final class BottomSheetViewController: UIViewController, LoginDelegate {

    // MARK: - Property
    
    var defaultLoginHeight: CGFloat = 282
    var defaultSignUpHeight: CGFloat = 394
    
    var betaAccessToken = UserDefaultsManager.betaLoginToken
    var popupBadgeData: [PopupBadge]?
    var userPlanRequest: UserPlanRequest?
    
    // MARK: - UI Property
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.086, alpha: 0.65).cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap)))
        return view
    }()
    
    var bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.viewType = .signUp
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setBottomViewDelegate()
    }
    
    // MARK: - @objc
    
    @objc func dimmedViewDidTap() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Custom Method
    
    func kakaoLoginDataSend() {
        betaLoginAPI()
    }
    
    func appleLoginDataSend() {
        ///
    }
    
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    private func setBottomViewDelegate() {
        self.bottomSheetView.delegate = self
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(dimmedView, bottomSheetView)
        
        dimmedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        if bottomSheetView.viewType == .login {
            bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(defaultLoginHeight)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        } else {
            bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(defaultSignUpHeight)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - Network

extension BottomSheetViewController {
    private func betaLoginAPI() {
        AuthAPI.shared.betaTestLoginAPI(param: BetaTestRequest(fcmToken: UserDefaultsManager.fcmToken)) { response in
            guard let data = response.data else { return }
            UserDefaultsManager.betaLoginToken = data.accessToken
            self.popupBadgeData = [PopupBadge(name: data.badges[0].name, imageURL: data.badges[0].imageURL)]
            
            let userNicknameVC = UserNicknameViewController()
            userNicknameVC.userPlanRequest = self.userPlanRequest
            userNicknameVC.badgeListData = self.popupBadgeData
            self.navigationController?.pushViewController(userNicknameVC, animated: true)
        }
    }
}
