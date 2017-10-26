//
//  DetailViewController.swift
//  CdViewerVol2
//
//  Created by Użytkownik Gość on 26.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var Artist: UITextField!
    
    @IBOutlet weak var Album: UITextField!
    
    @IBOutlet weak var Genre: UITextField!

    @IBOutlet weak var Year: UITextField!
    
    @IBOutlet weak var Tracks: UITextField!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.Artist.text = detail.artist
            self.Album.text = detail.album
            self.Genre.text = detail.genre
            self.Year.text = detail.year
            self.Tracks.text = detail.tracks
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: CD? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

