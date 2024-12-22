import SwiftUI
import AVKit

struct VideoEditorView: View {
    let videoURL: URL
    @StateObject private var viewModel = VideoEditorViewModel()
    @State private var selectedFilter: String = "None"
    @State private var startTime: Double = 0
    @State private var endTime: Double = 10
    @State private var isShowingShareSheet = false // 控制分享界面的弹出

    // 滤镜列表和汉字标签
    let availableFilters = [
        ("None", "无"),
        ("CISepiaTone", "复"),
        ("CIPhotoEffectNoir", "黑"),
        ("CIPhotoEffectChrome", "高"),
        ("CIPhotoEffectFade", "褪"),
        ("CIPhotoEffectInstant", "怀"),
        ("CIColorInvert", "反"),
        ("CIColorMonochrome", "单"),
        ("CIVignette", "暗")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // 视频播放器
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.horizontal)

                // 滤镜选择
                VStack {
                    Picker("滤镜", selection: $selectedFilter) {
                        ForEach(availableFilters, id: \.0) { filter, label in
                            Text(label).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    Button("应用滤镜") {
                        if selectedFilter != "None" {
                            viewModel.applyFilter(to: videoURL, filterName: selectedFilter)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedFilter == "None" ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isProcessing || selectedFilter == "None")
                }

                // 视频裁剪工具
                VStack(spacing: 10) {
                    HStack {
                        Text("开始: \(VideoUtils.formatTime(seconds: Int(startTime)))")
                        Slider(value: $startTime, in: 0...endTime, step: 1)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("结束: \(VideoUtils.formatTime(seconds: Int(endTime)))")
                        Slider(value: $endTime, in: startTime...30, step: 1)
                    }
                    .padding(.horizontal)

                    Button("裁剪视频") {
                        viewModel.trimVideo(sourceURL: videoURL, startTime: startTime, endTime: endTime)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isProcessing)
                }

                // 导出按钮
                if let output = viewModel.outputURL {
                    NavigationLink(destination: ExportView(exportedVideoURL: output)) {
                        Text("导出视频")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
        }
        .padding()
        .navigationTitle("视频编辑")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up") // 分享图标
                }
                .sheet(isPresented: $isShowingShareSheet) {
                    ShareSheet(activityItems: [videoURL])
                }
            }
        }
    }
}

