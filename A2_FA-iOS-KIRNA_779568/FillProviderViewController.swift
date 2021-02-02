//
//  FillProviderViewController.swift
//  A2_FA-iOS-KIRNA_779568
//
//  Created by user191875 on 2/2/21.
//

import UIKit
import CoreData
class FillProviderViewController: UIViewController {
    let context =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var ProviderField: UITextField!
    var selectedProvider : Provider?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sr = selectedProvider{
            ProviderField.text = sr.provider
        }



    }
    

    @IBAction func save(_ sender: Any) {
        if let sr = selectedProvider{
            sr.provider = ProviderField.text
        }
        else{
            let req : NSFetchRequest<Provider> = Provider.fetchRequest()
            req.predicate = NSPredicate(format: "provider = '\(ProviderField.text!)'")
            let storeProvider = try! context.fetch(req)
            if storeProvider.count == 0{
                let provid = Provider(context: context)
                provid.provider = ProviderField.text
                
                ProviderField.text = nil
            }
        }
        
        try! context.save()
    }
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


