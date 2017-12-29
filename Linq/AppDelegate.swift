//
//  AppDelegate.swift
//  Linq
//
//  Created by Quinton Askew on 5/22/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.


import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManagerSwift
import GoogleMobileAds
import FBSDKCoreKit
import GoogleSignIn

// cgXQuUVdyoc:APA91bFQYKPcfuZmPoRbkDEchzb-S9ZAfqsstvQTLN_qzgAOWOhcsYCFwVHG3oCJTyA-MpftkWr6MAcBJjEm_N6lgRMU8i65lev8OYk92qcvCNH9_Z49I1wXIYrHbG-E4hbInKn_3akr
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        let navigationBarAppearace = UINavigationBar.appearance()
        let color = UIColor.black
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationBarAppearace.tintColor = color
        let ISLOGIN :Bool? = Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("IS_LOGIN") as? Bool
        if ISLOGIN == nil {
            Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(false, key: "IS_LOGIN")
        }
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2288924893490965~5600453269")

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Twitter.sharedInstance().start(withConsumerKey:"sDQsMFUPYXIxZVP3CsGIaa8dG", consumerSecret:"VR47VDo1zw5pMZ4KiBjPqlgyvY51vMBaTwCIFaAusNWZwNCPV8")

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.bool(forKey: "DisplayLingo")) {
            
            if (userDefaults.bool(forKey: "DisplayedWalkThrough")) {
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "login")
                
                self.window?.rootViewController = initialViewController
            } else {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
                
                self.window?.rootViewController = initialViewController
                
            }
            
        } else {
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LingoVC")
            
            self.window?.rootViewController = initialViewController
            
        }
    
        
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        
        if url.absoluteString.contains("twitterkit") {
            return Twitter.sharedInstance().application(app, open: url, options: options)
        }
        
        
        if url.absoluteString.contains("facebook") {
            let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            return handled
        }
        else {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        
      
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("MessageID : \(String(describing: userInfo["gcm_message_id"]))")
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print(fcmToken)
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        if uid == nil {
            return
        }
        
        let refchild = ref.child("Users").child(uid!).child("fcmToken")
        refchild.setValue(fcmToken)
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.QuintonAskew.Jugg.newJugg"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newJugg = storyboard.instantiateViewController(withIdentifier: "NewMove") as? NewMove
            newJugg?.canceled(newJugg?.cancel as Any)
            self.window?.rootViewController?.present(newJugg!, animated: true)
            self.window?.makeKeyAndVisible()
           
        }
        else if shortcutItem.type == "com.QuintonAskew.Jugg.newMessage"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newJugg = storyboard.instantiateViewController(withIdentifier: "NewBoxMove") as? NewMessage
            let navController = UINavigationController(rootViewController: newJugg!)
            newJugg?.navigationController?.navigationBar.tintColor = UIColor.black
            newJugg?.title = "New Message"
            self.window?.rootViewController?.present(navController, animated: true)
            self.window?.makeKeyAndVisible()
        }
        else if shortcutItem.type == "com.QuintonAskew.Jugg.myInvites"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Make sure tab bar is shown.
            let newJugg = storyboard.instantiateViewController(withIdentifier: "NotificationBox") as? NotificationBox
            // Make sure shake gesture for new invitation works here.
            self.window?.rootViewController?.present(newJugg!, animated: true)
            self.window?.makeKeyAndVisible()
        }
    
    
    
    
    }







}

