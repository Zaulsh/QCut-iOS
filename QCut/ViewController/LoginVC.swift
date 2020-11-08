//
//  ViewController.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import MaterialComponents
import Toast_Swift
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginAreaUIV: UIView!
    @IBOutlet weak var mdcEmailTF: MDCTextField!
    @IBOutlet weak var mdcPasswordTF: MDCTextField!
    @IBOutlet weak var signUB: UIButton!
    @IBOutlet weak var facebookUB: UIButton!
    @IBOutlet weak var googleUB: UIButton!
    @IBOutlet weak var appleUB: UIButton!
    
    @IBOutlet weak var signInButnUIV: UIView!
    var emailMDCController: MDCTextInputControllerOutlined?
    var passwordMDCController: MDCTextInputControllerOutlined?
    
    var emailIcon: UIButton!
    var passwordToggleUB: UIButton!
    
    var isShowPassword = false
    
    let loginManager:LoginManager = LoginManager()//google sign in
    
    fileprivate var currentNonce: String? // apple sign in
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUIView()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func initUIView() {
        
        loginAreaUIV.setShadowRadiusToUIView()
        signInButnUIV.setShadowRadiusToUIView(radius: signInButnUIV.frame.height / 2)
        
        emailMDCController = MDCTextInputControllerOutlined(textInput: mdcEmailTF)
        emailMDCController?.setMDCTextInputOutline()
        
        passwordMDCController = MDCTextInputControllerOutlined(textInput: mdcPasswordTF)
        passwordMDCController?.setMDCTextInputOutline()
        
        mdcEmailTF.clearButton.isHidden = true
        mdcPasswordTF.clearButton.isHidden = true
        
        emailIcon = UIButton(type: .custom)
        emailIcon.setImage(UIImage.icEmail(), for: .normal)
        emailIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        emailIcon.frame = CGRect(x: CGFloat(mdcEmailTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        mdcEmailTF.rightView = emailIcon
        mdcEmailTF.rightViewMode = .always
        
        passwordToggleUB = UIButton(type: .custom)
        passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
        passwordToggleUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordToggleUB.frame = CGRect(x: CGFloat(mdcPasswordTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        passwordToggleUB.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        mdcPasswordTF.rightView = passwordToggleUB
        mdcPasswordTF.rightViewMode = .always
        
        facebookUB.setShadowRadiusToUIView(radius: 10.0)
        
        googleUB.setShadowRadiusToUIView(radius: 10.0)
        
        appleUB.setShadowRadiusToUIView(radius: 10.0)
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refresh() {
        if !isShowPassword {
            passwordToggleUB.setImage(UIImage.icUnlock(), for: .normal)
            mdcPasswordTF.isSecureTextEntry = false
        } else {
            passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
            mdcPasswordTF.isSecureTextEntry = true
        }
        isShowPassword = !isShowPassword
    }
    
    @IBAction func onTapLoginUB(_ sender: Any) {
        if !mdcEmailTF.emailValidation() {
            self.view.makeToast("Email not match.")
        } else if !mdcPasswordTF.passwordValidation() {
            self.view.makeToast("Password must be over 6 digits.")
        } else {
            Global.onShowProgressView(name: "Connecting")
            
            Auth.auth().signIn(withEmail: self.mdcEmailTF.text!, password: self.mdcPasswordTF.text!, completion: {(usr, err) in
                if err != nil {
                    Global.onhideProgressView()
                    self.view.makeToast("Account does not exist.")
                } else {
                    Global.onhideProgressView()
                    if Auth.auth().currentUser!.isEmailVerified {
                        let ref: DatabaseReference = FireManager.customerRef.child(Auth.auth().currentUser!.uid)
                        FireManager.getDataToFirebase(ref: ref, success: {result in
                            let object = result.value as! [String: AnyObject]
                            Global.gUser.id = object["id"] as! String
                            Global.gUser.email = object["email"] as! String
                            Global.gUser.name = object["name"] as! String
                            
                            UserDefaultManager.setStringData(key: UserDefaultManager.LOGIN_TYPE, val: "normal")
                            UserDefaultManager.setBoolData(key: UserDefaultManager.IS_LOGGEDIN, val: true)
                            UserDefaultManager.setStringData(key: UserDefaultManager.USER_NAME, val: Global.gUser.name)
                            UserDefaultManager.setStringData(key: UserDefaultManager.USER_EMAIL, val: Global.gUser.email)
                            UserDefaultManager.setStringData(key: UserDefaultManager.USER_ID, val: Global.gUser.id)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    } else {
                        self.view.makeToast("Check your mail box.")
                    }
                }
            })
        }
    }
    
    @IBAction func onTapFacebookUB(_ sender: Any) {
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                    }
                    
                }
            }
        }
    }
    
    @IBAction func onTapGoogleUB(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @available(iOS 13, *)
    @IBAction func onTapAppleUB(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result as Any)
                    guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    Global.onShowProgressView(name: "Loading...")
                    Auth.auth().signIn(with: credential, completion: {(user, error) in
                        if error != nil {
                            self.view.makeToast("Error has been occured.")
                            Global.onhideProgressView()
                        } else {
                            Database.database().reference().child("Customers").observe(.value, with: {snapshot in
                                if snapshot.hasChild((user?.user.uid)!){
                                    self.getFBUserInfo(userId: (user?.user.uid)!)
                                } else {
                                    self.saveFBUSERInfo(result: result as! [String: Any], userID: (user?.user.uid)!)
                                }
                                UserDefaultManager.setStringData(key: UserDefaultManager.LOGIN_TYPE, val: "facebook")
                                UserDefaultManager.setBoolData(key: UserDefaultManager.IS_LOGGEDIN, val: true)
                                UserDefaultManager.setStringData(key: UserDefaultManager.USER_NAME, val: Global.gUser.name)
                                UserDefaultManager.setStringData(key: UserDefaultManager.USER_EMAIL, val: Global.gUser.email)
                                UserDefaultManager.setStringData(key: UserDefaultManager.USER_ID, val: Global.gUser.id)
                            })
                            Global.onhideProgressView()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    })
                }
                else {
                    print(error?.localizedDescription as Any)
                    
                }
            })
        }
    }
    
    func getFBUserInfo(userId: String) {
        FireManager.getDataToFirebase(ref: FireManager.customerRef.child(userId), success: {snapshot in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            Global.gUser.id = postDict["id"] as! String
            Global.gUser.email = postDict["email"] as! String
            Global.gUser.name = postDict["name"] as! String
            Global.gUser.photo = postDict["photo"] as! String
        })
    }
    
    func saveFBUSERInfo(result: [String: Any], userID: String) {
        Global.gUser.id = userID
        Global.gUser.email = result["email"] as! String
        Global.gUser.name = result["name"] as! String
        
        if let picture = result["picture"] as? [String:Any] , let imgData = picture["data"] as? [String:Any] , let imgUrl = imgData["url"] as? String {
            Global.gUser.photo = imgUrl
        }
        
        let params = [
            "id": Global.gUser.id,
            "email": Global.gUser.email,
            "name": Global.gUser.name,
            "photo": Global.gUser.photo
        ] as [String : Any]
        
        FireManager.saveDataToFirebase(ref: FireManager.customerRef.child(Global.gUser.id), params: params as [String : AnyObject], success: {result in
            
        })
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
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
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Global.onShowProgressView(name: "Connecting")
        if error != nil {
            Global.onhideProgressView()
            print(error.localizedDescription)
        } else {
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential, completion: {(authResult, err) in
                if let err = err {
                    Global.onhideProgressView()
                    print(err.localizedDescription)
                    return
                }
                Global.onhideProgressView()
                
                Global.gUser.id = (authResult?.user.uid)!
                Global.gUser.email = user.profile.email
                Global.gUser.googleID = user.authentication.clientID
                Global.gUser.name = user.profile.name
                if user.profile.hasImage {
                    Global.gUser.photo = (user.profile.imageURL(withDimension: 200))!.absoluteString
                } else {
                    Global.gUser.photo = ""
                }
                
                let params = [
                    "id": Global.gUser.id,
                    "email": Global.gUser.email,
                    "name": Global.gUser.name,
                    "googleID": Global.gUser.googleID,
                    "photo": Global.gUser.photo,
                    "registeredInApp": false
                    ] as [String : Any]
                
                FireManager.saveDataToFirebase(ref: FireManager.customerRef.child(Global.gUser.id), params: params as [String : AnyObject], success: {result in
                    if result {
                        UserDefaultManager.setStringData(key: UserDefaultManager.LOGIN_TYPE, val: "google")
                        UserDefaultManager.setBoolData(key: UserDefaultManager.IS_LOGGEDIN, val: true)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_NAME, val: Global.gUser.name)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_EMAIL, val: Global.gUser.email)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_ID, val: Global.gUser.id)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            })
        }
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            
            //Initialize a Firebase credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            //Sing in with Firebase
            Global.onShowProgressView(name: "Connecting...")
            Auth.auth().signIn(with: credential) {(authResult, error) in
                if (error != nil) {
                    Global.onhideProgressView()
                    print(error!.localizedDescription)
                    return
                }
                Global.gUser.id = (authResult?.user.uid)!
                Global.gUser.name = (appleIDCredential.fullName?.givenName)! + (appleIDCredential.fullName?.familyName)! 
                Global.gUser.appleID = appleIDCredential.user
                Global.gUser.email = appleIDCredential.email!
                
                let params = [
                    "id": Global.gUser.id,
                    "email": Global.gUser.email,
                    "name": Global.gUser.name,
                    "appleID": Global.gUser.appleID
                ] as [String : AnyObject]
                
                FireManager.saveDataToFirebase(ref: FireManager.customerRef.child(Global.gUser.id), params: params, success: {(result) in
                    Global.onhideProgressView()
                    if result {
                        UserDefaultManager.setStringData(key: UserDefaultManager.LOGIN_TYPE, val: "apple")
                        UserDefaultManager.setBoolData(key: UserDefaultManager.IS_LOGGEDIN, val: true)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_NAME, val: Global.gUser.name)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_EMAIL, val: Global.gUser.email)
                        UserDefaultManager.setStringData(key: UserDefaultManager.USER_ID, val: Global.gUser.id)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        }
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

