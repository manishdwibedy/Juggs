import UIKit

extension CALayer {
    var UIShadowColor: UIColor? {
        get {
            guard let shadowColor = shadowColor else { return nil }
            return UIColor(cgColor: shadowColor)
        }
        set {
            shadowColor = newValue?.cgColor
        }
    }
    var UIBorderColor: UIColor? {
        get {
            guard let borderColor = borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}
