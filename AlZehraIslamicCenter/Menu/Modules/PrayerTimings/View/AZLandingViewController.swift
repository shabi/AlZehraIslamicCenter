//
//  AZLandingViewController.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 23/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController



class AZLandingViewController: UIViewController {
    
    @IBOutlet weak var imsaak: UILabel!
    @IBOutlet weak var fajr: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var dhuhr: UILabel!
    @IBOutlet weak var asr: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var maghrib: UILabel!
    @IBOutlet weak var isha: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var sendNotification: UIButton!
    var prayerTimingViewModel: AZPrayerTimingViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = AZUtility.getCurrentDayMonthYear()
        self.currentDate.text = "\(currentDate.day)" + "/" + "\(currentDate.month)" + "/" + "\(currentDate.year)"
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Prayer Timings"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
 
        self.prayerTimingViewModel = AZPrayerTimingViewModel(viewController: self as ViewController)
        self.prayerTimingViewModel?.fetchPrayerTimingInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sendNotification.isHidden = true
        if Keychain.loadValueFromKeychain(key: Constants.KeyChain.role) == "SuperAdmin" || Keychain.loadValueFromKeychain(key: Constants.KeyChain.role) == "Admin" {
            self.sendNotification.isHidden = false
        }
    }
    
    @IBAction func qiblaFinderAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://qiblafinder.withgoogle.com/intl/en/finder/ar")!)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://console.firebase.google.com/u/2/project/al-zahra-fe086/notification/compose")!)
    }
    
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension AZLandingViewController: ViewController {

    func updateView() {
        print("updateView")
        
        if let info = self.prayerTimingViewModel?.prayerTimingModel {
            self.imsaak.text = info.imsaak
            self.fajr.text = info.fajr
            self.sunrise.text = info.sunrise
            self.dhuhr.text = info.dhuhr
            self.asr.text = info.asr
            self.sunset.text = info.sunset
            self.maghrib.text = info.maghrib
            self.isha.text = info.isha

        }
    }
}
