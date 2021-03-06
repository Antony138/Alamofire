//
//  Notifications.swift
//
//  Copyright (c) 2014-2018 Alamofire Software Foundation (http://alamofire.org/)
//
// 每个文件都要写这一堆东西吗，真浪费行数～
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// 利用extension对Notification的Name进行扩展，这样和直接将通知名称声明成常量有何区别？可以直接用.调用通告名称？
extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    // 添加了一个结构体Task，里面有若干通告
    public struct Task {
        /// Posted when a `URLSessionTask` is resumed. The notification `object` contains the resumed `URLSessionTask`. / URLSessionTask重新启动的时候发送次通告
        public static let DidResume = Notification.Name(rawValue: "org.alamofire.notification.name.task.didResume")

        /// Posted when a `URLSessionTask` is suspended. The notification `object` contains the suspended `URLSessionTask`. / URLSessionTask暂停时发送此通告
        public static let DidSuspend = Notification.Name(rawValue: "org.alamofire.notification.name.task.didSuspend")

        /// Posted when a `URLSessionTask` is cancelled. The notification `object` contains the cancelled `URLSessionTask`. / URLSessionTask取消时发送此通告
        public static let DidCancel = Notification.Name(rawValue: "org.alamofire.notification.name.task.didCancel")

        /// Posted when a `URLSessionTask` is completed. The notification `object` contains the completed `URLSessionTask`. / URLSessionTask完成时发送此通告
        public static let DidComplete = Notification.Name(rawValue: "org.alamofire.notification.name.task.didComplete")
    }
}

// MARK: -

extension Notification {
    // 这些Key有啥用？
    /// Used as a namespace for all `Notification` user info dictionary keys.
    public struct Key {
        /// User info dictionary key representing the `URLSessionTask` associated with the notification.
        public static let Task = "org.alamofire.notification.key.task"

        /// User info dictionary key representing the responseData associated with the notification.
        public static let ResponseData = "org.alamofire.notification.key.responseData"
    }
}
