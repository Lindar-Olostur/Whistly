//import Foundation
//import FirebaseAuth
//
//class LoginManager: ObservableObject {
//    @Published var email = ""
//    @Published var password = ""
//    @Published var errorMessage = ""
//    
//    init() {}
//    
//    func login() {
//        guard validate() else { return }
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
//            
//            if let error = error {
//                self?.errorMessage = error.localizedDescription
//                print("error: \(error.localizedDescription)")
//                
//            }
//        }
//    }
//    
//    private func validate() -> Bool {
//        errorMessage = ""
//        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return false
//        }
//        guard email.contains("@") && email.contains(".") else {
//            errorMessage = "Please enter valid emeil"
//            return false
//        }
//        return true
//    }
//}
