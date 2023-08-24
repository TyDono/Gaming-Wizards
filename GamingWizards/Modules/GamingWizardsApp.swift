//
//  GamingWizardsApp.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/27/22.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import FirebaseCore
import FirebaseAnalytics
import FirebaseAppCheck
import GoogleSignIn
import SwiftUI
import UserNotifications
import CoreLocation


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var session = SessionStore()
    static let GamingWizardsUserSignupNotificationGreeting: String = "Welcome "
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
          return AppAttestProvider(app: app)
        } else {
          return DeviceCheckProvider(app: app)
        }
    }
}

@main
struct GamingWizardsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    let persistenceController = PersistenceController.shared
    @StateObject var coreDataController = CoreDataController.shared
    @StateObject var signInWithGoogleCoordinator = SignInWithGoogleCoordinator()
    @StateObject var signInWithAppleCoordinator = SignInWithAppleCoordinator()
    @State private var locationManager = CLLocationManager()
    
    init() {
        
        // change scheme to debug to run on simulator. change to release when testing on irl device/ ready for public.
#if DEBUG
//        let providerFactory = MyAppCheckProviderFactory() //for app attest, only one of the the can be used.
        let providerFactory = AppCheckDebugProviderFactory() // for device test
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif
        FirebaseApp.configure()
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: Constants.luminariRegularFontIdentifier, size: 40)!]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationLogInView()
                .onAppear() {
                    requestLocationPermission()
                    askNotificationPermission()
                }
                .environmentObject(signInWithAppleCoordinator)
                .environmentObject(signInWithGoogleCoordinator)
                .environmentObject(UserAuth())
                .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
        }
    }
    
    private func requestLocationPermission() {
            locationManager.requestWhenInUseAuthorization()
        }
    
    private func askNotificationPermission() {
        let center = UNUserNotificationCenter.current()
          center.requestAuthorization(options: [.alert, .sound, .badge]) { success, err in
              if let error = err {
                  print("NOTIFICATION AUTHORIZATION ERROR: \(error.localizedDescription)")
              } else if success {
                  // User granted authorization.
                  print("NOTIFICATION AUTHORIZATION GRANTED.")
              } else {
                  // User denied authorization.
                  print("NOTIFICATION AUTHORIZATION DENIED.")
              }
          }
    }
    
}
