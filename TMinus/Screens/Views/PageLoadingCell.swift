//
//  PageLoadingCell.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/12/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class PageLoadingCell: UITableViewCell {
    static var reuseID: String {
        return "PageLoadingCell"
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
}
