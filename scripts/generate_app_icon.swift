#!/usr/bin/env swift

import AppKit
import Foundation

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let assetsDir = CommandLine.arguments.count > 1
    ? URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
    : root.appendingPathComponent("assets", isDirectory: true)
let iconsetDir = assetsDir.appendingPathComponent("PromptFavorite.iconset", isDirectory: true)
let marketingIconURL = assetsDir.appendingPathComponent("app-store-icon-1024.png")

try? FileManager.default.removeItem(at: iconsetDir)
try FileManager.default.createDirectory(at: iconsetDir, withIntermediateDirectories: true)

func scaled(_ value: CGFloat, _ scale: CGFloat) -> CGFloat {
    value * scale
}

func drawIcon(pixelSize: Int) -> NSImage {
    let size = CGFloat(pixelSize)
    let scale = size / 1024.0
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let bounds = NSRect(x: 0, y: 0, width: size, height: size)
    NSColor(calibratedRed: 0.89, green: 0.95, blue: 0.97, alpha: 1).setFill()
    bounds.fill()

    if let gradient = NSGradient(colors: [
        NSColor(calibratedRed: 0.76, green: 0.90, blue: 0.95, alpha: 1),
        NSColor(calibratedRed: 0.95, green: 0.98, blue: 0.99, alpha: 1)
    ]) {
        gradient.draw(in: bounds, angle: 90)
    }

    let cardRect = NSRect(
        x: scaled(168, scale),
        y: scaled(148, scale),
        width: scaled(688, scale),
        height: scaled(728, scale)
    )
    let card = NSBezierPath(
        roundedRect: cardRect,
        xRadius: scaled(172, scale),
        yRadius: scaled(172, scale)
    )

    let shadow = NSShadow()
    shadow.shadowBlurRadius = scaled(42, scale)
    shadow.shadowOffset = NSSize(width: 0, height: scaled(-18, scale))
    shadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.13)
    NSGraphicsContext.saveGraphicsState()
    shadow.set()
    NSColor(calibratedRed: 0.98, green: 0.995, blue: 1.0, alpha: 1).setFill()
    card.fill()
    NSGraphicsContext.restoreGraphicsState()

    NSColor.white.withAlphaComponent(0.78).setStroke()
    card.lineWidth = scaled(18, scale)
    card.stroke()

    let bubbleRect = NSRect(
        x: scaled(280, scale),
        y: scaled(398, scale),
        width: scaled(464, scale),
        height: scaled(310, scale)
    )
    let bubble = NSBezierPath(
        roundedRect: bubbleRect,
        xRadius: scaled(72, scale),
        yRadius: scaled(72, scale)
    )
    NSColor(calibratedRed: 0.22, green: 0.46, blue: 0.96, alpha: 1).setFill()
    bubble.fill()

    let tail = NSBezierPath()
    tail.move(to: NSPoint(x: scaled(430, scale), y: scaled(408, scale)))
    tail.line(to: NSPoint(x: scaled(362, scale), y: scaled(286, scale)))
    tail.line(to: NSPoint(x: scaled(536, scale), y: scaled(398, scale)))
    tail.close()
    NSColor(calibratedRed: 0.22, green: 0.46, blue: 0.96, alpha: 1).setFill()
    tail.fill()

    NSColor.white.setStroke()
    for (x2, y, width) in [
        (CGFloat(0), CGFloat(604), CGFloat(264)),
        (CGFloat(0), CGFloat(524), CGFloat(320)),
        (CGFloat(0), CGFloat(444), CGFloat(220))
    ] {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: scaled(352 + x2, scale), y: scaled(y, scale)))
        line.line(to: NSPoint(x: scaled(352 + x2 + width, scale), y: scaled(y, scale)))
        line.lineCapStyle = .round
        line.lineWidth = scaled(34, scale)
        line.stroke()
    }

    let sparkle = NSBezierPath()
    sparkle.move(to: NSPoint(x: scaled(702, scale), y: scaled(742, scale)))
    sparkle.line(to: NSPoint(x: scaled(728, scale), y: scaled(800, scale)))
    sparkle.line(to: NSPoint(x: scaled(754, scale), y: scaled(742, scale)))
    sparkle.line(to: NSPoint(x: scaled(812, scale), y: scaled(716, scale)))
    sparkle.line(to: NSPoint(x: scaled(754, scale), y: scaled(690, scale)))
    sparkle.line(to: NSPoint(x: scaled(728, scale), y: scaled(632, scale)))
    sparkle.line(to: NSPoint(x: scaled(702, scale), y: scaled(690, scale)))
    sparkle.line(to: NSPoint(x: scaled(644, scale), y: scaled(716, scale)))
    sparkle.close()
    NSColor(calibratedRed: 0.99, green: 0.72, blue: 0.20, alpha: 1).setFill()
    sparkle.fill()

    image.unlockFocus()
    return image
}

func writePNG(_ image: NSImage, to url: URL) throws {
    guard
        let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        throw NSError(domain: "PromptFavoriteIcon", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to render icon PNG."])
    }
    try png.write(to: url)
}

let iconFiles: [(String, Int)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

for (fileName, pixelSize) in iconFiles {
    try writePNG(drawIcon(pixelSize: pixelSize), to: iconsetDir.appendingPathComponent(fileName))
}

try writePNG(drawIcon(pixelSize: 1024), to: marketingIconURL)
print(iconsetDir.path)
