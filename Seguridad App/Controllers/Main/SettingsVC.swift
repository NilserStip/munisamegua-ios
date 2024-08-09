//
//  SettingsVC.swift
//  Seguridad App
//
//  Created by Andres Moreno on 9/25/22.
//  Copyright © 2022 uc-web. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbvSettings: UITableView!
    
    var settings = ["Cambiar contraseña", "Cerrar Sesión"]
    var delegate: SettingsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tbvSettings.delegate = self
        tbvSettings.dataSource = self
        tbvSettings.tableFooterView = UIView()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnDeleteAccount(_ sender: Any) {
        showDestructiveDialog(self, destructiveTitle: "Eliminar cuenta", message: "¿Desea eliminar su cuenta? Se eliminarán todos sus datos de usuario") {
            self.dismiss(animated: false, completion: {
                self.delegate?.didSettingsDeleteAccount()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSettings", for: indexPath)
        
        let label = cell.viewWithTag(1) as! UILabel
        label.text = settings[indexPath.row]
        
        if indexPath.row == 2 {
            label.textColor = .red
        } else {
            label.textColor = .darkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
            case 0: performSegue(withIdentifier: "SettingsToPasswordUpdate", sender: nil)
            case 1: showDefaultActionDialog(self, actionTitle: "Cerrar sesión", message: "¿Desea cerrar sesión?") {
                self.dismiss(animated: false, completion: {
                    self.delegate?.didSettingsLogout()
                })
            }
            default: return
        }
    }
}
