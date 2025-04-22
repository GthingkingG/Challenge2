//
//  MyType.swift
//  Challenge2
//
//  Created by Air on 4/21/25.
//
import SwiftUI

enum myType: String, Codable ,CaseIterable {
    case greenOnions, redLettuce, basil, perillaLeaves, cherryTomatoes, kidneyBeans, peas, cucumbers
    
    var typeName: String {
        switch self {
        case .greenOnions:
            return "대파"
        case .redLettuce:
            return "적상추"
        case .basil:
            return "바질"
        case .perillaLeaves:
            return "꺳잎"
        case .cherryTomatoes:
            return "방울토마토"
        case .kidneyBeans:
            return "강낭콩"
        case .peas:
            return "완두콩"
        case .cucumbers:
            return "오이"
        }
    }
    
    var typeMeans: String {
        switch self {
        case .greenOnions:
            return "계층화된 구조와 지속적인 성장"
        case .redLettuce:
            return "다양성과 적응력"
        case .basil:
            return "다양한 활용과 가치 창출"
        case .perillaLeaves:
            return "독특한 경험과 문화적 다양성"
        case .cherryTomatoes:
            return "작지만 강렬한 맛의 경험"
        case .kidneyBeans:
            return "잠재력의 성장과 체계적인 발전"
        case .peas:
            return "신선함과 조화로운 구성"
        case .cucumbers:
            return "균형 잡힌 영양과 수분 공급"
        }
    }
    var typeDetail: String {
        switch self {
        case .greenOnions:
            return "대파의 층층이 쌓인 구조는 프로그래밍의 계층적 구조를 상징하며, 지속적으로 자라나는 특성은 코드의 발전과 유지보수를 나타냅니다."
        case .redLettuce:
            return "적상추의 독특한 색상과 다양한 요리법은 문화의 다양성과 새로운 환경에 대한 적응력을 나타냅니다."
        case .basil:
            return "바질의 다양한 요리 활용과 높은 경제적 가치는 경제 분야의 자원 활용과 가치 창출 능력을 상징합니다."
        case .perillaLeaves:
            return "깻잎의 독특한 향과 맛은 여행에서 경험하는 새로운 문화와 다양한 경험을 상징합니다."
        case .cherryTomatoes:
            return "방울토마토의 작은 크기와 풍부한 맛은 맛집에서 경험할 수 있는 집중된 맛의 경험을 상징합니다."
        case .kidneyBeans:
            return "강낭콩이 작은 씨앗에서 풍성한 수확으로 자라나는 과정은 기획의 잠재력 실현과 체계적인 발전 과정을 나타냅니다."
        case .peas:
            return "완두콩의 선명한 녹색과 다양한 주름 모양은 디자인의 신선함과 조화로운 구성을 나타냅니다."
        case .cucumbers:
            return "오이의 높은 수분 함량과 다양한 영양소는 건강한 생활을 위한 균형 잡힌 영양과 수분 공급을 상징합니다."
        }

    }
    
    var typeColor: Color {
        switch self {
        case .greenOnions:
            return .blue
        case .redLettuce:
            return .red
        case .basil:
            return .orange
        case .perillaLeaves:
            return .yellow
        case .cherryTomatoes:
            return .green
        case .kidneyBeans:
            return .mint
        case .peas:
            return .indigo
        case .cucumbers:
            return .purple
        }
    }
}
