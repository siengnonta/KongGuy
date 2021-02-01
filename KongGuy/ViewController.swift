//
//  ViewController.swift
//  KongGuy
//
//  Created by Nontapat Siengsanor on 1/2/2564 BE.
//

import UIKit

//struct Message: Decodable {
//    let australian: [String]
//}

struct Dog {
    let mainBreed: String
    let subBreeds: [String]
}

struct DogResponse: Decodable {
    let message: [String: [String]]?
    let status: String
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    let tableView = UITableView()
    
    var dogData = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        connectNetwork()
    }
    
    private func connectNetwork() {
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            let dogResponse = try? jsonDecoder.decode(DogResponse.self, from: data)
            
            self?.dogData = dogResponse?.message?.map({ Dog(mainBreed: $0, subBreeds: $1) }) ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        task.resume()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        label.text = "Kong!!"
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let dog = dogData[indexPath.row]
        cell.titleLabel.text = dog.mainBreed + " - " + dog.subBreeds.joined(separator: "|")
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1) push
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .cyan
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        // 2) present
        let secondViewController = DogDetailViewController()
        secondViewController.dogData = dogData
        secondViewController.selectCallback = { [weak self] dog in
            self?.title = dog.mainBreed
        }
        
        let navigationcontroller = UINavigationController(rootViewController: secondViewController)
        self.navigationController?.present(navigationcontroller, animated: true, completion: nil)
    }
    
}


class DogDetailViewController: UITableViewController {
    
    var dogData: [Dog] = []
    var selectCallback: ((Dog) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }
    
    // datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dogData[indexPath.row].mainBreed
        return cell
    }
    
    // delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dog = dogData[indexPath.row]
        selectCallback?(dog)
        
        dismiss(animated: true, completion: nil)
    }
    
}
