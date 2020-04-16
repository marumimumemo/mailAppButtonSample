//
//  URLSchemeHelper.swift
//  mailAppButtonSample
//
//  Created by satoshi.marumoto on 2020/04/16.
//  Copyright © 2020 satoshi.marumoto. All rights reserved.
//

import UIKit

struct URLSchemeHelper {
    
    /// メーラアプリを起動する
    static func mail(emailAddress: String?) {
        guard let emailURL = makeMailScheme(emailAddress: emailAddress) else {
            return
        }
        UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
    }
    
    /// Gmailアプリを起動する
    static func gMail(emailAddress: String?) {
        guard let gmailURL = makeGmailScheme(emailAddress: emailAddress) else {
            return
        }
        UIApplication.shared.open(gmailURL, options: [:], completionHandler: nil)
    }
}

extension URLSchemeHelper {
    
    /// メーラアプリを起動するURLを生成する
    static func makeMailScheme(emailAddress: String?) -> URL? {
        guard let emailAddress = emailAddress else {
            print("emailAddress is nil.")
            return nil
        }
        if emailAddress.isEmpty {
            print("emailAddress is empty.")
            return nil
        }
        guard let emailURL = URL(string: "mailto:\(emailAddress)") else {
            print("emailURL is nil.")
            return nil
        }
        if !UIApplication.shared.canOpenURL(emailURL) {
            return nil
        }
        
        return emailURL
    }
    
    /// メーラアプリを起動できるかどうか
    static func canOpenMail(emailAddress: String?) -> Bool {
        if makeMailScheme(emailAddress: emailAddress) == nil {
            return false
        }
        return true
    }
}

extension URLSchemeHelper {
    
    /// Gmailアプリを起動するURLを生成する
    static func makeGmailScheme(emailAddress: String?) -> URL? {
        guard let emailAddress = emailAddress else {
            print("emailAddress is nil.")
            return nil
        }
        if emailAddress.isEmpty {
            print("emailAddress is empty.")
            return nil
        }
        guard let gMailURL = URL(string: "googlegmail:///co?to=\(emailAddress)") else {
            print("gMailURL is nil.")
            return nil
        }
        if !UIApplication.shared.canOpenURL(gMailURL) {
            return nil
        }
        return gMailURL
    }
    
    /// Gmailアプリを起動できるかどうか
    static func canOpenGmail(emailAddress: String?) -> Bool {
        if makeGmailScheme(emailAddress: emailAddress) == nil {
            return false
        }
        return true
    }
}

extension URLSchemeHelper {
    
    static func showMailAppSelection(emailAddress: String?, viewController: UIViewController?) {
        
        guard let address = emailAddress else {
            return
        }
        
        let canOpenMail = self.canOpenMail(emailAddress: address)
        let canOpenGmail = self.canOpenGmail(emailAddress: address)
        
        if !canOpenMail && !canOpenGmail {
            print("起動できるメーラが無いため、メールアドレスコピーのみ。")
            UIPasteboard.general.string = address
            copiedMailAddress(viewController: viewController)
            return
        }
        
        // アクションシートを生成する
        let actionSheet = UIAlertController(
            title: nil,
            message: "どちらでメールを作成しますか？",
            preferredStyle: .actionSheet
        )
        
        if canOpenMail {
            let mailAction = UIAlertAction(title: "メールアプリを起動", style: .default) { _ in
                URLSchemeHelper.mail(emailAddress: address)
            }
            actionSheet.addAction(mailAction)
        }
        
        if canOpenGmail {
            let gMailAction = UIAlertAction(title: "Gmailアプリを起動", style: .default) { _ in
                URLSchemeHelper.gMail(emailAddress: address)
            }
            actionSheet.addAction(gMailAction)
        }
        
        let pasteboardAction = UIAlertAction(title: "メールアドレスをコピー", style: .default) { _ in
            UIPasteboard.general.string = address
            copiedMailAddress(viewController: viewController)
        }
        actionSheet.addAction(pasteboardAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        viewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private static func copiedMailAddress(viewController: UIViewController?) {
        let alert = UIAlertController(title: "確認", message: "メールアドレスをコピーしました。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
}

