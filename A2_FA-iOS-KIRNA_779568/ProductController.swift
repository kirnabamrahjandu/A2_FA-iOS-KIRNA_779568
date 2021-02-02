//
//  ProductController.swift
//  A2_FA-iOS-KIRNA_779568
//
//  Created by user191875 on 2/2/21.
//

import UIKit
import CoreData
class ProductController: UITableViewController ,UISearchBarDelegate{
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products:[Product] = []
    var providers:[Provider] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProducts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func getProducts(){
        products = []
        products = try! context.fetch(Product.fetchRequest())

        tableView.reloadData()
    
}
    @IBAction func Add(_ sender: Any) {
        if Segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: self)
        }
        else{
            performSegue(withIdentifier: "addProvider", sender: self)
        }
    }


@IBAction func change(_ sender: Any) {
    if Segment.selectedSegmentIndex == 0{
        getProducts()
        SearchBar.isHidden = false
    }
    else{
        getProvider()
        SearchBar.isHidden = true
    }
    }
    func getProvider(){
        providers = []
        providers = try! context.fetch(Provider.fetchRequest())
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? String{
            if Segment.selectedSegmentIndex == 0{
                let vc = segue.destination as! FillProductTableViewController
                vc.selectedProduct = products[tableView.indexPathForSelectedRow!.row]
            }
            else{
                let vc = segue.destination as! FillProviderViewController
                vc.selectedProvider = providers[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
//Mark Table
    //  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
  //      return 0
  //  }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // #warning Incomplete implementation, return the number of rows
        if Segment.selectedSegmentIndex == 0{
            return products.count
        }
        else{
            return providers.count
        }
    }
    

    // "cell" call
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        if Segment.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                products[indexPath.row].productName
            cell.detailTextLabel?.text = products[indexPath.row].provider?.provider
        }
        else{
            cell.textLabel?.text =
                providers[indexPath.row].provider
            
        
            let req : NSFetchRequest<Product> = Product.fetchRequest()
            
            let productz = try! context.fetch(req)
            var count = 0
            for proz in productz{
                if proz.provider?.provider == providers[indexPath.row].provider{
                    count = count + 1
                }
            }
            cell.detailTextLabel?.text = count.description
        }
        
        return cell        // Configure the cell...

    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "FillProduct", sender: "me")
        }
        else{
            performSegue(withIdentifier: "FillProvider", sender: "me")
        }
    }
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if Segment.selectedSegmentIndex == 0{
                let pro = products[indexPath.row]
                context.delete(pro)
            }
            else{
                for prod in products{
                    if prod.provider == providers[indexPath.row]{
                        context.delete(prod)
                    }
                }
                let pro = providers[indexPath.row]
                context.delete(pro)
                
            }
            try! context.save()
            change(self)
            
        }
    }
    //search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "productName contains[c] '\(searchText)' || productDesc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                products = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            getProducts()
            
        }
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
