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
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "All Cocktails"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the titleLabel to the view before setting up constraints
        view.addSubview(titleLabel)
        
        view.addSubview(tableView)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            // Constraints for SegmentedControl
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Constraints for Title Label
            titleLabel.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Constraints for TableView
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100 
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
