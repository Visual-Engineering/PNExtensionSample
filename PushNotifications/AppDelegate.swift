//
//  AppDelegate.swift
//  PushNotifications
//
//  Created by Alba Luján on 31/5/17.
//  Copyright © 2017 Alba Luján. All rights reserved.
//

import UIKit
import AirshipKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var musicPlayer = AVAudioPlayer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let userDefaults = UserDefaults(suiteName: "group.com.pushNotifications")
        if let enabledNotif = userDefaults?.object(forKey: "key") {
            print(enabledNotif)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { 
        
        do {
            if let bundle = Bundle.main.path(forResource: "track37", ofType: "mp3"){
                let alertSound = URL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                try self.musicPlayer = AVAudioPlayer(contentsOf: alertSound)
                self.musicPlayer.numberOfLoops = -1
                self.musicPlayer.prepareToPlay()
                self.musicPlayer.play()
            }
        } catch {
            print(error)
        }
        }
        
        
        
        let config = UAConfig.default()
        config.productionAppKey = "4sWL34__SUCBAa1dZqinIw"
        config.productionAppSecret = "Hx4Yq0iXQyO7TGetW-Np1w"
        config.developmentAppKey = "4sWL34__SUCBAa1dZqinIw"
        config.developmentAppSecret = "Hx4Yq0iXQyO7TGetW-Np1w"
        
        UAirship.takeOff(config)
    
        
        UAirship.push().userPushNotificationsEnabled = true
        UAirship.push().defaultPresentationOptions = [.alert, .badge, .sound]
        
        let channelID = UAirship.push().channelID
        print("My Application Channel ID: \(String(describing: channelID))")

        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        return true

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print(deviceToken.description)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UAAppIntegration.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
        let userDefaults = UserDefaults(suiteName: "group.com.pushNotifications")
        var str = userDefaults?.object(forKey: "newkey")
        if str == nil {
            str = "didReceive"
        }
        else {
            str = "notReceived"
        }
        userDefaults?.setValue(str, forKey: "newkey")
        userDefaults?.synchronize()
        
        self.musicPlayer.stop()
        
//                do {
//                    if let bundle = Bundle.main.path(forResource: "track37", ofType: "mp3"){
//                        let alertSound = URL(fileURLWithPath: bundle)
//                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//                        try AVAudioSession.sharedInstance().setActive(true)
//                        try musicPlayer = AVAudioPlayer(contentsOf: alertSound)
//                        musicPlayer.numberOfLoops = -1
//                        musicPlayer.prepareToPlay()
//                        musicPlayer.play()
//                    }
//                } catch {
//                    print(error)
//                }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let userDefaults = UserDefaults(suiteName: "group.com.pushNotifications")
        var str = userDefaults?.object(forKey: "keyKilledApp")
        if str == nil {
            str = "didReceived when the App was killed"
        }
        else {
            str = "notReceived"
        }
        userDefaults?.setValue(str, forKey: "key")
        userDefaults?.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

