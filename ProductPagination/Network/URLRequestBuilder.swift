//
//  URLRequestBuilder.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation
import Network



protocol URLRequestBuilderProtocol {
    
    func fetchURLRequest<T:Decodable>(from url :URL , as : T.Type) async throws -> T
    
}

final class URLRequestBuilder : URLRequestBuilderProtocol {
    
    func fetchURLRequest<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw NetworkError.invalidResponse
            }
            
            if type == Data.self, let data = data as? T {
                return data
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(urlError)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    
    
}




enum NetworkError: Error {
    case noInternetConnection
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
    case timeout
    case unknown(Error)
    
    var title: String {
        switch self {
        case .noInternetConnection:
            return AppConstants.AlertTitles.noInternet
        case .invalidURL:
            return AppConstants.AlertTitles.invalidURL
        case .invalidResponse, .serverError:
            return AppConstants.AlertTitles.serverError
        case .decodingError:
            return AppConstants.AlertTitles.dataError
        case .timeout:
            return AppConstants.AlertTitles.requestTimeout
        case .unknown:
            return AppConstants.AlertTitles.somethingWrong
        }
    }
    
    var message: String {
        switch self {
        case .noInternetConnection:
            return AppConstants.AlertMessages.checkConnection
        case .invalidURL:
            return AppConstants.AlertMessages.resourceNotFound
        case .invalidResponse:
            return AppConstants.AlertMessages.serverUnavailable
        case .serverError(let code):
            return "\(AppConstants.AlertMessages.serverUnavailable) (Code: \(code))"
        case .decodingError:
            return AppConstants.AlertMessages.processDataError
        case .timeout:
            return AppConstants.AlertMessages.requestTooLong
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var icon: String {
        switch self {
        case .noInternetConnection:
            return AppConstants.SFSymbols.wifiSlash
        case .timeout:
            return AppConstants.SFSymbols.clockArrowCirclepath
        default:
            return AppConstants.SFSymbols.exclamationmarkTriangle
        }
    }
}


// MARK: - Network Reachability Monitor
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: AppConstants.QueueNames.networkMonitor)

    
    private(set) var isConnected: Bool = true
    private(set) var connectionType: NWInterface.InterfaceType?
    private var hasInitialUpdate = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let wasConnected = self.isConnected
            let newIsConnected = path.status == .satisfied
            
            self.isConnected = newIsConnected
            self.connectionType = path.availableInterfaces.first?.type
            
            // Skip notification on first update to avoid false positives
            if !self.hasInitialUpdate {
                self.hasInitialUpdate = true
                return
            }
            
            // Only notify if state actually changed
            if wasConnected != newIsConnected {
                DispatchQueue.main.async {
                    
                    NotificationCenter.default.post(
                        name: .networkStatusChanged,
                        object: nil,
                        userInfo: [
                            "isConnected": newIsConnected,
                            "wasConnected": wasConnected
                        ]
                    )
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func checkConnection() -> Bool {
        return isConnected
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name(AppConstants.NotificationNames.networkStatusChanged)
}
