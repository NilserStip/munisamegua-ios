//
//  IncidenceVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/13/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import Alamofire

class IncidenceVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbvIncidences: UITableView!
    
    var incidences = [Incidence]()
    var category: Category?
    var incidenceDelegate: IncidenceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvIncidences.delegate = self
        tbvIncidences.dataSource = self
        tbvIncidences.tableFooterView = UIView()
        
        if category != nil {
            requestIncidences(category: category!)
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func requestIncidences(category: Category){
        if Connectivity.isConnected(self) {
            AF.request(Url.incidences(categoryId: category.id),
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<[Incidence]>.self) { response in
                        switch response.response?.statusCode {
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    self.incidences = value.data!
                                    self.tbvIncidences.reloadData()
                                case .failure(let error):
                                    print(error)
                                }
                            case 401:
                                self.logout()
                            default:
                                self.showInfoDialog(self, R.string.error_api)
                        }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIncidence", for: indexPath)
        
        let lblIncidence = cell.viewWithTag(1) as! UILabel
        lblIncidence.text = incidences[indexPath.row].shortTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: {
            self.incidenceDelegate?.didSelectIncidence(incidence: self.incidences[indexPath.row])
        })
    }
    
}
