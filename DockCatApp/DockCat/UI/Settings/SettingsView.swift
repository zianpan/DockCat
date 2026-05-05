import AppKit
import SwiftUI

struct SettingsView: View {
    @State private var draft: AppSettings
    private let usageStatistics: UsageStatistics
    private let outingCatalog: OutingCatalog
    private let collectableInventory: CollectableInventory
    private let dialogueImage: NSImage?
    private let labelWidth: CGFloat = 112
    private let controlWidth: CGFloat = 180
    private let panelWidth: CGFloat = 360
    var onSave: (AppSettings) -> Void

    init(
        settings: AppSettings,
        usageStatistics: UsageStatistics,
        outingCatalog: OutingCatalog,
        collectableInventory: CollectableInventory,
        dialogueImage: NSImage?,
        onSave: @escaping (AppSettings) -> Void
    ) {
        _draft = State(initialValue: settings)
        self.usageStatistics = usageStatistics
        self.outingCatalog = outingCatalog
        self.collectableInventory = collectableInventory
        self.dialogueImage = dialogueImage
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView {
                petTab
                    .tabItem { Text("宠物") }

                parametersTab
                    .tabItem { Text("参数") }

                collectablesTab
                    .tabItem { Text("收藏品箱") }

                aboutTab
                    .tabItem { Text("关于/支持") }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)

            Divider()

            HStack {
                Spacer()
                Button("保存") {
                    onSave(normalized(draft))
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(14)
        }
        .frame(width: 520, height: 500)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var petTab: some View {
        VStack(spacing: 18) {
            petImage
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 12) {
                compactTextField("宠物名字", text: $draft.catName)
                compactTextField("对你的称呼", text: $draft.userSalutation)
                compactTextField("资源包 ID", text: $draft.selectedAssetPackID)
                compactStepper("缩放", value: scaleBinding, range: 1...100, step: 1, suffix: "%")
            }
            .frame(width: labelWidth + controlWidth, alignment: .center)
        }
        .padding(.top, 16)
        .padding(.horizontal, 36)
    }

    @ViewBuilder
    private var petImage: some View {
        if let dialogueImage {
            Image(nsImage: dialogueImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .separatorColor).opacity(0.25))
                .frame(width: 120, height: 120)
        }
    }

    private var parametersTab: some View {
        VStack(alignment: .center, spacing: 14) {
            GroupBox {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("开启提醒模式", isOn: $draft.remindersEnabled)
                        .frame(width: labelWidth + controlWidth, alignment: .leading)
                    compactStepper("喝水提醒", value: minutesBinding(\.waterReminderInterval), range: 1...240, step: 5, suffix: "分钟")
                    compactStepper("久坐提醒", value: minutesBinding(\.movementReminderInterval), range: 5...360, step: 5, suffix: "分钟")
                    compactStepper("默认出门时长", value: minutesBinding(\.defaultOutingDuration), range: 5...480, step: 5, suffix: "分钟")
                }
                .padding(.vertical, 6)
            } label: {
                sectionTitle("提醒设置")
            }
            .frame(width: panelWidth)

            GroupBox {
                VStack(alignment: .leading, spacing: 10) {
                    rangeRow("休息时长", minimum: minutesBinding(\.restDurationMinimum), maximum: minutesBinding(\.restDurationMaximum), range: 1...480)
                    rangeRow("散步时长", minimum: minutesBinding(\.walkDurationMinimum), maximum: minutesBinding(\.walkDurationMaximum), range: 1...480)
                    compactStepper("散步基础速度", value: speedBinding, range: 8...240, step: 4, suffix: "px/s")
                }
                .padding(.vertical, 6)
            } label: {
                sectionTitle("状态参数")
            }
            .frame(width: panelWidth)

            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 14)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
    }

    private var aboutTab: some View {
        VStack(spacing: 16) {
            Text("当前版本：\(appVersion)")
                .font(.system(size: 14, weight: .semibold))

            VStack(spacing: 6) {
                Text("DockCat 是免费下载且开源的软件。")
                HStack(spacing: 0) {
                    Text("项目地址：")
                    Link("https://github.com/Auwuua/DockCat", destination: projectURL)
                }
            }

            HStack(spacing: 0) {
                Text("如果你喜欢 DockCat，欢迎")
                Link("给我们赞赏", destination: donationURL)
            }
        }
        .frame(width: panelWidth)
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.2"
    }

    private var projectURL: URL {
        URL(string: "https://github.com/Auwuua/DockCat")!
    }

    private var donationURL: URL {
        URL(string: "https://github.com/Auwuua/DockCat/blob/main/Wechat_donate.jpg")!
    }

    private var collectablesTab: some View {
        VStack(alignment: .center, spacing: 14) {
            GroupBox {
                VStack(alignment: .center, spacing: 8) {
                    Text("DockCat 已陪伴你 \(usageStatistics.litScreenUsageHoursText) 小时")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: labelWidth + controlWidth, alignment: .center)
                    Text("已完成喝水提醒 \(usageStatistics.completedWaterReminderCount) 次、走动提醒 \(usageStatistics.completedMovementReminderCount) 次")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: labelWidth + controlWidth, alignment: .center)
                    Text("\(draft.catName) 出门遇到事件 \(usageStatistics.outingEventCount) 次、带回礼物 \(usageStatistics.outingCollectableCount) 次")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: labelWidth + controlWidth, alignment: .center)
                }
                .frame(width: labelWidth + controlWidth, alignment: .center)
                .padding(.vertical, 6)
            } label: {
                sectionTitle("数据统计")
            }
            .frame(width: panelWidth, alignment: .center)

            if acquiredCollectables.isEmpty {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(nsColor: .separatorColor).opacity(0.45), lineWidth: 1)
                    .frame(width: 360, height: 150)
                    .overlay {
                        Text("还没有收藏品")
                            .foregroundStyle(.secondary)
                    }
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(92), spacing: 12), count: 4), spacing: 12) {
                        ForEach(acquiredCollectables) { item in
                            collectableCell(item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(height: 220)
            }

            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 14)
    }

    private var acquiredCollectables: [CollectableDisplayItem] {
        let collectablesByID = Dictionary(uniqueKeysWithValues: outingCatalog.collectables.map { ($0.id, $0) })
        return collectableInventory.acquiredEntries.compactMap { entry in
            guard let collectable = collectablesByID[entry.collectableID] else { return nil }
            return CollectableDisplayItem(
                collectable: collectable,
                imageURL: outingCatalog.imageURL(for: collectable),
                count: entry.count,
                isNew: collectableInventory.recentNewCollectableID == collectable.id
            )
        }
        .sorted {
            if $0.collectable.rarity == $1.collectable.rarity {
                return $0.collectable.chineseName < $1.collectable.chineseName
            }
            return $0.collectable.rarity > $1.collectable.rarity
        }
    }

    private func collectableCell(_ item: CollectableDisplayItem) -> some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(nsColor: .separatorColor).opacity(0.45), lineWidth: 1)
                    }
                collectableImage(url: item.imageURL)
                    .frame(width: 72, height: 72, alignment: .center)
                if item.isNew {
                    VStack {
                        HStack {
                            Spacer()
                            Text("New")
                                .font(.system(size: 10, weight: .semibold))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .padding(4)
                        }
                        Spacer()
                    }
                }
            }
            .frame(width: 88, height: 78)

            Text(item.collectable.chineseName)
                .font(.system(size: 12))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(width: 88)
            Text(String(repeating: "★", count: item.collectable.rarity))
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(width: 88)
        }
        .frame(width: 92, height: 122)
    }

    @ViewBuilder
    private func collectableImage(url: URL) -> some View {
        if let image = NSImage(contentsOf: url) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        } else {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(nsColor: .separatorColor).opacity(0.25))
        }
    }

    private func compactTextField(_ title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .frame(width: labelWidth, alignment: .trailing)
            TextField(title, text: text)
                .textFieldStyle(.roundedBorder)
                .frame(width: controlWidth)
        }
        .frame(width: labelWidth + controlWidth, alignment: .leading)
    }

    private func compactStepper(
        _ title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        suffix: String
    ) -> some View {
        HStack {
            Text(title)
                .frame(width: labelWidth, alignment: .trailing)
            HStack(spacing: 6) {
                Text("\(Int(value.wrappedValue))")
                    .font(.system(.body, design: .monospaced))
                    .frame(width: 48, alignment: .trailing)
                Stepper("", value: value, in: range, step: step)
                    .labelsHidden()
                    .frame(width: 22)
                Text(suffix)
                    .frame(width: controlWidth - 82, alignment: .leading)
            }
            .frame(width: controlWidth, alignment: .leading)
        }
        .frame(width: labelWidth + controlWidth, alignment: .leading)
    }

    private func rangeRow(
        _ title: String,
        minimum: Binding<Double>,
        maximum: Binding<Double>,
        range: ClosedRange<Double>
    ) -> some View {
        HStack {
            Text(title)
                .frame(width: labelWidth, alignment: .trailing)
            HStack(spacing: 4) {
                numericStepper(value: minimum, range: range, step: 1)
                Text("–")
                numericStepper(value: maximum, range: range, step: 1)
                Text("分钟")
            }
            .frame(width: controlWidth, alignment: .leading)
        }
        .frame(width: labelWidth + controlWidth, alignment: .leading)
    }

    private func numericStepper(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        HStack(spacing: 3) {
            Text("\(Int(value.wrappedValue))")
                .font(.system(.body, design: .monospaced))
                .frame(width: 28, alignment: .trailing)
            Stepper("", value: value, in: range, step: step)
                .labelsHidden()
                .frame(width: 22)
        }
        .frame(width: 54, alignment: .leading)
    }

    private var speedBinding: Binding<Double> {
        Binding(
            get: { draft.walkBaseSpeed },
            set: { draft.walkBaseSpeed = max(1, $0) }
        )
    }

    private var scaleBinding: Binding<Double> {
        Binding(
            get: { draft.catScalePercent },
            set: { draft.catScalePercent = max(1, min(100, $0)) }
        )
    }

    private func minutesBinding(_ keyPath: WritableKeyPath<AppSettings, TimeInterval>) -> Binding<Double> {
        Binding(
            get: { draft[keyPath: keyPath] / 60 },
            set: { draft[keyPath: keyPath] = $0 * 60 }
        )
    }

    private func normalized(_ settings: AppSettings) -> AppSettings {
        var normalized = settings
        if normalized.restDurationMinimum > normalized.restDurationMaximum {
            let minimum = normalized.restDurationMaximum
            normalized.restDurationMaximum = normalized.restDurationMinimum
            normalized.restDurationMinimum = minimum
        }
        if normalized.walkDurationMinimum > normalized.walkDurationMaximum {
            let minimum = normalized.walkDurationMaximum
            normalized.walkDurationMaximum = normalized.walkDurationMinimum
            normalized.walkDurationMinimum = minimum
        }
        normalized.walkBaseSpeed = max(1, normalized.walkBaseSpeed)
        normalized.catScalePercent = max(1, min(100, normalized.catScalePercent))
        return normalized
    }
}

private struct CollectableDisplayItem: Identifiable {
    var collectable: OutingCollectable
    var imageURL: URL
    var count: Int
    var isNew: Bool

    var id: String {
        collectable.id
    }
}
