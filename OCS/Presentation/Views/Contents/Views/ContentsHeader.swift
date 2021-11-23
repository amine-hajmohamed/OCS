//
//  ContentsHeader.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

class ContentsHeader: UIView {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var labelSlogan: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    @Published var searchText: String = ""
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createViewFromNib()
    }
    
    private func createViewFromNib() {
        guard let view = UIView.loadFromNib(with: ContentsHeader.self, owner: self) else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        searchBar.placeholder = "ContentsHeader.SearchBar.Placeholder".localized
        labelSlogan.text = getRandomSlogan()
        
        searchBar.delegate = self
    }
    
    private func getRandomSlogan() -> String {
        let randomInt = Int.random(in: 1...3)
        return "ContentsHeader.Label.Slogan\(randomInt)".localized
    }
}

// MARK: UISearchBarDelegate
extension ContentsHeader: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
