
import UIKit

class StarView: UIView {
    
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
        let starExtrusion: CGFloat = rect.width / 5 // Контролирует вытянутые вершины звезды
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
        
        // Настройка цвета звезды
        if starColor == UIColor.yellow {
            let shapeLayerback = CAShapeLayer()
            shapeLayerback.path = starPath.cgPath
            shapeLayerback.fillColor = starColor.cgColor
            shapeLayerback.strokeColor = starColor.cgColor
            shapeLayerback.lineWidth = 1
            layer.addSublayer(shapeLayerback)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = roundedStarPath
            shapeLayer.fillColor = UIColor.darkGray.cgColor
            shapeLayer.strokeColor = UIColor.darkGray.cgColor
            shapeLayer.lineWidth = 2
            layer.addSublayer(shapeLayer)
        } else {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = roundedStarPath
            shapeLayer.fillColor = starColor.cgColor
            shapeLayer.strokeColor = starColor.cgColor
            shapeLayer.lineWidth = 2
            layer.addSublayer(shapeLayer)
            
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = starPath.cgPath
//            shapeLayer.fillColor = UIColor.clear.cgColor
//            shapeLayer.strokeColor = starColor.cgColor
//            shapeLayer.lineWidth = 1
//            layer.addSublayer(shapeLayer)
        }
    }
    
    func updateColor(to color: UIColor = .yellow) {
        starColor = color
    }
    
    func setDefault() {
        starColor = .darkGray
    }
}
