//
//  PKStrokePathAdditions.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import PencilKit

extension PKStrokePath {
  func parametricValue(_ parametricValue: CGFloat, offsetBy step: InterpolatedSlice.Stride) -> CGFloat {
    switch step {
      case .distance(let distance):
        return (self as PKStrokePathReference).parametricValue(parametricValue, offsetByDistance: distance)
      case .time(let time):
        return (self as PKStrokePathReference).parametricValue(parametricValue, offsetByTime: time)
      case .parametricStep(let parametricStep):
        return Swift.max(0, Swift.min(CGFloat(count - 1), parametricValue + parametricStep))
      default:
        return parametricValue
    }
  }
}

