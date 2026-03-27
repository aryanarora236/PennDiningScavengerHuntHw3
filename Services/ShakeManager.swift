import Combine
import CoreMotion
import Foundation

@MainActor
final class ShakeManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published private(set) var shakeCount: Int = 0

    private var lastShakeDate = Date.distantPast
    private let threshold: Double = 2.25
    private let cooldownSeconds: TimeInterval = 1.0

    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else {
            return
        }
        guard !motionManager.isAccelerometerActive else {
            return
        }

        motionManager.accelerometerUpdateInterval = 0.12
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, _ in
            guard let self, let data else {
                return
            }

            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            let magnitude = sqrt((x * x) + (y * y) + (z * z))
            let shakeStrength = abs(magnitude - 1.0)

            guard shakeStrength > self.threshold else {
                return
            }

            let now = Date()
            guard now.timeIntervalSince(self.lastShakeDate) > self.cooldownSeconds else {
                return
            }
            self.lastShakeDate = now

            Task { @MainActor in
                self.shakeCount += 1
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
    }
}
