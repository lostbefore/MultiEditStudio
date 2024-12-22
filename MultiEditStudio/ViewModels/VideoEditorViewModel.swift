import Foundation
import AVFoundation
import CoreImage

class VideoEditorViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var outputURL: URL? = nil

    private let videoEditor = VideoEditor()
    
    // 裁剪视频方法
        func trimVideo(sourceURL: URL, startTime: Double, endTime: Double) {
            isProcessing = true
            let start = CMTime(seconds: startTime, preferredTimescale: 600)
            let end = CMTime(seconds: endTime, preferredTimescale: 600)
            
            videoEditor.trimVideo(sourceURL: sourceURL, startTime: start, endTime: end) { [weak self] output in
                DispatchQueue.main.async {
                    self?.isProcessing = false
                    self?.outputURL = output
                }
            }
        }
        
    
    func applyFilter(to videoURL: URL, filterName: String) {
        guard let filter = CIFilter(name: filterName) else {
            print("滤镜 \(filterName) 无法找到")
            return
        }
        isProcessing = true

        videoEditor.applyFilter(to: videoURL, filter: filter) { [weak self] output in
            DispatchQueue.main.async {
                self?.isProcessing = false
                self?.outputURL = output
            }
        }
    }
}

