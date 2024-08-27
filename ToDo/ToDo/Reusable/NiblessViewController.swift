//
//  NiblessViewController.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

open class NiblessViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable,
                message: "Cannot load from nib"
    )

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
    message: "Cannot load from nib"
    )

    public required init?(coder: NSCoder) {
          fatalError("Cannot load from nib")
      }

}
