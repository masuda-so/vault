import Foundation
import SwiftData
import XCTest

@testable import vault

final class VaultFoundationTests: XCTestCase {
  @MainActor
  func testProductIdentityMatchesBundleConvention() {
    let product = ProductDefinition.vault

    XCTAssertEqual(product.identifier, "vault")
    XCTAssertEqual(product.bundleIdentifier, "llc.ether.\(product.identifier)")
    XCTAssertEqual(
      VaultCommerceCatalog.dailyPassProductID,
      "\(product.bundleIdentifier).pro.daily"
    )
    XCTAssertEqual(
      VaultCommerceCatalog.monthlyProductID,
      "\(product.bundleIdentifier).pro.monthly"
    )
    XCTAssertEqual(
      VaultCommerceCatalog.yearlyProductID,
      "\(product.bundleIdentifier).pro.yearly"
    )
    XCTAssertEqual(
      VaultCommerceCatalog.catalog.nonRenewingDurations[VaultCommerceCatalog.dailyPassProductID],
      24 * 60 * 60
    )
    XCTAssertEqual(product.name, "Vault")
    XCTAssertFalse(product.tagline.isEmpty)
    XCTAssertEqual(
      product.privacyPolicyURL.absoluteString,
      "https://ether-llc.com/apps/vault/privacy/"
    )
    XCTAssertEqual(
      product.termsOfUseURL.absoluteString,
      "https://ether-llc.com/apps/vault/terms/"
    )
  }

  func testActiveDailyPassIsHiddenFromPurchaseOptions() {
    XCTAssertEqual(
      ProductID.offeredProductIDs(dailyPassIsActive: false),
      ProductID.all
    )
    XCTAssertEqual(
      ProductID.offeredProductIDs(dailyPassIsActive: true),
      ProductID.subscriptions
    )
    XCTAssertFalse(
      ProductID.offeredProductIDs(dailyPassIsActive: true).contains(
        VaultCommerceCatalog.dailyPassProductID
      )
    )
  }

  @MainActor
  func testApplicationSectionsRemainDistinct() {
    let sections: Set<AppSection> = [.notes, .assistant, .pro, .settings]

    XCTAssertEqual(sections.count, 4)
  }

  @MainActor
  func testLegalURLsMatchPublishedRoutesAndLocale() {
    let product = ProductDefinition.vault
    let base = "https://ether-llc.com/apps/\(product.identifier)"
    let urls = [
      (product.privacyPolicyURL, "privacy"),
      (product.termsOfUseURL, "terms"),
      (product.supportURL, "support"),
    ]

    for (url, route) in urls {
      XCTAssertEqual(url.absoluteString, "\(base)/\(route)/")
      XCTAssertEqual(
        product.localizedLegalURL(url, for: Locale(identifier: "en_US")),
        url
      )

      let japaneseURL = product.localizedLegalURL(
        url,
        for: Locale(identifier: "ja_JP")
      )
      XCTAssertEqual(
        japaneseURL.absoluteString,
        "https://ether-llc.com/ja/apps/\(product.identifier)/\(route)/"
      )
      XCTAssertEqual(
        product.localizedLegalURL(japaneseURL, for: Locale(identifier: "ja_JP")),
        japaneseURL
      )
    }
  }

  @MainActor
  func testDailyPassControlsProAccessAtExpiration() {
    let expiration = Date(timeIntervalSince1970: 100_000)
    let entitlements = EntitlementSnapshot(
      activeProductIDs: [VaultCommerceCatalog.dailyPassProductID],
      expirationDates: [VaultCommerceCatalog.dailyPassProductID: expiration]
    )

    XCTAssertTrue(
      entitlements.hasPremiumAccess(
        in: VaultCommerceCatalog.catalog,
        at: expiration.addingTimeInterval(-1)
      )
    )
    XCTAssertFalse(
      entitlements.hasPremiumAccess(in: VaultCommerceCatalog.catalog, at: expiration)
    )
  }

  @MainActor
  func testAppEnvironmentUsesInjectedDateForDailyPassAccess() {
    let expiration = Date(timeIntervalSince1970: 100_000)
    let entitlements = EntitlementSnapshot(
      activeProductIDs: [VaultCommerceCatalog.dailyPassProductID],
      expirationDates: [VaultCommerceCatalog.dailyPassProductID: expiration]
    )
    let environmentBeforeExpiration = AppEnvironment(
      aiClient: UnavailableAIClient(reason: .modelNotReady),
      subscriptionClient: PreviewSubscriptionClient(),
      currentDate: { expiration.addingTimeInterval(-1) }
    )
    environmentBeforeExpiration.entitlements = entitlements
    XCTAssertTrue(environmentBeforeExpiration.isPremium)
    XCTAssertTrue(
      environmentBeforeExpiration.isProductActive(VaultCommerceCatalog.dailyPassProductID)
    )

    let environmentAtExpiration = AppEnvironment(
      aiClient: UnavailableAIClient(reason: .modelNotReady),
      subscriptionClient: PreviewSubscriptionClient(),
      currentDate: { expiration }
    )
    environmentAtExpiration.entitlements = entitlements
    XCTAssertFalse(environmentAtExpiration.isPremium)
    XCTAssertFalse(
      environmentAtExpiration.isProductActive(VaultCommerceCatalog.dailyPassProductID)
    )
  }

  func testExpirationDelayUsesInjectedCurrentDate() {
    let currentDate = Date(timeIntervalSince1970: 1_000)

    XCTAssertEqual(
      AppEnvironment.expirationDelay(
        until: currentDate.addingTimeInterval(60),
        from: currentDate
      ),
      .seconds(60)
    )
    XCTAssertEqual(
      AppEnvironment.expirationDelay(
        until: currentDate.addingTimeInterval(-1),
        from: currentDate
      ),
      .zero
    )
  }

  @MainActor
  func testInMemoryDataContainerStartsWithoutPreviewRecords() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)

    XCTAssertTrue(try dataContainer.context.fetch(FetchDescriptor<Note>()).isEmpty)
  }

  @MainActor
  func testDataContainerCreatesEditsAndDeletesNote() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let note = Note(
      title: "Idea",
      text: "First",
      tags: "planning, private",
      summary: "A short organized summary."
    )

    dataContainer.context.insert(note)
    try dataContainer.context.save()
    let saved = try XCTUnwrap(
      dataContainer.context.fetch(FetchDescriptor<Note>()).first
    )
    saved.text = "Revised"
    try dataContainer.context.save()
    XCTAssertEqual(
      try dataContainer.context.fetch(FetchDescriptor<Note>()).first?.text,
      "Revised"
    )
    XCTAssertEqual(saved.tags, "planning, private")
    XCTAssertEqual(saved.summary, "A short organized summary.")

    dataContainer.context.delete(saved)
    try dataContainer.context.save()
    XCTAssertTrue(try dataContainer.context.fetch(FetchDescriptor<Note>()).isEmpty)
  }

  @MainActor
  func testManualContentEditInvalidatesGeneratedMetadata() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let note = Note(
      title: "Organized",
      text: "Original",
      tags: "planning, private, journal",
      summary: "Summary of the original text."
    )
    dataContainer.context.insert(note)
    try dataContainer.context.save()

    note.applyManualEdit(
      title: "Edited",
      text: "Revised",
      updatedAt: Date(timeIntervalSince1970: 123)
    )
    try dataContainer.context.save()

    let saved = try XCTUnwrap(
      dataContainer.context.fetch(FetchDescriptor<Note>()).first
    )
    XCTAssertEqual(saved.title, "Edited")
    XCTAssertEqual(saved.text, "Revised")
    XCTAssertNil(saved.tags)
    XCTAssertNil(saved.summary)
    XCTAssertEqual(saved.updatedAt, Date(timeIntervalSince1970: 123))
  }

  @MainActor
  func testSearchPredicateFiltersTheQueryAtThePersistentStore() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    dataContainer.context.insert(Note(title: "Release plan", text: "August"))
    dataContainer.context.insert(Note(title: "買い物", text: "りんご"))
    try dataContainer.context.save()

    let matchingTitle = FetchDescriptor<Note>(
      predicate: Note.predicate(searchText: "release")
    )
    let matchingText = FetchDescriptor<Note>(
      predicate: Note.predicate(searchText: "りんご")
    )
    let allNotes = FetchDescriptor<Note>(
      predicate: Note.predicate(searchText: "")
    )

    XCTAssertEqual(try dataContainer.context.fetch(matchingTitle).map(\.title), ["Release plan"])
    XCTAssertEqual(try dataContainer.context.fetch(matchingText).map(\.title), ["買い物"])
    XCTAssertEqual(try dataContainer.context.fetch(allNotes).count, 2)
  }

  @MainActor
  func testFailedTransactionDiscardsPendingNote() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        dataContainer.context.insert(Note(title: "Unsaved", text: ""))
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    XCTAssertTrue(try dataContainer.context.fetch(FetchDescriptor<Note>()).isEmpty)
  }

  @MainActor
  func testFailedEditRestoresPersistedNote() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let note = Note(title: "Saved", text: "Original")
    dataContainer.context.insert(note)
    try dataContainer.context.save()

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        note.text = "Unsaved change"
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    let saved = try XCTUnwrap(
      dataContainer.context.fetch(FetchDescriptor<Note>()).first
    )
    XCTAssertEqual(saved.text, "Original")
  }

  @MainActor
  func testFailedDeleteRestoresPersistedNote() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let note = Note(title: "Saved", text: "Original")
    dataContainer.context.insert(note)
    try dataContainer.context.save()

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        dataContainer.context.delete(note)
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    XCTAssertEqual(try dataContainer.context.fetch(FetchDescriptor<Note>()).count, 1)
  }

  func testTransactionFailureTriggersRollback() {
    var didRollback = false

    XCTAssertThrowsError(
      try ModelContext.performTransactionOrRollback(
        transaction: { throw CocoaError(.fileWriteNoPermission) },
        rollback: { didRollback = true }
      )
    )
    XCTAssertTrue(didRollback)
  }
}
