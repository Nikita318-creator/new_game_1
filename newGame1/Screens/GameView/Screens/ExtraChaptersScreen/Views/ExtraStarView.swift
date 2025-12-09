//
//  StarView.swift
//  Baraban
//
//  Created by никита уваров on 30.08.24.
//

import UIKit

class ExtraStarView: UIView {
    
    private var starColor: UIColor = .darkGray {
        didSet {
            // Перерисовать представление, чтобы отобразить новый цвет
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        drawRoundedStar(in: rect)
    }
    
    private func drawRoundedStar(in rect: CGRect) {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let starPath = UIBezierPath()
        let starExtrusion: CGFloat = rect.width / 7 // Контролирует вытянутые вершины звезды
        let radius: CGFloat = rect.width / 2
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let pointsOnStar = 5
        
        var angle: CGFloat = -CGFloat.pi / 2 // Начальная точка
        let angleIncrement = .pi * 2 / CGFloat(pointsOnStar * 2) // Интервал для каждой точки
        
        for i in 0..<(pointsOnStar * 2) {
            let point = CGPoint(x: center.x + cos(angle) * (i % 2 == 0 ? radius : starExtrusion),
                                y: center.y + sin(angle) * (i % 2 == 0 ? radius : starExtrusion))
            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
            angle += angleIncrement
        }
        
        starPath.close()
        
        // Добавление закруглений к вершинам
        let roundedStarPath = starPath.cgPath.copy(strokingWithWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 0)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = roundedStarPath
        shapeLayer.strokeColor = starColor.cgColor
        shapeLayer.lineWidth = 0.1
        layer.addSublayer(shapeLayer)
        
        if starColor == UIColor.yellow {
            // Добавление цветного слоя для звездного фона
            let shapeLayerBack = CAShapeLayer()
            shapeLayerBack.path = starPath.cgPath
            shapeLayerBack.fillColor = starColor.cgColor
            shapeLayerBack.strokeColor = starColor.cgColor
            shapeLayerBack.lineWidth = 0.1
            layer.addSublayer(shapeLayerBack)
            
            // Перерисовка верхнего слоя с тем же цветом
            let shapeLayerFront = CAShapeLayer()
            shapeLayerFront.path = roundedStarPath
            shapeLayerFront.fillColor = starColor.cgColor//UIColor.darkGray.cgColor
            shapeLayerFront.strokeColor = starColor.cgColor//UIColor.darkGray.cgColor
            shapeLayerFront.lineWidth = 0.1
            layer.addSublayer(shapeLayerFront)
        } else {
            // Основной цвет звезды
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = starPath.cgPath
            shapeLayer.fillColor = starColor.cgColor
            shapeLayer.strokeColor = starColor.cgColor
            shapeLayer.lineWidth = 0.1
            layer.addSublayer(shapeLayer)
        }
    }
    
    func updateColor(to color: UIColor = .yellow) {
        starColor = color
    }
    
    func setDefault() {
        starColor = .darkGray
    }
}
