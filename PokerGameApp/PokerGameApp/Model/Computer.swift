import Foundation

class Computer {
    enum Hands: Comparable {
        case highCard
        case onePair
        case twoPair
        case triple
        case straight
        case flush
        case fullHouse
        case fourCard
        case straightFlush
        case royalStraightFlush
    }
}