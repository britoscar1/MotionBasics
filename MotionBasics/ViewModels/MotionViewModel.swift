import Foundation
import Combine

@MainActor
class MotionViewModel: ObservableObject{
    
    @Published var rollDegrees: Double = 0
    @Published var pitchDegrees: Double = 0
    @Published var isRunning: Bool = false
    @Published var statusText: String = "Stopped"
    @Published var tiltText: String = "LEVEL"
    @Published var errorMessage: String = ""
    
    var motion: MotionService = MotionService()
    let threshold: Double = 7.0
    let deadZone: Double = 1.0
    
    func start(){
        if isRunning {
            return
        }

        errorMessage = ""
        isRunning = true
        statusText = "Running"

        motion.startUpdates(onMotion: {(roll: Double, pitch: Double) in
            let rollInDegrees: Double = roll * 180 / .pi
            let pitchInDegrees: Double = pitch * 180 / .pi

            self.rollDegrees = rollInDegrees
            self.pitchDegrees = pitchInDegrees
            self.updateTiltText()
        }, onError: {(message: String) in
            self.errorMessage = message
            self.isRunning = false
            self.statusText = "Stopped"
        })
    }
    
    func stop(){
        motion.stop()
        isRunning = false
        statusText = "Stopped"
    }
    
    func updateTiltText() {
        let rollAbs = abs(rollDegrees)
        let pitchAbs = abs(pitchDegrees)

        if rollAbs <= threshold && pitchAbs <= threshold {
            tiltText = "LEVEL"
            return
        }

        if rollAbs <= threshold + deadZone && pitchAbs <= threshold + deadZone {
            return
        }

        tiltText = "TILTED"
    }

    func reset() {
        rollDegrees = 0
        pitchDegrees = 0
        errorMessage = ""
        if isRunning {
            updateTiltText()
        } else {
            tiltText = "LEVEL"
        }
    }
}
