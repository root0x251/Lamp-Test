//
//  ViewController.swift
//  Lamp Test
//
//  Created by Вячеслав Алексеевич on 24/04/2019.
//  Copyright © 2019 Бортниченко Вячеслав Алексеевич. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // color
    lazy var mainColor = UIColor(red: 221/250.0, green: 177/255.0, blue: 97/255.0, alpha: 1)
    lazy var cellBGColor = UIColor(red: 101/250.0, green: 111/255.0, blue: 130/255.0, alpha: 1)
    
    // tableview
    @IBOutlet weak var mainTableView: UITableView!
    let identifier = "Cell"
    
    // URL
    lazy var strURL = URL(string: "http://lamptest.ru/led.csv")!
    
    // class obj
    var arrayOfLamp = [LampObj]()
    
    // users default
    var userDefaultsArrayLamp = UserDefaults()
    
    // activity indicator
    let activityIndicator = UIActivityIndicatorView()
    
    // pull to refresh
    lazy var refreshControl = UIRefreshControl()
    
    // search controller
    let searchController = UISearchController(searchResultsController: nil)
    var filteretLamp = [LampObj]()
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nib
        mainTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        // activity indicator
        activityIndicator.frame = view.bounds
        activityIndicator.style = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // user defauls
        if let data = userDefaultsArrayLamp.object(forKey: "Lamp") as? Data {
            // caceh
            self.arrayOfLamp = try! PropertyListDecoder().decode(Array<LampObj>.self, from: data)
            //stop activiti indicator
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        } else {
            // load data from server
            loadData()
        }
        // Puul to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: mainColor])
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = mainColor
        mainTableView.addSubview(refreshControl)
        
        // setup SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск модели"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Pull to refresh
    @objc func refresh() {
        print(arrayOfLamp.count)
        loadData()
        mainTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - LoadDAta From Server
    func loadData() {
        URLSession.shared.dataTask(with: strURL) { (data, response, error) in
            let responseHeader = response as? HTTPURLResponse
            if responseHeader?.statusCode != 200 {
                print("error")
                self.alertError(title: "Ooopse", message: "Something wrong", button: "WTF")
            } else {
                let loadData = String(data: data!, encoding: .windowsCP1251)
                var rows = loadData!.components(separatedBy: "\n")
                rows.removeFirst()  // del title
                rows.removeLast()   // why nil??
                rows.reverse()      // revers
                
                // check
                if rows.count <= self.arrayOfLamp.count {
                    // okk
                    self.alertError(title: "", message: "You have the latest database", button: "OK")
                } else {
                    
                    // clear user defaults
                    self.userDefaultsArrayLamp.removeObject(forKey: "Lamp")
                    
                    for obj in rows {
                        let item = obj.components(separatedBy: ";")
                        self.arrayOfLamp.append(LampObj(no: item[0], brand: item[1], model: item[2],
                                                        power_l: item[3], matt: item[4], dim: item[5],
                                                        color_l: item[6], lm_l: item[7], eq_l: item[8],
                                                        ra_l: item[9], u: item[10], life: item[11],
                                                        war: item[12], prod: item[13], d: item[14],
                                                        h: item[15], w: item[16], barcode: item[17],
                                                        base: item[18], shape: item[19], type: item[20],
                                                        type2: item[21], url: item[22], shop: item[23],
                                                        rub: item[24], usd: item[25], reserve1: item[26],
                                                        reserve2: item[27], p: item[28], pf: item[29],
                                                        lm: item[30], color: item[31], cri: item[32],
                                                        r9: item[33], Rf: item[34], Rg: item[35],
                                                        flicker: item[36], angle: item[37], switchLP: item[38],
                                                        umin: item[39], drv: item[40], tmax: item[41],
                                                        date: item[42], instruments: item[43], add2: item[44],
                                                        add3: item[45], add4: item[46], add5: item[47],
                                                        cqs: item[48], eq: item[49], rating: item[50],
                                                        act: item[51], lamp_image: item[52], lamp_desc: item[53]))
                    }
                }
                DispatchQueue.main.sync {
                    // add to cache
                    self.userDefaultsArrayLamp.set(try? PropertyListEncoder().encode(self.arrayOfLamp), forKey: "Lamp")
                    
                    self.mainTableView.reloadData()
                    //stop activiti indicator
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
            }
        }
        .resume()
    }
    
}

// MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteretLamp.count
        } else {
            return arrayOfLamp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
        var item: LampObj
        if isFiltering {
            item = filteretLamp[indexPath.row]
        } else {
            item = arrayOfLamp[indexPath.row]
        }
        
        // cell bg color
        let bgColorView = UIView()
        bgColorView.backgroundColor = cellBGColor
        cell.selectedBackgroundView = bgColorView
        
        cell.testLabel.text = item.brand
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexCell = mainTableView.indexPathForSelectedRow!
        let item = arrayOfLamp[indexCell.row]
        let detailVC = segue.destination as! DetailViewController
        detailVC.testStr = item.brand
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: self)
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Alert
extension ViewController: UIAlertViewDelegate {
    func alertError(title: String, message: String, button: String) {
        DispatchQueue.main.async { [weak self] in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: button, style: .cancel, handler: { (UIAlertAction) in
                self!.stopRefresh()
            }))
            self!.present(alertVC, animated: true, completion: nil)
        }
    }
    func stopRefresh() {
        self.refreshControl.endRefreshing()
    }
    
}

// MARK: - Search Bar
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(searchController.searchBar.text!)
    }
    func filterContentForSearch(_ searchText: String) {
        filteretLamp = arrayOfLamp.filter({ (object: LampObj) -> Bool in
            return object.brand.lowercased().contains(searchText.lowercased())
        })
        mainTableView.reloadData()
    }
}

