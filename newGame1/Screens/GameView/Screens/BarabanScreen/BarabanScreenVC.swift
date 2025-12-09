//
//  BarabanScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 24.08.24.
//

import UIKit
import SnapKit
internal import StoreKit

class BarabanScreenVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private enum Const {
        static let question = "Your Question Here"
        static let cellSize: CGFloat = 30
        static let cellSizeMini: CGFloat = 25
        static let cellSizeMaxi: CGFloat = 30 // решил не использовать это
        static let cellSpacing: CGFloat = 4
        static let labelInitialSize: CGFloat = 28
        static let labelFinalSize: CGFloat = 74
        static let labelAnimationDuration: TimeInterval = 1.5
    }

    var barabanImage: UIImage? {
        return PurchasedLogicHelper.shared.getCurrentDrum() ?? UIImage(named: "Baraban")
    }

    var viewModel = BarabanScreenViewModel()
    var answerText = ""
    var popUpLessonView = PopUpView()
    var currentLevel: Int = 0 {
        didSet {
            questionLabel.text = viewModel.data[currentLevel].question
            answerText = viewModel.data[currentLevel].keyWord
        }
    }

    var answerWithoutduplicated = ""
    
    private lazy var barabanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = barabanImage
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        // Настраиваем адаптивный шрифт с помощью UIFontMetrics
        let font = UIFont.FontsName.simpleFont.value.withSize(17) // UIFont.boldSystemFont(ofSize: 17)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        label.font = fontMetrics.scaledFont(for: font)
        
        return label
    }()

    private var collectionView: UICollectionView!
    private var alpabetView = AlphabetView()
    
    private var currentAnimator: UIViewPropertyAnimator?
    private let animatedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.FontsName.mainFont.value.withSize(Const.labelInitialSize)
        label.isHidden = true
        label.textColor = .white
        return label
    }()

    // Иконка лампочки
     private let lightbulbImageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(systemName: "lightbulb"))
         imageView.contentMode = .scaleAspectFit
         imageView.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
         imageView.isUserInteractionEnabled = true // Включаем взаимодействие
         return imageView
     }()
     
    private let lightbulbImageViewFill: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lightbulb.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
        imageView.isUserInteractionEnabled = true // Включаем взаимодействие
        return imageView
    }()
    
     // Иконка "открыть"
     private let openImageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(systemName: "arrow.right.circle"))
         imageView.contentMode = .scaleAspectFit
         imageView.isUserInteractionEnabled = true // Включаем взаимодействие
         imageView.tintColor = UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1.0)
         return imageView
     }()
    
    private let openImageViewFill: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true // Включаем взаимодействие
        imageView.tintColor = UIColor(red: 106/255, green: 90/255, blue: 205/255, alpha: 0.5)

        return imageView
    }()
    
    private var timer: Timer?
    private var startTime: Date?
    private var errorsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !PurchasedLogicHelper.shared.getShowAdds() {
//            loadInterstitialAd()
        }
//        loadRewardedAdRevard()

        view.backgroundColor = .white
        setupQuestionLabel()
        setupCollectionView()
        setupImageView()
        setupAlpabetView()
        setupAnimatedLabel()
        addTapGestureToImageView()
        setupHelpButtons()
        
        alpabetView.cellTapedHandler = { [weak self] letter in
            guard let self else { return true }
            
            if popUpLessonView.isKeyboardTapped {
                alpabetView.layer.borderColor = nil
                alpabetView.layer.borderWidth = 0
                popUpLessonView.hide()
                popUpLessonView.isKeyboardTapped = false
                popUpLessonView.isTrueTapped = true
                popUpLessonView.isFalseTapped = true
            }
            
            if answerText.contains(letter) {
                answerText = answerText.replacingOccurrences(of: letter, with: "")
                // Добавляем логику для анимации появления буквы
                self.showAnimatedLabel(with: letter)
                handleTap()
                
                if answerText.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.finishedLevel()
                        GameLogicHelper.shared.saveGameLesson(true)
                    }
                }
                
                if popUpLessonView.isTrueTapped {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.popUpLessonView.setup(text: "Popup.Lesson.TrueLetter".localized())
                        self.popUpLessonView.show()
                        self.popUpLessonView.isTrueTapped = false
                    }
                }
                    
                return true
            } else {
                self.errorsCount += 1
//                //TODO: delete
//                finishedLevel()
                
                if popUpLessonView.isFalseTapped {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.popUpLessonView.setup(text: "Popup.Lesson.FalseLetter".localized())
                        self.popUpLessonView.show(isNeedHide: false)
                        self.popUpLessonView.isFalseTapped = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.popUpLessonView.hide()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.popUpLessonView.setup(text: "Popup.Lesson.Help".localized())
                            self.popUpLessonView.show(isNeedHide: false)
                            self.popUpLessonView.isHelpTapped = true
                            self.lightbulbImageView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.7).cgColor
                            self.lightbulbImageView.layer.borderWidth = 5
                            self.openImageView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.7).cgColor
                            self.openImageView.layer.borderWidth = 5
                        }
                    }
                }
                
                return false
            }
        }

        alpabetView.showPopUpHandler = { [weak self] in
            self?.showPopUp()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorsCount = 0
        startTimer()
        
        barabanImageView.image = barabanImage
        
        if PurchasedLogicHelper.shared.getNewDrumAvailable() {
            PurchasedLogicHelper.shared.saveNewDrumAvailable(false)
            showAlert(title: "StoreScreen.Buy.Coins.newDrumOpened.Title".localized(), message: "StoreScreen.Buy.Coins.newDrumOpened.Message".localized()) { [weak self] in
                let storeScreenVC = StoreScreenVC()
                storeScreenVC.isNeedScrollToDrums = true
                self?.navigationController?.pushViewController(storeScreenVC, animated: true)
            }
        }
        
        if !GameLogicHelper.shared.getGameLesson() {
//            GameLogicHelper.shared.saveGameLesson(true) // TODO: - можно уже тут сообщить что урок пройден
            
            popUpLessonView.setup(text: "Popup.Lesson.TapDrum".localized())
            popUpLessonView.show(isNeedHide: false)
            barabanImageView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.7).cgColor
            barabanImageView.layer.borderWidth = 5
            popUpLessonView.isBarabanTapped = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Останавливаем таймер
        timer?.invalidate()
        timer = nil
        popUpLessonView.hide()
    }
    
    private func showPopUp() {
        let popUpView = PopUpView()
        popUpView.setup(text: "PopUp.Text".localized()) // Настраиваем попап
        popUpView.show()  // Показываем попап
    }
    
    private func startTimer() {
        // Сохраняем время начала
        startTime = Date()
        // Запускаем таймер, который будет вызываться каждую секунду
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard let startTime = startTime else { return }
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(startTime)
        
        print("Прошло секунд: \(elapsedTime)")
    }
    
    func getCurrentTime() -> TimeInterval? {
        guard let startTime = startTime else { return nil }
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(startTime)
        
        // Останавливаем таймер
        timer?.invalidate()
        timer = nil
        
        print("Текущее время: \(elapsedTime) секунд прошло с момента запуска.")
        return elapsedTime
    }
    
    private func setupImageView() {
        view.addSubview(barabanImageView)
        
        barabanImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).inset(20)
            make.width.equalTo(view.snp.width).inset(60)
            make.height.equalTo(barabanImageView.snp.width)
        }
    }

    private func setupQuestionLabel() {
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAlpabetView() {
        view.addSubview(alpabetView)
        alpabetView.backgroundColor = .clear
        
        alpabetView.snp.makeConstraints { make in
            make.top.equalTo(barabanImageView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Const.cellSpacing
        layout.minimumInteritemSpacing = Const.cellSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AnswerCell.self, forCellWithReuseIdentifier: "AnswerCell")

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(Const.cellSize * 2 + Const.cellSpacing)
        }
    }

    private func setupAnimatedLabel() {
        view.addSubview(animatedLabel)
        animatedLabel.snp.remakeConstraints { make in
            make.center.equalTo(barabanImageView)
            make.width.height.equalTo(Const.labelFinalSize)
        }
    }
    
    private func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        barabanImageView.addGestureRecognizer(tapGesture)
    }

    private func setupHelpButtons() {
        view.addSubview(lightbulbImageViewFill)
        view.addSubview(lightbulbImageView)
        view.addSubview(openImageViewFill)
        view.addSubview(openImageView)
        
        // Установка констрейнтов для иконок
        lightbulbImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().inset(30)
            make.size.equalTo(CGSize(width: 50, height: 50)) // Установите размер по вашему усмотрению
        }
        
        lightbulbImageViewFill.snp.makeConstraints { make in
            make.edges.equalTo(lightbulbImageView)
        }
        
        openImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-35)
            make.bottom.equalToSuperview().inset(30)
            make.size.equalTo(CGSize(width: 50, height: 50)) // Установите размер по вашему усмотрению
        }
        
        openImageViewFill.snp.makeConstraints { make in
            make.edges.equalTo(openImageView)
        }
        
        let tapLight = UITapGestureRecognizer(target: self, action: #selector(handleTapLight)) // to open Letter
        lightbulbImageView.addGestureRecognizer(tapLight)
        let tapOpenWord = UITapGestureRecognizer(target: self, action: #selector(handleTapOpenWord))
        openImageView.addGestureRecognizer(tapOpenWord)
        
        view.layoutIfNeeded()
    }
    
    @objc private func handleTap() {
        rotateImageView()
        alpabetView.shuffledData()
        
        if popUpLessonView.isBarabanTapped {
            barabanImageView.layer.borderColor = nil
            barabanImageView.layer.borderWidth = 0
            popUpLessonView.hide()
            popUpLessonView.isBarabanTapped = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.popUpLessonView.setup(text: "Popup.Lesson.TapKeybord".localized())
                self.popUpLessonView.show(isNeedHide: false)
                self.alpabetView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.7).cgColor
                self.alpabetView.layer.borderWidth = 5
                self.popUpLessonView.isKeyboardTapped = true
            }
        }
    }

    @objc private func handleTapLight() {
        showAlert(title: "Purchases.Light.Text".localized(), message: "") { [weak self] in
            guard let self else { return }
            
            if CoinsHelper.shared.getSpecialCoins() >= 1, let letter = answerText.first {
                answerText = answerText.replacingOccurrences(of: String(letter), with: "")
                CoinsHelper.shared.saveSpecialCoins(CoinsHelper.shared.getSpecialCoins() - 1)
                // Добавляем логику для анимации появления буквы
                self.showAnimatedLabel(with: String(letter))
                handleTap()
                
                if answerText.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.finishedLevel()
                    }
                }
            } else {
                showAlertNotEnothMoney()
            }
        }
        
        helpTapped()
    }
    
    @objc private func handleTapOpenWord() {
        showAlert(title: "Purchases.Arrow.Text".localized(), message: "") { [weak self] in
            // TODO: - показ рекламы

//            self?.showRewardedAdRevard()
        }
        
        helpTapped()
    }
    
    private func helpTapped() {
        if popUpLessonView.isHelpTapped {
            self.popUpLessonView.hide()
            self.popUpLessonView.isHelpTapped = false
            self.lightbulbImageView.layer.borderColor = nil
            self.lightbulbImageView.layer.borderWidth = 0
            self.openImageView.layer.borderColor = nil
            self.openImageView.layer.borderWidth = 0
            
            GameLogicHelper.shared.saveGameLesson(true)
        }
    }
    
    private func showAlert(title: String, message: String, complition: @escaping (() -> Void)) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "OK".localized(),
            style: .destructive,
            handler: { _ in
                complition()
            }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertNotEnothMoney() {
        let alert = UIAlertController(
            title: "StoreScreen.Buy.Coins.NotEnath.Title".localized(),
            message: "StoreScreen.Buy.Coins.NotEnath.Message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "StoreScreen.BlockAddsCell.cancel".localized(),
            style: .cancel,
            handler: nil))
        
        alert.addAction(UIAlertAction(
            title: "OK".localized(),
            style: .destructive,
            handler: { [weak self] _ in
                let storeScreenVC = StoreScreenVC()
                self?.navigationController?.pushViewController(storeScreenVC, animated: true)
            }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func rotateImageView() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = 1

        barabanImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    private func showAnimatedLabel(with text: String) {
        // Cancel the current animation if it exists
        currentAnimator?.stopAnimation(true)
        currentAnimator?.finishAnimation(at: .current)

        // Reset the animated label
        animatedLabel.font = UIFont.FontsName.mainFont.value.withSize(Const.labelInitialSize)
        animatedLabel.text = text
        animatedLabel.textColor = .white
        animatedLabel.isHidden = false
        animatedLabel.snp.remakeConstraints { make in
            make.center.equalTo(barabanImageView)
            make.width.height.equalTo(Const.labelFinalSize)
        }
        animatedLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) // Initial size
        
        guard let cell = (collectionView.visibleCells.first {
            ($0 as? AnswerCell)?.answerLetter == text
        }) as? AnswerCell else { return }
        
        // Animate the transformation of the label
        let animator = UIViewPropertyAnimator(duration: Const.labelAnimationDuration, curve: .easeInOut) { [self] in
            self.animatedLabel.transform = .identity // Final size
            self.animatedLabel.font = UIFont.FontsName.mainFont.value.withSize(Const.labelFinalSize)
        }
        
        animator.addCompletion { _ in
            // Animate the color and position after the first animation completes
            UIView.animate(withDuration: Const.labelAnimationDuration, animations: { [self] in
                self.animatedLabel.textColor = .black
                self.animatedLabel.font = UIFont.FontsName.mainFont.value.withSize(Const.labelInitialSize)
                self.animatedLabel.snp.remakeConstraints { make in
                    make.center.equalTo(cell)
                    make.width.height.equalTo(Const.labelFinalSize)
                }
                self.view.layoutIfNeeded()
                self.animatedLabel.layoutIfNeeded()
            }) { _ in
                self.animatedLabel.isHidden = true
                cell.configure(text: text, isCellMiniSize: self.viewModel.data[self.currentLevel].keyWord.count > 10)
            }
        }
        
        // Store the animator to cancel if needed
        currentAnimator = animator
        animator.startAnimation()
    }

    private func finishedLevel() {
        let levelcomplitedView = LevelcomplitedView()
        levelcomplitedView.clipsToBounds = true
        levelcomplitedView.layer.cornerRadius = 20
        levelcomplitedView.alpha = 0 // Устанавливаем начальную прозрачность в 0
        levelcomplitedView.layer.borderColor = UIColor.black.cgColor
        levelcomplitedView.layer.borderWidth = 0.5
        
        // MARK: - сохраняем прогресс - глава/уровень пройдена
        switch self.viewModel.gameMod {
            
        case .storyline:
            print("level: \(GameLogicHelper.shared.currentLevel) - finished")
            var finishedLevel = GameLogicHelper.shared.getFinishedLevel()
            finishedLevel.append(GameLogicHelper.shared.currentLevel)
            GameLogicHelper.shared.saveFinishedLevel(finishedLevel)
            
            if GameLogicHelper.shared.getFinishedLevel().count % 5 == 0 {
                var alreadyFinishedChapters = GameLogicHelper.shared.getFinishedChapters()
                alreadyFinishedChapters.append(GameLogicHelper.shared.currentChapter + 1)
                GameLogicHelper.shared.saveFinishedChapters(alreadyFinishedChapters)
                PurchasedLogicHelper.shared.addDrumPurchased(purchas: GameLogicHelper.shared.currentChapter + 1)
                
                self.requestAppReview()
            }
            
        case .freeFall:
            print("extra level: \(GameLogicHelper.shared.currentExtraLevel) - finished")
            var finishedExtraLevel = GameLogicHelper.shared.getFinishedExtraLevel()
            finishedExtraLevel.append(GameLogicHelper.shared.currentExtraLevel)
            GameLogicHelper.shared.saveFinishedExtraLevel(finishedExtraLevel)
            
            if GameLogicHelper.shared.currentExtraLevel == 2 {
                requestAppReview(isSecondTime: true)
            }
        case .manyLevels:
            print("many level: \(GameLogicHelper.shared.currentManyLevel) - finished")
            var finishedExtraLevel = GameLogicHelper.shared.getFinishedManyLevel()
            finishedExtraLevel.append(GameLogicHelper.shared.currentManyLevel)
            GameLogicHelper.shared.saveFinishedManyLevel(finishedExtraLevel)
            
            if GameLogicHelper.shared.currentManyLevel == 2 {
                requestAppReview(isSecondTime: true)
            }
        }
        
        levelcomplitedView.okDidTapHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
                
        let time = getCurrentTime() ?? 0
        levelcomplitedView.setup(
            time: time,
            errors: errorsCount
        )
        switch viewModel.gameMod {
        case .storyline:
            LevelProgreeHelper.shared.updateLevelProgres(
                with: LevelProgres(
                    isFinished: true,
                    isError: errorsCount < 2,
                    isTime: time < 30
                    ),
                at: currentLevel
            )
        case .freeFall:
            LevelProgreeHelper.shared.updateExtraLevelProgres(
                with: LevelProgres(
                    isFinished: true,
                    isError: errorsCount < 2,
                    isTime: time < 30
                    ),
                at: currentLevel
            )
        case .manyLevels:
            LevelProgreeHelper.shared.updateManyLevelProgres(
                with: LevelProgres(
                    isFinished: true,
                    isError: errorsCount < 2,
                    isTime: time < 30
                    ),
                at: currentLevel
            )
        }
 
        view.addSubview(levelcomplitedView)

        // Устанавливаем начальные размеры и позицию
        levelcomplitedView.snp.makeConstraints { make in
            make.center.equalToSuperview() // Центрируем по центру экрана
            make.width.height.equalTo(0)  // Начальная ширина и высота равны 0
        }
        
        // Анимация изменения размеров и прозрачности
        UIView.animate(withDuration: 0.5, animations: {
            levelcomplitedView.alpha = 1 // Делаем видимым
            levelcomplitedView.snp.remakeConstraints { make in
                make.center.equalToSuperview() // Центрируем по центру экрана
                make.width.equalTo(UIScreen.main.bounds.width - 30)
                make.height.equalTo(2 * UIScreen.main.bounds.height / 3)
            }
            self.view.layoutIfNeeded() // Обновляем макет
        })
    }
    
    func requestAppReview(isSecondTime: Bool = false) {
        guard !GameLogicHelper.shared.getRateApp() || isSecondTime else { return }
        
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            // Использовать старый способ для iOS ниже 14.0
            SKStoreReviewController.requestReview()
        }
        
        GameLogicHelper.shared.saveRateApp(true)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data[currentLevel].keyWord.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as? AnswerCell else {
            return UICollectionViewCell()
        }
  
        let keyWord = viewModel.data[currentLevel].keyWord
        let index = keyWord.index(keyWord.startIndex, offsetBy: indexPath.item)
        let currentLetter = String(keyWord[index])
        
        if answerWithoutduplicated.contains(currentLetter) {
            cell.configure(text: currentLetter, isCellMiniSize: self.viewModel.data[self.currentLevel].keyWord.count > 10)
        } else if !("AlphabetView".localized().contains(currentLetter)) {
            cell.configure(text: currentLetter, isCellMiniSize: self.viewModel.data[self.currentLevel].keyWord.count > 10)
            answerText = answerText.replacingOccurrences(of: currentLetter, with: "")
        } else {
            answerWithoutduplicated.append(currentLetter)
            cell.answerLetter = currentLetter
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.data[currentLevel].keyWord.count <= 5 {
            return CGSize(width: Const.cellSizeMaxi, height: Const.cellSizeMaxi)
        } else if viewModel.data[currentLevel].keyWord.count <= 10 {
            return CGSize(width: Const.cellSize, height: Const.cellSize)
        } else {
            return CGSize(width: Const.cellSizeMini, height: Const.cellSizeMini)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let currentCellSize = viewModel.data[currentLevel].keyWord.count <= 10 ? Const.cellSize : Const.cellSizeMini
        let totalCellWidth = currentCellSize * CGFloat(collectionView.numberOfItems(inSection: section))
        let totalSpacingWidth = Const.cellSpacing * CGFloat(collectionView.numberOfItems(inSection: section) - 1)
        let totalContentWidth = totalCellWidth + totalSpacingWidth
        let horizontalInset = (collectionView.bounds.width - totalContentWidth) / 2

        return UIEdgeInsets(top: 0, left: max(0, horizontalInset), bottom: 0, right: max(0, horizontalInset))
    }
}
