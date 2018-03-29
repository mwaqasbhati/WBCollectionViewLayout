//
//  MenuViewController.swift
//  CustomLayout
//
//  Created by Muhammad Waqas Bhati on 3/28/18.
//  Copyright © 2018 Muhammad Waqas Bhati. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableViewMenu: UITableView!
    
    fileprivate let menuItems = ["Two Cells Layout","Three Cells Left Layout","Three Cells Right Layout","Mixture Layout"]
    fileprivate var cellLayout: MyCellLayout = .Mixture
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ViewController {
            vc.cellLayout = cellLayout
        }
    }
 

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellID")
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellLayout = MyCellLayout(rawValue: indexPath.row + 2) ?? .Mixture
        performSegue(withIdentifier: "goToLayoutVC", sender: nil)
    }
}
