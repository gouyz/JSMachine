//
//  JSMShopLeftCell.swift
//  JSMachine
//  在线商城 left cell
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMShopLeftCell: UITableViewCell {
    
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.highlightedTextColor = kBlueFontColor
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureUI()
    }
    
    func configureUI () {
        
        contentView.addSubview(nameLab)
        contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(5)
        }
        nameLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(lineView)
            make.left.equalTo(lineView.snp.right).offset(5)
            make.right.equalTo(-kMargin)
            make.height.greaterThanOrEqualTo(34)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected ? kWhiteColor : kBackgroundColor
        isHighlighted = selected
        nameLab.isHighlighted = selected
        lineView.isHidden = !selected
    }

}
