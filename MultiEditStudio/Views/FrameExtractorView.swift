import SwiftUI
import AVKit

struct FrameExtractorView: View {
    let videoURL: URL
    @State private var time: Double = 0.0
    @State private var extractedImage: UIImage? = nil
    @State private var player: AVPlayer? = nil
    @State private var videoDuration: Double = 30.0 // 默认时长
    @State private var isProcessing = false

    var body: some View {
        VStack(spacing: 20) {
            // 视频播放器
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 250)
                    .cornerRadius(10)
                    .onAppear {
                        player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
                        player.play()
                    }
            } else {
                Text("无法加载视频")
                    .foregroundColor(.red)
            }

            // 时间选择
            VStack {
                Text("选择时间（秒）")
                    .font(.headline)
                
                HStack {
                    Text("时间: \(String(format: "%.2f", time)) 秒")
                    Spacer()
                    Stepper(value: $time, in: 0...videoDuration, step: 0.1) {
                        Text("")
                    }
                }
                .padding(.horizontal)

                Button("提取帧") {
                    extractFrame()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isProcessing ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isProcessing)
            }
            .padding()

            // 显示提取的帧
            if let image = extractedImage {
                Text("帧提取成功")
                    .font(.subheadline)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("提取视频帧")
        .onAppear {
            loadVideoDuration()
        }
    }
    
    private func loadVideoDuration() {
        Task {
            player = AVPlayer(url: videoURL)
            guard let asset = player?.currentItem?.asset else { return }
            do {
                let duration = try await asset.load(.duration)
                videoDuration = CMTimeGetSeconds(duration)
            } catch {
                print("无法加载视频时长：\(error)")
                videoDuration = 30.0 // 默认时长
            }
        }
    }
    
    private func extractFrame() {
        guard let player = player else { return }
        isProcessing = true
        
        let generator = AVAssetImageGenerator(asset: player.currentItem?.asset ?? AVAsset(url: videoURL))
        generator.appliesPreferredTrackTransform = true

        let timeToExtract = CMTime(seconds: time, preferredTimescale: 600)
        
        DispatchQueue.global().async {
            do {
                let cgImage = try generator.copyCGImage(at: timeToExtract, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    self.extractedImage = uiImage
                    self.isProcessing = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("提取帧失败：\(error)")
                    self.isProcessing = false
                }
            }
        }
    }
}

