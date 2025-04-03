import ProjectDescription

// 🔹 변수 정의
let projectName = "WebviewBase"
let bundleId = "com.template.\(projectName.lowercased())"

let project = Project(
    name: projectName,
    targets: [
        .target(
            name: projectName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
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
                    ],
                    "UIMainStoryboardFile": "" // ✅ 스토리보드 제거
                ]
            ),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "\(projectName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId)Tests",
            infoPlist: .default,
            sources: ["\(projectName)/Tests/**"],
            resources: [],
            dependencies: [.target(name: projectName)]
        ),
    ]
)
