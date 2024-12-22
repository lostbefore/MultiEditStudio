import Foundation
import UIKit

class ExportViewModel: ObservableObject {
    @Published var isExporting = false
    @Published var exportComplete = false
    @Published var exportURL: URL? = nil
    
    func exportVideo(_ videoURL: URL, completion: @escaping (Bool) -> Void) {
        isExporting = true
        
        // Simulate exporting (replace with actual logic)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async { [weak self] in
                self?.isExporting = false
                self?.exportComplete = true
                self?.exportURL = videoURL
                completion(true)
            }
        }
    }
    
    func shareVideo(from viewController: UIViewController, videoURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        viewController.present(activityVC, animated: true, completion: nil)
    }
}

