//
//  DateFormat.swift
//  PhotosClone
//
//  Created by Swain Yun on 8/23/24.
//

import Foundation

/// 날짜, 시간 표현 방식
enum DateFormat: String {
    /// 년.월.일
    case yyyyMMdd = "yyyy.MM.dd"
    
    /// 한국어 년월일 (yyyy년 MM월 dd일)
    case yyyyMMddKorean = "yyyy년 MM월 dd일"
    
    /// 한국어 년월일 (yyyy년 M월 d일)
    case yyyyMdKorean = "yyyy년 M월 d일"
    
    /// 한국어 월일 (MM월 dd일)
    case MMddKorean = "MM월 dd일"
    
    /// 년.월
    case yyyyMM = "yyyy.MM"
    
    /// 월.일
    case MMdd = "MM.dd"
    
    /// 년.월.일 시:분:초
    case dateTime = "yyyy.MM.dd HH:mm:ss"
    
    /// 년.월.일 시:분
    case yyyyMMddHHmm = "yyyy.MM.dd HH:mm"
    
    /// 년.월.일 오전/오후 시:분
    case yyyyMMddahhmm = "yyyy.MM.dd a hh:mm"
    
    /// 년.월.일 오전/오후 시(24):분
    case yyyyMMddaHHmm = "yyyy.MM.dd a HH:mm"
    
    /// 시:분:초
    case HHmmss = "HH:mm:ss"
    
    /// 시:분
    case HHmm = "HH:mm"
    
    /// 오전/오후 시:분
    case ahhmm = "a hh:mm"
    
    /// 오전/오후 시:분
    /// - Note: 숫자가 0으로 시작하지 않음
    case ahmm = "a h:mm"
    
    /// 축약 요일 (월, 화)
    case ee = "EE"
    
    /// 서버 날짜, 시간 (년-월-일 시:분:초)
    case serverDateTime = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
}

// MARK: DateFormatter 관련
extension DateFormat {
    private static var formatters = [String: DateFormatter]()
    
    /**
     각 DateFormat에 대응되는 DateFormatter
     
     * DateFormatter를 매번 생성하지 않고 재사용 하려는 목적으로 사용
     
     */
    var formatter: DateFormatter {
        Self.cachedFormatter(dateFormat: self.rawValue)
    }
    
    static func cachedFormatter(dateFormat: String) -> DateFormatter {
        if let cached = formatters[dateFormat] {
            return cached
        }
        
        let formatter = createFormatter(with: dateFormat)
        Self.formatters[dateFormat] = formatter
        return formatter
    }
    
    private static func createFormatter(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
}

// MARK: Date+Format
extension Date {
    func toString(by dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
    
    /// DateFormat에서 제공하는 형태와 다른 날짜 형식일 경우 사용
    func toString(by dateFormat: String) -> String {
        let formatter = DateFormat.cachedFormatter(dateFormat: dateFormat)
        return formatter.string(from: self)
    }
}
