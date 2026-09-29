import XCTest
@testable import iQualize

final class EQIntensityTests: XCTestCase {

    func testFullIntensityLeavesGainUnchanged() {
        XCTAssertEqual(EQIntensity.scaledGain(6, by: 1), 6)
        XCTAssertEqual(EQIntensity.scaledGain(-9.5, by: 1), -9.5)
    }

    func testZeroIntensityFlattensBoostsAndCuts() {
        XCTAssertEqual(EQIntensity.scaledGain(12, by: 0), 0)
        XCTAssertEqual(EQIntensity.scaledGain(-12, by: 0), 0)
    }

    func testPartialIntensityScalesProportionally() {
        XCTAssertEqual(EQIntensity.scaledGain(8, by: 0.5), 4)
        XCTAssertEqual(EQIntensity.scaledGain(-6, by: 0.25), -1.5)
    }

    func testOutOfRangeIntensityIsClamped() {
        XCTAssertEqual(EQIntensity.scaledGain(6, by: 2), 6)
        XCTAssertEqual(EQIntensity.scaledGain(6, by: -1), 0)
    }

    func testNonFiniteIntensityFallsBackToFullStrength() {
        XCTAssertEqual(EQIntensity.scaledGain(6, by: .nan), 6)
        XCTAssertEqual(EQIntensity.scaledGain(6, by: .infinity), 6)
    }

    func testScaledBandOnlyChangesGain() {
        let band = EQBand(frequency: 1000, gain: 10, bandwidth: 0.7, filterType: .highShelf)
        let scaled = EQIntensity.scaled(band, by: 0.3)
        XCTAssertEqual(scaled.gain, 3, accuracy: 0.0001)
        XCTAssertEqual(scaled.frequency, band.frequency)
        XCTAssertEqual(scaled.bandwidth, band.bandwidth)
        XCTAssertEqual(scaled.filterType, band.filterType)
        XCTAssertEqual(scaled.id, band.id)
    }
}
