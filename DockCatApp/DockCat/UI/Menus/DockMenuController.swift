import AppKit

@MainActor
final class DockMenuController: NSObject {
    var stateProvider: (() -> CatState)?
    var statusProvider: (() -> CatStatusSnapshot?)?
    var settingsProvider: (() -> AppSettings)?
    var onPet: (() -> Void)?
    var onOuting: (() -> Void)?
    var onRecall: (() -> Void)?
    var onSettings: (() -> Void)?
    var onSleep: (() -> Void)?

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()
        let state = stateProvider?()
        let currentSettings = settingsProvider?() ?? .defaults
        let strings = AppStrings(language: currentSettings.language)
        if let snapshot = statusProvider?() {
            menu.addItem(CatStatusMenuPresenter.statusItem(snapshot: snapshot, language: currentSettings.language))
            menu.addItem(NSMenuItem.separator())
        }
        if case .outing(.away) = state {
            menu.addItem(item(strings.recall(currentSettings.catName), #selector(recall)))
        } else {
            menu.addItem(item(strings.menuPet, #selector(pet)))
            menu.addItem(item(strings.menuGoOut, #selector(outing)))
        }
        menu.addItem(item(strings.menuSettings, #selector(settings)))
        menu.addItem(item(strings.menuSleep, #selector(sleep)))
        return menu
    }

    private func item(_ title: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    @objc private func pet() {
        onPet?()
    }

    @objc private func outing() {
        onOuting?()
    }

    @objc private func recall() {
        onRecall?()
    }

    @objc private func settings() {
        onSettings?()
    }

    @objc private func sleep() {
        onSleep?()
    }
}
