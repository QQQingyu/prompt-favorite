import Cocoa
import ApplicationServices
import ServiceManagement

enum Language {
    case zh
    case en
}

enum LanguageMode: String, CaseIterable {
    case system
    case zh
    case en

    var title: String {
        switch self {
        case .system:
            return L10n.text("language.system")
        case .zh:
            return L10n.text("language.zh")
        case .en:
            return L10n.text("language.en")
        }
    }
}

enum L10n {
    private static var languageMode: LanguageMode = .system

    static func configure(languageMode: LanguageMode) {
        self.languageMode = languageMode
    }

    private static var systemLanguage: Language {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? ""
        return preferred.hasPrefix("zh") ? .zh : .en
    }

    static var language: Language {
        switch languageMode {
        case .system:
            return systemLanguage
        case .zh:
            return .zh
        case .en:
            return .en
        }
    }

    static func text(_ key: String) -> String {
        switch language {
        case .zh:
            return zh[key] ?? en[key] ?? key
        case .en:
            return en[key] ?? key
        }
    }

    private static let zh: [String: String] = [
        "trigger.doubleOption": "连按两次 Option",
        "trigger.commandOptionP": "Command + Option + P",
        "trigger.commandShiftP": "Command + Shift + P",
        "trigger.off": "关闭",
        "behavior.review": "保存前确认",
        "behavior.quick": "快速保存",
        "menu.captureSelectedText": "收藏当前选中文本",
        "menu.target": "目标",
        "menu.chooseTargetFolder": "选择目标文件夹...",
        "menu.collection": "文件",
        "menu.saveFormatSettings": "保存格式设置...",
        "menu.globalTrigger": "全局触发方式",
        "menu.captureBehavior": "收藏行为",
        "menu.language": "界面语言",
        "menu.launchAtStartup": "开机时自动启动",
        "menu.checkCapturePermission": "检查捕获权限",
        "menu.openTargetFolder": "打开目标文件夹",
        "menu.openAccessibilitySettings": "打开辅助功能权限设置",
        "menu.quit": "退出 Prompt Favorite",
        "language.system": "跟随系统",
        "language.zh": "中文",
        "language.en": "English",
        "alert.savePrompt.title": "保存 Prompt",
        "alert.savePrompt.message": "选择这条 prompt 追加到哪里。",
        "button.save": "保存",
        "button.cancel": "取消",
        "button.chooseFolder": "选择...",
        "field.title": "标题",
        "field.targetFolder": "目标文件夹",
        "field.collectionFile": "Collection 文件",
        "field.prompt": "Prompt",
        "alert.format.title": "保存格式设置",
        "alert.format.message": "这些默认值会用于全局收藏流程。",
        "field.defaultCollectionFile": "默认文件",
        "field.entryTitleTemplate": "条目标题模板",
        "field.timestampFormat": "时间格式",
        "field.entrySeparator": "条目分割线",
        "field.codeFenceLanguage": "代码块语言",
        "field.preview": "标题预览",
        "section.saveTarget": "收藏文件",
        "section.entryFormat": "Markdown 条目",
        "section.preview": "Markdown 预览",
        "preview.sampleTitle": "PRD Review",
        "preview.samplePrompt": "请审阅这份 PRD，只指出阻塞性的逻辑问题。",
        "error.accessibilityDenied": "Prompt Favorite 当前没有通过 macOS 辅助功能校验。需要授权的是 Prompt Favorite，不是复制的目标 App。若已经授权，通常是 App 在授权后被重新构建或覆盖，导致 macOS 权限记录失效。请删除系统设置里的旧 Prompt Favorite，重新添加当前安装位置，然后重启 App。",
        "error.noSelectedText": "没有复制到选中文本。请先选中文本；如果权限刚开启过，请退出并重新打开 Prompt Favorite。",
        "error.title": "Prompt Favorite",
        "permission.title": "捕获权限",
        "permission.trusted": "辅助功能校验：已通过",
        "permission.untrusted": "辅助功能校验：未通过",
        "permission.status": "当前状态",
        "permission.menuEnabled": "已开启",
        "permission.menuDisabled": "未开启",
        "permission.bundleId": "Bundle ID",
        "permission.path": "当前 App 路径",
        "permission.openSettings": "打开系统设置",
        "launchAtStartup.requiresApproval": "已提交开机时自动启动请求。请在系统设置 > 通用 > 登录项中允许 Prompt Favorite。",
        "launchAtStartup.unsupported": "当前 macOS 版本不支持通过此 App 设置开机时自动启动。",
        "error.launchAtStartup": "更新开机时自动启动失败：%@",
        "status.saved": "已保存",
        "notice.savedTo": "已保存到 %@",
        "default.untitledPrompt": "未命名 prompt"
    ]

    private static let en: [String: String] = [
        "trigger.doubleOption": "Double Option",
        "trigger.commandOptionP": "Command + Option + P",
        "trigger.commandShiftP": "Command + Shift + P",
        "trigger.off": "Off",
        "behavior.review": "Review Before Save",
        "behavior.quick": "Quick Save",
        "menu.captureSelectedText": "Capture Selected Text",
        "menu.target": "Target",
        "menu.chooseTargetFolder": "Choose Target Folder...",
        "menu.collection": "Collection",
        "menu.saveFormatSettings": "Save Format Settings...",
        "menu.globalTrigger": "Global Trigger",
        "menu.captureBehavior": "Capture Behavior",
        "menu.language": "Language",
        "menu.launchAtStartup": "Launch at Startup",
        "menu.checkCapturePermission": "Check Capture Permission",
        "menu.openTargetFolder": "Open Target Folder",
        "menu.openAccessibilitySettings": "Open Accessibility Settings",
        "menu.quit": "Quit Prompt Favorite",
        "language.system": "Follow System",
        "language.zh": "中文",
        "language.en": "English",
        "alert.savePrompt.title": "Save Prompt",
        "alert.savePrompt.message": "Choose where this prompt should be appended.",
        "button.save": "Save",
        "button.cancel": "Cancel",
        "button.chooseFolder": "Choose...",
        "field.title": "Title",
        "field.targetFolder": "Target folder",
        "field.collectionFile": "Collection file",
        "field.prompt": "Prompt",
        "alert.format.title": "Save Format Settings",
        "alert.format.message": "These defaults are used by the global capture flow.",
        "field.defaultCollectionFile": "Default file",
        "field.entryTitleTemplate": "Entry title template",
        "field.timestampFormat": "Timestamp format",
        "field.entrySeparator": "Entry separator",
        "field.codeFenceLanguage": "Code fence language",
        "field.preview": "Heading preview",
        "section.saveTarget": "Collection File",
        "section.entryFormat": "Markdown Entry",
        "section.preview": "Markdown Preview",
        "preview.sampleTitle": "PRD Review",
        "preview.samplePrompt": "Review this PRD and only point out blocking logic issues.",
        "error.accessibilityDenied": "Prompt Favorite is not passing the macOS Accessibility trust check. The app that needs permission is Prompt Favorite, not the source app. If it is already enabled, the app was likely rebuilt or replaced after permission was granted, so the macOS permission record is stale. Remove the old Prompt Favorite entry in System Settings, add the current installed app again, then reopen it.",
        "error.noSelectedText": "No selected text was copied. Select text first; if permission was just enabled, quit and reopen Prompt Favorite.",
        "error.title": "Prompt Favorite",
        "permission.title": "Capture Permission",
        "permission.trusted": "Accessibility trust check: passed",
        "permission.untrusted": "Accessibility trust check: failed",
        "permission.status": "Status",
        "permission.menuEnabled": "Enabled",
        "permission.menuDisabled": "Disabled",
        "permission.bundleId": "Bundle ID",
        "permission.path": "Current app path",
        "permission.openSettings": "Open Settings",
        "launchAtStartup.requiresApproval": "Launch at Startup was requested. Allow Prompt Favorite in System Settings > General > Login Items.",
        "launchAtStartup.unsupported": "This macOS version does not support configuring Launch at Startup from this app.",
        "error.launchAtStartup": "Failed to update Launch at Startup: %@",
        "status.saved": "Saved",
        "notice.savedTo": "Saved to %@",
        "default.untitledPrompt": "Untitled prompt"
    ]
}

enum TriggerMode: String, CaseIterable {
    case doubleOption
    case commandOptionP
    case commandShiftP
    case off

    var title: String {
        switch self {
        case .doubleOption:
            return L10n.text("trigger.doubleOption")
        case .commandOptionP:
            return L10n.text("trigger.commandOptionP")
        case .commandShiftP:
            return L10n.text("trigger.commandShiftP")
        case .off:
            return L10n.text("trigger.off")
        }
    }
}

enum CaptureBehavior: String, CaseIterable {
    case review
    case quick

    var title: String {
        switch self {
        case .review:
            return L10n.text("behavior.review")
        case .quick:
            return L10n.text("behavior.quick")
        }
    }
}

struct AppSettings {
    private let defaults = UserDefaults.standard

    var targetFolder: String {
        get {
            defaults.string(forKey: "targetFolder")
                ?? (FileManager.default.homeDirectoryForCurrentUser
                    .appendingPathComponent("Documents")
                    .appendingPathComponent("Prompt Favorite")
                    .path)
        }
        set { defaults.set(newValue, forKey: "targetFolder") }
    }

    var collectionFile: String {
        get { defaults.string(forKey: "collectionFile") ?? "Favorites.md" }
        set { defaults.set(newValue, forKey: "collectionFile") }
    }

    var triggerMode: TriggerMode {
        get {
            TriggerMode(rawValue: defaults.string(forKey: "triggerMode") ?? "") ?? .doubleOption
        }
        set { defaults.set(newValue.rawValue, forKey: "triggerMode") }
    }

    var captureBehavior: CaptureBehavior {
        get {
            CaptureBehavior(rawValue: defaults.string(forKey: "captureBehavior") ?? "") ?? .review
        }
        set { defaults.set(newValue.rawValue, forKey: "captureBehavior") }
    }

    var languageMode: LanguageMode {
        get {
            LanguageMode(rawValue: defaults.string(forKey: "languageMode") ?? "") ?? .system
        }
        set { defaults.set(newValue.rawValue, forKey: "languageMode") }
    }

    var titleTemplate: String {
        get { defaults.string(forKey: "titleTemplate") ?? "{{time}} - {{title}}" }
        set { defaults.set(newValue, forKey: "titleTemplate") }
    }

    var timestampFormat: String {
        get { defaults.string(forKey: "timestampFormat") ?? "yyyy-MM-dd HH:mm:ss" }
        set { defaults.set(newValue, forKey: "timestampFormat") }
    }

    var entrySeparator: String {
        get { defaults.string(forKey: "entrySeparator") ?? "---" }
        set { defaults.set(newValue, forKey: "entrySeparator") }
    }

    var codeFenceLanguage: String {
        get { defaults.string(forKey: "codeFenceLanguage") ?? "prompt" }
        set { defaults.set(newValue, forKey: "codeFenceLanguage") }
    }
}

struct PromptDraft {
    var text: String
    var title: String
    var targetFolder: String
    var collectionFile: String
}

struct PasteboardSnapshot {
    let items: [[NSPasteboard.PasteboardType: Data]]

    static func capture() -> PasteboardSnapshot {
        let pasteboard = NSPasteboard.general
        let capturedItems = (pasteboard.pasteboardItems ?? []).map { item in
            var dataByType: [NSPasteboard.PasteboardType: Data] = [:]
            for type in item.types {
                if let data = item.data(forType: type) {
                    dataByType[type] = data
                }
            }
            return dataByType
        }
        return PasteboardSnapshot(items: capturedItems)
    }

    func restore() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let restoredItems = items.map { dataByType in
            let item = NSPasteboardItem()
            for (type, data) in dataByType {
                item.setData(data, forType: type)
            }
            return item
        }
        pasteboard.writeObjects(restoredItems)
    }
}

final class PromptStore {
    static func append(_ draft: PromptDraft, settings: AppSettings) throws -> URL {
        let folder = cleanFolderPath(draft.targetFolder)
        let fileName = cleanCollectionFileName(draft.collectionFile)
        let folderURL = URL(fileURLWithPath: folder, isDirectory: true)
        let fileURL = folderURL.appendingPathComponent(fileName)
        let now = Date()

        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)

        let entry = renderEntry(draft: draft, settings: settings, date: now)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let current = try String(contentsOf: fileURL, encoding: .utf8)
            let updated = updateHeaderTimestamp(current, date: now)
            try (updated + entry).write(to: fileURL, atomically: true, encoding: .utf8)
        } else {
            let header = renderHeader(folder: folder, fileName: fileName, date: now)
            try (header + entry).write(to: fileURL, atomically: true, encoding: .utf8)
        }

        return fileURL
    }

    private static func cleanFolderPath(_ value: String) -> String {
        let expanded = NSString(string: value.trimmingCharacters(in: .whitespacesAndNewlines)).expandingTildeInPath
        return expanded.isEmpty
            ? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Documents/Prompt Favorite").path
            : expanded
    }

    private static func cleanCollectionFileName(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = trimmed.isEmpty ? "Favorites.md" : trimmed
        let fileName = URL(fileURLWithPath: base).lastPathComponent
        return fileName.lowercased().hasSuffix(".md") ? fileName : "\(fileName).md"
    }

    private static func renderHeader(folder: String, fileName: String, date: Date) -> String {
        let title = fileName.lowercased().hasSuffix(".md") ? String(fileName.dropLast(3)) : fileName
        let stamp = isoString(date)
        return """
        ---
        title: "\(escapeYaml(title))"
        tags:
          - prompt-collection
        folder: "\(escapeYaml(folder))"
        created: \(stamp)
        updated: \(stamp)
        ---

        """
    }

    private static func renderEntry(draft: PromptDraft, settings: AppSettings, date: Date) -> String {
        let separator = settings.entrySeparator.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "---"
            : settings.entrySeparator.trimmingCharacters(in: .whitespacesAndNewlines)
        let timestamp = formatted(date, format: settings.timestampFormat)
        let title = normalizedTitle(draft.title.isEmpty ? titleFromText(draft.text) : draft.title)
        let heading = renderEntryHeading(template: settings.titleTemplate, timestamp: timestamp, title: title)
        let fence = codeFence(for: draft.text)
        let language = settings.codeFenceLanguage.trimmingCharacters(in: .whitespacesAndNewlines)

        return """

        \(separator)

        ## \(heading)

        \(fence)\(language)
        \(draft.text.trimmingCharacters(in: .newlines))
        \(fence)

        """
    }

    private static func updateHeaderTimestamp(_ content: String, date: Date) -> String {
        let stamp = isoString(date)
        guard let regex = try? NSRegularExpression(pattern: #"(?m)^updated: .*$"#) else {
            return content
        }
        let range = NSRange(content.startIndex..<content.endIndex, in: content)
        return regex.stringByReplacingMatches(in: content, range: range, withTemplate: "updated: \(stamp)")
    }

    private static func titleFromText(_ text: String) -> String {
        let first = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? "Untitled prompt"
        return String(first.prefix(80))
    }

    private static func normalizedTitle(_ text: String) -> String {
        text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func codeFence(for text: String) -> String {
        var longest = 0
        var current = 0
        for character in text {
            if character == "`" {
                current += 1
                longest = max(longest, current)
            } else {
                current = 0
            }
        }
        return String(repeating: "`", count: max(3, longest + 1))
    }

    private static func formatted(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.isEmpty ? "yyyy-MM-dd HH:mm:ss" : format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    private static func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    private static func escapeYaml(_ value: String) -> String {
        value.replacingOccurrences(of: #"\"#, with: #"\\"#)
            .replacingOccurrences(of: #"""#, with: #"\""#)
    }
}

func renderEntryHeading(template: String, timestamp: String, title: String) -> String {
    let fallback = "{{time}} - {{title}}"
    let raw = template.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? fallback : template
    let rendered = raw
        .replacingOccurrences(of: "{{time}}", with: timestamp)
        .replacingOccurrences(of: "{{title}}", with: title)
    return raw.contains("{{time}}") ? rendered : "\(timestamp) - \(rendered)"
}

func formattedPreviewDate(_ date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "yyyy-MM-dd HH:mm:ss"
        : format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}

func capturePermissionDiagnosticText() -> String {
    let trusted = AXIsProcessTrusted()
    let status = trusted ? L10n.text("permission.trusted") : L10n.text("permission.untrusted")
    let bundleID = Bundle.main.bundleIdentifier ?? "unknown"
    let bundlePath = Bundle.main.bundleURL.path
    return """
    \(status)

    \(L10n.text("permission.bundleId")): \(bundleID)
    \(L10n.text("permission.path")): \(bundlePath)
    """
}

final class SavePromptWindowController: NSWindowController {
    private let titleField: NSTextField
    private let folderField: NSTextField
    private let fileField: NSTextField
    private let textView: NSTextView
    private let onSave: (PromptDraft) -> Void
    private let onCancel: () -> Void
    private var didComplete = false

    init(draft: PromptDraft, onSave: @escaping (PromptDraft) -> Void, onCancel: @escaping () -> Void) {
        self.titleField = NSTextField(string: draft.title)
        self.folderField = NSTextField(string: draft.targetFolder)
        self.fileField = NSTextField(string: draft.collectionFile)
        self.textView = NSTextView()
        self.textView.string = draft.text
        self.onSave = onSave
        self.onCancel = onCancel

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 620),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.text("alert.savePrompt.title")
        window.center()
        super.init(window: window)
        window.delegate = self
        buildUI(in: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI(in window: NSWindow) {
        guard let contentView = window.contentView else {
            return
        }

        let root = NSStackView()
        root.orientation = .vertical
        root.alignment = .leading
        root.spacing = 14
        root.edgeInsets = NSEdgeInsets(top: 24, left: 28, bottom: 22, right: 28)
        root.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(root)

        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            root.topAnchor.constraint(equalTo: contentView.topAnchor),
            root.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        let title = NSTextField(labelWithString: L10n.text("alert.savePrompt.title"))
        title.font = NSFont.boldSystemFont(ofSize: 22)
        title.alignment = .left

        let subtitle = NSTextField(labelWithString: L10n.text("alert.savePrompt.message"))
        subtitle.font = NSFont.systemFont(ofSize: 13)
        subtitle.textColor = .secondaryLabelColor
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.maximumNumberOfLines = 2

        root.addArrangedSubview(title)
        root.addArrangedSubview(subtitle)
        root.addArrangedSubview(formRow(label: L10n.text("field.title"), field: titleField))
        root.addArrangedSubview(folderRow())
        root.addArrangedSubview(formRow(label: L10n.text("field.collectionFile"), field: fileField))
        root.addArrangedSubview(promptSection())
        root.addArrangedSubview(buttonRow())

        for field in [titleField, folderField, fileField] {
            field.font = NSFont.systemFont(ofSize: 14)
            field.lineBreakMode = .byTruncatingMiddle
        }
    }

    private func formRow(label: String, field: NSTextField) -> NSView {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 6

        let labelView = labelView(label)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 664).isActive = true
        field.heightAnchor.constraint(equalToConstant: 28).isActive = true

        stack.addArrangedSubview(labelView)
        stack.addArrangedSubview(field)
        return stack
    }

    private func folderRow() -> NSView {
        let wrapper = NSStackView()
        wrapper.orientation = .vertical
        wrapper.alignment = .leading
        wrapper.spacing = 6

        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8

        folderField.translatesAutoresizingMaskIntoConstraints = false
        folderField.widthAnchor.constraint(equalToConstant: 548).isActive = true
        folderField.heightAnchor.constraint(equalToConstant: 28).isActive = true

        let chooseButton = NSButton(title: L10n.text("button.chooseFolder"), target: self, action: #selector(chooseFolder))
        chooseButton.bezelStyle = .rounded
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.widthAnchor.constraint(equalToConstant: 108).isActive = true

        row.addArrangedSubview(folderField)
        row.addArrangedSubview(chooseButton)
        wrapper.addArrangedSubview(labelView(L10n.text("field.targetFolder")))
        wrapper.addArrangedSubview(row)
        return wrapper
    }

    private func promptSection() -> NSView {
        let wrapper = NSStackView()
        wrapper.orientation = .vertical
        wrapper.alignment = .leading
        wrapper.spacing = 6

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.borderType = .bezelBorder
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.widthAnchor.constraint(equalToConstant: 664).isActive = true
        scroll.heightAnchor.constraint(equalToConstant: 260).isActive = true

        textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.frame = NSRect(x: 0, y: 0, width: 664, height: 260)
        textView.minSize = NSSize(width: 0, height: 260)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize = NSSize(width: 664, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        scroll.documentView = textView

        wrapper.addArrangedSubview(labelView(L10n.text("field.prompt")))
        wrapper.addArrangedSubview(scroll)
        return wrapper
    }

    private func buttonRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 12

        let spacer = NSView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: 418).isActive = true

        let cancel = NSButton(title: L10n.text("button.cancel"), target: self, action: #selector(cancel))
        cancel.bezelStyle = .rounded
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.widthAnchor.constraint(equalToConstant: 110).isActive = true

        let save = NSButton(title: L10n.text("button.save"), target: self, action: #selector(save))
        save.bezelStyle = .rounded
        save.keyEquivalent = "\r"
        save.translatesAutoresizingMaskIntoConstraints = false
        save.widthAnchor.constraint(equalToConstant: 124).isActive = true

        row.addArrangedSubview(spacer)
        row.addArrangedSubview(cancel)
        row.addArrangedSubview(save)
        return row
    }

    private func labelView(_ text: String) -> NSTextField {
        let view = NSTextField(labelWithString: text)
        view.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .secondaryLabelColor
        return view
    }

    @objc private func chooseFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = URL(fileURLWithPath: NSString(string: folderField.stringValue).expandingTildeInPath)

        if panel.runModal() == .OK, let url = panel.url {
            folderField.stringValue = url.path
        }
    }

    @objc private func save() {
        didComplete = true
        onSave(
            PromptDraft(
                text: textView.string,
                title: titleField.stringValue,
                targetFolder: folderField.stringValue,
                collectionFile: fileField.stringValue
            )
        )
        close()
    }

    @objc private func cancel() {
        didComplete = true
        onCancel()
        close()
    }
}

extension SavePromptWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if !didComplete {
            onCancel()
        }
    }
}

final class FormatSettingsWindowController: NSWindowController {
    private let collectionField: NSTextField
    private let templateField: NSTextField
    private let timestampField: NSTextField
    private let separatorField: NSTextField
    private let languageField: NSTextField
    private let previewTextView: NSTextView
    private let onSave: (String, String, String, String, String) -> Void
    private let onCancel: () -> Void
    private var didComplete = false

    init(settings: AppSettings, onSave: @escaping (String, String, String, String, String) -> Void, onCancel: @escaping () -> Void) {
        self.collectionField = NSTextField(string: settings.collectionFile)
        self.templateField = NSTextField(string: settings.titleTemplate)
        self.timestampField = NSTextField(string: settings.timestampFormat)
        self.separatorField = NSTextField(string: settings.entrySeparator)
        self.languageField = NSTextField(string: settings.codeFenceLanguage)
        self.previewTextView = NSTextView(frame: .zero)
        self.onSave = onSave
        self.onCancel = onCancel

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 680, height: 560),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.text("alert.format.title")
        window.center()
        super.init(window: window)
        window.delegate = self
        buildUI(in: window)
        updatePreview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI(in window: NSWindow) {
        guard let contentView = window.contentView else {
            return
        }

        let root = NSStackView()
        root.orientation = .vertical
        root.alignment = .width
        root.spacing = 18
        root.edgeInsets = NSEdgeInsets(top: 28, left: 32, bottom: 24, right: 32)
        root.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(root)

        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            root.topAnchor.constraint(equalTo: contentView.topAnchor),
            root.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        let title = NSTextField(labelWithString: L10n.text("alert.format.title"))
        title.font = NSFont.boldSystemFont(ofSize: 21)
        let subtitle = NSTextField(labelWithString: L10n.text("alert.format.message"))
        subtitle.font = NSFont.systemFont(ofSize: 13)
        subtitle.textColor = .secondaryLabelColor
        subtitle.lineBreakMode = .byWordWrapping

        root.addArrangedSubview(title)
        root.addArrangedSubview(subtitle)

        root.addArrangedSubview(
            section(
                title: L10n.text("section.saveTarget"),
                rows: [
                    formRow(label: L10n.text("field.defaultCollectionFile"), field: collectionField)
                ]
            )
        )
        root.addArrangedSubview(
            section(
                title: L10n.text("section.entryFormat"),
                rows: [
                    formRow(label: L10n.text("field.entryTitleTemplate"), field: templateField),
                    formRow(label: L10n.text("field.timestampFormat"), field: timestampField),
                    formRow(label: L10n.text("field.entrySeparator"), field: separatorField),
                    formRow(label: L10n.text("field.codeFenceLanguage"), field: languageField)
                ]
            )
        )
        root.addArrangedSubview(previewSection())
        root.addArrangedSubview(buttonRow())

        for field in [collectionField, templateField, timestampField, separatorField, languageField] {
            field.font = NSFont.systemFont(ofSize: 14)
            field.delegate = self
        }
        collectionField.placeholderString = "Favorites.md"
        templateField.placeholderString = "{{time}} - {{title}}"
        timestampField.placeholderString = "yyyy-MM-dd HH:mm:ss"
        separatorField.placeholderString = "---"
        languageField.placeholderString = "prompt"
    }

    private func section(title: String, rows: [NSView]) -> NSView {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .width
        stack.spacing = 10

        let titleView = NSTextField(labelWithString: title)
        titleView.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        titleView.textColor = .labelColor

        stack.addArrangedSubview(titleView)
        for row in rows {
            stack.addArrangedSubview(row)
        }
        return stack
    }

    private func formRow(label: String, field: NSTextField) -> NSView {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .firstBaseline
        stack.spacing = 14

        let label = labelView(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 164).isActive = true

        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 438).isActive = true
        field.heightAnchor.constraint(equalToConstant: 28).isActive = true

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(field)
        return stack
    }

    private func previewSection() -> NSView {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .width
        stack.spacing = 10

        previewTextView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        previewTextView.textColor = .labelColor
        previewTextView.backgroundColor = .textBackgroundColor
        previewTextView.drawsBackground = true
        previewTextView.isEditable = false
        previewTextView.isSelectable = true
        previewTextView.textContainerInset = NSSize(width: 8, height: 8)
        previewTextView.textContainer?.lineFragmentPadding = 0
        previewTextView.textContainer?.widthTracksTextView = true
        previewTextView.isHorizontallyResizable = false
        previewTextView.isVerticallyResizable = true

        let scrollView = NSScrollView()
        scrollView.borderType = .bezelBorder
        scrollView.drawsBackground = true
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.documentView = previewTextView
        previewTextView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalToConstant: 616).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 118).isActive = true

        let titleView = NSTextField(labelWithString: L10n.text("section.preview"))
        titleView.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        titleView.textColor = .labelColor

        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(scrollView)
        return stack
    }

    private func buttonRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 12

        let spacer = NSView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let cancel = NSButton(title: L10n.text("button.cancel"), target: self, action: #selector(cancel))
        cancel.bezelStyle = .rounded
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.widthAnchor.constraint(equalToConstant: 110).isActive = true

        let save = NSButton(title: L10n.text("button.save"), target: self, action: #selector(save))
        save.bezelStyle = .rounded
        save.keyEquivalent = "\r"
        save.translatesAutoresizingMaskIntoConstraints = false
        save.widthAnchor.constraint(equalToConstant: 124).isActive = true

        row.addArrangedSubview(spacer)
        row.addArrangedSubview(cancel)
        row.addArrangedSubview(save)
        return row
    }

    private func labelView(_ text: String) -> NSTextField {
        let view = NSTextField(labelWithString: text)
        view.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .secondaryLabelColor
        view.alignment = .right
        return view
    }

    private func updatePreview() {
        let timestamp = formattedPreviewDate(Date(), format: timestampField.stringValue)
        let sampleTitle = L10n.text("preview.sampleTitle")
        let separator = separatorField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "---"
            : separatorField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let language = languageField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let heading = renderEntryHeading(
            template: templateField.stringValue,
            timestamp: timestamp,
            title: sampleTitle
        )
        previewTextView.string = """
        \(separator)

        ## \(heading)

        ```\(language)
        \(L10n.text("preview.samplePrompt"))
        ```
        """
    }

    func controlTextDidChange(_ obj: Notification) {
        updatePreview()
    }

    @objc private func save() {
        didComplete = true
        onSave(
            collectionField.stringValue,
            templateField.stringValue,
            timestampField.stringValue,
            separatorField.stringValue,
            languageField.stringValue
        )
        close()
    }

    @objc private func cancel() {
        didComplete = true
        onCancel()
        close()
    }
}

extension FormatSettingsWindowController: NSWindowDelegate, NSTextFieldDelegate {
    func windowWillClose(_ notification: Notification) {
        if !didComplete {
            onCancel()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private var settings = AppSettings()
    private var optionDown = false
    private var optionCleanTap = false
    private var lastOptionTapAt: TimeInterval = 0
    private var isCapturing = false
    private var saveWindowController: SavePromptWindowController?
    private var formatWindowController: FormatSettingsWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        L10n.configure(languageMode: settings.languageMode)
        setupStatusItem()
        installEventMonitors()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = makeStatusIcon()
        statusItem.button?.image?.isTemplate = true
        statusItem.button?.imagePosition = .imageOnly
        statusItem.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(actionItem(L10n.text("menu.captureSelectedText"), #selector(captureSelectedTextFromMenu)))
        menu.addItem(NSMenuItem.separator())

        let folderItem = NSMenuItem(title: "\(L10n.text("menu.target")): \(shortPath(settings.targetFolder))", action: nil, keyEquivalent: "")
        folderItem.isEnabled = false
        menu.addItem(folderItem)
        menu.addItem(actionItem(L10n.text("menu.chooseTargetFolder"), #selector(chooseTargetFolder)))

        let fileItem = NSMenuItem(title: "\(L10n.text("menu.collection")): \(settings.collectionFile)", action: nil, keyEquivalent: "")
        fileItem.isEnabled = false
        menu.addItem(fileItem)
        menu.addItem(actionItem(L10n.text("menu.saveFormatSettings"), #selector(showFormatSettings)))
        menu.addItem(NSMenuItem.separator())

        let triggerMenu = NSMenu()
        for mode in TriggerMode.allCases {
            let item = NSMenuItem(title: mode.title, action: #selector(setTriggerMode(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = mode.rawValue
            item.state = mode == settings.triggerMode ? .on : .off
            triggerMenu.addItem(item)
        }
        let triggerItem = NSMenuItem(title: L10n.text("menu.globalTrigger"), action: nil, keyEquivalent: "")
        triggerItem.submenu = triggerMenu
        menu.addItem(triggerItem)

        let behaviorMenu = NSMenu()
        for behavior in CaptureBehavior.allCases {
            let item = NSMenuItem(title: behavior.title, action: #selector(setCaptureBehavior(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = behavior.rawValue
            item.state = behavior == settings.captureBehavior ? .on : .off
            behaviorMenu.addItem(item)
        }
        let behaviorItem = NSMenuItem(title: L10n.text("menu.captureBehavior"), action: nil, keyEquivalent: "")
        behaviorItem.submenu = behaviorMenu
        menu.addItem(behaviorItem)

        let languageMenu = NSMenu()
        for mode in LanguageMode.allCases {
            let item = NSMenuItem(title: mode.title, action: #selector(setLanguageMode(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = mode.rawValue
            item.state = mode == settings.languageMode ? .on : .off
            languageMenu.addItem(item)
        }
        let languageItem = NSMenuItem(title: L10n.text("menu.language"), action: nil, keyEquivalent: "")
        languageItem.submenu = languageMenu
        menu.addItem(languageItem)

        let launchItem = actionItem(L10n.text("menu.launchAtStartup"), #selector(toggleLaunchAtStartup(_:)))
        launchItem.state = isLaunchAtStartupEnabled() ? .on : .off
        menu.addItem(launchItem)

        menu.addItem(actionItem(L10n.text("menu.openTargetFolder"), #selector(openTargetFolder)))
        let permissionItem = NSMenuItem(title: L10n.text("permission.title"), action: nil, keyEquivalent: "")
        permissionItem.submenu = buildPermissionMenu()
        menu.addItem(permissionItem)
        menu.addItem(NSMenuItem.separator())
        let quitItem = actionItem(L10n.text("menu.quit"), #selector(quit))
        quitItem.keyEquivalent = "q"
        menu.addItem(quitItem)
        return menu
    }

    private func buildPermissionMenu() -> NSMenu {
        let menu = NSMenu()
        let status = AXIsProcessTrusted() ? L10n.text("permission.menuEnabled") : L10n.text("permission.menuDisabled")
        let statusItem = NSMenuItem(title: "\(L10n.text("permission.status")): \(status)", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(actionItem(L10n.text("menu.checkCapturePermission"), #selector(checkCapturePermission)))
        menu.addItem(actionItem(L10n.text("menu.openAccessibilitySettings"), #selector(openAccessibilitySettings)))
        return menu
    }

    private func makeStatusIcon() -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size)
        image.lockFocus()

        NSColor.black.setStroke()
        NSColor.black.setFill()

        let bubble = NSBezierPath(roundedRect: NSRect(x: 3.0, y: 5.0, width: 12.0, height: 9.0), xRadius: 2.2, yRadius: 2.2)
        bubble.lineWidth = 1.6
        bubble.stroke()

        let tail = NSBezierPath()
        tail.move(to: NSPoint(x: 7.0, y: 5.2))
        tail.line(to: NSPoint(x: 5.2, y: 2.9))
        tail.line(to: NSPoint(x: 9.2, y: 5.2))
        tail.close()
        tail.fill()

        let line1 = NSBezierPath()
        line1.move(to: NSPoint(x: 5.8, y: 10.8))
        line1.line(to: NSPoint(x: 12.2, y: 10.8))
        line1.lineWidth = 1.4
        line1.stroke()

        let line2 = NSBezierPath()
        line2.move(to: NSPoint(x: 5.8, y: 8.2))
        line2.line(to: NSPoint(x: 10.2, y: 8.2))
        line2.lineWidth = 1.4
        line2.stroke()

        image.unlockFocus()
        image.isTemplate = true
        return image
    }

    private func actionItem(_ title: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    private func refreshMenu() {
        statusItem.menu = buildMenu()
    }

    private func installEventMonitors() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
            self?.handleEvent(event)
        }
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
            self?.handleEvent(event)
            return event
        }
    }

    private func handleEvent(_ event: NSEvent) {
        switch event.type {
        case .keyDown:
            handleKeyDown(event)
        case .flagsChanged:
            handleFlagsChanged(event)
        default:
            break
        }
    }

    private func handleKeyDown(_ event: NSEvent) {
        if optionDown {
            optionCleanTap = false
        }

        let key = event.charactersIgnoringModifiers?.lowercased()
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let matchesCommandOptionP = settings.triggerMode == .commandOptionP
            && key == "p"
            && flags.contains(.command)
            && flags.contains(.option)
            && !flags.contains(.shift)
            && !flags.contains(.control)
        let matchesCommandShiftP = settings.triggerMode == .commandShiftP
            && key == "p"
            && flags.contains(.command)
            && flags.contains(.shift)
            && !flags.contains(.option)
            && !flags.contains(.control)

        if matchesCommandOptionP || matchesCommandShiftP {
            captureSelectedText()
        }
    }

    private func handleFlagsChanged(_ event: NSEvent) {
        guard settings.triggerMode == .doubleOption else {
            return
        }

        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let optionPressed = flags.contains(.option)
        let optionOnly = optionPressed
            && !flags.contains(.command)
            && !flags.contains(.control)
            && !flags.contains(.shift)

        if optionOnly && !optionDown {
            optionDown = true
            optionCleanTap = true
            return
        }

        if optionDown && optionPressed && !optionOnly {
            optionCleanTap = false
            return
        }

        if optionDown && !optionPressed {
            optionDown = false
            guard optionCleanTap else {
                lastOptionTapAt = 0
                return
            }
            let now = Date().timeIntervalSince1970
            if lastOptionTapAt > 0 && now - lastOptionTapAt <= 0.5 {
                lastOptionTapAt = 0
                captureSelectedText()
            } else {
                lastOptionTapAt = now
            }
        }
    }

    @objc private func captureSelectedTextFromMenu() {
        captureSelectedText()
    }

    private func captureSelectedText() {
        guard !isCapturing else {
            return
        }
        isCapturing = true

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                Thread.sleep(forTimeInterval: 0.35)
                let text = try self.copyCurrentSelection()
                DispatchQueue.main.async {
                    self.isCapturing = false
                    self.handleCapturedText(text)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isCapturing = false
                    self.showError(error.localizedDescription)
                }
            }
        }
    }

    private func handleCapturedText(_ text: String) {
        switch settings.captureBehavior {
        case .review:
            showSavePrompt(text: text)
        case .quick:
            quickSave(text: text)
        }
    }

    private func quickSave(text: String) {
        let draft = PromptDraft(
            text: text,
            title: defaultTitle(from: text),
            targetFolder: settings.targetFolder,
            collectionFile: settings.collectionFile
        )
        do {
            let url = try PromptStore.append(draft, settings: settings)
            refreshMenu()
            notify(String(format: L10n.text("notice.savedTo"), url.lastPathComponent))
        } catch {
            showError(error.localizedDescription)
        }
    }

    private func copyCurrentSelection() throws -> String {
        guard AXIsProcessTrusted() else {
            throw NSError(
                domain: "PromptFavorite",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: accessibilityDeniedDiagnostic()]
            )
        }

        let snapshot = PasteboardSnapshot.capture()
        let pasteboard = NSPasteboard.general
        let sentinel = "PROMPT_FAVORITE_SENTINEL_\(UUID().uuidString)"

        pasteboard.clearContents()
        pasteboard.setString(sentinel, forType: .string)

        defer {
            snapshot.restore()
        }

        postCommandC()

        let deadline = Date().addingTimeInterval(1.5)
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.08)
            let value = pasteboard.string(forType: .string) ?? sentinel
            if value != sentinel {
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    return trimmed
                }
            }
        }

        let message = AXIsProcessTrusted()
            ? L10n.text("error.noSelectedText")
            : accessibilityDeniedDiagnostic()
        throw NSError(domain: "PromptFavorite", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }

    private func accessibilityDeniedDiagnostic() -> String {
        "\(L10n.text("error.accessibilityDenied"))\n\n\(capturePermissionDiagnosticText())"
    }

    private func postCommandC() {
        let source = CGEventSource(stateID: .hidSystemState)
        let cKeyCode: CGKeyCode = 8
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: cKeyCode, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: cKeyCode, keyDown: false)
        keyDown?.flags = .maskCommand
        keyUp?.flags = .maskCommand
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }

    private func showSavePrompt(text: String) {
        NSApp.activate(ignoringOtherApps: true)

        let controller = SavePromptWindowController(
            draft: PromptDraft(
                text: text,
                title: defaultTitle(from: text),
                targetFolder: settings.targetFolder,
                collectionFile: settings.collectionFile
            ),
            onSave: { [weak self] draft in
                guard let self else { return }
                self.saveWindowController = nil
                self.saveDraft(draft)
            },
            onCancel: { [weak self] in
                self?.saveWindowController = nil
            }
        )
        saveWindowController = controller
        controller.showWindow(nil)
        controller.window?.makeKeyAndOrderFront(nil)
    }

    private func saveDraft(_ draft: PromptDraft) {
            settings.targetFolder = draft.targetFolder
            settings.collectionFile = draft.collectionFile
            do {
                let url = try PromptStore.append(draft, settings: settings)
                refreshMenu()
                notify(String(format: L10n.text("notice.savedTo"), url.lastPathComponent))
            } catch {
                showError(error.localizedDescription)
            }
    }

    @objc private func chooseTargetFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = URL(fileURLWithPath: NSString(string: settings.targetFolder).expandingTildeInPath)

        if panel.runModal() == .OK, let url = panel.url {
            settings.targetFolder = url.path
            refreshMenu()
        }
    }

    @objc private func showFormatSettings() {
        NSApp.activate(ignoringOtherApps: true)

        let controller = FormatSettingsWindowController(
            settings: settings,
            onSave: { [weak self] collectionFile, titleTemplate, timestampFormat, entrySeparator, codeFenceLanguage in
                guard let self else { return }
                self.formatWindowController = nil
                self.settings.collectionFile = collectionFile
                self.settings.titleTemplate = titleTemplate
                self.settings.timestampFormat = timestampFormat
                self.settings.entrySeparator = entrySeparator
                self.settings.codeFenceLanguage = codeFenceLanguage
                self.refreshMenu()
            },
            onCancel: { [weak self] in
                self?.formatWindowController = nil
            }
        )
        formatWindowController = controller
        controller.showWindow(nil)
        controller.window?.makeKeyAndOrderFront(nil)
    }

    @objc private func setTriggerMode(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let mode = TriggerMode(rawValue: rawValue)
        else {
            return
        }
        settings.triggerMode = mode
        refreshMenu()
    }

    @objc private func setCaptureBehavior(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let behavior = CaptureBehavior(rawValue: rawValue)
        else {
            return
        }
        settings.captureBehavior = behavior
        refreshMenu()
    }

    @objc private func setLanguageMode(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let mode = LanguageMode(rawValue: rawValue)
        else {
            return
        }
        settings.languageMode = mode
        L10n.configure(languageMode: mode)
        refreshMenu()
    }

    @objc private func toggleLaunchAtStartup(_ sender: NSMenuItem) {
        guard #available(macOS 13.0, *) else {
            showError(L10n.text("launchAtStartup.unsupported"))
            return
        }

        let service = SMAppService.mainApp
        let shouldEnable = service.status != .enabled
        do {
            if shouldEnable {
                try service.register()
                if service.status == .requiresApproval {
                    showError(L10n.text("launchAtStartup.requiresApproval"))
                }
            } else {
                try service.unregister()
            }
            refreshMenu()
        } catch {
            showError(String(format: L10n.text("error.launchAtStartup"), error.localizedDescription))
        }
    }

    private func isLaunchAtStartupEnabled() -> Bool {
        guard #available(macOS 13.0, *) else {
            return false
        }
        return SMAppService.mainApp.status == .enabled
    }

    @objc private func openTargetFolder() {
        let url = URL(fileURLWithPath: NSString(string: settings.targetFolder).expandingTildeInPath)
        NSWorkspace.shared.open(url)
    }

    @objc private func checkCapturePermission() {
        showCapturePermissionStatus()
    }

    @objc private func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func showError(_ message: String) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = L10n.text("error.title")
        alert.informativeText = message
        alert.runModal()
    }

    private func showCapturePermissionStatus() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = L10n.text("permission.title")
        alert.informativeText = capturePermissionDiagnostic()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: L10n.text("permission.openSettings"))
        let response = alert.runModal()
        if response == .alertSecondButtonReturn {
            openAccessibilitySettings()
        }
    }

    private func capturePermissionDiagnostic() -> String {
        capturePermissionDiagnosticText()
    }

    private func notify(_ message: String) {
        print(message)
        statusItem.button?.image = nil
        statusItem.button?.title = L10n.text("status.saved")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.statusItem.button?.title = ""
            let image = self?.makeStatusIcon()
            image?.isTemplate = true
            self?.statusItem.button?.image = image
        }
    }

    private func label(_ text: String) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        return label
    }

    private func defaultTitle(from text: String) -> String {
        let first = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? L10n.text("default.untitledPrompt")
        return String(first.prefix(32))
    }

    private func shortPath(_ path: String) -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if path.hasPrefix(home) {
            return "~" + path.dropFirst(home.count)
        }
        return path
    }
}

func runSelfTestIfRequested() -> Bool {
    let arguments = CommandLine.arguments
    guard
        let index = arguments.firstIndex(of: "--self-test"),
        arguments.indices.contains(index + 1)
    else {
        return false
    }

    let target = arguments[index + 1]
    let draft = PromptDraft(
        text: "Self test prompt",
        title: "Self Test",
        targetFolder: target,
        collectionFile: "Self Test.md"
    )

    do {
        let url = try PromptStore.append(draft, settings: AppSettings())
        print(url.path)
    } catch {
        fputs("\(error.localizedDescription)\n", stderr)
        exit(1)
    }
    return true
}

func runAccessibilityCheckIfRequested() -> Bool {
    guard CommandLine.arguments.contains("--check-accessibility") else {
        return false
    }
    print(capturePermissionDiagnosticText())
    return true
}

if !runSelfTestIfRequested() && !runAccessibilityCheckIfRequested() {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
