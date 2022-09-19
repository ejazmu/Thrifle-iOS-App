import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
    
    func makeRound(cornerRadius: CGFloat = 20.0) {
        if let textfield = value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                // Rounded corner
                backgroundview.layer.cornerRadius = cornerRadius;
                backgroundview.clipsToBounds = true;
            }
        }
    }
}
