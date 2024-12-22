import SwiftUI
import AVFoundation

struct GIFCreatorView: View {
    let videoURL: URL
    @State private var frameRate: Double = 10
    @State private var duration: Double = 5
    @State private var isProcessing = false
    @State private var gifURL: URL? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("视频转 GIF")
                .font(.headline)
                .padding()
            
            HStack {
                Text("帧率: \(Int(frameRate)) fps")
                Slider(value: $frameRate, in: 1...30, step: 1)
            }
            .padding()
            
            HStack {
                Text("持续时间: \(Int(duration)) 秒")
                Slider(value: $duration, in: 1...30, step: 1)
            }
            .padding()
            
            Button("生成 GIF") {
                isProcessing = true
                let gifGenerator = GIFGenerator()
                gifGenerator.createGIF(from: videoURL, startTime: 0, duration: duration, frameRate: Int(frameRate)) { output in
                    DispatchQueue.main.async {
                        isProcessing = false
                        gifURL = output
                    }
                }
            }
            .padding()
            .background(isProcessing ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isProcessing)
            
            if let gif = gifURL {
                Text("GIF 生成完成！")
                Button("查看 GIF") {
                    // 打开 GIF 文件
                    UIApplication.shared.open(gif)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("视频转 GIF")
    }
}

