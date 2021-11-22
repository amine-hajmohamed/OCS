//
//  ContentsViewController.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit
import Combine

private let kColumnsPerRow = UIDevice.current.userInterfaceIdiom == .phone ? 2: 3
private let kCellRatio: CGFloat = 1
private let kCellSpacing: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 20: 30

class ContentsViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var viewHeader: ContentsHeader!
    @IBOutlet private weak var collectionViewContents: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel: ContentsViewModel?
    
    private var cellSize = CGSize.zero
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        observeData()
        viewModel?.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let availableWidh = collectionViewContents.bounds.width - kCellSpacing * CGFloat(kColumnsPerRow + 1)
        let cellWidth = floor(availableWidh / CGFloat(kColumnsPerRow))
        let cellHeight = cellWidth * kCellRatio
        cellSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        collectionViewContents.register(with: ContentCollectionViewCell.self)
        collectionViewContents.dataSource = self
        collectionViewContents.delegate = self
    }
    
    private func observeData() {
        viewHeader.$searchText
            .sink { [weak self] text in
                self?.viewModel?.onSearch(title: text)
            }
            .store(in: &subscriptions)
        
        viewModel?.$contents
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in self?.collectionViewContents.reloadData() })
            .store(in: &subscriptions)
    }
}

// MARK: - UICollectionViewDataSource
extension ContentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.contents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ContentCollectionViewCell.self, for: indexPath)
        if let content = viewModel?.contents[indexPath.row] {
            cell.setup(with: content)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ContentsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: kCellSpacing, left: kCellSpacing, bottom: kCellSpacing, right: kCellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kCellSpacing
    }
}
