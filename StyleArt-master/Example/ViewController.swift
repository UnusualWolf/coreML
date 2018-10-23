//
//  ViewController.swift
//  StyleArts
//
//  Created by Levin on 14/6/2017.
//  Copyright © 2017 Levin . All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    typealias FilteringCompletion = ((UIImage?) -> ())
    
    //MARK:- IBOutlets
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var sections:NSArray = []
    
    //MARK:- Properties
    var originalImage:UIImage?
  
    //MARK:- ViewController life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageView.layer.cornerRadius = 4
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.black.cgColor
        
        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 50, width: 60, height: 60))
        btn.setTitle("保存", for:.normal)
        btn.setTitleColor(UIColor.orange, for:.normal)
        btn.addTarget(self, action:#selector(saveAtion), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }
    @objc func saveAtion() {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            print("error!")
        }else{
            DispatchQueue.main.async {
                self.view.showHud(message: "保存成功")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                self.view.hideHud()
            }
        }
      }
    override func viewWillAppear(_ animated: Bool) {
     
       self.originalImage = self.imageView.image
       CollectionView.delegate = self
       CollectionView.dataSource = self
        
    }
    //MARK:- Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- IBActions
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    //MARK:- CollectionView datasource and delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FilterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filter", for: indexPath) as! FilterCollectionViewCell
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                cell.lbl.text = "SA:Mosaic"
                cell.imageView.image = #imageLiteral(resourceName: "mosaicImg")
            case 1:
                cell.lbl.text = "SA:Scream"
                cell.imageView.image = #imageLiteral(resourceName: "screamImg")
            case 2:
                cell.lbl.text = "SA:Muse"
                cell.imageView.image = #imageLiteral(resourceName: "museImg")
            case 3:
                cell.lbl.text = "SA:Udnie"
                cell.imageView.image = #imageLiteral(resourceName: "Udanie")
            case 4:
                cell.lbl.text = "SA:Candy"
                cell.imageView.image = #imageLiteral(resourceName: "candy")
            case 5:
                cell.lbl.text = "SA:Feathers"
                cell.imageView.image = #imageLiteral(resourceName: "Feathers")
            case 6:
                cell.lbl.text = "StarryNight"
                cell.imageView.image = #imageLiteral(resourceName: "provence.jpg")
            case 7:
                cell.lbl.text = "StarryStyle"
                cell.imageView.image = #imageLiteral(resourceName: "StarryNight.jpg")
            case 8:
                cell.lbl.text = "fuse"
                cell.imageView.image = #imageLiteral(resourceName: "fuse.jpg")
            case 9:
                cell.lbl.text = "Dsn1"
                cell.imageView.image = #imageLiteral(resourceName: "DSN1.jpg")
            case 10:
                cell.lbl.text = "Dsn3"
                cell.imageView.image = #imageLiteral(resourceName: "DSN3.jpg")
            case 11:
                cell.lbl.text = "Wave"
                cell.imageView.image = #imageLiteral(resourceName: "wave.jpg")
            case 12:
                cell.lbl.text = "Princess"
                cell.imageView.image = #imageLiteral(resourceName: "rain_princess.jpeg")
            case 13:
                cell.lbl.text = "Wreck"
                cell.imageView.image = #imageLiteral(resourceName: "wreck.jpg")
            default:
                cell.lbl.text = ""
            }
        }
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.view.showHud(message: "Loading")
        }
        if indexPath.item < 6 {
            if self.imageView.image != nil{
                StyleArt.shared.process(image: self.originalImage!, style: ArtStyle(rawValue: indexPath.row)!, compeletion: { (result) in
                    
                    if let image = result{
                        self.imageView.image = image
                    }
                })
            }
        }else if indexPath.item == 6  {
            self.process(input: self.originalImage!) { filteredImage in
                if let filteredImage = filteredImage {
                    self.imageView.image = filteredImage
                }
            }
        }else if indexPath.item == 7  {
            self.process2()
        }else if indexPath.item > 7 && indexPath.item < 11{
            if indexPath.item == 8 {
              self.process3(idx: 1)
            }else if indexPath.item == 9 {
              self.process3(idx: 2)
            }else if indexPath.item == 10{
              self.process3(idx: 3)
            }
        }
        else if indexPath.item == 11 {
            self.proces5(idx: 0)
        }
        else if indexPath.item == 12 {
            self.proces5(idx:1)
        }
        else if indexPath.item == 13 {
            self.proces5(idx:2)
        }
        DispatchQueue.main.async {
            self.view.hideHud()
        }
    }
//=====================StarryNight==================
    //MARK:- CoreML
    func process(input: UIImage, completion: @escaping FilteringCompletion) {
        
        // Initialize the NST model
        let model = StarryNight()
        
        // Next steps are pretty heavy, better process them on a background thread
        DispatchQueue.global().async {
            
            // 1 - Transform our UIImage to a PixelBuffer of appropriate size
            guard let cvBufferInput = input.pixelBuffer(width: 720, height: 720) else {
                print("UIImage to PixelBuffer failed")
                completion(nil)
                return
            }
            
            // 2 - Feed that PixelBuffer to the model
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                print("Model prediction failed")
                completion(nil)
                return
            }
            
            // 3 - Transform PixelBuffer output to UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                print("PixelBuffer to UIImage failed")
                completion(nil)
                return
            }
            
            // 4 - Resize result to the original size, then hand it back to the main thread
            let finalImage = outputImage.resize(to: input.size)
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
//=====================StarryStyle==================
    //MARK:- CoreML
    func process2(){
        
        // Style Transfer Here
        let model = StarryStyle()
        
        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
        styleArray?[0] = 1.0
        
        if let image = pixelBuffer(from: imageView.image!) {
            do {
                let predictionOutput = try model.prediction(image: image, index: styleArray!)
                
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                imageView.image = UIImage(cgImage: tempImage!)
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        }
    }
    
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 256, height: 256), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 2
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 256, 256, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        // 3
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        // 4
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 256, height: 256, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // 5
        context?.translateBy(x: 0, y: 256)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }

//=====================fuse Dsn==================
    enum SelectedModel: Int {
        case fuse = 0,dsn3,dsn1
        
        var outputLayerName: String {
            switch self {
            case .fuse:
                return "upscore-fuse"
            case .dsn3:
                return "upscore-dsn3"
            case .dsn1:
                return "upscore-dsn1"
            }
        }
    }
    
    var hedMain = HED_fuse()
    var hedSO = HED_so()
    var selectedModel: SelectedModel = .fuse

    func process3(idx: NSInteger){
        switch idx {
        case 1:
            self.selectedModel = .fuse
        case 2:
            self.selectedModel = .dsn1
        case 3:
            self.selectedModel = .dsn3
        default:
            self.selectedModel = .fuse
        }
        let inputW = 500
        let inputH = 500
        guard let inputPixelBuffer =
            self.originalImage?.resize(to: CGSize(width: inputW, height: inputH)).pixelBuffer(width: inputW, height: inputH) else {
            fatalError("Couldn't create pixel buffer.")
        }
        let featureProvider: MLFeatureProvider
        if idx == 1 {
           featureProvider = try! hedMain.prediction(data: inputPixelBuffer)
        }else{
           featureProvider = try! hedSO.prediction(data: inputPixelBuffer)
        }
        
        // Retrieve results
        guard let outputFeatures = featureProvider.featureValue(for: selectedModel.outputLayerName)?.multiArrayValue else {
            fatalError("Couldn't retrieve features")
        }
        
        // Calculate total buffer size by multiplying shape tensor's dimensions
        let bufferSize = outputFeatures.shape.lazy.map { $0.intValue }.reduce(1, { $0 * $1 })
        
        // Get data pointer to the buffer
        let dataPointer = UnsafeMutableBufferPointer(start: outputFeatures.dataPointer.assumingMemoryBound(to: Double.self),
                                                     count: bufferSize)
        
        // Prepare buffer for single-channel image result
        var imgData = [UInt8](repeating: 0, count: bufferSize)
        
        // Normalize result features by applying sigmoid to every pixel and convert to UInt8
        for i in 0..<inputW {
            for j in 0..<inputH {
                let idx = i * inputW + j
                let value = dataPointer[idx]
                
                let sigmoid = { (input: Double) -> Double in
                    return 1 / (1 + exp(-input))
                }
                
                let result = sigmoid(value)
                imgData[idx] = UInt8(result * 255)
            }
        }
        
        // Create single chanel gray-scale image out of our freshly-created buffer
        let cfbuffer = CFDataCreate(nil, &imgData, bufferSize)!
        let dataProvider = CGDataProvider(data: cfbuffer)!
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let cgImage = CGImage(width: inputW, height: inputH, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: inputW, space: colorSpace, bitmapInfo: [], provider: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        let resultImage = UIImage(cgImage: cgImage!)
        self.imageView.image = resultImage;
    }
    
//==================Rain=====================
    private let models = [
        wave().model,
//        rain_princess().model
    ]
    // MARK: - Processing
    private func stylizeImage(cgImage: CGImage, model: MLModel) -> CGImage {
        
        let input = StyleTransferInput(input: pixelBuffer(cgImage:cgImage, width: 883, height: 720))
        
//        let options = MLPredictionOptions()
//        options.usesCPUOnly = true // Can't use GPU in the background
//
//        let outFeatures = try! model.prediction(from: input, options: options)
        let outFeatures = try! model.prediction(from: input)
        
        let output = outFeatures.featureValue(for: "add_37__0")!.imageBufferValue!
        CVPixelBufferLockBaseAddress(output, .readOnly)
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: CVPixelBufferGetBytesPerRow(output),
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
    }
    
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer!
    }
    private func toggleLoading(show: Bool) {
        
    }
    
    func proces4(idx: NSInteger){
//        let image = self.originalImage?.cgImage
        let image = UIImage(named: "chicago")?.cgImage
        let model = models[idx]
       
        toggleLoading(show: true)
        DispatchQueue.global(qos: .userInteractive).async {
            let stylized = self.stylizeImage(cgImage: image!, model: model)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(cgImage: stylized)
         }
       }
    }
    //Wave princess wreck
    func proces5(idx: NSInteger){
        let input =  pixelBuffer(cgImage:(self.originalImage?.cgImage)!, width: 480, height: 640)
        var imageOutputBufferRef:CVPixelBuffer? = nil
        if idx == 0 {
            let waveM = STWaveMLModel()
           let outPut:STWaveMLModelOutput = try! waveM.prediction(input1: input )
            imageOutputBufferRef = outPut.output1
        }
        else if idx == 1{
           let princessM = STPrincessMLModel()
           let outPut:STPrincessMLModelOutput = try! princessM.prediction(input1: input)
            imageOutputBufferRef = outPut.output1
        }else if idx == 2{
            let wreckM = STShipwreckMLModel()
            let outPut:STShipwreckMLModelOutput = try! wreckM.prediction(input1:input)
            imageOutputBufferRef = outPut.output1
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let stylized = UIImage(pixelBuffer: imageOutputBufferRef!)
            DispatchQueue.main.async {
                self.imageView.image = stylized
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true)
      
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        originalImage = image
        imageView.image = image
    }
}
