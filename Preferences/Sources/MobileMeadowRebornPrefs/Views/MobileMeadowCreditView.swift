import UIKit

class MobileMeadowCreditView: UIView {

    //MARK: - Propertys
    private lazy var titleLabel: UILabel = {
        let label = UILabel().createLabelWithFontPath(text: self.username.user, fontSize: 12)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel().createLabelWithFontPath(text: "@" + self.username.shorthand, fontSize: 10)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(contentsOfFile: prefsAssetsPath + "Credits/DefaultIcon.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Variables
    let username: (user: String, shorthand: String)
    let avatarUrlString: String
    
    //MARK: - Initializer
    init(username: (user: String, shorthand: String), avatarUrlString: String) {
        self.username = username
        self.avatarUrlString = avatarUrlString
        
        super.init(frame: .zero)
        setupCreditView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.layer.masksToBounds = true
    }
    
    //MARK: - Functions
    private func setupCreditView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(loadTwitterPageFromString))
        
        getProfilePicture(from: self.avatarUrlString)
        
        self.addGestureRecognizer(recognizer)
        self.addSubview(avatarImageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -3),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc private func loadTwitterPageFromString() {
        guard let url = URL(string: "https://twitter.com/" + username.shorthand) else { return }
        UIApplication.shared.open(url)
    }
    
    func getProfilePicture(from urlString: String) {
        guard let url = URL(string: "https://pbs.twimg.com/profile_images/" + urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }.resume()
    }
}
