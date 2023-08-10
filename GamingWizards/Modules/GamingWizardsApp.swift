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
//    let providerFactory = AppCheckDebugProviderFactory()
    static let GamingWizardsUserSignupNotificationGreeting: String = "Welcome "
//    @ObservedObject var user = UserObservable()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        AppCheck.setAppCheckProviderFactory(providerFactory)
//        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}
 

//@main
//struct GamingWizardsApp: App {
//
//    @StateObject var viewModel = AuthenticationViewModel()
//
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationLogInView()
//                .environmentObject(UserAuth())
//
//        }
//    }
//}

class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
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
    let providerFactory = AppCheckDebugProviderFactory()
    
    init() {
#if DEBUG
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
//                .environmentObject(authenticationViewModel)
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
                  // Handle the error here.
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

//extension GamingWizardsApp {
//    private func setupAuthentication() {
//        FirebaseApp.configure()
////        MyFirebase.shared.addUserListender(loggedIn: false)
//    }
//}
