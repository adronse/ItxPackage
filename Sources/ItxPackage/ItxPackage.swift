// Sources/MySwiftPackage/MySwiftPackage.swift

import SwiftUI

public struct MySwiftPackage: View {
    
    @available(iOS 13.0.0, *)
    public var body: some View {
        VStack {
            Text("Need help ?")
                .font(.title)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray)
                .padding(.vertical, 10)
            
            Button(action: {
                // Handle report bug button tapped
            }) {
                VStack {
                    Text("Report a bug")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Something in the app is broken or doesn't work as expected")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray)
                .padding(.vertical, 10)
            
            Button(action: {
                // Handle suggest improvement button tapped
            }) {
                VStack {
                    Text("Suggest an improvement")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("New ideas or desired enhancements for this app")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Handle cancel button tapped
            }) {
                Text("Cancel")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color("#41403F")))
        .frame(width: 300, height: 200)
    }
}
