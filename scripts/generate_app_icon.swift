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
    NSGraphicsContext.current?.cgContext.clear(bounds)

    let tileRect = NSRect(
        x: scaled(112, scale),
        y: scaled(112, scale),
        width: scaled(800, scale),
        height: scaled(800, scale)
    )
    let tile = NSBezierPath(
        roundedRect: tileRect,
        xRadius: scaled(184, scale),
        yRadius: scaled(184, scale)
    )

    let shadow = NSShadow()
    shadow.shadowBlurRadius = scaled(34, scale)
    shadow.shadowOffset = NSSize(width: 0, height: scaled(-22, scale))
    shadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.22)
    NSGraphicsContext.saveGraphicsState()
    shadow.set()
    NSColor(calibratedRed: 0.17, green: 0.39, blue: 0.90, alpha: 1).setFill()
    tile.fill()
    NSGraphicsContext.restoreGraphicsState()

    if let gradient = NSGradient(colors: [
        NSColor(calibratedRed: 0.18, green: 0.44, blue: 0.96, alpha: 1),
        NSColor(calibratedRed: 0.35, green: 0.72, blue: 0.98, alpha: 1)
    ]) {
        gradient.draw(in: tile, angle: 270)
    }

    NSColor.white.withAlphaComponent(0.28).setStroke()
    tile.lineWidth = scaled(12, scale)
    tile.stroke()

    let bubbleRect = NSRect(
        x: scaled(262, scale),
        y: scaled(414, scale),
        width: scaled(500, scale),
        height: scaled(298, scale)
    )
    let bubble = NSBezierPath(
        roundedRect: bubbleRect,
        xRadius: scaled(70, scale),
        yRadius: scaled(70, scale)
    )
    let bubbleShadow = NSShadow()
    bubbleShadow.shadowBlurRadius = scaled(18, scale)
    bubbleShadow.shadowOffset = NSSize(width: 0, height: scaled(-8, scale))
    bubbleShadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.13)
    NSGraphicsContext.saveGraphicsState()
    bubbleShadow.set()
    NSColor.white.setFill()
    bubble.fill()
    NSGraphicsContext.restoreGraphicsState()

    let tail = NSBezierPath()
    tail.move(to: NSPoint(x: scaled(458, scale), y: scaled(424, scale)))
    tail.line(to: NSPoint(x: scaled(382, scale), y: scaled(306, scale)))
    tail.line(to: NSPoint(x: scaled(570, scale), y: scaled(414, scale)))
    tail.close()
    NSColor.white.setFill()
    tail.fill()

    NSColor(calibratedRed: 0.20, green: 0.47, blue: 0.98, alpha: 1).setStroke()
    for (x2, y, width) in [
        (CGFloat(0), CGFloat(616), CGFloat(292)),
        (CGFloat(0), CGFloat(536), CGFloat(350)),
        (CGFloat(0), CGFloat(456), CGFloat(238))
    ] {
        let line = NSBezierPath()
        line.move(to: NSPoint(x: scaled(352 + x2, scale), y: scaled(y, scale)))
        line.line(to: NSPoint(x: scaled(352 + x2 + width, scale), y: scaled(y, scale)))
        line.lineCapStyle = .round
        line.lineWidth = scaled(34, scale)
        line.stroke()
    }

    let sparkle = NSBezierPath()
    sparkle.move(to: NSPoint(x: scaled(720, scale), y: scaled(760, scale)))
    sparkle.line(to: NSPoint(x: scaled(750, scale), y: scaled(828, scale)))
    sparkle.line(to: NSPoint(x: scaled(780, scale), y: scaled(760, scale)))
    sparkle.line(to: NSPoint(x: scaled(848, scale), y: scaled(730, scale)))
    sparkle.line(to: NSPoint(x: scaled(780, scale), y: scaled(700, scale)))
    sparkle.line(to: NSPoint(x: scaled(750, scale), y: scaled(632, scale)))
    sparkle.line(to: NSPoint(x: scaled(720, scale), y: scaled(700, scale)))
    sparkle.line(to: NSPoint(x: scaled(652, scale), y: scaled(730, scale)))
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
