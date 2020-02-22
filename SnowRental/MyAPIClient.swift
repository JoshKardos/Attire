//
//  APIClient.swift
//  SnowRental
//
//  Created by Josh Kardos on 2/20/20.
//  Copyright © 2020 Josh Kardos. All rights reserved.
//


import Foundation
import Alamofire
import Stripe
import SwiftyJSON
import FirebaseDatabase

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    static let serverBase = "http://10.247.36.182:80/AttireServer/"

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let parameters = ["api_version": apiVersion]
        AF.request(URL(string: "\(MyAPIClient.serverBase)empheralkey.php")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            let data = apiResponse.data
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, apiResponse.error)
                return
            }
            completion(json, nil)

        }
    }
    
    class func createCustomer(userId: String, email: String, name: String, onSuccess: @escaping () -> Void) {
        var customerDetailParams = [String: String]()
        customerDetailParams["email"] = email
        customerDetailParams["name"] = name
        
        AF.request(URL(string: "\(MyAPIClient.serverBase)createCustomer.php")!, method: .post, parameters: customerDetailParams, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                // Do whatever here
                debugPrint(response.error)
                debugPrint(response.debugDescription)
                break
            case .success:
                guard let data = response.data else {
                    return
                }
                // stripe customer id is JSON(data["id"])
                if let stripeUid = JSON(data)["id"].string {
                    print("here")
                    Database.database().reference().child(FirebaseNodes.users).child(userId).child(FirebaseNodes.stripeCustomerId).setValue(stripeUid)
                }
                onSuccess()
                break
            }
        }
    }
    
    class func createPaymentIntent( amount: Double, currency: String, customerId: String, completion: @escaping (Result<String, AFError>)->Void) {
        AF.request(URL(string: "\(MyAPIClient.serverBase)createpaymentintent.php")!, method: .post, parameters: ["amount": amount, "currency": currency, "customerId": customerId], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure:
                completion(.failure(response.error!))
                break
            case .success:
                let data = response.data
                guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : String]) as [String : String]??) else {
                    completion(.failure(response.error!))
                    return
                }
                completion(.success(json!["clientSecret"]!))
                break
            }
        }
    }
}
