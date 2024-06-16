//
//  CustomCellTableViewCell.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 27/05/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var outerImageView: UIView!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        outerImageView.isHidden = true
        imageViewWidthConstraint.constant = 0
    }
    
    func configure(result: WikipediaPage){
        titleLabel.text = result.title
        subtitleLabel.text = result.extract
        imageViewWidthConstraint.constant = 120
        
        if let imageUrl = result.thumbnail?.source{
            APIManager.shared.getImage(url: imageUrl){ [weak self] result in
                DispatchQueue.main.async {
                    switch(result){
                        case .success(let image):
                            self?.outerImageView.isHidden = false
                            self?.customImageView.image = image
                            
                        case .failure(let error):
                            print(error.rawValue)
                    }
                }
            }
        }else{
            imageViewWidthConstraint.constant = 0
        }
    }
}
