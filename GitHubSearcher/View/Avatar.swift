//
//  Avatar.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 5/31/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class Avatar: UIImageView {
    
    let placeholder = UIImage(named: "placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, url: String?) {
        self.init(frame: frame)
        startDownload(from: url)
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        clipsToBounds = true
        contentMode = .scaleAspectFit
    }

    func startDownload(from url: String?) {
        if let url = url {
            WebServices.getImageFromWeb(url) { [weak self] (image, success) in
                if success {
                    self?.image = image
                } else {
                    self?.image = self?.placeholder
                }
            }
        }
    }
}
