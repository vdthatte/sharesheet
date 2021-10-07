//
//  ViewController.swift
//  HalfScreenPresentation
import UIKit

class AnotherViewController: UIViewController {

    // 1. Defined UI views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum"
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem fringilla ut morbi tincidunt augue interdum. Ut morbi tincidunt augue interdum velit euismod in pellentesque massa. Pulvinar etiam non quam lacus suspendisse faucibus interdum posuere. Mi in nulla posuere sollicitudin aliquam ultrices sagittis orci a. Eget nullam non nisi est sit amet. Odio pellentesque diam volutpat commodo. Id eu nisl nunc mi ipsum faucibus vitae. "
        return textView
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = view.tintColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    lazy var containerStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [spacer, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        return stackView
    }()
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // 3. Add action
        registerButton.addTarget(self, action: #selector(presentModalController), for: .touchUpInside)
    }
    
    func setupView() {
        // cosmetics
        view.backgroundColor = .systemBackground
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundxx.png")
         
        view.backgroundColor = UIColor(patternImage: UIImage(named:"backgroundxx.png")!)
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.center = view.center
        view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
    // 4. Add subviews and set constraints
    func setupConstraints() {
        view.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        // 5. Call .activate method to enable the defined constraints
        NSLayoutConstraint.activate([
            // 6. Set containerStackView edges to superview with 24 spacing
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -24),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            // 7. Set button height
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 8. To be updated
    @objc func presentModalController() {
        let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            // Keep animated value as false
            // Custom Modal presentation animation will be handled in VC itself
            self.present(vc, animated: false)
    }
    
    
}

extension UIView{
    func screenShot() -> UIImage?{
        let scale = UIScreen.main.scale
        let bounds = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        
        if let _ = UIGraphicsGetCurrentContext(){
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}

