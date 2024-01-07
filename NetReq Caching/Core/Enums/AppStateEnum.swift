//
//  AppStateEnum.swift
//  NetReq Caching
//
//  Created by Fernando Putra on 07/01/24.
//

enum AppState {
    case loading, success, error(Error)

    var rawValue: String {
        switch self {
        case .loading:
            return "loading"
        case .success:
            return "success"
        case .error:
            return "error"
        }
    }
}
