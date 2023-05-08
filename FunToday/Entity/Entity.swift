//
//  Entity.swift
//  FunToday
//
//  Created by 백상휘 on 2023/04/27.
//

import Foundation

protocol Entity: Codable {
  /// 고유 ID
  var uniqueID: String { get }
  /// 고유 인덱스
  var index: Int { get }
  /// 이름
  var name: String { get set }
  /// 설명
  var description: String { get }
  /// 등록일자
  var regDate: String { get }
  /// 수정일자
  var updateDate: String? { get set }
  /// 등록 사용자 ID
  var regID: String { get }
}
