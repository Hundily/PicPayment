//
//  WebServiceSpec.swift
//  PicPaymentTests
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Nimble
import Quick
import OHHTTPStubs
import Foundation
@testable import PicPayment

// swiftlint:disable all

struct TestModel: Codable {
    let test: String
}

extension BaseWebservice {
    static func jsonDataSuccess() -> Data {
        let jsonSuccess: [String: String] = ["test": "ok"]
        return try! JSONSerialization.data(withJSONObject: jsonSuccess)
    }
    
    static func notJSONDataSuccess() -> Data {
        let string = "test"
        return Data(base64Encoded: string)!
    }
}

final class WebserviceSpec: QuickSpec {
    
    override func spec() {
        describe("Test request function") {
            
            var webservice: BaseWebservice!
            let dummyURLString = "dummyURL.com"
            let httpDummyURLString = "http://dummyURL.com"
            
            beforeEach {
                webservice = BaseWebservice()
            }
            
            it("return success with correct data when receives 200") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.jsonDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success(let testModel):
                            expect(testModel.test) == "ok"
                        case .failure:
                            XCTFail()
                        }
                        done()
                    }
                }
            }
            
            it("return no connection when receives not connected to internet error") {
                
                stub(condition: isHost(dummyURLString)) { _ in
                    let error = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil)
                    return OHHTTPStubsResponse(error: error)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.notConnectedToInternet
                        }
                        done()
                    }
                }
            }
            
            it("return unexpected error when receives a unhandled error") {
                
                stub(condition: isHost(dummyURLString)) { _ in
                    let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue, userInfo: nil)
                    return OHHTTPStubsResponse(error: error)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.unexpected
                        }
                        done()
                    }
                }
            }
            
            it("return timeout error when receives a timeout error") {
                
                stub(condition: isHost(dummyURLString)) { _ in
                    let error = NSError(domain: NSURLErrorDomain, code: URLError.timedOut.rawValue, userInfo: nil)
                    return OHHTTPStubsResponse(error: error)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.timedOut
                        }
                        done()
                    }
                }
            }
            
            it("return unauthorized error when receives 401") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.jsonDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 401, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.unauthorized
                        }
                        done()
                    }
                }
            }
            
            it("return internal server error when receives 500") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.jsonDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 500, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.internalServerError
                        }
                        done()
                    }
                }
            }
            
            it("return unexpected error when receives 999") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.jsonDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 999, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.unexpected
                        }
                        done()
                    }
                }
            }
            
            it("return forbidden error when receives 403") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.jsonDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 403, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.forbidden
                        }
                        done()
                    }
                }
            }
            
            it("return malformed url error when URL is malformed") {
                waitUntil { done in
                    webservice.request(urlString: "") {(result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.malformedURL
                        }
                        done()
                    }
                }
            }
            
            it("return unparseable error when receives unparseable data") {
                stub(condition: isHost(dummyURLString)) { _ in
                    let data = BaseWebservice.notJSONDataSuccess()
                    return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
                }
                
                waitUntil { done in
                    webservice.request(urlString: httpDummyURLString) { (result: Result<TestModel, WebserviceError>) in
                        switch result {
                        case .success:
                            XCTFail("This test must be failed")
                        case let .failure(error):
                            expect(error) == WebserviceError.unparseable
                        }
                        done()
                    }
                }
            }
        }
    }
}


