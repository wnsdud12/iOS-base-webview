//
//  SplashViewController.swift
//

import UIKit

class SplashViewController: UIViewController {

    let label: UILabel = {
        let _label = UILabel()
        _label.text = "Splash"
        _label.textAlignment = .center
        _label.font = .systemFont(ofSize: 16)
        _label.textColor = .black
        return _label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let nextVC = ViewController()
        // splash를 1초 보여준 후 메인화면(웹뷰)으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.navigationController?.setViewControllers([nextVC], animated: true)
        }
    }
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
