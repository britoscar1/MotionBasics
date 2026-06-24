import Foundation
import CoreMotion

class MotionService{
    
    private let motionManager: CMMotionManager = CMMotionManager()
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "MotionQueue"
        return queue
    }()
    
    func startUpdates(
        onMotion: @escaping (Double, Double) -> Void,
        onError: @escaping (String) -> Void
    ){
        if self.motionManager.isDeviceMotionAvailable == false {
            onError("Motion data is not available on this device.")
            return
        }

        self.motionManager.deviceMotionUpdateInterval = 0.1
        self.motionManager.startDeviceMotionUpdates(to: queue) { data, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError("Unable to read motion data.")
                }
                return
            }

            guard let safeData = data else {
                return
            }

            let roll: Double = safeData.attitude.roll
            let pitch: Double = safeData.attitude.pitch

            DispatchQueue.main.async {
                onMotion(roll, pitch)
            }
        }
    }
    
    func stop(){
        self.motionManager.stopDeviceMotionUpdates()
    }
}







