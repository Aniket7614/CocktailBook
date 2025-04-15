import UIKit

import UIKit
import Combine

final class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = CocktailListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let segmentedControl = UISegmentedControl(items: CocktailFilter.allCases.map { $0.rawValue })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        title = "All Cocktails"
        view.backgroundColor = .systemBackground
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        
        tableView.register(CocktailCell.self, forCellReuseIdentifier: CocktailCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CocktailCell.identifier, for: indexPath) as? CocktailCell else {
            return UITableViewCell()
        }
        
        let cocktail = viewModel.cocktails[indexPath.row]
        let isFavorite = viewModel.isFavorite(cocktail)
        cell.configure(with: cocktail, isFavorite: isFavorite)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cocktail = viewModel.cocktails[indexPath.row]
        let detailVM = CocktailDetailViewModel(cocktail: cocktail, listViewModel: viewModel)
        let detailVC = CocktailDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        let selectedFilter = CocktailFilter.allCases[sender.selectedSegmentIndex]
        viewModel.filter = selectedFilter
    }
    
    private func bindViewModel() {
        viewModel.$cocktails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$filter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filter in
                self?.title = "\(filter.rawValue) Cocktails"
            }
            .store(in: &cancellables)
    }
}
