//
//  ViewController.swift
//  dataloadALAMA
//
//  Created by Евгений Сабина on 16.05.24.
//
import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let networkService = ApiManager.shared
    var todosPhoto: [todosPhoto] = []
    var tableView: UITableView!
    var label: UILabel!
    var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        
        label = UILabel()
        label.text = "Тема оформления"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
                
        let items = ["red", "black", "blue", "orange", "green"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let saveButton = UIButton()
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = UIColor.orange
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        let loadButton = UIButton()
        loadButton.setTitle("Загрузить", for: .normal)
        loadButton.backgroundColor = UIColor.orange
        loadButton.layer.cornerRadius = 10
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadButton)
        
        
        segmentedControl.addTarget(self, action: #selector(changeTheme), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
                    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    
                    
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
                      
                    segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    segmentedControl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
                    
                    
                    saveButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
                    saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    saveButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 0), //
                        
                    loadButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
                    loadButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                    loadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                ])
        
        loadTodos()
    }
    
    private func loadTodos() {
        networkService.getTodosPhoto { result in
            switch result {
            case .success(let photos):
                self.todosPhoto = photos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todosPhoto[indexPath.row]
        
        // изображение в ячейку
        if let url = URL(string: todo.url) {
            AF.request(url).responseData { response in
                if let data = response.value {
                    cell.imageView?.image = UIImage(data: data)
                    cell.setNeedsLayout()
                }
            }
        }
        
        cell.textLabel?.text = todo.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    
    
    @objc func changeTheme(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.view.backgroundColor = .red
            label.text = "Тема: Красный"
        case 1:
            self.view.backgroundColor = .black
            label.text = "Тема: Черный"
        case 2:
            self.view.backgroundColor = .blue
            label.text = "Тема: Синий"
        case 3:
            self.view.backgroundColor = .orange
            label.text = "Тема: Оранжевый"
        case 4:
            self.view.backgroundColor = .green
            label.text = "Тема: Зеленый"
        default:
            break
        }
    }
    
    @objc func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(label.text, forKey: "ThemeText")
        defaults.set(segmentedControl.selectedSegmentIndex, forKey: "ThemeIndex")
    }
    
    @objc func loadData() {
        let defaults = UserDefaults.standard
            if let savedText = defaults.string(forKey: "ThemeText") {
                label.text = savedText
            }
            let savedIndex = defaults.integer(forKey: "ThemeIndex")
            segmentedControl.selectedSegmentIndex = savedIndex
            changeTheme(segmentedControl: segmentedControl)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
