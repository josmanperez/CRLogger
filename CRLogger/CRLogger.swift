//
//  CRLogger.swift
//  CRLogger
//
//  Created by Josman Pedro Pérez Expósito on 18/12/21.
//

import Foundation
import RealmSwift
import FirebaseCrashlytics

/** Enum class to capture, process and send log errors from Sync
 *  to Crashlytics as not-fatal error
 */
public enum CFLogger {
    
    /**
     * Method for parsing the log messages line by line
     * and sending the first line to Crashlytics
     * - Parameter meesage: `String` the complete error message
     */
    fileprivate static func parseTrace(message: String) {
        if message.contains("Failed to parse") {
            let messageLines = message.components(separatedBy: "\n")
            if !messageLines.isEmpty, let _line = messageLines.first {
                let userInfo = [
                    "message": _line
                ]
                Crashlytics.crashlytics().record(error: NSError.init(
                    domain: SyncLogLevel(rawValue: SyncLogLevel.error.rawValue).debugDescription , code: Int(SyncLogLevel.error.rawValue), userInfo: userInfo))
            }
        }
    }
    
    /**
     * External log call function provided to use with `SyncManager`
     * - Parameter level: `UIint` the raw value of the level associated to the stacktrace
     * - Parameter message: `String` the complete error message
     */
    public static func log(level: UInt, message: String) {
        if SyncLogLevel(rawValue: level) == SyncLogLevel.error {
            parseTrace(message: message)
        }
    }
}
