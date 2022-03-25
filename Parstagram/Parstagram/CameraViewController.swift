//
//  CameraViewController.swift
//  Parstagram
//
//  Created by LiYang on 3/25/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageViewe: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = false
            picker.sourceType = .camera
        } else{
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledIamge = image.af.imageScaled(to: size)
        imageViewe.image = scaledIamge
        dismiss(animated: true,completion: nil)
    }
    @IBAction func submitAction(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentText.text
        post["author"] = PFUser.current()!
        
        let imageData = imageViewe.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        
        
        post.saveInBackground { success, error in
            if success{
                print("Saved!")
                self.dismiss(animated: true, completion: nil)
            } else{
                print("Error; \(String(describing: error))")
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
