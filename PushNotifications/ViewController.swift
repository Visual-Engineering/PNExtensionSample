//
//  ViewController.swift
//  PushNotifications
//
//  Created by Alba Luján on 31/5/17.
//  Copyright © 2017 Alba Luján. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let switchButton: UISwitch = {
        let switchBT = UISwitch()
        switchBT.isOn = false
        switchBT.setOn(true, animated: false)
        switchBT.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return switchBT
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = "Do you want to enable custom push notifications?"
        lbl.textAlignment = .center
        lbl.font = lbl.font.withSize(24)
        return lbl
    }()
    
    let userDefaults = UserDefaults(suiteName: "group.com.pushNotifications")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let enabledNotif = userDefaults?.object(forKey: "enabledNotif") {
            self.switchButton.isOn = enabledNotif as! Bool
        }
        else {
        switchButton.isOn = false
        }
        
        view.addSubview(switchButton)
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 50).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 50).isActive = true
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func switchValueDidChange(sender: UISwitch) {
        userDefaults?.setValue(sender.isOn, forKey: "enabledNotif")
        userDefaults?.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

