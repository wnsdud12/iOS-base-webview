import ProjectDescription

let project = Project(
    name: "WebviewBase",
    targets: [
        .target(
            name: "WebviewBase",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.WebviewBase",
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["WebviewBase/Sources/**"],
            resources: ["WebviewBase/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "WebviewBaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.WebviewBaseTests",
            infoPlist: .default,
            sources: ["WebviewBase/Tests/**"],
            resources: [],
            dependencies: [.target(name: "WebviewBase")]
        ),
    ]
)
