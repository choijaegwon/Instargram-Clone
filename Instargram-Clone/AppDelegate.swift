//
//  AppDelegate.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/09/27.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스 연결
        FirebaseApp.configure()
        
        // 루트 뷰 설정
        window = UIWindow()
        // 홈 화면이 처음 나오게 설정
        window?.rootViewController = MainTabVC()
        
        attemptToRegisterForNotifications(application: application)
        
        return true
    }
    
    func attemptToRegisterForNotifications(application: UIApplication) {
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { authorized, error in
            if authorized {
                print("DEBUG: SUCCESSFULLY REGISTERED FOR NOTIFICATIONS")
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEBUG: Registered for notifications with device token: ", deviceToken)
    }
    
    // 등록 토큰 가져오기 나중에 업데이트하고 연결해서 테스트 하면 됨.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: Registered with FCM Token: ", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

