import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var Artist: UITextField!
    
    @IBOutlet weak var Album: UITextField!
    
    @IBOutlet weak var Genre: UITextField!
    
    @IBOutlet weak var Year: UITextField!
    
    @IBOutlet weak var Track: UITextField!
    
    var detailItem: CD? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    var currentIndex = 0
    var masterViewController: MasterViewController?
    
    @IBOutlet weak var SaveButton: UIButton!
    
    
    func inputChanged(textField: UITextField) {
        self.SaveButton!.isEnabled = true
    }
    @IBAction func SaveAction(_ sender: Any) {
        let cd: CD = self.masterViewController!.objects[self.currentIndex]
        cd.album = self.Album.text!
        cd.artist = self.Artist.text!
        cd.genre = self.Genre.text!
        cd.year = self.Year.text!
        cd.tracks = self.Track.text!
        self.masterViewController!.tableView.reloadData()
        self.configureView()
    }
    
    func initHandleInputChange() {
        self.Album.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
        self.Artist.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
        self.Genre.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
        self.Year.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
        self.Track.addTarget(self, action: #selector(inputChanged(textField:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    func configureView() {
        let detail: CD
        if (self.currentIndex >= 0 && self.currentIndex < self.masterViewController!.objects.count ) {
            detail     = self.masterViewController!.objects[self.currentIndex]
            self.title = "Edycja rekordu \(self.currentIndex + 1) z \(self.masterViewController!.objects.count)"
        } else {
            detail = CD()
            detail.album = "New"
            detail.artist = "New"
            detail.year = "New"
            self.masterViewController!.objects.append(detail)
            self.title = "Nowy Rekord"
        }
        
        self.Artist.text = detail.artist
        self.Album.text = detail.album
        self.Genre.text = detail.genre
        self.Year.text = detail.year
        self.Track.text = detail.tracks
        
        self.SaveButton.isEnabled = false
        initHandleInputChange()
        self.masterViewController!.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteButton = UIBarButtonItem(title: "delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteAction))
        
        navigationItem.rightBarButtonItem = deleteButton
        self.configureView()
    }
    
    func deleteAction(){
        if (self.masterViewController!.objects.count > 0 && self.currentIndex < self.masterViewController!.objects.count) {
            self.masterViewController!.objects.remove(at: self.currentIndex)
            if (self.currentIndex > 0 ){
                self.currentIndex = self.currentIndex - 1
            }
            self.masterViewController!.tableView.reloadData()
            self.configureView()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

