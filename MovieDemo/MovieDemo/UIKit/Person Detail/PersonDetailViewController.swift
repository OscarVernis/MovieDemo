//
//  PersonDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class PersonDetailViewController: UIViewController {
    var router: PersonDetailRouter?
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: PersonDetailDataSource!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    fileprivate var showingNavBarTitle = false {
        didSet {
            if oldValue != showingNavBarTitle {
                animateTitleView(show: showingNavBarTitle)
            }
        }
    }
    
    var store: PersonDetailStore!
    var person: PersonViewModel! {
        store.person
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private var gradient: CAGradientLayer!
    private var blurAnimator: UIViewPropertyAnimator!
    
    var titleView = UILabel()
    var titleViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupAnimations()
        setup()
        setupStore()
    }
    
    fileprivate func setupNavigationBar() {
        //Create Title
        let titleViewContainer = UIView()
        titleView.text = person.name
        titleView.font = UIFont(name: "Avenir Next Medium", size: 20)
        titleView.textColor = .label
        titleView.alpha = 0
        
        //Setup Title
        titleViewContainer.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints =   false
        titleViewTopConstraint = titleView.topAnchor.constraint(equalTo: titleViewContainer.topAnchor, constant: 30)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: titleViewContainer.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo:titleViewContainer.trailingAnchor, constant: 0),
            titleViewTopConstraint,
            titleView.bottomAnchor.constraint(equalTo: titleViewContainer.bottomAnchor, constant: 0)
        ])
        navigationItem.titleView = titleViewContainer
        
        //Setup Navigation Bar Appereance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        
        //Setup Back Button
        let backButton = BlurButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        backButton.setImage(.asset(.back), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        blurAnimator?.stopAnimation(true)
    }
    
    //MARK: - Setup
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        }
        
        return layout
    }
    
    fileprivate func setup() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = personImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.85, 1]
        personImageView.layer.mask = gradient
        
        //Setup CollectionView
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        dataSource = PersonDetailDataSource(collectionView: collectionView, person: person)
        collectionView.dataSource = dataSource
        
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        let bottomInset = UIWindow.mainWindow.bottomInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        
        
        //setup Person
        self.title = person.name
        nameLabel.text = person.name
        
        if let imageURL = self.person.profileImageURL {
            personImageView.setRemoteImage(withURL: imageURL)
        }
        
        let width = UIWindow.mainWindow.frame.width
        let height = width * 1.5
        headerHeightConstraint.constant = height
        collectionView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: bottomInset, right: 0)
    }
    
    fileprivate func setupStore()  {
        store.$person
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.storeDidUpdate()
        }
        .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
            if error != nil {
                self?.handleError()
                self?.store?.error = nil
            }
        }
        .store(in: &cancellables)

        store.refresh()
    }
    
    //MARK: - Actions
    fileprivate func storeDidUpdate() {
        dataSource.person = store.person
        self.dataSource.reload()
        self.collectionView.reloadData()
    }
    
    fileprivate func handleError() {
        router?.handle(error: .refreshError, shouldDismiss: true)
    }
    
}

//MARK: - Header Animations
extension PersonDetailViewController {
    fileprivate func animateTitleView(show: Bool) {
        UIView.animate(withDuration: 0.2) {
            if show {
                self.titleView.alpha = 1
                self.titleViewTopConstraint.constant = 0
                self.titleView.superview?.layoutIfNeeded()
                
                self.nameLabel.alpha = 0
                self.nameLabelBottomConstraint.constant = 10
                self.nameLabel.superview?.layoutIfNeeded()
            } else {
                self.titleView.alpha = 0
                self.titleViewTopConstraint.constant = 20
                self.titleView.superview?.layoutIfNeeded()
                
                self.nameLabel.alpha = 1
                self.nameLabelBottomConstraint.constant = 0
                self.nameLabel.superview?.layoutIfNeeded()
            }
        }
        
    }
    
    fileprivate func setupAnimations() {
        blurView.effect = nil
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.blurView.effect = UIBlurEffect(style: .light)
        }

        blurAnimator.pausesOnCompletion = true
    }

    fileprivate func updateHeader() {
        let width = UIWindow.mainWindow.frame.width
        let height = width * 1.5
        let titleHeight: CGFloat = 60
        let navBarHeight = view.safeAreaInsets.top

        var headerHeight = height
        if collectionView.contentOffset.y <= 0 {
            headerHeight = max(abs(collectionView.contentOffset.y), view.safeAreaInsets.top)
        } else {
            headerHeight = view.safeAreaInsets.top
        }

        if collectionView.contentOffset.y + navBarHeight + titleHeight < 0 {
            showingNavBarTitle = false
        } else {
            showingNavBarTitle = true
        }

        let ratio = 1 - (headerHeight - navBarHeight) / (height * 0.6)
        blurAnimator.fractionComplete = ratio

        if collectionView.contentOffset.y < -navBarHeight {
            headerHeightConstraint.constant = headerHeight

            var gradientFrame = personImageView.bounds
            gradientFrame.size.height = headerHeight
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradient.frame = gradientFrame
            CATransaction.commit()
        }
    }

}

//MARK: - CollectionView Delegate
extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        
        switch section {
        case .popular:
            let movie = person.popularMovies[indexPath.row]
            router?.showMovieDetail(movie: movie)
        case .castCredits:
            let castCredit = person.castCredits[indexPath.row]
            if let movie = castCredit.movie {
                router?.showMovieDetail(movie: movie)
            }
        case .crewCredits:
            if let crewCredit = dataSource.crewCredit(at: indexPath),
               let movie = crewCredit.movie {
                router?.showMovieDetail(movie: movie)
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader()
    }
    
}

import SwiftUI
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
    
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
}

struct PersonDetail_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let vc = PersonDetailViewController.instantiateFromStoryboard()
            let navCont = UINavigationController(rootViewController: vc)
            vc.store = MockData.personDetailStore
            return navCont
        }
    }
}
