//
//  GetAllStationsWebService.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import SimpleLogger

/// Get All Stations
///
///     http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML
///
/// returns a list of all stations with StationDesc, StaionCode, StationId, StationAlias, StationLatitude and StationLongitude ordered by Latitude, Longitude
final class GetAllStationsWebService: BaseWebService<Station> {
    
    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getAllStations)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        return
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [Station] {
        return try StationParser.parse(xmlString)
    }
}
