import AVFoundation
import UIKit
import ImageIO
import UniformTypeIdentifiers

class GIFGenerator {
    func createGIF(from videoURL: URL, startTime: TimeInterval, duration: TimeInterval, frameRate: Int, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        
        asset.loadTracks(withMediaType: .video) { tracks, error in
            guard let videoTrack = tracks?.first else {
                completion(nil)
                return
            }
            
            let reader = try? AVAssetReader(asset: asset)
            let outputSettings: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            
            let trackOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
            reader?.add(trackOutput)
            reader?.startReading()
            
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.gif")
            guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, UTType.gif.identifier as CFString, 0, nil) else {
                completion(nil)
                return
            }
            
            let frameDuration = 1.0 / Double(frameRate)
            var time = startTime
            
            while reader?.status == .reading {
                guard let sampleBuffer = trackOutput.copyNextSampleBuffer(),
                      let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { break }
                
                let ciImage = CIImage(cvPixelBuffer: imageBuffer)
                let uiImage = UIImage(ciImage: ciImage)
                
                let gifProperties: [CFString: Any] = [
                    kCGImagePropertyGIFDelayTime: frameDuration
                ]
                let frameProperties: [CFString: Any] = [
                    kCGImagePropertyGIFDictionary: gifProperties
                ]
                
                CGImageDestinationAddImage(destination, uiImage.cgImage!, frameProperties as CFDictionary)
                time += frameDuration
            }
            
            CGImageDestinationFinalize(destination)
            completion(outputURL)
        }
    }
}

