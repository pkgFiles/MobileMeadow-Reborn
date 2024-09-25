import Preferences
import AudioToolbox.AudioServices

@available(iOS 13.0, *)
class MobileMeadowInfoButtonCell: PSTableCell {

    //MARK: - Propertys
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonDetails: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = UIColor(red: 63/255, green: 201/255, blue: 255/255, alpha: 1.0)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showDetailsAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String, specifier: PSSpecifier) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buttonLabel.text = specifier.property(forKey: "buttonLabelText") as? String
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonLabel)
        self.contentView.addSubview(buttonDetails)
        
        NSLayoutConstraint.activate([
            buttonLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),

            buttonDetails.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            buttonDetails.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -22.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    @objc func showDetailsAlert() {
        guard let viewController = self.findViewController() else { return }
        AudioServicesPlayAlertSound(1521)
        
        let alertController = UIAlertController(title: buttonLabel.text, message: specifier.property(forKey: "buttonInfoText") as? String, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(dismissAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
}
