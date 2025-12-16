import SwiftUI
import ApphudSDK
import ApphudBase

struct PaywallListView: View {
    @Environment(PurchaseManager.self) private var premium
    @Environment(\.dismiss) var dismiss
    @State var product: ApphudProduct?
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Image(".arrowLeft")
                        .standardImageStyle(color: .textPrimary)
                        .roundButton()
                }
                Spacer()
            }
            .overlay(content: {
                Text("Premium")
                    .font(.headline)
            })
            .padding(.bottom, 8)
            
            ForEach(premium.products, id: \.self) { product in
//                LineImageButtonView(image: .diamond, title: "\(product.fullPrice)", action: {
//                    self.product = product
//                })
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.bgPrimary)
        .fullScreenCover(item: $product, onDismiss: {
            if premium.isSubscribed {
                dismiss()
            }
        }, content: { product in
            PaywallView(currentProduct: product.getProductType(), isOB: false)
        })
    }
}

#Preview {
    PaywallListView()
        .environment(PurchaseManager.shared)
        .delayedAppearance(delay: 2.0)
}

