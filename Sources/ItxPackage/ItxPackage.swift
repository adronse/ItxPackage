import SwiftUI

public struct MySwiftPackage: View {
    @available(iOS 13.0.0, *)
    public var body: some View {
        Text("Hello, World!")
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: UIScreen.capturedDidChangeNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    // Your logic for handling screenshot here
                    ScreenshotObserver.detectScreenshot()
                }
            }
    }
}

public class ScreenshotObserver {
    @objc static func detectScreenshot() {
        // Handle screenshot detection
        print("Screenshot detected!")
    }
}

struct MySwiftUIView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        VStack(spacing: 20) {
                    Text("Need help ?")
                        .foregroundColor(.white)
                        .font(.title)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray)
                    
                    // Add your buttons and UI components here
                    
                    Spacer()
                    
                    Button(action: {
                        // Dismiss the SwiftUI view if needed
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(width: 300, height: 200)
                .background(Color(UIColor.from(hex: "#41403F", alpha: 1)))
                .cornerRadius(8)
    }
}
