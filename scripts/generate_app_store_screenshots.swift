#!/usr/bin/env swift
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputRoot = root.appendingPathComponent("assets/app-store-screenshots")
let outputDir = outputRoot.appendingPathComponent("zh-Hans")
let englishOutputDir = outputRoot.appendingPathComponent("en-US")
try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: englishOutputDir, withIntermediateDirectories: true)

let width: CGFloat = 1440
let height: CGFloat = 900

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(
        calibratedRed: CGFloat((hex >> 16) & 0xff) / 255,
        green: CGFloat((hex >> 8) & 0xff) / 255,
        blue: CGFloat(hex & 0xff) / 255,
        alpha: alpha
    )
}

func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> NSRect {
    NSRect(x: x, y: height - y - h, width: w, height: h)
}

func drawRounded(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ radius: CGFloat, fill: NSColor, stroke: NSColor? = nil, lineWidth: CGFloat = 1, shadow: Bool = false) {
    if shadow {
        let s = NSShadow()
        s.shadowColor = NSColor.black.withAlphaComponent(0.10)
        s.shadowBlurRadius = 24
        s.shadowOffset = NSSize(width: 0, height: -8)
        s.set()
    }
    let path = NSBezierPath(roundedRect: rect(x, y, w, h), xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    NSShadow().set()
    if let stroke {
        stroke.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}

func drawLine(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, color: NSColor, width: CGFloat = 1) {
    color.setStroke()
    let p = NSBezierPath()
    p.lineWidth = width
    p.move(to: NSPoint(x: x1, y: height - y1))
    p.line(to: NSPoint(x: x2, y: height - y2))
    p.stroke()
}

func drawText(_ text: String, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = color(0x111827), align: NSTextAlignment = .left, mono: Bool = false) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = align
    paragraph.lineSpacing = size * 0.22
    let font = mono ? NSFont.monospacedSystemFont(ofSize: size, weight: weight) : NSFont.systemFont(ofSize: size, weight: weight)
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: paragraph
    ]
    (text as NSString).draw(in: rect(x, y, w, h), withAttributes: attrs)
}

func drawWindow(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, title: String, fill: NSColor = color(0xf9fafb)) {
    drawRounded(x, y, w, h, 16, fill: fill, stroke: color(0xd1d5db), shadow: true)
    drawRounded(x, y, w, 54, 16, fill: color(0xf3f4f6), stroke: color(0xd1d5db))
    drawText(title, x, y + 15, w, 24, size: 18, weight: .semibold, color: color(0x374151), align: .center)
    for (i, c) in [0xff5f57, 0xffbd2e, 0x28c840].enumerated() {
        drawRounded(x + 20 + CGFloat(i) * 32, y + 18, 14, 14, 7, fill: color(UInt32(c)))
    }
}

func drawIcon(_ x: CGFloat, _ y: CGFloat, _ size: CGFloat) {
    let iconURL = root.appendingPathComponent("assets/PromptFavorite.iconset/icon_512x512.png")
    if let img = NSImage(contentsOf: iconURL) {
        img.draw(in: rect(x, y, size, size))
    }
}

func drawInput(_ label: String, value: String, x: CGFloat, y: CGFloat, w: CGFloat) {
    drawText(label, x, y, w, 24, size: 19, weight: .semibold, color: color(0x6b7280))
    drawRounded(x, y + 32, w, 48, 8, fill: .white, stroke: color(0xd1d5db))
    drawText(value, x + 16, y + 43, w - 32, 24, size: 21)
}

func render(_ name: String, directory: URL = outputDir, _ body: () -> Void) {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(width), pixelsHigh: Int(height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    color(0xf5f7fb).setFill()
    rect(0, 0, width, height).fill()
    body()
    NSGraphicsContext.restoreGraphicsState()
    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: directory.appendingPathComponent(name))
}

render("01-global-capture.png") {
    drawText("在任意 App 里选中，立刻收藏 Prompt", 76, 72, 760, 70, size: 43, weight: .bold)
    drawText("Prompt Favorite 用全局触发捕获当前选中文本，保存前可确认标题、目录和正文。", 78, 142, 720, 52, size: 22, color: color(0x4b5563))
    drawIcon(1140, 62, 146)
    drawWindow(76, 244, 650, 446, title: "Browser")
    drawRounded(112, 320, 574, 54, 10, fill: color(0xeef2ff))
    drawText("Review this PRD and identify only blocking logic issues.", 136, 335, 520, 24, size: 20, color: color(0x1f2937))
    drawText("Select text in Chrome, Terminal, Codex, ChatGPT, Claude, Obsidian, or almost any other app.", 116, 408, 540, 120, size: 29, weight: .medium, color: color(0x111827))
    drawRounded(816, 248, 488, 454, 18, fill: color(0xffffff), stroke: color(0xd1d5db), shadow: true)
    drawIcon(1004, 286, 112)
    drawText("保存 Prompt", 816, 422, 488, 42, size: 30, weight: .bold, align: .center)
    drawText("选择这条 prompt 追加到哪里。", 816, 471, 488, 28, size: 21, color: color(0x4b5563), align: .center)
    drawInput("标题", value: "PRD Review", x: 852, y: 538, w: 416)
    drawRounded(852, 642, 190, 54, 12, fill: color(0xe5e7eb))
    drawRounded(1078, 642, 190, 54, 12, fill: color(0x2563eb))
    drawText("取消", 852, 655, 190, 26, size: 22, weight: .medium, color: color(0x374151), align: .center)
    drawText("保存", 1078, 655, 190, 26, size: 22, weight: .bold, color: .white, align: .center)
}

render("02-save-preview.png") {
    drawText("保存前确认，不打断工作流", 76, 66, 650, 64, size: 43, weight: .bold)
    drawText("修改标题、选择目标文件夹、指定 collection file，然后追加到同一个 Markdown 文件。", 78, 136, 760, 52, size: 22, color: color(0x4b5563))
    drawWindow(92, 230, 1256, 560, title: "保存 Prompt")
    drawText("保存 Prompt", 140, 318, 360, 50, size: 39, weight: .bold)
    drawText("选择这条 prompt 追加到哪里。", 140, 378, 500, 34, size: 23, color: color(0x6b7280))
    drawInput("标题", value: "PRD Review", x: 140, y: 440, w: 1120)
    drawInput("目标文件夹", value: "~/Documents/Prompt Favorite/Work", x: 140, y: 548, w: 850)
    drawRounded(1016, 580, 244, 48, 9, fill: color(0xf3f4f6), stroke: color(0xd1d5db))
    drawText("选择...", 1016, 591, 244, 24, size: 20, weight: .medium, align: .center)
    drawInput("Collection 文件", value: "Favorites.md", x: 140, y: 640, w: 1120)
    drawRounded(720, 744, 238, 48, 10, fill: color(0xf3f4f6), stroke: color(0xd1d5db))
    drawRounded(982, 744, 278, 48, 10, fill: color(0x2563eb))
    drawText("取消", 720, 754, 238, 24, size: 21, color: color(0x374151), align: .center)
    drawText("保存", 982, 754, 278, 24, size: 21, weight: .bold, color: .white, align: .center)
}

render("03-markdown-obsidian.png") {
    drawText("输出就是普通 Markdown", 76, 66, 620, 64, size: 43, weight: .bold)
    drawText("可以放进独立收藏夹，也可以直接指向 Obsidian Vault 中的任意文件夹。", 78, 136, 760, 52, size: 22, color: color(0x4b5563))
    drawWindow(76, 226, 420, 560, title: "Prompt Favorite")
    drawText("Capture Selected Text", 114, 312, 330, 30, size: 23, weight: .medium)
    drawLine(114, 360, 456, 360, color: color(0xd1d5db))
    drawText("Target: ~/Documents/Prompt Favorite", 114, 392, 330, 30, size: 18, color: color(0x9ca3af))
    drawText("Choose Target Folder...", 114, 436, 330, 30, size: 22)
    drawText("Collection: Favorites.md", 114, 480, 330, 30, size: 18, color: color(0x9ca3af))
    drawText("Save Format Settings...", 114, 524, 330, 30, size: 22)
    drawLine(114, 572, 456, 572, color: color(0xd1d5db))
    drawText("Global Trigger        Double Option", 114, 606, 330, 30, size: 20)
    drawText("Capture Behavior      Review", 114, 646, 330, 30, size: 20)
    drawText("Language              Follow System", 114, 686, 330, 30, size: 20)
    drawWindow(548, 226, 816, 560, title: "Favorites.md")
    drawText("---\ntitle: \"Favorites\"\ntags:\n  - prompt-collection\n---", 598, 304, 720, 132, size: 22, color: color(0x374151), mono: true)
    drawLine(598, 454, 1312, 454, color: color(0xd1d5db))
    drawText("## 2026-07-02 12:04:16 - PRD Review", 598, 486, 720, 40, size: 26, weight: .bold)
    drawRounded(598, 552, 720, 134, 12, fill: color(0xf3f4f6), stroke: color(0xe5e7eb))
    drawText("```prompt\nReview this PRD and identify only blocking logic issues.\n```", 626, 580, 664, 84, size: 20, color: color(0x111827), mono: true)
}

render("01-global-capture.png", directory: englishOutputDir) {
    drawText("Capture prompts from any Mac app", 76, 72, 760, 70, size: 43, weight: .bold)
    drawText("Prompt Favorite captures selected text globally, then lets you review the title, folder, and body before saving.", 78, 142, 760, 58, size: 22, color: color(0x4b5563))
    drawIcon(1140, 62, 146)
    drawWindow(76, 244, 650, 446, title: "Browser")
    drawRounded(112, 320, 574, 54, 10, fill: color(0xeef2ff))
    drawText("Review this PRD and identify only blocking logic issues.", 136, 335, 520, 24, size: 20, color: color(0x1f2937))
    drawText("Select text in Chrome, Terminal, Codex, ChatGPT, Claude, Obsidian, or almost any other app.", 116, 408, 540, 120, size: 29, weight: .medium, color: color(0x111827))
    drawRounded(816, 248, 488, 454, 18, fill: color(0xffffff), stroke: color(0xd1d5db), shadow: true)
    drawIcon(1004, 286, 112)
    drawText("Save Prompt", 816, 422, 488, 42, size: 30, weight: .bold, align: .center)
    drawText("Choose where this prompt should be appended.", 856, 471, 408, 56, size: 21, color: color(0x4b5563), align: .center)
    drawInput("Title", value: "PRD Review", x: 852, y: 548, w: 416)
    drawRounded(852, 652, 190, 54, 12, fill: color(0xe5e7eb))
    drawRounded(1078, 652, 190, 54, 12, fill: color(0x2563eb))
    drawText("Cancel", 852, 665, 190, 26, size: 22, weight: .medium, color: color(0x374151), align: .center)
    drawText("Save", 1078, 665, 190, 26, size: 22, weight: .bold, color: .white, align: .center)
}

render("02-save-preview.png", directory: englishOutputDir) {
    drawText("Review before saving", 76, 66, 650, 64, size: 43, weight: .bold)
    drawText("Edit the title, choose a target folder, pick a collection file, then append to Markdown.", 78, 136, 760, 52, size: 22, color: color(0x4b5563))
    drawWindow(92, 230, 1256, 560, title: "Save Prompt")
    drawText("Save Prompt", 140, 318, 360, 50, size: 39, weight: .bold)
    drawText("Choose where this prompt should be appended.", 140, 378, 560, 34, size: 23, color: color(0x6b7280))
    drawInput("Title", value: "PRD Review", x: 140, y: 440, w: 1120)
    drawInput("Target folder", value: "~/Documents/Prompt Favorite/Work", x: 140, y: 548, w: 850)
    drawRounded(1016, 580, 244, 48, 9, fill: color(0xf3f4f6), stroke: color(0xd1d5db))
    drawText("Choose...", 1016, 591, 244, 24, size: 20, weight: .medium, align: .center)
    drawInput("Collection file", value: "Favorites.md", x: 140, y: 640, w: 1120)
    drawRounded(720, 744, 238, 48, 10, fill: color(0xf3f4f6), stroke: color(0xd1d5db))
    drawRounded(982, 744, 278, 48, 10, fill: color(0x2563eb))
    drawText("Cancel", 720, 754, 238, 24, size: 21, color: color(0x374151), align: .center)
    drawText("Save", 982, 754, 278, 24, size: 21, weight: .bold, color: .white, align: .center)
}

render("03-markdown-obsidian.png", directory: englishOutputDir) {
    drawText("Plain Markdown output", 76, 66, 620, 64, size: 43, weight: .bold)
    drawText("Use a standalone folder, an Obsidian vault, or any synced directory you already manage.", 78, 136, 760, 52, size: 22, color: color(0x4b5563))
    drawWindow(76, 226, 420, 560, title: "Prompt Favorite")
    drawText("Capture Selected Text", 114, 312, 330, 30, size: 23, weight: .medium)
    drawLine(114, 360, 456, 360, color: color(0xd1d5db))
    drawText("Target: ~/Documents/Prompt Favorite", 114, 392, 330, 30, size: 18, color: color(0x9ca3af))
    drawText("Choose Target Folder...", 114, 436, 330, 30, size: 22)
    drawText("Collection: Favorites.md", 114, 480, 330, 30, size: 18, color: color(0x9ca3af))
    drawText("Save Format Settings...", 114, 524, 330, 30, size: 22)
    drawLine(114, 572, 456, 572, color: color(0xd1d5db))
    drawText("Global Trigger        Double Option", 114, 606, 330, 30, size: 20)
    drawText("Capture Behavior      Review", 114, 646, 330, 30, size: 20)
    drawText("Language              Follow System", 114, 686, 330, 30, size: 20)
    drawWindow(548, 226, 816, 560, title: "Favorites.md")
    drawText("---\ntitle: \"Favorites\"\ntags:\n  - prompt-collection\n---", 598, 304, 720, 132, size: 22, color: color(0x374151), mono: true)
    drawLine(598, 454, 1312, 454, color: color(0xd1d5db))
    drawText("## 2026-07-02 12:04:16 - PRD Review", 598, 486, 720, 40, size: 26, weight: .bold)
    drawRounded(598, 552, 720, 134, 12, fill: color(0xf3f4f6), stroke: color(0xe5e7eb))
    drawText("```prompt\nReview this PRD and identify only blocking logic issues.\n```", 626, 580, 664, 84, size: 20, color: color(0x111827), mono: true)
}

print(outputRoot.path)
