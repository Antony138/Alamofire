// AFError类，是对错误的封装，包含了AlamoFire中所有可能出现的错误
// 总体来说，属于「响应」部分（参考：http://blog.oneinbest.com/2017/04/27/swift学习及Alamofire源码阅读/）
//  AFError.swift
//
// 下面这个网址，指向的是：https://github.com/Alamofire/Foundation 介绍的是Alamofire软件基金会的官方政策
//  Copyright (c) 2014-2018 Alamofire Software Foundation (http://alamofire.org/)
//
// 次框架的授权事宜（貌似就是免责声明～）
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
// 不知道Swift的Founddation和OC的Foundation有何区别
import Foundation

/// 定义了不同类型的errors，和其错误原因
/// `AFError` is the error type returned by Alamofire. It encompasses a few different types of errors, each with
/// their own associated reasons.
///

// 只有这5种错误？
// 从「Returned」开始，是对齐的，是怎么对齐的？
/// - invalidURL:                  Returned when a `URLConvertible` type fails to create a valid `URL`. / 当无法创建一个有效的URL时返回这个错误
/// - parameterEncodingFailed:     Returned when a parameter encoding object throws an error during the encoding process. / 当参数在编码过程中抛出错误时返回这个错误
/// - multipartEncodingFailed:     Returned when some step in the multipart encoding process fails. / multipart encoding错误时返回（multipart encoding是什么东东？）
/// - responseValidationFailed:    Returned when a `validate()` call fails. / `validate()`调用失败时返回（`validate()`是啥？）
/// - responseSerializationFailed: Returned when a response serializer encounters an error in the serialization process. / 「序列化」过程中遇到错误时返回。（「序列化/Serialization」是啥？）

// AFError是一个枚举enum，enum可以继承？这里意思是AFError继承自Error？
public enum AFError: Error {
    
    // 参数编码错误（对应上面5种错误的第2种）的潜在原因，3个
    /// The underlying reason the parameter encoding error occurred.
    ///
    /// - missingURL:                 The URL request did not have a URL to encode. / 没有（缺失）要编码的URL
    /// - jsonEncodingFailed:         JSON serialization failed with an underlying system error during the
    ///                               encoding process. / 编码过程中，JSON序列化失败，并出现基础系统错误
    /// - propertyListEncodingFailed: Property list serialization failed with an underlying system error during
    ///                               encoding process. / 编码过程中，Property list序列化失败，并出现基础系统错误
    // enum里面还有一个enum
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error) // 为什么这两个多了后面括号部分？
        case propertyListEncodingFailed(error: Error)
    }

    // multipart编码错误（对应上面5种错误的第3种）发生的潜在（可能）的原因，13个
    /// The underlying reason the multipart encoding error occurred.
    ///
    /// - bodyPartURLInvalid:                   The `fileURL` provided for reading an encodable body part isn't a
    ///                                         file URL.
    /// - bodyPartFilenameInvalid:              The filename of the `fileURL` provided has either an empty
    ///                                         `lastPathComponent` or `pathExtension.
    /// - bodyPartFileNotReachable:             The file at the `fileURL` provided was not reachable.
    /// - bodyPartFileNotReachableWithError:    Attempting to check the reachability of the `fileURL` provided threw
    ///                                         an error.
    /// - bodyPartFileIsDirectory:              The file at the `fileURL` provided is actually a directory.
    /// - bodyPartFileSizeNotAvailable:         The size of the file at the `fileURL` provided was not returned by
    ///                                         the system.
    /// - bodyPartFileSizeQueryFailedWithError: The attempt to find the size of the file at the `fileURL` provided
    ///                                         threw an error.
    /// - bodyPartInputStreamCreationFailed:    An `InputStream` could not be created for the provided `fileURL`.
    /// - outputStreamCreationFailed:           An `OutputStream` could not be created when attempting to write the
    ///                                         encoded data to disk.
    /// - outputStreamFileAlreadyExists:        The encoded body data could not be writtent disk because a file
    ///                                         already exists at the provided `fileURL`.
    /// - outputStreamURLInvalid:               The `fileURL` provided for writing the encoded body data to disk is
    ///                                         not a file URL.
    /// - outputStreamWriteFailed:              The attempt to write the encoded body data to disk failed with an
    ///                                         underlying error.
    /// - inputStreamReadFailed:                The attempt to read an encoded body part `InputStream` failed with
    ///                                         underlying system error.
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)

        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)

        case inputStreamReadFailed(error: Error)
    }

    // `validate()`调用失败（对应上面5种错误的第4种）发生的潜在原因，5个
    /// The underlying reason the response validation error occurred.
    ///
    /// - dataFileNil:             The data file containing the server response did not exist.
    /// - dataFileReadFailed:      The data file containing the server response could not be read.
    /// - missingContentType:      The response did not contain a `Content-Type` and the `acceptableContentTypes`
    ///                            provided did not contain wildcard type.
    /// - unacceptableContentType: The response `Content-Type` did not match any type in the provided
    ///                            `acceptableContentTypes`.
    /// - unacceptableStatusCode:  The response status code was not acceptable.
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }

    // response序列化错误（对应上面5种错误的第5种）发生的潜在原因，7个
    /// The underlying reason the response serialization error occurred.
    ///
    /// - inputDataNil:                    The server response contained no data.
    /// - inputDataNilOrZeroLength:        The server response contained no data or the data was zero length.
    /// - inputFileNil:                    The file containing the server response did not exist.
    /// - inputFileReadFailed:             The file containing the server response could not be read.
    /// - stringSerializationFailed:       String serialization failed using the provided `String.Encoding`.
    /// - jsonSerializationFailed:         JSON serialization failed with an underlying system error.
    /// - propertyListSerializationFailed: Property list serialization failed with an underlying system error.
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }

    // 下面4个是AFError的case，对应最开头介绍的5种错误
    // 这样「分层次」，方便归类、抛出不同类型的错误？
    case invalidURL(url: URLConvertible)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// 这个结构体是什么意思
// MARK: - Adapt Error

struct AdaptError: Error {
    let error: Error
}

// 对原Error进行扩展（系统的Error是一个Protocol？！）（extension/拓展的图标，是黄色的「Ex」）
// 这里的扩展增加了一个属性underlyingAdaptError，有何作用？
extension Error {
    var underlyingAdaptError: Error? { return (self as? AdaptError)?.error }
}

// MARK: - Error Booleans
// Error 布尔值，就是是否有错误的意思？

// 这里又对自己定义的enum进行拓展，为什么不一次性写好？是为了代码可读性吗？
extension AFError {
    /// Returns whether the AFError is an invalid URL error.
    public var isInvalidURLError: Bool {
        // if case是什么写法？
        if case .invalidURL = self { return true }
        return false
    }

    /// Returns whether the AFError is a parameter encoding error. When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isParameterEncodingError: Bool {
        if case .parameterEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the AFError is a multipart encoding error. When `true`, the `url` and `underlyingError` properties
    /// will contain the associated values.
    public var isMultipartEncodingError: Bool {
        if case .multipartEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response validation error. When `true`, the `acceptableContentTypes`,
    /// `responseContentType`, and `responseCode` properties will contain the associated values.
    public var isResponseValidationError: Bool {
        if case .responseValidationFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response serialization error. When `true`, the `failedStringEncoding` and
    /// `underlyingError` properties will contain the associated values.
    public var isResponseSerializationError: Bool {
        if case .responseSerializationFailed = self { return true }
        return false
    }
}

// MARK: - Convenience Properties
// 方便使用者识别错误的属性？

extension AFError {
    /// The `URLConvertible` associated with the error.
    // 返回具体的错误提示？
    public var urlConvertible: URLConvertible? {
        switch self {
        case .invalidURL(let url):
            return url
        default:
            return nil
        }
    }

    /// The `URL` associated with the error.
    public var url: URL? {
        switch self {
        case .multipartEncodingFailed(let reason):
            return reason.url
        default:
            return nil
        }
    }

    /// The `Error` returned by a system framework associated with a `.parameterEncodingFailed`,
    /// `.multipartEncodingFailed` or `.responseSerializationFailed` error.
    public var underlyingError: Error? {
        switch self {
        case .parameterEncodingFailed(let reason):
            return reason.underlyingError
        case .multipartEncodingFailed(let reason):
            return reason.underlyingError
        case .responseSerializationFailed(let reason):
            return reason.underlyingError
        default:
            return nil
        }
    }

    /// The acceptable `Content-Type`s of a `.responseValidationFailed` error.
    public var acceptableContentTypes: [String]? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.acceptableContentTypes
        default:
            return nil
        }
    }

    /// The response `Content-Type` of a `.responseValidationFailed` error.
    public var responseContentType: String? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseContentType
        default:
            return nil
        }
    }

    /// The response code of a `.responseValidationFailed` error.
    public var responseCode: Int? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseCode
        default:
            return nil
        }
    }

    /// The `String.Encoding` associated with a failed `.stringResponse()` call.
    public var failedStringEncoding: String.Encoding? {
        switch self {
        case .responseSerializationFailed(let reason):
            return reason.failedStringEncoding
        default:
            return nil
        }
    }
}

// 对AFError enum 内的 enum 进行扩展
extension AFError.ParameterEncodingFailureReason {
    var underlyingError: Error? {
        switch self {
        case .jsonEncodingFailed(let error), .propertyListEncodingFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var url: URL? {
        switch self {
        case .bodyPartURLInvalid(let url), .bodyPartFilenameInvalid(let url), .bodyPartFileNotReachable(let url),
             .bodyPartFileIsDirectory(let url), .bodyPartFileSizeNotAvailable(let url),
             .bodyPartInputStreamCreationFailed(let url), .outputStreamCreationFailed(let url),
             .outputStreamFileAlreadyExists(let url), .outputStreamURLInvalid(let url),
             .bodyPartFileNotReachableWithError(let url, _), .bodyPartFileSizeQueryFailedWithError(let url, _):
            return url
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .bodyPartFileNotReachableWithError(_, let error), .bodyPartFileSizeQueryFailedWithError(_, let error),
             .outputStreamWriteFailed(let error), .inputStreamReadFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var acceptableContentTypes: [String]? {
        switch self {
        case .missingContentType(let types), .unacceptableContentType(let types, _):
            return types
        default:
            return nil
        }
    }

    var responseContentType: String? {
        switch self {
        case .unacceptableContentType(_, let responseType):
            return responseType
        default:
            return nil
        }
    }

    var responseCode: Int? {
        switch self {
        case .unacceptableStatusCode(let code):
            return code
        default:
            return nil
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var failedStringEncoding: String.Encoding? {
        switch self {
        case .stringSerializationFailed(let encoding):
            return encoding
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .jsonSerializationFailed(let error), .propertyListSerializationFailed(let error):
            return error
        default:
            return nil
        }
    }
}

// MARK: - Error Descriptions
// 错误的具体描述

// LocalizedError也是一个Protocol（所以，AFError comfirm了多个protocols）
extension AFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .parameterEncodingFailed(let reason):
            return reason.localizedDescription
        case .multipartEncodingFailed(let reason):
            return reason.localizedDescription
        case .responseValidationFailed(let reason):
            return reason.localizedDescription
        case .responseSerializationFailed(let reason):
            return reason.localizedDescription
        }
    }
}

// 写具体的原因，让使用者更容易排查
extension AFError.ParameterEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL request to encode was missing a URL"
        case .jsonEncodingFailed(let error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case .propertyListEncodingFailed(let error):
            return "PropertyList could not be encoded because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .bodyPartURLInvalid(let url):
            return "The URL provided is not a file URL: \(url)"
        case .bodyPartFilenameInvalid(let url):
            return "The URL provided does not have a valid filename: \(url)"
        case .bodyPartFileNotReachable(let url):
            return "The URL provided is not reachable: \(url)"
        case .bodyPartFileNotReachableWithError(let url, let error):
            return (
                "The system returned an error while checking the provided URL for " +
                "reachability.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartFileIsDirectory(let url):
            return "The URL provided is a directory: \(url)"
        case .bodyPartFileSizeNotAvailable(let url):
            return "Could not fetch the file size from the provided URL: \(url)"
        case .bodyPartFileSizeQueryFailedWithError(let url, let error):
            return (
                "The system returned an error while attempting to fetch the file size from the " +
                "provided URL.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartInputStreamCreationFailed(let url):
            return "Failed to create an InputStream for the provided URL: \(url)"
        case .outputStreamCreationFailed(let url):
            return "Failed to create an OutputStream for URL: \(url)"
        case .outputStreamFileAlreadyExists(let url):
            return "A file already exists at the provided URL: \(url)"
        case .outputStreamURLInvalid(let url):
            return "The provided OutputStream URL is invalid: \(url)"
        case .outputStreamWriteFailed(let error):
            return "OutputStream write failed with error: \(error)"
        case .inputStreamReadFailed(let error):
            return "InputStream read failed with error: \(error)"
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var localizedDescription: String {
        switch self {
        case .inputDataNil:
            return "Response could not be serialized, input data was nil."
        case .inputDataNilOrZeroLength:
            return "Response could not be serialized, input data was nil or zero length."
        case .inputFileNil:
            return "Response could not be serialized, input file was nil."
        case .inputFileReadFailed(let url):
            return "Response could not be serialized, input file could not be read: \(url)."
        case .stringSerializationFailed(let encoding):
            return "String could not be serialized with encoding: \(encoding)."
        case .jsonSerializationFailed(let error):
            return "JSON could not be serialized because of error:\n\(error.localizedDescription)"
        case .propertyListSerializationFailed(let error):
            return "PropertyList could not be serialized because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var localizedDescription: String {
        switch self {
        case .dataFileNil:
            return "Response could not be validated, data file was nil."
        case .dataFileReadFailed(let url):
            return "Response could not be validated, data file could not be read: \(url)."
        case .missingContentType(let types):
            return (
                "Response Content-Type was missing and acceptable content types " +
                "(\(types.joined(separator: ","))) do not match \"*/*\"."
            )
        case .unacceptableContentType(let acceptableTypes, let responseType):
            return (
                "Response Content-Type \"\(responseType)\" does not match any acceptable types: " +
                "\(acceptableTypes.joined(separator: ","))."
            )
        case .unacceptableStatusCode(let code):
            return "Response status code was unacceptable: \(code)."
        }
    }
}
