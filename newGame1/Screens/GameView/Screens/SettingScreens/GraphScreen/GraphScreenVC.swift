//
//  GraphScreenVC.swift
//  Baraban
//
//  Created by никита уваров on 25.08.24.
//

import UIKit
import SnapKit
import Charts

class GraphScreenVC: UIViewController {
    
//    private enum Const {
//        static let bacgraundImagename = "mainBackGraund"
//    }
//    
//    let gradientLayer = CAGradientLayer()
//
//    private var lineChartView: LineChartView!
//    
//    private let bottomLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Chart.CurrentEarnings.Text".localized()
//        label.font = UIFont.FontsName.simpleFont.value.withSize(30)
//        label.textColor = .clear
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setup()
//        setupChart()
//        setupBottomLabel()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientLayer.frame = bottomLabel.bounds
//    }
//    
//    static func setCurrentMultiple() {
//        if GameLogicHelper.shared.getFinishedChapters().count >= 5 {
//            CoinsHelper.shared.currentMultiplireForXCoin = 0
//        } else {
//            let currentHour = Calendar.current.component(.hour, from: Date())
//            switch currentHour {
//            case 10..<12:
//                CoinsHelper.shared.currentMultiplireForXCoin = 3
//            case 9..<10:
//                CoinsHelper.shared.currentMultiplireForXCoin = 4
//            case 8..<9:
//                CoinsHelper.shared.currentMultiplireForXCoin = 5
//            default:
//                CoinsHelper.shared.currentMultiplireForXCoin = 1
//            }
//        }
//    }
//    
//    private func setup() {
//        // Создание UIImageView для фона
//        let backgroundImageView = UIImageView(frame: view.bounds)
//        backgroundImageView.image = UIImage(named: Const.bacgraundImagename)
//        backgroundImageView.contentMode = .scaleAspectFill
//        view.addSubview(backgroundImageView)
//        view.sendSubviewToBack(backgroundImageView)
//    }
//    
//    private func setupChart() {
//        lineChartView = LineChartView()
//        view.addSubview(lineChartView)
//        
//        // Настройка констрейнтов для графика
//        lineChartView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(170)
//            make.width.height.equalTo(UIScreen.main.bounds.width - 40)
//            make.centerX.equalToSuperview()
//        }
//    
//        var dataEntries: [ChartDataEntry] = []
//
//        if GameLogicHelper.shared.getFinishedChapters().count >= 5 {
//            CoinsHelper.shared.currentMultiplireForXCoin = 0
//             dataEntries = [
//                ChartDataEntry(x: 1.0, y: 5.0), // Начальная точка
//                ChartDataEntry(x: 3.0, y: 0.0), // Первая вершина
//                ChartDataEntry(x: 5.0, y: 0.0), // Вторая вершина
//                ChartDataEntry(x: 7.0, y: 0.0)  // Третья вершина
//            ]
//        } else {
//            dataEntries = getDataEntries()
//        }
//        
//        let dataSet = LineChartDataSet(entries: dataEntries, label: "Chart.CurrentEarnings".localized())
//        dataSet.colors = [NSUIColor.blue]
//        dataSet.valueColors = [NSUIColor.black]
//        dataSet.drawFilledEnabled = false // Отключить заполнение области под линией
//        
//        // Настройка графика
//        let data = LineChartData(dataSet: dataSet)
//        lineChartView.data = data
//        
//        // Дополнительные настройки графика
//        lineChartView.leftAxis.labelTextColor = .white
//        lineChartView.rightAxis.labelTextColor = .white
//        lineChartView.xAxis.labelTextColor = .white
//        lineChartView.legend.textColor = .white
//        lineChartView.gridBackgroundColor = .clear
//        
//        view.layoutIfNeeded()
//
//        // Создание градиентного слоя
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.systemBlue.withAlphaComponent(0.3).cgColor,
//                                UIColor.purple.withAlphaComponent(0.3).cgColor,
//                                UIColor.yellow.withAlphaComponent(0.3).cgColor]
//        gradientLayer.locations = [0.0, 0.5, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        
//        // Установка градиентного фона для графика
//        gradientLayer.frame = lineChartView.bounds
//        lineChartView.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    
//    private func getDataEntries() -> [ChartDataEntry] {
//        // Получение текущего времени
//        let currentHour = Calendar.current.component(.hour, from: Date())
//        print(currentHour)
//        
//        var dataEntries: [ChartDataEntry] = []
//        
//        // Пример данных для графика с изменяющимися значениями в зависимости от времени
//        switch currentHour {
//        case 10..<12:
//            // Значения для времени от 6 до 8 утра
//            CoinsHelper.shared.currentMultiplireForXCoin = 3
//            dataEntries = [
//                ChartDataEntry(x: 1.0, y: 2.5), // Начальная точка
//                ChartDataEntry(x: 3.0, y: 1.0), // Первая вершина
//                ChartDataEntry(x: 5.0, y: 5.0), // Вторая вершина
//                ChartDataEntry(x: 7.0, y: 3.0)  // Третья вершина
//            ]
//        case 9..<10:
//            // Значения для времени от 8 до 10 утра
//            CoinsHelper.shared.currentMultiplireForXCoin = 4
//            dataEntries = [
//                ChartDataEntry(x: 1.0, y: 1.5), // Начальная точка
//                ChartDataEntry(x: 3.0, y: 2.0), // Первая вершина
//                ChartDataEntry(x: 5.0, y: 5.0), // Вторая вершина
//                ChartDataEntry(x: 7.0, y: 4.0)  // Третья вершина
//            ]
//        case 8..<9:
//            // Значения для времени от 10 до 12 утра
//            CoinsHelper.shared.currentMultiplireForXCoin = 5
//            dataEntries = [
//                ChartDataEntry(x: 1.0, y: 2.0), // Начальная точка
//                ChartDataEntry(x: 3.0, y: 4.0), // Первая вершина
//                ChartDataEntry(x: 5.0, y: 1.0), // Вторая вершина
//                ChartDataEntry(x: 7.0, y: 5.0)  // Третья вершина
//            ]
//        default:
//            // Значения для остального времени (параллельная линия)
//            CoinsHelper.shared.currentMultiplireForXCoin = 1
//            dataEntries = [
//                ChartDataEntry(x: 1.0, y: 1.0), // Начальная точка
//                ChartDataEntry(x: 3.0, y: 1.0), // Вторая точка
//                ChartDataEntry(x: 5.0, y: 1.0), // Третья точка
//                ChartDataEntry(x: 7.0, y: 1.0)  // Четвертая точка
//            ]
//        }
//        
//        return dataEntries
//    }
//    
//    private func setupBottomLabel() {
//        view.addSubview(bottomLabel)
//        
//        // Настройка констрейнтов для лейбла
//        bottomLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineChartView.snp.bottom).inset(-60)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(UIScreen.main.bounds.width - 40)
//        }
//        
//        view.layoutIfNeeded()
//        bottomLabel.layoutIfNeeded()
//        
//        // Настройка градиентного слоя
//        gradientLayer.colors = [UIColor(red: 16/255, green: 31/255, blue: 39/255, alpha: 1).cgColor,
//                                UIColor(red: 11/255, green: 11/255, blue: 20/255, alpha: 0.8).cgColor]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.frame = bottomLabel.bounds
//        
//        // Добавление градиентного слоя к лейблу
//        bottomLabel.layer.insertSublayer(gradientLayer, at: 0)
//        bottomLabel.layer.masksToBounds = true
//        
//        // идиотское решение
//        let textLabel = UILabel()
//        textLabel.backgroundColor = .clear
//        textLabel.text = "Chart.CurrentEarnings.Text".localized()
//        + ": \(CoinsHelper.shared.currentMultiplireForXCoin)"
//        + "Chart.CurrentEarnings.XGameMinutes".localized()
//        textLabel.font = UIFont.FontsName.simpleFont.value.withSize(24)
//        textLabel.textColor = .white
//        textLabel.textAlignment = .center
//        textLabel.numberOfLines = 0
//
//        bottomLabel.addSubview(textLabel)
//        textLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }


}



