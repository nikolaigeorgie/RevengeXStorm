/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Main view controller for the AR experience.
 */

import ARKit
import SceneKit
import UIKit
import ColorSlider
import SDWebImage
import Lottie


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CarListDelegate {
    
    //        var animationView : LOTAnimationView?
    
    static var bodyColor = UIColor.black
    static var boltColor = UIColor.white
    static var bodyImage = UIImage()
    static var boltImage = UIImage()
    
    static var residueSystem = SCNParticleSystem(named: "SmokeResidue", inDirectory: "")
    
    var environmentIsLoaded = false
    
    var currentUser = "Ian Connor"
    
    // MARK: IBOutlets
    
    @IBOutlet var sceneView: VirtualObjectARView!
    
    @IBOutlet weak var addObjectButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var colorDisplayView: UIView!
    
    var colorPicker: ColorSlider!
    var leftShoeNode: SCNNode?
    var rightShoeNode: SCNNode?
    var cigNode: SCNNode?
    
    var vehicle = SCNPhysicsVehicle()
    
    var virtualObjects = [VirtualObject]()
    var characterObject = [VirtualObject]()
    
    var selectedVirtualObjectRows = IndexSet()
    var delegate: CarListDelegate?
    
    static var selectedModel = "IanConnor"
    
    var carCellId = "carCellId"
    var characters = ["Ian Connor", "???", "????"]
    var characterURLS = ["https://firebasestorage.googleapis.com/v0/b/cybershop-f4213.appspot.com/o/IanConnor.gif?alt=media&token=a64d415e-225d-46ab-958b-39f08a4e54e9", "https://firebasestorage.googleapis.com/v0/b/revengexs-7792e.appspot.com/o/mysteryone.gif?alt=media&token=9583616d-ad1c-4275-9606-524b813aea76", "https://firebasestorage.googleapis.com/v0/b/revengexs-7792e.appspot.com/o/mysterytwo.gif?alt=media&token=38f9d030-4909-499b-add1-97c68a549e95"]
    
    
    let frameImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "frame")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    
    let planetLabel: UILabel = {
        let label = UILabel()
        label.text = "Plane detected"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(37, green: 33, blue: 30)
        view.alpha = 0.5
        return view
    }()
    
    let colorWheelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "colorWheel"), for: .normal)
        //        button.addTarget(self, action: #selector(colorWheelButtonHit), for: .touchUpInside)
        return button
    }()
    
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "reset"), for: .normal)
        button.addTarget(self, action: #selector(resetButtonHit), for: .touchUpInside)
        return button
    }()
    
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self, action: #selector(resetButtonHit), for: .touchUpInside)
        button.alpha = 0
        button.isHidden = true
        return button
    }()
    
    var stackView = UIStackView()
    
    let switchCharacterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "characters"), for: .normal)
        button.addTarget(self, action: #selector(loadCharacters), for: .touchUpInside)
        return button
    }()
    
    let carCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //        layout.minimumLineSpacing = 200
        //        layout.minimumInteritemSpacing = 200
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isHidden = true
        cv.alpha = 0
        return cv
    }()
    
    
    let IanImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "landingBackground")
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let ArielImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "landingBackground")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.isHidden = true
        return imageView
    }()
    
    let LalaImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "landingBackground")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.isHidden = true
        return imageView
    }()
    
    var IanHorizontalConstraint = NSLayoutConstraint()
    var IanBottomConstraint = NSLayoutConstraint()
    var IanWidthConstraint = NSLayoutConstraint()
    var IanHeightConstraint = NSLayoutConstraint()
    
    
    var ArielHorizontalConstraint = NSLayoutConstraint()
    var ArielBottomConstraint = NSLayoutConstraint()
    var ArielWidthConstraint = NSLayoutConstraint()
    var ArielHeightConstraint = NSLayoutConstraint()
    
    var LalaHorizontalConstraint = NSLayoutConstraint()
    var LalaBottomConstraint = NSLayoutConstraint()
    var LalaWidthConstraint = NSLayoutConstraint()
    var LalaHeightConstraint = NSLayoutConstraint()
    
    var characterIsLoaded = false
    
    let leftArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrowButtonLeft"), for: .normal)
        button.addTarget(self, action: #selector(handleLeftButtonHit), for: .touchUpInside)
        return button
    }()
    
    let rightArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrowButtonRight"), for: .normal)
        button.addTarget(self, action: #selector(handleRightButtonHit), for: .touchUpInside)
        return button
    }()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SELECT", for: .normal)
        button.titleLabel?.font = UIFont(name: "GaposisSolidBRK", size: 10)
        button.addTarget(self, action: #selector(loadCharacter), for: .touchUpInside)
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return button
    }()
    
    let currentPersonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ian Connor"
        label.textColor = .white
        label.font = UIFont(name: "GaposisSolidBRK", size: 20)
        label.alpha = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let currentPersonLabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "IAN CONNOR")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.isHidden = true
        return imageView
    }()
    
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "BACK"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadCharacters() {
        
        if animationView.isHidden == false {
            return
        }
        
        if characterIsLoaded == false {
            characterIsLoaded = true
            
            self.currentPersonLabel.isHidden = false
            self.stackView.isHidden = false
            self.IanImageView.isHidden = false
            self.ArielImageView.isHidden = false
            self.LalaImageView.isHidden = false
            self.leftArrowButton.isHidden = false
            self.rightArrowButton.isHidden = false
            self.currentPersonLabelImageView.isHidden = false
            self.currentPersonLabel.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.currentPersonLabel.alpha = 1
                self.stackView.alpha = 1
                self.IanImageView.alpha = 1
                self.ArielImageView.alpha = 1
                self.LalaImageView.alpha = 1
                self.leftArrowButton.alpha = 1
                self.rightArrowButton.alpha = 1
                self.currentPersonLabelImageView.alpha = 1
                self.currentPersonLabel.alpha = 1
                
            })
            
        } else if characterIsLoaded == true {
            characterIsLoaded = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.currentPersonLabel.alpha = 0
                self.stackView.alpha = 0
                self.leftArrowButton.alpha = 0
                self.rightArrowButton.alpha = 0
                self.IanImageView.alpha = 0
                self.ArielImageView.alpha = 0
                self.LalaImageView.alpha = 0
                self.currentPersonLabelImageView.alpha = 0
                self.currentPersonLabel.alpha = 0
                
                
            }, completion: { (done) in
                self.currentPersonLabel.isHidden = true
                self.stackView.isHidden = true
                self.IanImageView.isHidden = true
                self.ArielImageView.isHidden = true
                self.LalaImageView.isHidden = true
                self.leftArrowButton.isHidden = true
                self.rightArrowButton.isHidden = true
                self.currentPersonLabelImageView.isHidden = true
                self.currentPersonLabel.isHidden = true
            })
        }
    }
    
    @objc func switchCarButtonHit() {
        guard !virtualObjectLoader.isLoading else { return }
        
        showCarList()
        
        if carCollectionView.alpha == 0 {
            carCollectionView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.carCollectionView.alpha = 1
                self.carCollectionView.reloadData()
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.carCollectionView.alpha = 0
            }, completion: { (done) in
                self.carCollectionView.isHidden = true
            })
        }
        
        statusViewController.cancelScheduledMessage(for: .contentPlacement)
    }
    
    func showCarList() {
        virtualObjects = VirtualObject.availableObjects
        carCollectionView.reloadData()
    }
    
    @objc func modifyButtonHit() {
        //        rootCarNode?.geometry?.material(named: "verniceCarM1SG_001")?.transparency = 0.3
        
        
    }
    
    @objc func resetButtonHit() {
        self.restartExperience()
        ViewController.objectIsLoadedInAR = false
        //        playAnimation(key: "left")
        
    }
    
    // MARK: - UI Elements
    var focusSquare = FocusSquare()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    let animationView = LOTAnimationView(name: "ARDEMO")
    let scanEnvironmentLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        animationView.play()
        
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    //    let carNode = SCNScene(named: "Models.scnassets]/oldCar.scn")?.rootNode.childNode(withName: "oldCar", recursively: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ARConfiguration.isSupported == false {
            let alertController = UIAlertController(title: "AR NOT SUPPORTED", message: "Your phone does not support AR functionality", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            alertController.addAction(UIAlertAction(title: "Fasho", style: .default, handler: { (_) in
              self.dismiss(animated: true, completion: nil)
            }))
            
        
        
        } else {
        
        sceneView.delegate = self
        sceneView.session.delegate = self
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        // Set up scene content.
        setupCamera()
        sceneView.scene.rootNode.addChildNode(focusSquare)
        //        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        /*
         The `sceneView.automaticallyUpdatesLighting` option creates an
         ambient light source and modulates its intensity. This sample app
         instead modulates a global lighting environment map for use with
         physically based materials, so disable automatic lighting.
         */
        if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
            sceneView.scene.lightingEnvironment.contents = environmentMap
        }
        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [weak self] in
            self?.restartExperience()
        }
        
        //        setupBottomBar()
        setupFrameView()
        
        view.addSubview(animationView)
        
        scanEnvironmentLabel.alpha = 1
        animationView.alpha = 1
        
        animationView.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor).isActive = true
        //        animationView.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 500, height: 500)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        animationView.loopAnimation = true
        animationView.autoReverseAnimation = true
        animationView.play()
        
        
        scanEnvironmentLabel.text = "MOVE YOUR PHONE TO SCAN"
        scanEnvironmentLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanEnvironmentLabel)
        scanEnvironmentLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -130).isActive = true
        scanEnvironmentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanEnvironmentLabel.font = UIFont(name: "GaposisSolidBRK", size: 10)
        scanEnvironmentLabel.textColor = .white
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return virtualObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carCollectionView.dequeueReusableCell(withReuseIdentifier: carCellId, for: indexPath) as! CarCell
        
        //        if virtualObjects[indexPath.row].modelName == "Portal" {
        //            virtualObjects.remove(at: 1)
        //        } else {
        cell.modelName = virtualObjects[indexPath.row].modelName
        cell.model = virtualObjects[indexPath.row]
        cell.characters = characters[indexPath.row]
        cell.characterURLS = characterURLS[indexPath.row]
        cell.delegate = self
        return cell
    }
    static var objectIsLoadedInAR = false
    
    func virtualObjectAddDelete(for cell: CarCell) {
        guard let object = cell.model else { return }
        
        if virtualObjectLoader.loadedObjects.contains(object) {
            guard let objectIndex = virtualObjectLoader.loadedObjects.index(of: object) else {
                fatalError("Programmer error: Failed to lookup virtual object in scene.")
            }
            virtualObjectLoader.removeVirtualObject(at: objectIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.carCollectionView.alpha = 0
            }, completion: { (done) in
                self.carCollectionView.isHidden = true
            })
        } else {
            virtualObjectLoader.loadVirtualObject(object, loadedHandler: { [weak self] loadedObject in
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        guard let carCollection = self?.carCollectionView else { return }
                        carCollection.alpha = 0
//                        self.carCollectionView.alpha = 0
                    }, completion: { (done) in
                        guard let carCollection = self?.carCollectionView else { return }
                        guard let pvo = self?.placeVirtualObject else { return }

                        carCollection.isHidden = true
                        pvo(loadedObject)
                        
                    })
                }
            })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.sceneView.frame.width
        let height = self.sceneView.frame.height
        
        return CGSize(width: width/1.5, height: view.frame.height / 3.8)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        //            let when = DispatchTime.now() + 0.4 // change 2 to desired number of seconds
        //            DispatchQueue.main.asyncAfter(deadline: when) {
        //                self.virtualObjects.remove(at: 1)
        //                self.carCollectionView.reloadData()
        //        }
        // Start the `ARSession`.
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Scene content setup
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
    }
    
    // MARK: - Focus Square
    
    func updateFocusSquare() {
        let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            //            addObjectButton.isHidden = true
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
        statusViewController.cancelScheduledMessage(for: .focusSquare)
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        blurView.isHidden = false
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


