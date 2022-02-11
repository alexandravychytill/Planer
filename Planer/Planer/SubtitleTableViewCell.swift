//
//  SubtitleTableViewCell.swift
//  Planer
//
//  Created by Alexandra Vychytil on 13.01.22.
//
import UIKit
class SubtitleTableViewCell: UITableViewCell {

    // for subtitle in UITableView
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
