//
//  PersonDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class PersonDetailViewController: UIViewController, GenericCollection {
    weak var mainCoordinator: MainCoordinator!
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top

    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var sections: [ConfigurableSection]!
    var person: PersonViewModel!
    
    //MARK:- View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = []
        
        setup()
        setupDataProvider()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK:- Setup
    fileprivate func setup() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        //setup Person
        nameLabel.text = person.name
        
        if let imageURL = self.person.profileImageURL {
            personImageView.af.setImage(withURL: imageURL)
        }
        
        dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)
    }
    
    fileprivate func setupDataProvider()  {
        let updateCollectionView:(Error?) -> () = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            self.reloadSections()
        }
        
        person.didUpdate = updateCollectionView
        person.refresh()
    }
    
    //MARK: - Section Loading
    fileprivate func reloadSections() {
        sections = [ConfigurableSection]()
        
        dataSource.sections = sections
        collectionView.reloadData()
    }

}

