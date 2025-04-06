//
//  ViewController.swift
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webViews: [WKWebView] = [] {
        didSet {
            navBar.isHidden = webViews.count <= 1
            if navBar.isHidden == false {
                view.bringSubviewToFront(navBar)
            }
        }
    }
    var navBarHeight: CGFloat {
        get {
            let vwValue: CGFloat = 16
            let screenWidth = UIScreen.main.bounds.width
            let result = screenWidth * (vwValue / 100)

            return result
        }
    }
    let mainBound = UIScreen.main.bounds
    lazy var navigationBarHeight: CGFloat = {
        // 여기에 x 버튼 들어갈 뷰 height 더하기
        return self.view.safeAreaInsets.top + navBarHeight
    }()
    
    let safeAreaView = UIView()
    var mainWebView: WKWebView!
    let navBar = UIView()
    let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        clearWebViewCache()
        // Notification 수신 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setWebview()
        setLayout()
    }
    // 레이아웃 세팅
    private func setLayout() {
        // 1. Add subviews
        view.addSubview(navBar)
        navBar.addSubview(closeButton)
        view.addSubview(mainWebView)
        view.addSubview(safeAreaView)
        
        // 2. Configure views
        let image = UIImage(named: "icons-close-24-px")
        closeButton.setImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(destroyCurrentWebView), for: .touchUpInside)
        
        // 3. Disable autoresizing masks
        navBar.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        mainWebView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. Set layout constraints
        NSLayoutConstraint.activate([
            // navBar
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: navBarHeight),
            
            // closeButton
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 8),
            
            // mainWebView
            mainWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainWebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // safeAreaView
            safeAreaView.topAnchor.constraint(equalTo: view.topAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }

    private func setWebview() {
        let webConfiguration = WKWebViewConfiguration()
        
        // JavaScript 사용여부 설정
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        
        // WebView Bridge
        let contentController = WKUserContentController()
        
        
        // TODO: Xcode 콘솔에 console.log 출력 (필요시) - start
        /// JavaScript 코드를 주입하여 console.log 호출 감지 및 메시지 핸들러로 전달
        /// userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) 부분도 같이 주석 해제해야함
        
        //    let userScript = WKUserScript(source: """
        //            console.log = function(log) {
        //                window.webkit.messageHandlers.consoleLog.postMessage(log);
        //            };
        //            """, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        //
        //    contentController.addUserScript(userScript)
        //    contentController.add(self, name: "consoleLog")
        // TODO: Xcode 콘솔에 console.log 출력 (필요시) - end
        
        
        webConfiguration.userContentController = contentController
        
        mainWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        
        mainWebView.navigationDelegate = self
        mainWebView.uiDelegate = self
        webViews.append(mainWebView)
        
        
        // 웹뷰 뒤로가기 제스쳐
        mainWebView.allowsBackForwardNavigationGestures = true
        
        
        if let url = URL(string: <#Webview URL#>) {
            let request = URLRequest(url: url)
            // URL이 변경될 때마닥 감지해서 observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) 함수에 전달
            mainWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
            mainWebView.load(request)
        }
    }
    // KVO를 통한 URL 변경 감지 메서드
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            // URL이 변경되었을 때의 로직
            checkAndSetBadge()
        }
    }

    @objc func handleApplicationWillEnterForeground() {
        // applicationWillEnterForeground이 호출되면 여기에서 badge 제거 등의 작업 수행
        checkAndSetBadge()
    }
    
    // TODO: 뱃지 초기화 (필요시)
    // URL을 확인해서 "pushMessages/" 문자열이 포함되어 있으면 push badge 초기화 (해당 URL에 접속 시 모든 알림을 읽은 것으로 판단)
    func checkAndSetBadge() {
        if let currentURL = mainWebView.url?.absoluteString, currentURL.contains("pushMessages/") {
            setBadge()
        }
    }
    func setBadge() {
        if #available(iOS 17, *) {
            UNUserNotificationCenter.current().setBadgeCount(0) { error in
                guard let error else {
                    return
                }
                print("set badge error : \(error)")
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    // 웹 캐시 비우기
    func clearWebViewCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        
        let dateFrom = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom) {
        }
    }
    
    func createWebView(frame: CGRect, configuration: WKWebViewConfiguration) -> WKWebView {
        let webView = WKWebView(frame: frame, configuration: configuration)
        webView.uiDelegate = self // set delegate
        webView.navigationDelegate = self
        self.view.addSubview(webView) // 화면에 추가
        self.webViews.append(webView) // 웹뷰 목록에 추가
        
        return webView // 그 외 서비스 환경에 최적화된 뷰 설정하기
    }
    @objc func destroyCurrentWebView() {
        // 웹뷰 목록과 화면에서 제거하기
        self.webViews.popLast()?.removeFromSuperview()
    }
    @objc private func refreshWebView() {
        // mainWebView.scrollView.bounces = false 코드로 인해 비활성화 상태
        mainWebView.reload()
    }
}

// MARK: - WKNavigation Delegate

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 이동하는 페이지 url을 알고 싶으면 주석 해제
        // Log.d("url : \(String(describing: navigationAction.request.url))")
        
        // 전화걸기 버튼 (web에서 <a href="tel:전화번호"> 로 선언되어 있는 상태
        if let url = navigationAction.request.url, url.scheme == "tel" {
            // 전화 걸기를 처리합니다.
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel) // 전화 걸기 후에는 네비게이션을 취소합니다.
            } else {
                decisionHandler(.allow) // 전화 걸기를 처리할 수 없는 경우 계속 진행합니다.
            }
            return
        }
        
        
        // Check if the navigation action is a link click
        if navigationAction.navigationType == .linkActivated {
            // Open links with target="_blank" in a new tab
            if let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame {
                // The link has a target frame, so open it in the current webview
                decisionHandler(.allow)
            } else {
                // The link does not have a target frame, so open it in a new tab
                webView.load(navigationAction.request)
                decisionHandler(.cancel)
            }
            return
        } else {
            // Allow other types of navigation actions
            decisionHandler(.allow)
            return
        }
        
    }
    
}


// MARK: - WKUI Delegate

extension ViewController: WKUIDelegate {
    
    // javascript alert()
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
        completionHandler()
    }
    // JavaScript confirm()
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true)
    }
    // JavaScript prompt()
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard var frame = self.webViews.last?.frame else {
            return nil
        }
        return createWebView(frame: .init(x: 0, y: navigationBarHeight, width: mainBound.width, height: mainBound.height - navigationBarHeight), configuration: configuration)
    }
    func webViewDidClose(_ webView: WKWebView) {
        destroyCurrentWebView()
    }
}

// WebView <-----> javascript bridge
extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let name = message.name
        let body = message.body as? String
        
        // TODO: Xcode 콘솔에 console.log 출력 (필요시) - start
        //    if message.name == "consoleLog", let log = message.body as? String {
        //      // Xcode 콘솔에 JavaScript의 console.log 출력
        //      print("JavaScript Console: \(log)")
        //    }
        // TODO: Xcode 콘솔에 console.log 출력 (필요시) - end
    }
}
