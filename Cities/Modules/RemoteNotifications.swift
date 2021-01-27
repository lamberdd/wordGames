//
//  RemoteNotifications.swift
//  Cities
//
//  Created by Владислав Казмирчук on 26.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class RemoteNotifications: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = RemoteNotifications()
    
    private override init() {}
    
    //MARK: - Public methods
    func register() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Notification permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func saveToken(_ deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Toke: \(token)")
        
        saveToServer(token: token, lang: Locale.current.languageCode ?? "NO")
        
    }
    
    func clearBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK: - Private methods
    private func saveToServer(token: String, lang: String) {
        guard let url = URL(string: "https://citiesgame.000webhostapp.com/save_device_token.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "token=\(token)&lang=\(lang)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(String(data: data, encoding: .utf8))
            }
        }.resume()
    }
    
    
    //MARK: - Notification delegate
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        clearBadges()
    }
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge, .sound])
    }
}
