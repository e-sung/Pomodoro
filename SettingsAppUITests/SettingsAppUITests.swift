//
//  SettingsAppUITests.swift
//  SettingsAppUITests
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest

class SettingsAppUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testChangeOrCancelSettings() {
        let tableView = app.tables.firstMatch
        let focusSettingCell = tableView.cells["focusIntervalSetting"].firstMatch
        focusSettingCell.tap()
        
        sleep(1)
        let cancelButton = XCUIApplication().buttons["Cancel"]
        cancelButton.tap()
        
        focusSettingCell.tap()
        let picker = app.pickerWheels.firstMatch
        picker.adjust(toPickerWheelValue: "15 min")
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        XCTAssert(focusSettingCell.staticTexts["15 min"].exists)
        
        let breakSettingCell = tableView.cells["breakIntervalSetting"].firstMatch
        breakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "10 min")
        doneButton.tap()
        XCTAssert(breakSettingCell.staticTexts["10 min"].exists)
        
        breakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "35 min")
        cancelButton.tap()
        XCTAssert(breakSettingCell.staticTexts["10 min"].exists)
        
        let longBreakSettingCell = tableView.cells["longBreakIntervalSetting"].firstMatch
        longBreakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "35 min")
        doneButton.tap()
        XCTAssert(longBreakSettingCell.staticTexts["35 min"].exists)

        longBreakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "5 min")
        cancelButton.tap()
        XCTAssert(longBreakSettingCell.staticTexts["35 min"].exists)
        
        let targetCell = tableView.cells["targetSetting"].firstMatch
        targetCell.tap()
        picker.adjust(toPickerWheelValue: "8 intervals")
        doneButton.tap()
        XCTAssert(targetCell.staticTexts["8 intervals"].exists)
        
        targetCell.tap()
        picker.adjust(toPickerWheelValue: "7 intervals")
        cancelButton.tap()
        XCTAssert(targetCell.staticTexts["8 intervals"].exists)
    }
    
    override func tearDown() {
        let tableView = app.tables.firstMatch
        let focusSettingCell = tableView.cells["focusIntervalSetting"].firstMatch
        focusSettingCell.tap()

        let picker = app.pickerWheels.firstMatch
        picker.adjust(toPickerWheelValue: "25 min")
        let doneButton = app.buttons["Done"]
        doneButton.tap()

        let breakSettingCell = tableView.cells["breakIntervalSetting"].firstMatch
        breakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "5 min")
        doneButton.tap()

        let longBreakSettingCell = tableView.cells["longBreakIntervalSetting"].firstMatch
        longBreakSettingCell.tap()
        picker.adjust(toPickerWheelValue: "15 min")
        doneButton.tap()
        
        let targetCell = tableView.cells["targetSetting"].firstMatch
        targetCell.tap()
        picker.adjust(toPickerWheelValue: "10 intervals")
        doneButton.tap()
    }

}
