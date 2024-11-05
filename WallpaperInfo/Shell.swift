//
//  Shell.swift
//  WallpaperInfo
//
//  Created by Brad Greenlee on 11/4/24.
//

import Foundation

func shell(_ args: String...) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = args
    task.launchPath = "/usr/bin/env"
    task.standardInput = nil
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}
