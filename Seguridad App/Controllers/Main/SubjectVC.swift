//
//  SubjectVC.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 1/16/20.
//  Copyright © 2020 uc-web. All rights reserved.
//

import UIKit
import Alamofire

class SubjectVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbvSubjects: UITableView!
    
    var subjects = [Subject]()
    var delegate: SubjectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvSubjects.delegate = self
        tbvSubjects.dataSource = self
        tbvSubjects.tableFooterView = UIView()
        
            requestSubjects()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func requestSubjects(){
        if Connectivity.isConnected(self) {
            AF.request(Url.subjects,
                       method: .get,
                       headers: headers).responseDecodable(of: ResponseModel<[Subject]>.self) { response in
                        switch response.response?.statusCode {
                            case 200:
                                switch response.result {
                                case .success(let value):
                                    print("amd: \(value)")
                                    self.subjects = value.data!
                                    self.tbvSubjects.reloadData()
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
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubject", for: indexPath)
        
        let label = cell.viewWithTag(1) as! UILabel
        label.text = subjects[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: {
            self.delegate?.didSelect(subject: self.subjects[indexPath.row])
        })
    }
    
}
