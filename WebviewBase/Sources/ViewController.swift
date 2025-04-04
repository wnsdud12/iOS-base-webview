//
//  ViewController.swift
//

import UIKit

class ViewController: UIViewController {

    let label: UILabel = {
        let _label = UILabel()
        _label.text = "Main"
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
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

}

