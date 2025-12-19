import SwiftUI
import UniformTypeIdentifiers

struct TuneManagerView: View {
    @Environment(MainContainer.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPicker = false
    @State private var importError: String?
    @State private var showError = false
    @State private var isLoading = false
    var onTuneImported: ((TuneModel) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                }
                Spacer()
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 20))
                }
            }
            ForEach(viewModel.storage.tunesCache, id: \.id) { tune in
                HStack(spacing: 8) {
                    Text(tune.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(tune.tuneType == .unknown ? "" : tune.tuneType.rawValue)
                }
                .onTapGesture {
                    viewModel.storage.loadTune(tune, into: viewModel.sequencer)
                    dismiss()
                }
                //TODO
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background {
            BackgroundView()
        }
#if os(iOS)
        .sheet(isPresented: $showPicker) {
            DocumentPicker(
                allowedContentTypes: [
                    UTType(filenameExtension: "abc") ?? .data
                ],
                onDocumentPicked: { url in
                    isLoading = true
                    DispatchQueue.global(qos: .userInitiated).async {
                        let tune = viewModel.storage.importFile(from: url)
                        DispatchQueue.main.async {
                            isLoading = false
                            if let tune = tune {
                                viewModel.storage.loadTune(tune, into: viewModel.sequencer)
                                onTuneImported?(tune)
                                dismiss()
                            } else {
                                importError = "Can't load file"
                                showError = true
                            }
                        }
                    }
                }
            )
        }
#elseif os(macOS)
        .fileImporter(
            isPresented: $showPicker,
            allowedContentTypes: [
                UTType(filenameExtension: "abc") ?? .data
            ],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                isLoading = true
                DispatchQueue.global(qos: .userInitiated).async {
                    let tune = viewModel.storage.importFile(from: url)
                    DispatchQueue.main.async {
                        isLoading = false
                        if let tune = tune {
                            viewModel.storage.loadTune(tune, into: viewModel.sequencer)
                            onTuneImported?(tune)
                            dismiss()
                        } else {
                            importError = "Can't load file"
                            showError = true
                        }
                    }
                }
            case .failure:
                importError = "Can't open file"
                showError = true
            }
        }
    #endif
    }
}

#Preview {
    TuneManagerView()
        .environment(MainContainer())
}
