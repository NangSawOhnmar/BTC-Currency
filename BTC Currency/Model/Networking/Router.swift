//
//  Router.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import Alamofire
import SwiftyJSON

class Router{
    internal var client: Client!
    internal typealias successJSONResponse = (_ responseJSON: JSON) -> Void
    internal typealias failJSONResponse = (_ error: JSON) -> Void
    internal typealias uploadProgress = (_ progress: Double) -> Void
    
    init(client: Client) {
        self.client = client
    }
    
    internal func request(urlRequest: URLRequest,params: [String: Any]?,_ interceptor: RequestInterceptor? = nil,encoding: ParameterEncoding = JSONEncoding.default,success:@escaping successJSONResponse,fail: @escaping failJSONResponse){
        var urlRequest = urlRequest
        do{
            urlRequest = try encoding.encode(urlRequest, with: params)
            self.client.request(urlRequest, requestInterceptor: interceptor as? Interceptor) { (response) in
                self.responseJSON(response: response, success: success, fail: fail)
            }
        }catch let error{
            fail(JSON(error))
        }
    }
    
    private func responseJSON(response: AFDataResponse<Data>,success: @escaping successJSONResponse,fail: @escaping failJSONResponse){
        switch response.result{
        case .success(let value):
            switch response.response?.statusCode{
            case 200,204,201:
                let json = JSON(value)
                success(json)
            default:
                DispatchQueue.main.async {
                    fail(JSON(value))
                    print(response)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                fail(JSON(error))
            }
        }
    }
}

struct ErrorResponse {
    var code: String!
    var message: String!
    
    static func loadJSON(json: JSON) -> ErrorResponse{
        var response = ErrorResponse()
        response.code = json["code"].stringValue
        response.message = json["messages"].stringValue
        return response
    }
}
