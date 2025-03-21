// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "HealthAssistant",
    dependencies: [
        // Add your own dependencies here:
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            exact: "11.10.0"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire",
            exact: "5.10.2"
        ),
    ]
)
