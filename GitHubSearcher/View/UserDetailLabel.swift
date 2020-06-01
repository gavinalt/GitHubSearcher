//
//  UserDetailLabel.swift
//  GitHubSearcher
//
//  Created by Gavin Li on 5/31/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class UserDetailLabel: UILabel {
    var prefix = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        font = UIFont(name: "HelveticaNeue", size: 18)
        textColor = .black
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setPrefix(_ prefix: String) {
        self.prefix = prefix
    }

    func setText(_ text: String) {
        self.text = prefix + text
    }
}
