import AVFoundation
import CoreImage

class VideoEditor {
    private let context = CIContext()
    
    func trimVideo(sourceURL: URL, startTime: CMTime, endTime: CMTime, completion: @escaping (URL?) -> Void) {
            let asset = AVAsset(url: sourceURL)
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
                completion(nil)
                return
            }
            
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("trimmedVideo.mov")
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mov
            exportSession.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
            
            exportSession.exportAsynchronously {
                if exportSession.status == .completed {
                    completion(outputURL)
                } else {
                    completion(nil)
                }
            }
        }
    
    func applyFilter(to videoURL: URL, filter: CIFilter, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let composition = AVVideoComposition(asset: asset) { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            if let output = filter.outputImage {
                let croppedOutput = output.cropped(to: request.sourceImage.extent)
                request.finish(with: croppedOutput, context: self.context)
            } else {
                request.finish(with: NSError(domain: "com.MultiEditStudio", code: -1, userInfo: nil))
            }
        }

        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("filteredVideo.mov")
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = outputURL
        exporter?.outputFileType = .mov
        exporter?.videoComposition = composition

        exporter?.exportAsynchronously {
            if exporter?.status == .completed {
                completion(outputURL)
            } else {
                completion(nil)
            }
        }
    }
}

