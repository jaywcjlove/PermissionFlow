#if os(macOS)
import Foundation

@available(macOS 13.0, *)
enum PermissionFlowLocalizer {
    /// Resolves a localized string from the best matching `.lproj` bundle for
    /// the injected locale. Never touches `Bundle.module`; uses the resilient
    /// packaged-resource lookup and falls back to `defaultValue` when the
    /// resource bundle cannot be found.
    static func string(
        _ key: String,
        defaultValue: String,
        localeIdentifier: String?
    ) -> String {
        guard let packageBundle = PermissionFlowResources.packageBundle else {
            return defaultValue
        }

        if let localized = localizedBundle(for: localeIdentifier, in: packageBundle) {
            return localized.localizedString(forKey: key, value: defaultValue, table: nil)
        }

        return packageBundle.localizedString(forKey: key, value: defaultValue, table: nil)
    }

    private static func localizedBundle(for localeIdentifier: String?, in packageBundle: Bundle) -> Bundle? {
        guard let localeIdentifier, localeIdentifier.isEmpty == false else {
            return nil
        }

        let preferences = localizationPreferences(for: localeIdentifier)
        guard let localization = Bundle.preferredLocalizations(
            from: packageBundle.localizations,
            forPreferences: preferences
        ).first,
        let path = packageBundle.path(forResource: localization, ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }

    private static func localizationPreferences(for localeIdentifier: String) -> [String] {
        let normalizedIdentifier = localeIdentifier.replacingOccurrences(of: "_", with: "-")
        let locale = Locale(identifier: normalizedIdentifier)

        var preferences = [normalizedIdentifier]
        if let identifier = locale.language.languageCode?.identifier {
            if let script = locale.language.script?.identifier {
                preferences.append("\(identifier)-\(script)")
            }
            preferences.append(identifier)
        }

        return Array(NSOrderedSet(array: preferences)) as? [String] ?? preferences
    }
}
#endif
