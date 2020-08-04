
import UIKit
//import SVProgressHUD

class ProductsTableViewController: UIViewController {

    // OUTLETS HERE

    @IBOutlet weak var tableview: UITableView!
    
    
    // VARIABLES HERE
    var viewModel = ProductsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = "Поиск"
        }
    
    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
//        self.viewModel.updateLoadingStatus = {
//            if self.viewModel.isLoading {
//                SVProgressHUD.show()
//            } else {
//                 SVProgressHUD.dismiss()
//            }
//        }

        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            // show UI Internet is disconnected
        }

        self.viewModel.serverErrorStatus = {
            print("Server Error / Unknown Error")
            // show UI Server is Error
        }
        
        self.viewModel.getTires {
            self.tableview.reloadData()
        }

    }
    
}

extension ProductsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "products", for: indexPath) as! ProductTableViewCell
        
        let data = self.viewModel.model[indexPath.row]
        
        
        cell.priceTxt.text = data.price
        cell.nameTxt.text = data.partName
        cell.modelTxt.text = data.model
        cell.statusTxt.text = data.status
        
        return cell
    }
    
   
    
    

}
