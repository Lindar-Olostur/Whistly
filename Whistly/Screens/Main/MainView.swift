import SwiftUI
import StoreKit

struct MainView: View {
    @Environment(\.openURL) var openURL
    @Environment(MainContainer.self) private var viewModel
    @AppStorage("shouldShowRateAlert") private var shouldShowRateAlert = true
    @AppStorage("shouldShowReviewAlert") private var shouldShowReviewAlert = true
    @State private var showAppStoreAlert = false
    @State private var shownAskReview = false
    @State private var triggerActionToReview = false
    
    
    @State private var showFileImport = false
    @State private var tuneType: TuneType = .unknown
    
    var body: some View {
        VStack(spacing: 16, content: {
            HStack {
                Text("Cooley's")
                    .font(.headline).bold()//TODO name
                Menu {
                    ForEach(TuneType.allCases, id: \.self) { type in
                        Button {
                            tuneType = type
                        } label: {
                            Text(type.rawValue)
                        }
                    }
                } label: {
                    Text(tuneType.rawValue)//TODO type
                        .font(.headline).bold()
                        .foregroundStyle(tuneType == .unknown ? .accentPrimary :  .white)
                }

                Spacer()
                Menu {
//                    Button { //TODO in settings
//                        // TODO Auth
//                    } label: {
//                        Text("Sign/Log in")
//                        Image(systemName: "person.circle")
//                    }
                    Button {
                        // TODO Import
                    } label: {
                        Text("Import ABC")
                        Image(systemName: "square.and.arrow.down")
                    }
                    Button {
                        // TODO Save/Load Tunes
                    } label: {
                        Text("Open Tune")
                        Image(systemName: "music.note")
                    }
                    Button {
                        // TODO Save/Load Sets
                    } label: {
                        Text("Open Set")
                        Image(systemName: "music.note.list")
                    }
                    Button {
                        // TODO Settings
                    } label: {
//                        Text("Settings")
                        Image(systemName: "gearshape.fill")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
            Spacer()
        })
        .padding(.horizontal, 16)
        .background(BackgroundView())
        .onChange(of: triggerActionToReview, {
            if viewModel.premium.isSubscribed && shouldShowReviewAlert {
                shownAskReview.toggle()
            }
        })
        .alert("Do you like the app?", isPresented: $shownAskReview) {
            Button("No") {
                shouldShowReviewAlert = false
            }
            Button("Yes") {
                showAppStoreAlert = true
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("We Appreciate Your Feedback")
        }
        .alert("Please leave a review", isPresented: $showAppStoreAlert) {
            Button("Go to AppStore") {
                shouldShowReviewAlert = false
                openURL(URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")!)
            }
        } message: {
            Text("Positive reviews are a powerful motivation for us to excel")
        }
    }
}

#Preview {
    MainView()
        .environment(MainContainer())
}

