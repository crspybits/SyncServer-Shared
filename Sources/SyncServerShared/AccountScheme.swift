//
//  AccountScheme.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 9/7/19.
//

import Foundation

public struct AccountScheme: Equatable {
    private let name: String
    public let userType: UserType
    
    // e.g., "GoogleToken", "DropboxToken"
    public typealias AuthTokenType = String
    public let authTokenType:AuthTokenType
    
    // Each of the following Strings, if non-nil, needs to be distinct from others used in other AccountScheme's for the same purpose
    
    // Nil if not cloud storage (i.e., if sharing UserType), but otherwise, e.g., "Dropbox" or "Google"
    public typealias CloudStorageType = String
    public var cloudStorageType: CloudStorageType? {
        return userType == .sharing ? nil : name
    }

    // e.g., "Google", "Facebook", "Dropbox"
    public typealias AccountName = String
    public var accountName: AccountName {
        return name
    }
    
    private init(name: String, authTokenType: AuthTokenType, userType: UserType) {
        self.userType = userType
        self.authTokenType = authTokenType
        self.name = name
    }
    
    public static let google = AccountScheme(name: "Google", authTokenType: "GoogleToken", userType: .owning)
    public static let dropbox = AccountScheme(name: "Dropbox", authTokenType: "DropboxToken", userType: .owning)
    public static let facebook = AccountScheme(name: "Facebook", authTokenType: "FacebookToken", userType: .sharing)
    public static let microsoft = AccountScheme(name: "Microsoft", authTokenType: "MicrosoftToken", userType: .owning)
    public static let appleSignIn = AccountScheme(name: "AppleSignIn", authTokenType: "AppleSignInToken", userType: .sharing)
    
    public static let all:[AccountScheme] = [.google, .dropbox, .facebook, .microsoft, .appleSignIn]
    
    public enum InitFrom {
        case authTokenType(AuthTokenType)
        case accountName(AccountName)
    }
    
    public init?(_ from: InitFrom) {
        var result = [AccountScheme]()
        
        switch from {
        case .authTokenType(let authTokenType):
            result = AccountScheme.all.filter { $0.authTokenType == authTokenType }
        case .accountName(let accountName):
            result = AccountScheme.all.filter { $0.accountName == accountName }
        }
        
        if result.count == 1 {
            self = result[0]
        }
        else {
            return nil
        }
    }
}
