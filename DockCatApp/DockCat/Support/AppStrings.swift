import Foundation

struct AppStrings {
    let language: AppLanguage

    var settingsWindowTitle: String {
        switch language {
        case .chinese: "DockCat 设置"
        case .english: "DockCat Settings"
        }
    }

    var menuPet: String {
        switch language {
        case .chinese: "摸摸 (改变姿势)"
        case .english: "Pat pat (change pose)"
        }
    }

    var menuGoOut: String {
        switch language {
        case .chinese: "出门玩吧 (专注模式)"
        case .english: "Explore outdoors (focus mode)"
        }
    }

    var menuSettings: String {
        switch language {
        case .chinese: "设置"
        case .english: "Settings"
        }
    }

    var menuSleep: String {
        switch language {
        case .chinese: "去睡觉吧 (退出应用)"
        case .english: "Go to sleep (quit)"
        }
    }

    func recall(_ catName: String) -> String {
        switch language {
        case .chinese: "召回\(catName)"
        case .english: "Recall \(catName)"
        }
    }

    func statusTitle(_ state: CatState) -> String {
        switch state {
        case .transitioning:
            return language == .chinese ? "过渡" : "Transition"
        case .walking:
            return language == .chinese ? "散步" : "Walking"
        case .resting:
            return language == .chinese ? "休息" : "Resting"
        case .dragged:
            return language == .chinese ? "被抱起" : "Held"
        case .dialogue:
            return language == .chinese ? "对话" : "Dialogue"
        case .outing:
            return language == .chinese ? "出门" : "Outing"
        }
    }

    func statusLine(state: CatState, remaining: String) -> String {
        switch language {
        case .chinese: "\(statusTitle(state))：剩余\(remaining)"
        case .english: "\(statusTitle(state)): \(remaining) left"
        }
    }

    func reminderMessage(_ type: ReminderType, salutation: String) -> String {
        switch (language, type) {
        case (.chinese, .water):
            return "\(salutation)，该喝水啦"
        case (.chinese, .movement):
            return "\(salutation)，该起来走走啦"
        case (.english, .water):
            return "\(salutation), time to drink some water."
        case (.english, .movement):
            return "\(salutation), time for a stand up reminder."
        }
    }

    var done: String {
        switch language {
        case .chinese: "完成啦"
        case .english: "Done"
        }
    }

    var snoozeFiveMinutes: String {
        switch language {
        case .chinese: "稍等5分钟"
        case .english: "Wait 5 min"
        }
    }

    var cancel: String {
        switch language {
        case .chinese: "取消"
        case .english: "Cancel"
        }
    }

    var confirm: String {
        switch language {
        case .chinese: "确认"
        case .english: "Confirm"
        }
    }

    var ok: String {
        switch language {
        case .chinese: "好的"
        case .english: "OK"
        }
    }

    var minuteUnit: String {
        switch language {
        case .chinese: "分钟"
        case .english: "min"
        }
    }

    func askOutingDuration(catName: String) -> String {
        switch language {
        case .chinese: "要让\(catName)出门多久呢？"
        case .english: "How long should \(catName) go out?"
        }
    }

    var outingPrimary: String {
        switch language {
        case .chinese: "出门"
        case .english: "Go out"
        }
    }

    func outingDeparture(salutation: String) -> String {
        switch language {
        case .chinese: "我出门啦，\(salutation)工作要加油呀！"
        case .english: "I'm heading out, \(salutation). Good luck with your work!"
        }
    }

    func outingReturnEvent(salutation: String, event: OutingEvent) -> String {
        switch language {
        case .chinese: "\(salutation)，我回来啦。\(event.chineseDescription)"
        case .english: "I'm back, \(salutation). \(event.englishDescription)"
        }
    }

    func outingReturnCollectable(salutation: String) -> String {
        switch language {
        case .chinese: "我回来啦，给\(salutation)带了礼物"
        case .english: "I'm back, \(salutation). I brought you a gift."
        }
    }

    func outingReturnPlain(salutation: String) -> String {
        switch language {
        case .chinese: "\(salutation)，我回来啦"
        case .english: "I'm back, \(salutation)."
        }
    }

    var welcomeBack: String {
        switch language {
        case .chinese: "欢迎回来"
        case .english: "Welcome back"
        }
    }

    var receiveGift: String {
        switch language {
        case .chinese: "收下礼物"
        case .english: "Take gift"
        }
    }

    func recallConfirmation(catName: String) -> String {
        switch language {
        case .chinese: "提前召回会丢失可能的收藏品，确定要召回\(catName)吗？"
        case .english: "Recalling \(catName) early will lose possible collectables. Recall now?"
        }
    }
}

extension AppStrings {
    var settingsPetTab: String { language == .chinese ? "猫咪设置" : "Cat" }
    var settingsParametersTab: String { language == .chinese ? "参数设置" : "Parameters" }
    var settingsCollectablesTab: String { language == .chinese ? "收藏品箱" : "Collectables" }
    var settingsAboutTab: String { language == .chinese ? "关于" : "About" }
    var settingsSave: String { language == .chinese ? "保存" : "Save" }
    var settingsCatName: String { language == .chinese ? "猫咪名字" : "Cat name" }
    var settingsSalutation: String { language == .chinese ? "对你的称呼" : "Calls you" }
    var settingsLanguage: String { language == .chinese ? "语言" : "Language" }
    var settingsAssetPackID: String { language == .chinese ? "资源包 ID" : "Asset pack ID" }
    var settingsOpenAssetPackFolder: String { language == .chinese ? "打开资源包位置" : "Open folder" }
    var settingsLoadSelected: String { language == .chinese ? "加载所选" : "Load pack" }
    var settingsScale: String { language == .chinese ? "缩放" : "Scale" }
    var settingsStartPosition: String { language == .chinese ? "起始出现位置" : "Start position" }
    var settingsReminderSection: String { language == .chinese ? "提醒设置" : "Reminders" }
    var settingsReminderEnabled: String { language == .chinese ? "开启提醒模式" : "Enable reminders" }
    var settingsWaterReminder: String { language == .chinese ? "喝水提醒" : "Water reminder" }
    var settingsMovementReminder: String { language == .chinese ? "久坐提醒" : "Stand up reminder" }
    var settingsDefaultOutingDuration: String { language == .chinese ? "默认出门时长" : "Default outing" }
    var settingsStateSection: String { language == .chinese ? "状态参数" : "State timing" }
    var settingsRestDuration: String { language == .chinese ? "休息时长" : "Rest duration" }
    var settingsWalkDuration: String { language == .chinese ? "散步时长" : "Walk duration" }
    var settingsWalkSpeed: String { language == .chinese ? "散步基础速度" : "Walk speed" }
    var settingsDisplaySection: String { language == .chinese ? "多显示器设置" : "Display" }
    var settingsDisplayRow: String { language == .chinese ? "猫咪出现在" : "Cat appears on" }
    var settingsVersionPrefix: String { language == .chinese ? "当前版本" : "Version" }
    var settingsProjectPrefix: String { language == .chinese ? "项目地址：" : "Project: " }
    var settingsDonationLead: String { language == .chinese ? "如果你喜欢 DockCat，欢迎" : "If you like DockCat, you can " }
    var settingsDonationLink: String { language == .chinese ? "给我们赞赏" : "support us" }
    var settingsAboutDescription: String {
        language == .chinese ? "DockCat 是免费下载且开源的软件。作者：Auwuua" : "DockCat is an open-source software. Author: Auwuua"
    }
    var settingsStatisticsSection: String { language == .chinese ? "数据统计" : "Stats" }
    var settingsNoCollectables: String { language == .chinese ? "还没有收藏品" : "No collectables yet" }
    var assetPackValidationSuccessTitle: String { language == .chinese ? "加载校验结果" : "Asset pack check" }
    var assetPackValidationFailureTitle: String { language == .chinese ? "资源包加载失败" : "Asset pack failed" }
    var assetPackAlertOK: String { language == .chinese ? "好" : "OK" }

    func usageHours(_ hours: String) -> String {
        switch language {
        case .chinese: "DockCat 已陪伴你 \(hours) 小时"
        case .english: "DockCat has kept you company for \(hours) h"
        }
    }

    func reminderStats(water: Int, movement: Int) -> String {
        switch language {
        case .chinese: "已完成喝水提醒 \(water) 次、走动提醒 \(movement) 次"
        case .english: "Completed \(water) water reminders and \(movement) stand up reminders"
        }
    }

    func outingStats(catName: String, events: Int, collectables: Int) -> String {
        switch language {
        case .chinese: "\(catName) 出门遇到事件 \(events) 次、带回礼物 \(collectables) 次"
        case .english: "\(catName) found \(events) outing events and \(collectables) gifts"
        }
    }
}

extension AppStrings {
    func collectableName(_ collectable: OutingCollectable) -> String {
        switch language {
        case .chinese: collectable.chineseName
        case .english: collectable.englishName
        }
    }

    func assetPackStatusTitle(_ title: String) -> String {
        guard language == .english else { return title }
        switch title {
        case "休息状态": return "Resting poses"
        case "抱起状态": return "Held poses"
        case "对话状态": return "Dialogue poses"
        case "过渡状态": return "Transition poses"
        default: return title
        }
    }

    func assetPackError(_ error: String?) -> String {
        guard let error else {
            return language == .chinese ? "未知错误。" : "Unknown error."
        }
        guard language == .english else { return error }
        switch error {
        case "资源包 ID 不能为空。":
            return "Asset pack ID cannot be empty."
        case "资源包 ID 必须是 CatPacks 下的直属文件夹名，不能包含路径分隔符。":
            return "Asset pack ID must be a direct folder name under CatPacks and cannot contain path separators."
        case "资源包目录不存在，或不是文件夹。":
            return "The asset pack folder does not exist or is not a folder."
        case "缺少 manifest.json。":
            return "Missing manifest.json."
        case "缺少可加载的休息姿态图片。":
            return "Missing loadable resting pose images."
        case "缺少可加载的散步动画帧。":
            return "Missing loadable walking animation frames."
        case "DockCat 尚未准备好资源包加载器。", "资源包加载器尚未准备好。":
            return "DockCat is not ready to load asset packs yet."
        default:
            if error.hasPrefix("缺少可加载资源：") {
                return "Missing loadable resource: \(error.replacingOccurrences(of: "缺少可加载资源：", with: ""))"
            }
            if error.hasPrefix("manifest.json 无法解析：") {
                return "Could not parse manifest.json: \(error.replacingOccurrences(of: "manifest.json 无法解析：", with: ""))"
            }
            return error
        }
    }
}
