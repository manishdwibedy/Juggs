//
//  SelectLanguageController.swift
//  Linq
//
//  Created by Quinton Askew on 12/9/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class SelectLanguageController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let languageArray = ["English", "Arabic", "Chinese Simplified", "Chinese Traditional", "Czech", "Danish", "Dutch", "Finnish", "French", "German", "Greek", "Hebrew", "Indonesian", "Itailian", "Japanese", "Korean", "Polish", "Portuguese", "Russian", "Spanish", "Swedish", "Turkish", "Ukrainian", "Vietnamese"]
    
    static var myLingo = "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        continueBtn.layer.masksToBounds = true
        continueBtn.layer.cornerRadius = 15
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var selectedLang = ""
        selectedLang = languageArray[row]
        SelectLanguageController.myLingo = selectedLang
        return selectedLang
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var selectedLang = ""
        selectedLang = languageArray[row]
        SelectLanguageController.myLingo = selectedLang
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowString = languageArray[row]
        let attributedString = NSAttributedString(string: rowString, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    

    
    
    
    func changeToLang(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let alert = UIAlertController(title: NSLocalizedString("restartTitle", comment: ""), message: NSLocalizedString("restart", comment: ""), preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: NSLocalizedString("close", comment: ""), style: .destructive) { _ in
                
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
            }
            
            let cancel = UIAlertAction(title:  NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
            
            alert.addAction(confirm)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        }else{
            
            if let initialViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") {
                present(initialViewController, animated: true, completion: nil)
            }
            
            
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectMyLanguage()
    {
        
        switch (SelectLanguageController.myLingo) {
            
        case "English":
            self.changeToLang("en")
        case "Arabic":
            self.changeToLang("ar")
        case "Chinese Simplified":
            self.changeToLang("zh-Hans")
        case "Chinese Traditional":
            self.changeToLang("zh-Hant")
        case "Czech":
            self.changeToLang("cs")
        case "Danish":
            self.changeToLang("da")
        case "Dutch":
            self.changeToLang("nl")
        case "Finnish":
            self.changeToLang("fi")
        case "French":
            self.changeToLang("fr")
        case "German":
            self.changeToLang("de")
        case "Greek":
            self.changeToLang("el")
        case "Hebrew":
            self.changeToLang("he")
        case "Indonesian":
            self.changeToLang("id")
        case "Itailian":
            self.changeToLang("it")
        case "Japanese":
            self.changeToLang("ja")
        case "Korean":
            self.changeToLang("ko")
        case "Polish":
            self.changeToLang("pl")
        case "Portuguese":
            self.changeToLang("pt")
        case "Russian":
            self.changeToLang("ru")
        case "Spanish":
            self.changeToLang("es")
        case "Swedish":
            self.changeToLang("sv")
        case "Turkish":
            self.changeToLang("tr")
        case "Ukrainian":
            self.changeToLang("uk")
        case "Vietnamese":
            self.changeToLang("vi")
        default:
            self.changeToLang("en")
        }
        
        let ud = UserDefaults.standard
        ud.set(true, forKey: "DisplayLingo")
        
    }
    
    @IBAction func continueToJugg(_ sender: Any) {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView(pickerView, didSelectRow: row, inComponent: 0)
        self.selectMyLanguage()
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

