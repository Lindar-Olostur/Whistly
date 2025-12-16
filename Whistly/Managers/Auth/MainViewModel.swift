//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseCore
//
//class AuthManager: ObservableObject {
//    @Published var currentUserId: String = ""
////    @Published var user: UserModel = UserModel()
//    private var handler: AuthStateDidChangeListenerHandle?
//    
//    init() {
//        //        logOut()
//        FirebaseApp.configure()
//        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            DispatchQueue.main.async {
//                self?.currentUserId = user?.uid ?? ""
//            }
//        }
//    }
//    
//    public var isSignedIn: Bool {
//        return Auth.auth().currentUser != nil
//    }
//    
//    func fetchUser() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).getDocument { [weak self] (snapshot, error) in
//            guard let snapshot = snapshot, error == nil else {
//                if let error = error {
//                    print("Error fetching user: \(error.localizedDescription)")
//                    loadFromUserDefaults()
//                } else {
//                    print("User document not found")
//                }
//                return
//            }
//            if let data = snapshot.data() {
//                DispatchQueue.main.async {
//                    self?.user = UserModel(id: data["id"] as? String ?? "",
//                                           email: data["email"] as? String ?? "",
//                                           name: data["name"] as? String ?? "",
//                                           birthDay: data["birthDay"] as? TimeInterval ?? 0,
//                                           age: data["age"] as? Int ?? 0,
//                                           sexIsMan: data["sexIsMan"] as? Bool ?? true,
//                                           weight: data["weight"] as? Int ?? 0,
//                                           height: data["height"] as? Int ?? 0,
//                                           
//                                           intencityMode: IntensityMode(rawValue: data["intencityMode"] as? String ?? "") ?? .RPE,
//                                           activityLevel: Intensity(rawValue: data["activityLevel"] as? String ?? "") ?? .low,
//                                           activityWeekGoal: data["activityWeekGoal"] as? Int ?? 0,
//                                           muscleTrainingLevel: Intensity(rawValue: data["muscleTrainingLevel"] as? String ?? "") ?? .low,
//                                           muscleWeekGoal: data["muscleWeekGoal"] as? Int ?? 0,
//                                           userInventoryList: (data["userInventoryList"] as? [String])?.compactMap { Inventory(rawValue: $0) } ?? [Inventory.none],
//                                           
//                                           startTrainingDate: data["startTrainingDate"] as? TimeInterval ?? 0,
//                                           updateTrainingDate: data["updateTrainingDate"] as? TimeInterval ?? 0,
//                                           trainingDay: data["trainingDay"] as? Int ?? 0,
//                                           daysOffset: data["daysOffset"] as? Int ?? 0,
//                                           activityOffset: data["acrivityOffset"] as? Int ?? 0,
//                                           activityDayGoal: data["activityDayGoal"] as? Int ?? 0,
//                                           activityWeekTime: data["activityWeekTime"] as? Int ?? 0,
//                                           activityDayTime: data["activityDayTime"] as? Int ?? 0,
//                                           muscleWeekProgress: data["muscleWeekProgress"] as? Int ?? 0,
//                                           todayActivity: getExerciseData(from: data["todayActivity"] as? [[String: Any]] ?? []),
//                                           activityWeekExercises: getExerciseData(from: data["activityWeekExercises"] as? [[String: Any]] ?? []),
//                                           muscleWeekExercises: getExerciseData(from: data["muscleWeekExercises"] as? [[String: Any]] ?? []),
//                                           muscleUsageList: (data["muscleUsageList"] as? [[String: Any]] ?? []).compactMap {
//                        guard
//                            let muscleGroupRawValue = $0["muscleGroup"] as? String,
//                            let muscleGroup = MuscleGroup(rawValue: muscleGroupRawValue),
//                            let load = $0["load"] as? Int
//                        else {
//                            return nil
//                        }
//                        
//                        return MuscleUsage(muscleGroup: muscleGroup, load: load)
//                    },
//                                           muscleWeekActivation: (data["muscleWeekActivation"] as? [[String: Any]] ?? []).compactMap {
//                        guard
//                            let muscleGroupRawValue = $0["muscleGroup"] as? String,
//                            let muscleGroup = MuscleGroup(rawValue: muscleGroupRawValue),
//                            let load = $0["load"] as? Int
//                        else {
//                            return nil
//                        }
//                        
//                        return MuscleUsage(muscleGroup: muscleGroup, load: load)
//                    },
//                                           exercicesList: getExerciseData(from: data["exercicesList"] as? [[String: Any]] ?? []),
//                                           savedTrainings: getTrainingData(from: data["savedTrainings"] as? [[String: Any]] ?? [])
//                    )
//                }
//            }
//        }
//        func loadFromUserDefaults() {
//            guard let data = UserDefaults.standard.data(forKey: "User") else {
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let loadedUser = try decoder.decode(UserModel.self, from: data)
//                user = loadedUser
//            } catch {
//                print("Ошибка при десериализации пользователей: \(error.localizedDescription)")
//            }
//        }
//        func getExerciseData(from dataArray: [[String: Any]]) -> [Exercise] {
//            return dataArray.compactMap { item in
//                return Exercise(
//                    name: item["name"] as? String ?? "error name",
//                    activityType: ActivityType(rawValue: item["activityType"] as? String ?? "Кардио"),
//                    inventoryNeeded: Inventory(rawValue: item["inventoryNeeded"] as? String ?? "Без инвентаря") ?? .none,
//                    expectedTime: item["expectedTime"] as? Int ?? 0,
//                    activeMuscles: (item["activeMuscles"] as? [[String: Any]] ?? []).compactMap { muscle in
//                        guard
//                            let muscleGroupRawValue = muscle["muscleGroup"] as? String,
//                            let muscleGroup = MuscleGroup(rawValue: muscleGroupRawValue),
//                            let load = muscle["load"] as? Int
//                        else {
//                            return nil
//                        }
//                        
//                        return MuscleUsage(muscleGroup: muscleGroup, load: load)
//                    },
//                    link: item["link"] as? String,
//                    isHiIntensity: item["isHiIntensity"] as? Bool ?? false,
//                    date: item["date"] as? TimeInterval ?? nil,
//                    isAvailable: item["isAvailable"] as? Bool ?? true,
//                    myRating: item["myRating"] as? Int ?? 0,
//                    complexity: Complexity(rawValue: item["complexity"] as? String ?? "Легко") ?? .easy
//                )
//            }
//        }
//        func getTrainingData(from dataArray: [[String: Any]]) -> [Training] {
//            return dataArray.compactMap { item in
//                return Training(
//                    id: item["id"] as? UUID ?? UUID(),
//                    name: item["name"] as? String ?? "error name",
//                    activityType: ActivityType(rawValue: item["activityType"] as? String ?? "Кардио") ?? .all,
//                    exercices: getExerciseData(from: item["exercices"] as? [[String: Any]] ?? []),
//                    exerciseTime: item["exerciseTime"] as? Int ?? 30,
//                    restTime: item["restTime"] as? Int ?? 15,
//                    myRating: item["myRating"] as? Int ?? 0,
//                    complexity: Complexity(rawValue: item["complexity"] as? String ?? "Легко") ?? .easy
//                )
//            }
//        }
//    }
//    
//    func logOut() {
//        do {
//            print("SAVE - logout")
//            saveUser()
//            try Auth.auth().signOut()
//        } catch {
//            print(error)
//        }
//    }
//    func saveUser() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).setData(user.asDictionary()) { error in
//            if let error = error {
//                saveToUserDefaults()
//                print("Error saving user data: \(error.localizedDescription)")
//            } else {
//                //print("User data saved successfully")
//            }
//        }
//        func saveToUserDefaults() {
//            do {
//                let encoder = JSONEncoder()
//                let data = try encoder.encode(user)
//                UserDefaults.standard.set(data, forKey: "User")
//            } catch {
//                print("Ошибка при сериализации пользователей: \(error.localizedDescription)")
//            }
//        }
//    }
//}
