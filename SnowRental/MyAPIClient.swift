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
    
    static let stripeServerBase = "https://still-tor-66399.herokuapp.com/"
    static let serverBase = "https://flix-clothing-server.herokuapp.com/"
    
    class func emailReport(design: Design, onSuccess: @escaping () -> Void) {
        
        let parameters = ["designId": design.designId!, "apiKey": ApiKeys.sendGridApiKey]
        AF.request(URL(string: "\(serverBase)api/form")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            print(apiResponse)
            onSuccess()
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        guard let customerId = UsersManager.currentUser.stripeCustomerId else {
            print("no customerId")
            return
        }
        // maybe add a search in database for customerStripeId
        
        let parameters = ["api_version": apiVersion, "customer_id": customerId, "stripeSecretKey": ApiKeys.stripeSecretKey]
        AF.request(URL(string: "\(MyAPIClient.stripeServerBase)empheralkey.php")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            let data = apiResponse.data
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, apiResponse.error)
                return
            }
            completion(json, nil)

        }
    }
    
    class func signUpStripeCustomer(userId: String, email: String, name: String, onSuccess: @escaping () -> Void) {
        var customerDetailParams = [String: String]()
        customerDetailParams["email"] = email
        customerDetailParams["name"] = name
        customerDetailParams["stripeSecretKey"] = ApiKeys.stripeSecretKey
        AF.request(URL(string: "\(MyAPIClient.stripeServerBase)createCustomer.php")!, method: .post, parameters: customerDetailParams, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                debugPrint(response.error)
                debugPrint(response.debugDescription)
                break
            case .success:
                guard let data = response.data else {
                    return
                }
                if let stripeUid = JSON(data)["id"].string {
                    print("here")
                    Database.database().reference().child(FirebaseNodes.users).child(userId).child(FirebaseNodes.stripeCustomerId).setValue(stripeUid)
                    UsersManager.currentUser.setStripeCustomerId(id: stripeUid)
                }
                onSuccess()
                break
            }
        }
    }
    
    class func createPaymentIntent( amount: Double, currency: String, customerId: String, completion: @escaping (Result<String, AFError>)->Void) {
        let params = ["amount": amount, "currency": currency, "customerId": customerId, "stripeSecretKey": ApiKeys.stripeSecretKey] as [String: Any]
        AF.request(URL(string: "\(MyAPIClient.stripeServerBase)createpaymentintent.php")!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
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
