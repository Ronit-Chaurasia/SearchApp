//
//  Utility.swift
//  Ronit_HiveAssignment
//
//  Created by Ronit Chaurasia on 27/05/24.
//

import Foundation

enum errorStrings: String, Error{
    case invalidUrl = "Invalid url"
    case errorFromApi = "Error from API"
    case invalidStatusCode = "Invalid status code"
    case wrongData = "No data"
    case failedParsing = "Failed parsing"
}
