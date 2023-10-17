//
//  SignInView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/28/22.
//

import CryptoKit
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import FirebaseAnalytics

struct SignInView: View {
    
//    @AppStorage("log_Status") var log_Status = false
    
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @EnvironmentObject var signInWithGoogleCoordinator: SignInWithGoogleCoordinator
    @EnvironmentObject var signInWithAppleCoordinator: SignInWithAppleCoordinator
//    @StateObject private var signInWithGoogleCoordinator: SignInWithGoogleCoordinator = SignInWithGoogleCoordinator()
    
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @EnvironmentObject var session: SessionStore
    
    @StateObject private var signInViewModel = SignInViewModel()
    
    @State var email = ""
    @State var password = ""
    
    @State var isEmailValid = false
    @State var isPasswordValid = false
    
    @State var isEmailError = false
    @State var isPasswordError = false
    
    @State var hasTappedSignIn = false
    
    @State var currentNonce: String?
    @State var alertItem: AlertItem?
    @State var coordinator: SignInWithAppleCoordinator?
    
    var body: some View {
        ZStack(alignment: .bottom) {
//            ScrollView {
                Image("gaming-wizard")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                //            LinearGradient(gradient: Gradient(colors: [Colors.GamingWizardsBrown, Colors.GamingWizardsYellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
                //                .edgesIgnoringSafeArea(.all)
                //                .cornerRadius(15)
                //                .overlay(
                ZStack {
                    if authenticationViewModel.isLoading {
                        Color.black
                            .opacity(1.00) //post mvp
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
//                    if authenticationViewModel.isUserLoggingInLoading == true {
//                        LoadingAnimation(loadingProgress: $authenticationViewModel.loadingProgress)
//                    }
                }
                
                GeometryReader { geometry in
                    VStack {
                        customNavigationBar
                        
                        Spacer()
                        appleSignInButton
                            .padding(.bottom, 5)
                        googleSignInButton
                            .padding(.vertical, 5)
                        //                    signInWithFacebook // NON MVP
                        //                        .padding(.vertical, 5)
                    }
                }
//            }
        }
        
    }
    

//    private var backButton: some View { //dont need in sign in
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image("chevron.left")
//                .renderingMode(.template)
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//        }
//    }
    
    private var titleLabel: some View {
        Text("Gaming Wizards")
            .foregroundColor(Color.black)
            .fontWeight(.black)
            .foregroundColor(Color(.systemIndigo))
            .multilineTextAlignment(.center)
//            .modifier(FontModifier(size: 20, weight: .extraBold))
            .font(.custom(Constants.luminariRegularFontIdentifier, size: 36))
    }
    
    private var appleSignInButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                authenticationViewModel.currentNonce = authenticationViewModel.randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = sha256(authenticationViewModel.currentNonce)
            },
            onCompletion: { result in
                switch result {
                case.success(let user):
                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                        print("ERROR WITH FIREBASE")
                        return
                    }
                    signInWithAppleCoordinator.appleAuthenticate(credential: credential)
                case .failure(let error):
                    print("APPLE SIGN IN ERROR \(error.localizedDescription)")
                }
            })
        .signInWithAppleButtonStyle(.white)
        .frame(height: 55)
        .clipShape(Capsule())
        .padding(.horizontal, 40)
        .offset(y: -70)
//        Button(action: {
//            signInViewModel.testrest()
//            signInWithApple()
//        }) {
//            RoundedRectangle(cornerRadius: 4)
//                .foregroundColor(.white)
//                .shadow(color: Color.black.opacity(0.26), radius: 12, x: 0, y: 0)
//                .frame(maxWidth: .infinity)
//                .frame(height: 44)
//                .overlay(
//                    Text("Sign in with Apple")
//                        .foregroundColor(Colors.greyDark)
//                        .modifier(FontModifier(size: 15, weight: .extraBold))
//                )
//        }
    }
    
    private var googleSignInButton: some View {
        Button(action: {
//            authenticationViewModel.signInWithGoogle()
            signInWithGoogleCoordinator.signInWithGoogle()
        }) {
            Image("btn_google_signin_light_normal_web")
//                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var orDivider: some View {
        HStack {
            customDivider
                .foregroundColor(Colors.greyMedium)
            
            Text("or")
                .foregroundColor(Colors.greyMedium)
                .modifier(FontModifier(size: 15, weight: .regular))
            
            customDivider
                .foregroundColor(Colors.greyMedium)
        }
    }
    
    private var customDivider: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(height: 2)
    }
    
    //not being used
//    private func signInWithApple() {
//        SignInView().environmentObject(SessionStore())
//        coordinator = SignInWithAppleCoordinator(session: session)
//        if let coordinator = coordinator {
//            coordinator.startSignInWithAppleFlow()
//        }
//    }
    
    private var signInWithFacebook: some View {
        Button(action: {
            
        }) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.26), radius: 12, x: 0, y: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Text("Sign in with Facebook")
                        .foregroundColor(Colors.greyDark)
                        .modifier(FontModifier(size: 15, weight: .extraBold))
                )
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private var customNavigationBar: some View {
        ZStack {
            HStack {
                Spacer()
            }
            titleLabel
        }
    }
    
    enum UserInfoType {
        case email
        case password
        case all
    }
    
    private func verifyUserInfo(for type: UserInfoType) {
        switch type {
        case .email:
            isEmailValid = Validation().validateEmail(email)
            isEmailError = !isEmailValid
            
        case .password:
            isPasswordValid = Validation().validatePassword(password)
            isPasswordError = !isPasswordValid
            
        case .all:
            isEmailValid = Validation().validateEmail(email)
            isEmailError = !isEmailValid

            isPasswordValid = Validation().validatePassword(password)
            isPasswordError = !isPasswordValid
        }
    }
    
}

//struct SignInPreview: PreviewProvider {
//    static var previews: some View {
//        SignInView().environmentObject(SessionStore())
//        SignInView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
