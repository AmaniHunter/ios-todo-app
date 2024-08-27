//
//  NiblessView.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

open class NiblessView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable,
                message: "Cannot load from nib"
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot load from nib")
    }
}
