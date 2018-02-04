//
//  ViewController.swift
//  FBlogin
//
//  Created by 張書涵 on 2018/2/4.
//  Copyright © 2018年 AliceChang. All rights reserved.
//
import UIKit
import FacebookLogin
import FacebookCore


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email,.userFriends], viewController: self) { (loginResult) in
            switch loginResult{
            case .failed(let error):
                print(error)
            //失敗的時候回傳
            case .cancelled:
                print("the user cancels login")
            //取消時回傳內容
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.getDetails()
                print("user log in")
                //成功時print("user log in")
            }
        }
    }
    

    func getDetails(){
        guard let _ = AccessToken.current else{return}
        let param = ["fields":"name, email , gender , picture.width(640).height(480)"]
        let graphRequest = GraphRequest(graphPath: "me",parameters: param)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult{
            case .failed(let error):
                print(error)
            case .success(response: let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue{
                    let name = responseDictionary["name"] as! String
                    let gender = responseDictionary["gender"] as! String
                    if let photo = responseDictionary["picture"] as? NSDictionary{
                        let data = photo["data"] as! NSDictionary
                        let picURL = data["url"] as! String
                        print(name , gender , picURL)
                        
                        DispatchQueue.global().async {
                            let imgData = NSData(contentsOf: URL(string: picURL)!)
                            
                            DispatchQueue.main.async {
                                self.nameLabel.text = name
                                self.genderLabel.text = gender
                                let userImage = UIImage(data: imgData! as Data)
                                self.photoImgView.image = userImage
                            }
                        }
                    }
                    
                }
            }
        }
    }
}













