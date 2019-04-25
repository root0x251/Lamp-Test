//
//  DetailViewController.swift
//  Lamp Test
//
//  Created by Вячеслав Алексеевич on 24/04/2019.
//  Copyright © 2019 Бортниченко Вячеслав Алексеевич. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    var testStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.text = testStr
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
