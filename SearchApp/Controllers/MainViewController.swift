//
//  ViewController.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 27/05/24.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 120
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    //MARK: Stored properties
    var results: [WikipediaPage] = []
    var threadManager = ThreadManager()
    private var tapGesture: UITapGestureRecognizer?
    
    //MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        //open keyboard at start
        searchBar.becomeFirstResponder()
        
        // keyboard handling
        addKeyboardObserver()
        
    }
    
    deinit{
        // Memory leak prevention
        removeKeyboardObserver()
    }
}

// Tableview handling
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else{
            return UITableViewCell()
        }
        
        let result = results[indexPath.row]
        cell.configure(result: result)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// SearchBar handling
extension MainViewController: UISearchBarDelegate, UIScrollViewDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //cancel the previous hit if user changed the text
        threadManager.cancelWorkItem()
        
        if searchText.isEmpty || searchText == " "{
            results = []
            tableView.reloadData()
        }else{
            threadManager.manageThread { [weak self] in
                self?.searchWikipedia(query: searchText)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        searchBar.resignFirstResponder()
    }
    
    func searchWikipedia(query: String){
        APIManager.shared.getData(query: query){ [weak self] result in
            DispatchQueue.main.async {
                switch(result){
                case .success(let data):
                    self?.results = data.sorted{$0.pageid < $1.pageid}
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
}

// Keyboard handling
extension MainViewController{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(addTapGesture), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeTapGesture), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addTapGesture(){
        if tapGesture == nil{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture!)
        }
    }
    
    @objc func removeTapGesture(){
        if let tapGesture = tapGesture{
            view.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
}
