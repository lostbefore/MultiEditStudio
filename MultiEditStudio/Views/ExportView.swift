import SwiftUI
import MobileCoreServices

struct ExportView: View {
    let exportedVideoURL: URL
    @State private var exportComplete = false
    @State private var isShowingShareSheet = false

    var body: some View {
        VStack(spacing: 20) {
            if exportComplete {
                Text("导出成功!")
                    .font(.title)
                    .padding()
            } else {
                Text("导出视频中...")
                    .font(.headline)
                    .padding()
            }
            
            Button("分享") {
                isShowingShareSheet = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
            .sheet(isPresented: $isShowingShareSheet) {
                ShareSheet(activityItems: [exportedVideoURL])
            }
            
            Button("返回主页面") {
                // Add navigation logic here if needed
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("导出视频")
        .onAppear {
            // 模拟导出完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                exportComplete = true
            }
        }
    }
}

