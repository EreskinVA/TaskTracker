//
//  Tasks.swift
//  TaskTracker
//
//  Created by Vladimir Ereskin on 18.07.2018.
//  Copyright © 2018 Vladimir Ereskin. All rights reserved.
//

import UIKit

struct Status: Codable {
    let new = "Новая"
    let inProcess = "В процессе"
    let completed = "Завершено"
}

struct DefaultsKeys {
    static let tasks = "tasks"
}

struct Tasks: Codable {
    var title: String
    var comment: String
    var status: String
}
