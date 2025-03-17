// Health Assistant App
// Copyright ACME Corporation
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let project = Project(
    name: "HealthAssistant",
    targets: [
        .target(
            name: "HealthAssistant",
            destinations: .iOS,
            product: .app,
            bundleId: "com.acme.HealthAssistant",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["HealthAssistant/Sources/**"],
            resources: ["HealthAssistant/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "HealthAssistantTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.acme.HealthAssistantTests",
            infoPlist: .default,
            sources: ["HealthAssistant/Tests/**"],
            resources: [],
            dependencies: [.target(name: "HealthAssistant")]
        ),
    ]
)
