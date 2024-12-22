import SwiftUI
import PhotosUI
import AVFoundation

struct HomeView: View {
    @State private var selectedVideo: URL? = nil
    @State private var isVideoPickerPresented = false
    @State private var isCameraPresented = false
    @State private var showActionSheet = false
    @State private var isShowingInfo = false // 控制信息视图的弹出
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("欢迎来到\nMulti-Edit Studio")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    showActionSheet.toggle()
                }) {
                    Text("选择视频")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("选择视频来源"),
                        message: nil,
                        buttons: [
                            .default(Text("从相册选择")) {
                                isVideoPickerPresented = true
                            },
                            .default(Text("录制视频")) {
                                isCameraPresented = true
                            },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $isVideoPickerPresented) {
                    VideoPicker(selectedVideo: $selectedVideo)
                }
                .fullScreenCover(isPresented: $isCameraPresented) {
                    CameraRecorderView(selectedVideo: $selectedVideo)
                }
                
                if let videoURL = selectedVideo {
                    NavigationLink(destination: VideoEditorView(videoURL: videoURL)) {
                        Text("编辑视频")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: GIFCreatorView(videoURL: videoURL)) {
                        Text("视频转 GIF")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: FrameExtractorView(videoURL: videoURL)) {
                        Text("提取视频帧")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .navigationTitle("主页")
            
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isShowingInfo.toggle()
                                }) {
                                    Image(systemName: "info.circle") // 使用系统图标表示信息
                                }
                            }
                        }
                        .sheet(isPresented: $isShowingInfo) {
                            CreatorInfoView() // 弹出制作者信息视图
                        }
        }
    }
}

