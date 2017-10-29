import UIKit

class MasterViewController: UITableViewController {
    var json: [Dictionary<String,Any>] = []
    var failCount = 0
    
    
    var detailViewController: DetailViewController? = nil
    var objects = [CD]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.fetchJson();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        let cd = CD();
        cd.album = "New"
        cd.artist = "New"
        cd.year = "New"
        
        objects.insert(cd, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.currentIndex = indexPath.row
                controller.masterViewController = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        (cell.viewWithTag(201) as! UILabel).text = object.artist
        (cell.viewWithTag(202) as! UILabel).text = object.album
        (cell.viewWithTag(203) as! UILabel).text = object.year
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func fetchJson(){
        let url = URL(string:"https://isebi.net/albums.php");
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
            
            let json = (try! JSONSerialization.jsonObject(with: data!, options: []) as? [Dictionary<String,Any>])
            self.json = json != nil ? json! : []
            
            if (json == nil && self.failCount < 3) {
                self.failCount = self.failCount + 1
                self.fetchJson()
            }
            
            self.objects = self.parseCollection(json: self.json)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func parseCollection(json: [Dictionary<String,Any>]) -> [CD] {
        var collection:[CD] = [];
        for element in json {
            collection.append(CD(json:element))
        }
        return collection
    }
}

