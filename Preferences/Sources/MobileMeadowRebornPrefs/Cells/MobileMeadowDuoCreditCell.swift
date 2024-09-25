import Preferences

class MobileMeadowDuoCreditCell: PSTableCell {
    
    //MARK: - Propertys
    private let leftCreditCell: MobileMeadowCreditView = {
        let view = MobileMeadowCreditView(username: (user: "★\u{2002}Install\u{2002}Package\u{2002}Files", shorthand: "pkgFiles"), avatarUrlString: "1651534033019437056/BlFUdlQg_200x200.jpg")
        return view
    }()
    
    private let rightCreditCell: MobileMeadowCreditView = {
        let view = MobileMeadowCreditView(username: (user: "Samperson", shorthand: "SamNChiet"), avatarUrlString: "1605080302723878912/KBQBJO5N_200x200.jpg")
        return view
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let seperatorView: UIView = UIView()
        seperatorView.backgroundColor = UIColor.white
        seperatorView.alpha = 0.6
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(leftCreditCell)
        self.contentView.addSubview(seperatorView)
        self.contentView.addSubview(rightCreditCell)
        
        NSLayoutConstraint.activate([
            leftCreditCell.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            leftCreditCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            leftCreditCell.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            leftCreditCell.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.575),

            rightCreditCell.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            rightCreditCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            rightCreditCell.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            rightCreditCell.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.425),

            seperatorView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            seperatorView.leadingAnchor.constraint(equalTo: self.leftCreditCell.trailingAnchor, constant: 2.5),
            seperatorView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.7),
            seperatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
