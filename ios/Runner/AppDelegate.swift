import UIKit
import Flutter
import FirebaseCore
import flutter_downloader

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()

    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set the downloader plugin callback
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Required for flutter_downloader background isolates
private func registerPlugins(registry: FlutterPluginRegistry) {
  if !registry.hasPlugin("FlutterDownloaderPlugin") {
    FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
  }
}
