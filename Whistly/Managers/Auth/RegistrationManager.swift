//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//class RegistrationManager: ObservableObject {
//    @Published var name = ""
//    @Published var email = ""
//    @Published var password = ""
//    @Published var errorMessage = ""
//    
//    init() {}
//    
//    func registration() {
//        guard validate() else { return }
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            guard let userId = result?.user.uid else {
//                return
//            }
//            self?.insertUserRecord(id: userId)
//        }
//    }
//    
//    private func insertUserRecord(id: String) {
//        let newUser = UserModel(id: id,
//                                email: email,
//                                name: name
//        )
//        let db = Firestore.firestore()
//        db.collection("users").document(id).setData(newUser.asDictionary())
//    }
//    
//    private func validate() -> Bool {
//        errorMessage = ""
//        guard !name.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return false
//        }
//        guard email.contains("@") && email.contains(".") else {
//            errorMessage = "Please enter valid emeil"
//            return false
//        }
//        guard password.count >= 6 else {
//            errorMessage = "Please enter at least 6 characters as password"
//            return false
//        }
//        
//        return true
//    }
//}
