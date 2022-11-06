//
//  ShareBottomSheetController.swift
//  Share
//
//  Created by 최동규 on 2022/11/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

final class ShareBottomSheetController: UIViewController {

    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!

    private let image: UIImage
    private let colorMenu: ShareColorMenu
    private var cancellabels = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        sheetView.layer.cornerRadius = 20
        saveButton.setImage(saveButton.currentImage?.withTintColor(.white) , for: .normal)
        shareButton.setImage(shareButton.currentImage?.withTintColor(.white) , for: .normal)

        saveButton.tapPublisher
            .sink { [weak self] _ in
                self?.saveImage()
            }.store(in: &cancellabels)

        dismissButton.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellabels)

        shareButton.tapPublisher
            .sink { [weak self] _ in
                self?.shareToInstartgram()
            }.store(in: &cancellabels)
    }

    init?(coder: NSCoder, image: UIImage, color: ShareColorMenu) {
        self.image = image
        self.colorMenu = color
        super.init(coder: coder)
    }

    required public init?(coder: NSCoder) {
        fatalError("This viewController must be init with image.")
    }

    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func shareToInstartgram() {
        if let storyShareURL = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storyShareURL)
            {

                guard let imageData = image.pngData() else {return}


                let pasteboardItems : [String:Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor" : colorMenu.backgroundColor.hexString ?? "b2bec3",
                    "com.instagram.sharedSticker.backgroundBottomColor" : colorMenu.labelColor.hexString ?? "#636e72",

                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                ]

                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)


                UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)


            }
            else
            {
                let alert = UIAlertController(title: "알림", message: "인스타그램이 필요합니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }


    //MARK: - Save Image callback


    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {

            print(error.localizedDescription)

        } else {

            print("Success")
        }

    }

}

extension ShareBottomSheetController {
    public static func create(image: UIImage, color: ShareColorMenu) -> ShareBottomSheetController? {
        let storyboard = UIStoryboard(name: "Share", bundle: .init(for: self))
        return storyboard.instantiateViewController(identifier: "ShareBottomSheetController") { coder in
            return ShareBottomSheetController(coder: coder, image: image, color: color)
        }

    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
