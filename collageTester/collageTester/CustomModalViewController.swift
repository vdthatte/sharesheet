import UIKit
import Social
import MessageUI

class CustomModalViewController: UIViewController, UIDocumentInteractionControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    // 1
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // 2
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    let defaultHeight: CGFloat = 300
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func animateDismissView() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Share to"
        label.textColor = UIColor.black
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    //STORIES
    lazy var storiesButton: UIButton = {
        let newImage = UIImage(named: "igLogo") as UIImage?
        let rzImg = resizeImage(image: newImage!, targetSize: CGSize(width: 100, height: 100))
        let newButton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        //newButton.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        newButton.setImage(rzImg, for: .normal)
        newButton.imageView?.contentMode = .scaleAspectFill
        //newButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
        
        newButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        newButton.adjustsImageWhenHighlighted = false
        return newButton
    }()
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        self.animateDismissView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            if let storiesUrl = URL(string: "instagram-stories://share"){
                if UIApplication.shared.canOpenURL(storiesUrl){
                    //guard let image = self.view.screenShot() else { return }
                    //guard let image = UIImage(named: "backgroundxx.png") else {return}
                    //guard let imageData = image.pngData() else {return}
                    
                    
                     let instagramCanvasBoundsHeight = UIScreen.main.bounds.width * 16/9
                     let storyBackgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: instagramCanvasBoundsHeight))
                     
                    //let newView = UIImageView()
                    
                    //let imgSz = UIImageView(frame: UIScreen.main.bounds)
                    //let imgSz = UIImageView(frame: CGRect(x: 100, y: 0, width: 200, height: 200))
                    storyBackgroundView.image = UIImage(named: "backgroundxx.png")
                    

                    
                    guard let imageData = storyBackgroundView.image else {return}
                    
                    
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.backgroundImage": imageData,
                        "com.instagram.sharedSticker.backgroundTopColor": "#000",
                        "com.instagram.sharedSticker.backgroundBotttomColor": "#000"
                    ]
                    
                    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
                            
                    // 5
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                            
                    // 6
                    UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                    
                }
                else{
                    print("User doesn't have instagram on their phone")
                }
            }
        }
    }
    
    //iMESSAGE
    lazy var textButton: UIButton = {
        let newImage = UIImage(named: "textLogo") as UIImage?
        let rzImg = resizeImage(image: newImage!, targetSize: CGSize(width: 100, height: 100))
        let newButton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        //newButton.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        newButton.setImage(rzImg, for: .normal)
        newButton.imageView?.contentMode = .scaleAspectFill
        //newButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
        
        newButton.addTarget(self, action: #selector(textButtonAction), for: .touchUpInside)
        newButton.adjustsImageWhenHighlighted = false
        return newButton
    }()
    
    @objc func textButtonAction(sender: UIButton!) {
        
        
        let messageVC = MFMessageComposeViewController()
                
            messageVC.body = ""
            if let image = UIImage(named: "backgroundxx.png"){
                var imageData = image.pngData()
                
                messageVC.addAttachmentData(
                imageData!,
                typeIdentifier: "public.data",
                filename: "image.png"
                )
            }
            //vc.add(UIImage(named: "backgroundxx.png"))
            //messageVC.recipients = [""]
            messageVC.messageComposeDelegate = self
                
            self.present(messageVC, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
                case .cancelled:
                    print("Message was cancelled")
                    dismiss(animated: true, completion: nil)
                case .failed:
                    print("Message failed")
                    dismiss(animated: true, completion: nil)
                case .sent:
                    print("Message was sent")
                    dismiss(animated: true, completion: nil)
                default:
                break
            }
    }
    
    //TWEET
    lazy var tweetButton: UIButton = {
        let newImage = UIImage(named: "tweetLogo") as UIImage?
        let rzImg = resizeImage(image: newImage!, targetSize: CGSize(width: 100, height: 100))
        let newButton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        //newButton.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        newButton.setImage(rzImg, for: .normal)
        newButton.imageView?.contentMode = .scaleAspectFill
        //newButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
        
        newButton.addTarget(self, action: #selector(tweetButtonAction), for: .touchUpInside)
        newButton.adjustsImageWhenHighlighted = false
        return newButton
    }()
    
    @objc func tweetButtonAction(sender: UIButton!) {
        

        //self.animateDismissView()
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
            //vc.setInitialText("hi")
            vc.add(UIImage(named: "backgroundxx.png"))
            present(vc, animated: true)
        }
        
        //self.animateDismissView()
    }

    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem fringilla ut morbi tincidunt augue interdum. \n\nUt morbi tincidunt augue interdum velit euismod in pellentesque massa. Pulvinar etiam non quam lacus suspendisse faucibus interdum posuere. Mi in nulla posuere sollicitudin aliquam ultrices sagittis orci a. Eget nullam non nisi est sit amet. Odio pellentesque diam volutpat commodo. Id eu nisl nunc mi ipsum faucibus vitae.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem fringilla ut morbi tincidunt augue interdum. Ut morbi tincidunt augue interdum velit euismod in pellentesque massa."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    lazy var contentStackView: UIStackView = {
        //view.backgroundColor = UIColor.green
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [storiesButton, tweetButton, textButton, spacer])
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        stackView.center = containerView.center
        return stackView
    }()
    
    func setupConstraints() {
        // Information
        containerView.addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        // ..
        NSLayoutConstraint.activate([
            // ..
            // content stackView
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        // ..
        
        // 4. Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // 6. Set container to default height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        // 7. Set bottom constant to 0
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
//        stackView.center = containerView.center
    }
    
}



/*
 
 */
