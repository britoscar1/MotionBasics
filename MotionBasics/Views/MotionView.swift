import SwiftUI

struct MotionView: View{
    
    @StateObject var viewModel: MotionViewModel = MotionViewModel()
    
    var body: some View {
        VStack(spacing: 24){
            Text("Is Tilted?")
                .font(.title)

            Text("Hold your device flat and watch the tilt status.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Text(viewModel.tiltText)
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(viewModel.tiltText == "LEVEL" ? .green : .orange)

            Text(viewModel.statusText)
                .font(.headline)

            if viewModel.errorMessage.isEmpty == false {
                Text(viewModel.errorMessage)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing:12){
                Button(
                    action: {
                        viewModel.start()
                    },
                    label: {
                        Text("Start")
                            .frame(maxWidth: .infinity)
                    }
                ).buttonStyle(.borderedProminent)
                
                Button(
                    action: {
                        viewModel.stop()
                    },
                    label: {
                        Text("Stop")
                            .frame(maxWidth: .infinity)
                    }
                ).buttonStyle(.borderedProminent)
            }
            .padding()
            
            VStack(spacing: 12){
                Text("Roll: \(String(format: "%.1f", viewModel.rollDegrees))°")
                Text("Pitch: \(String(format: "%.1f", viewModel.pitchDegrees))°")
            }

            Button("Reset") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    MotionView()
}



