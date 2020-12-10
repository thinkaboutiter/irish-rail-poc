//
//  TrainMovementViewTestCase.swift
//  irish-rail-poc-unit-tests
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
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

import XCTest
@testable import irish_rail_poc

extension TrainMovementView: ValueProvider {}

extension TrainMovementViewTestCase {
    
    private enum Constants {
        enum Label {
            static let originDestinationLabel = "originDestinationLabel"
            static let dateLabel = "dateLabel"
            static let locationLabel = "locationLabel"
            static let locationCodeLabel = "locationCodeLabel"
            static let locationOrderLabel = "locationOrderLabel"
            static let arrivalTitleLabel = "arrivalTitleLabel"
            static let arrivalTimeLabel = "arrivalTimeLabel"
            static let departureTitleLabel = "departureTitleLabel"
            static let departureTimeLabel = "departureTimeLabel"
        }
    }
}

class TrainMovementViewTestCase: XCTestCase {
    
    // MARK: - Properties
    private var sut: TrainMovementView!
    private var viewModel: TrainMovementViewModelImpl!

    // MARK: - Life cycle
    override func setUpWithError() throws {
        let trainMovement = StaticTrainMovement.singleValue
        viewModel = TrainMovementViewModelImpl(trainMovement: trainMovement)
        sut = TrainMovementView()
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
    }
    
    // MARK: - Tests
    func test_configureUI_setsProperValueTo_originDestinationLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.originDestinationLabel)
        let expected = "\(viewModel.trainOrigin) - \(viewModel.trainDestination)".uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_dateLabelLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.dateLabel)
        let expected = viewModel.trainDate.uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_locationLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationLabel)
        let expected = viewModel.locationFullName.uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_locationCodeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationCodeLabel)
        let expected = viewModel.locationCode.uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_locationOrderLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationOrderLabel)
        let expected = "(\(viewModel.locationOrder))"
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_arrivalTitleLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.arrivalTitleLabel)
        let expected = NSLocalizedString("arrival", comment: "arrival").uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_arrivalTimeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.arrivalTimeLabel)
        let expected = "(\(viewModel.scheduledArrival))"
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_departureTitleLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.departureTitleLabel)
        let expected = NSLocalizedString("departure", comment: "departure").uppercased()
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_configureUI_setsProperValueTo_departureTimeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.departureTimeLabel)
        let expected = "(\(viewModel.scheduledDeparture))"
        
        // when
        sut.configure(with: viewModel)
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_originDestinationLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.originDestinationLabel)
        let expected = NSLocalizedString("N/A - N/A", comment: "N/A - N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_dateLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.dateLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_locationLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_locationCodeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationCodeLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_locationOrderLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.locationOrderLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_arrivalTitleLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.arrivalTitleLabel)
        let expected = NSLocalizedString("arrival", comment: "arrival").uppercased()
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_arrivalTimeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.arrivalTimeLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_departureTitleLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.departureTitleLabel)
        let expected = NSLocalizedString("departure", comment: "departure").uppercased()
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
    
    func test_resetUI_setsProperValueTo_departureTimeLabel() {
        // given
        let label: UILabel? = sut.value(forLabel: Constants.Label.departureTimeLabel)
        let expected = NSLocalizedString("N/A", comment: "N/A")
        
        // when
        sut.resetUI()
        
        // then
        XCTAssertEqual(label?.text, expected)
    }
}
