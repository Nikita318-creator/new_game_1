import UIKit
import SnapKit
import AVFoundation
import AVKit
internal import StoreKit
import WebKit
import MobileCoreServices // Needed for media types

// MARK: - 1. Constants & Configuration
extension Const {
    static let backgroundImagename = "purple_bg" //  и так норм!
    static let appLink = "https://apps.apple.com/app/id6756383243" // Link to copy
    
    // Placeholder URLs
    static let dashboardURL = "https://sites.google.com/view/dashbordleaders"
    static let privacyURL = "https://sites.google.com/view/agreementmain"
    static let termsURL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    
    // UserDefaults Keys
    static let keyUserName = "UserProfileName"
    static let keyAvatarType = "UserAvatarType" // "image" or "video"
    static let keyAvatarPath = "UserAvatarPath" // filename in documents
}

// MARK: - 2. Storage Helper (To save files to disk)
class StorageManager {
    static let shared = StorageManager()
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveImage(_ image: UIImage, name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        try? data.write(to: filename)
        return name
    }
    
    func saveVideo(at url: URL, name: String) -> String? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        try? FileManager.default.removeItem(at: filename) // Remove old if exists
        try? FileManager.default.copyItem(at: url, to: filename)
        return name
    }
    
    func loadImage(name: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: filename.path)
    }
    
    func getVideoURL(name: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(name)
    }
}

// MARK: - 3. Simple Web View Controller
class GenericWebViewController: UIViewController {
    private let urlString: String
    private let webView = WKWebView()
    
    init(url: String, title: String) {
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - 4. Main Profile Screen
class ProfileScreenVC: UIViewController {

    // Logic Variables
    private let imagePicker = UIImagePickerController()
    private var videoPlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - UI Components
    
    // Avatar Container
    private lazy var avatarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 60 // Size 120/2
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.circle.fill") // Placeholder
        iv.tintColor = .white
        return iv
    }()
    
    // Name Input
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your name"
        tf.textAlignment = .center
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 22, weight: .bold)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()
    
    // Score Label
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Hardcoded for now
        label.textColor = .systemYellow
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    // Buttons Stack
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    // Footer Stack
    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        setupConstraints()
        setupActions()
        loadUserData()
        
        // Setup Image Picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.videoMaximumDuration = 10 // Limit capture time
        
        scoreLabel.text = "High Score: \(GameLogicHelper.shared.getFinishedLevel().count * 1379)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = avatarContainer.bounds
    }

    // MARK: - Setup UI & Background
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        // Ensure you have an image set in Const or handle nil gracefully
        backgroundImageView.image = UIImage(named: Const.backgroundImagename)
        backgroundImageView.backgroundColor = .systemIndigo // Fallback color
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupUI() {
        view.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        
        view.addSubview(nameTextField)
        view.addSubview(scoreLabel)
        view.addSubview(mainStackView)
        view.addSubview(footerStackView)
        
        // Add Main Buttons
        mainStackView.addArrangedSubview(createButton(title: "Records Dashboard", action: #selector(openDashboard)))
        mainStackView.addArrangedSubview(createButton(title: "Share Result", action: #selector(shareResult)))
        mainStackView.addArrangedSubview(createButton(title: "Invite Friends", action: #selector(inviteFriends)))
        mainStackView.addArrangedSubview(createButton(title: "Rate Us", action: #selector(rateApp)))
        
        // Add Footer Buttons
        footerStackView.addArrangedSubview(createFooterButton(title: "Privacy Policy", action: #selector(openPrivacy)))
        footerStackView.addArrangedSubview(createFooterButton(title: "Terms of Use", action: #selector(openTerms)))
    }
    
    private func setupConstraints() {
        avatarContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        footerStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    private func setupActions() {
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarContainer.addGestureRecognizer(tapAvatar)
    }

    // MARK: - Factory Methods for Buttons
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.6)
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.snp.makeConstraints { $0.height.equalTo(55) }
        return btn
    }
    
    private func createFooterButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    // MARK: - Logic: Actions
    
    @objc private func openDashboard() {
        let webVC = GenericWebViewController(url: Const.dashboardURL, title: "Records")
        present(webVC, animated: true)
    }
    
    @objc private func shareResult() {
        let textToShare = "I just scored \(scoreLabel.text ?? "0") in this amazing app! Check it out."
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func rateApp() {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @objc private func openPrivacy() {
        present(GenericWebViewController(url: Const.privacyURL, title: "Privacy"), animated: true)
    }
    
    @objc private func openTerms() {
        present(GenericWebViewController(url: Const.termsURL, title: "Terms"), animated: true)
    }
    
    // MARK: - Invite Logic (Deep Links)
    @objc private func inviteFriends() {
        let alert = UIAlertController(title: "Invite Friends", message: "Choose a platform", preferredStyle: .actionSheet)
        
        let apps: [(name: String, schema: String)] = [
            ("Telegram", "tg://"),
            ("WhatsApp", "whatsapp://"),
            ("Mail", "mailto:?body="),
            ("Instagram", "instagram://") // Instagram doesn't support direct text sharing easily via scheme, usually opens app
        ]
        
        for app in apps {
            alert.addAction(UIAlertAction(title: app.name, style: .default, handler: { _ in
                self.processInvite(schema: app.schema)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func processInvite(schema: String) {
        // 1. Ask to copy link
        let confirmAlert = UIAlertController(title: "Copy Link?", message: "Do you want to copy the app link to your clipboard before switching apps?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // 2. Copy to clipboard
            UIPasteboard.general.string = Const.appLink
            
            // 3. Prepare Deep Link URL
            var urlString: String
            
            // В нашем случае, поскольку мы передаем схемы, которые просто открывают приложение,
            // мы можем использовать переданную схему напрямую, если она не 'mailto'.
            
            if schema.contains("tg://") {
                urlString = "tg://"
            } else if schema.contains("whatsapp://") {
                urlString = "whatsapp://"
            } else if schema.contains("instagram://") {
                urlString = "instagram://app" // Иногда требуется для Instagram, чтобы просто открыть приложение
            } else {
                // Для mailto: и других сложных случаев оставляем как есть.
                urlString = schema
            }

            // 4. Attempt to open URL directly without canOpenURL check
            if let url = URL(string: urlString) {
                
                // Используем UIApplication.shared.open
                // Если приложение установлено, оно откроется. Если нет, ничего не произойдет.
                UIApplication.shared.open(url, options: [:]) { success in
                    if !success {
                        // Это сообщение появится, если приложение не установлено.
                        // Это чище, чем полагаться на canOpenURL.
                        print("⚠️ Failed to open URL scheme: \(urlString). App might not be installed.")
                    }
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(confirmAlert, animated: true)
    }
    
    // MARK: - Avatar Logic
    
    @objc private func avatarTapped() {
        let alert = UIAlertController(title: "Update Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo // Can be switched to .video if needed logic allows
        // To allow video recording in camera:
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true)
    }
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // MARK: - Data Persistence
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: Const.keyUserName) {
            nameTextField.text = name
        }
        
        let type = defaults.string(forKey: Const.keyAvatarType)
        let path = defaults.string(forKey: Const.keyAvatarPath)
        
        if type == "video", let path = path {
            playVideoAvatar(url: StorageManager.shared.getVideoURL(name: path))
        } else if let path = path, let image = StorageManager.shared.loadImage(name: path) {
            avatarImageView.image = image
            removeVideoLayer()
        }
    }
    
    private func saveData(type: String, filename: String) {
        UserDefaults.standard.set(type, forKey: Const.keyAvatarType)
        UserDefaults.standard.set(filename, forKey: Const.keyAvatarPath)
    }
}

// MARK: - TextField Delegate
extension ProfileScreenVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(textField.text, forKey: Const.keyUserName)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Image Picker & Video Handling
extension ProfileScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let mediaType = info[.mediaType] as? String
        
        // Handle Photo
        if mediaType == "public.image", let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let filename = "avatar_\(UUID().uuidString).jpg"
            if let savedName = StorageManager.shared.saveImage(image, name: filename) {
                avatarImageView.image = image
                removeVideoLayer()
                saveData(type: "image", filename: savedName)
            }
        }
        
        // Handle Video
        if mediaType == "public.movie", let videoURL = info[.mediaURL] as? URL {
            trimAndSaveVideo(url: videoURL)
        }
    }
    
    // Simplified logic to "Trim" (Visual only) and save
    private func trimAndSaveVideo(url: URL) {
        // In a real production app, use AVAssetExportSession to actually cut the file to 3 seconds.
        // Here, for brevity and stability, we save the full file but play it in a loop.
        
        let filename = "avatar_video_\(UUID().uuidString).mov"
        if let savedName = StorageManager.shared.saveVideo(at: url, name: filename) {
            let savedURL = StorageManager.shared.getVideoURL(name: savedName)
            playVideoAvatar(url: savedURL)
            saveData(type: "video", filename: savedName)
        }
    }
    
    private func playVideoAvatar(url: URL) {
        // 1. Clean up old
        removeVideoLayer()
        avatarImageView.isHidden = true
        
        // 2. Setup Player
        let playerItem = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer?.isMuted = true
        
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.frame = avatarContainer.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let layer = playerLayer {
            avatarContainer.layer.addSublayer(layer)
        }
        
        // 3. Loop Logic (3 seconds cap visually or infinite loop)
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        
        // 4. Start
        videoPlayer?.play()
        
        // Optional: Cap playback to 3 seconds then loop (Manual trim simulation)
        // You can use a Timer to seek back to 0 after 3 seconds if you strictly want 3s content
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.videoPlayer?.seek(to: .zero)
            self?.videoPlayer?.play()
        }
    }
    
    @objc private func loopVideo() {
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
    }
    
    private func removeVideoLayer() {
        videoPlayer?.pause()
        videoPlayer = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        avatarImageView.isHidden = false
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
