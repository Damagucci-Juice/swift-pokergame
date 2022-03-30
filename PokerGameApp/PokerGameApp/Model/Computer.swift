import Foundation

class Computer {
    private var pairsCount = 0
    private var isTriple : Bool = false
    private var isFourCard : Bool = false
    private var shapeRankTable: [Shape : [Int]] = [.club : [Int](repeating: 0, count: 13),
                                                   .diamond : [Int](repeating: 0, count: 13),
                                                   .heart : [Int](repeating: 0, count: 13),
                                                   .spade: [Int](repeating: 0, count: 13)]
    private var countPerShape : [Shape: Int] = [.heart : 0,
                                                .spade : 0,
                                                .club : 0,
                                                .diamond : 0]
    
    private var sumOfShapes : [Int]?
    
    private var isStraight : (back: Bool, straight: Bool) {
        guard let sumOfShapes = self.sumOfShapes else {
            return (false ,false)
        }
        for index in 0..<10 {
            if sumOfShapes[index] > 0 &&
                sumOfShapes[index+1] > 0 &&
                sumOfShapes[index+2] > 0 &&
                sumOfShapes[index+3] > 0 &&
                sumOfShapes[index+4] > 0 {
                if index == 1 {
                    return (true, true)
                } else {
                    return (false,true)
                }
            }
        }
        return (false,false)
    }
    
    private var isFlush : Bool {
        for key in shapeRankTable.keys {
            shapeRankTable[key]?.forEach({ index in
                countPerShape[key]! += index
            })
        }
        
        for value in countPerShape.values {
            if value >= 5 {
                return true
            }
        }
        return false
    }
    
    func getHand(_ playerDeck: [Card]) -> Hand {
        shapeRankTable = caculateHandTable(playerDeck)
        sumOfShapes = getSumOfShapes(shapeRankTable)
        checkSameRankCard(sumOfShapes)
        return judgementHand(pairsCount, isTriple, isFourCard, isFlush, isStraight, isStraightFlush)
    }
    
    private var isStraightFlush : (back: Bool, straightFlush: Bool) {
        for value in shapeRankTable.values {
            for index in 0..<10 {
                if value[index] > 0 &&
                    value[index+1] > 0 &&
                    value[index+2] > 0 &&
                    value[index+3] > 0 &&
                    value[index+4] > 0 {
                    if index == 1 {
                        return (true, true)
                    } else {
                        return (false, true)
                    }
                }
            }
        }
        return (false, false)
    }
    
    
    private func judgementHand(_ pairs: Int, _ isTriple: Bool, _ isFourCard: Bool,_ isFlush: Bool, _ isStraight: (back:Bool, straight:Bool), _ isStraightFlush: (back:Bool, straightFlush:Bool)) -> Hand {
        switch (pairs, isTriple, isFourCard, isFlush, isStraight.back, isStraight.straight, isStraightFlush.back, isStraightFlush.straightFlush) {
        case (_, _, _, _, _, _, isStraightFlush.back, isStraightFlush.straightFlush):
            return .backStraightFlush
        case (_, _, _, _, _, _, _, isStraightFlush.straightFlush):
            return .straightFlush
        case (_, _, isFourCard, _, _, _, _, _):
            return .fourCard
        case (1...2, isTriple, _, _, _, _, _, _):
            return .fullHouse
        case (_,_,_, isFlush, _, _, _, _):
            return .flush
        case (_, _, _, _, isStraight.back, isStraight.straight, _, _):
            return .backStraight
        case (_, _, _, _, _, isStraight.straight, _, _):
            return .straight
        case (_, isTriple, _, _, _, _, _, _):
            return .triple
        case (2, _,_,_,_,_,_,_):
            return .twoPair
        case (1, _,_,_,_,_,_,_):
            return .onePair
        default:
            return .highCard
        }
    }
    
    private func caculateHandTable(_ playerDeck: [Card]) -> [Shape : [Int]] {
        
        playerDeck.forEach { card in
            let rank2Index = card.rank.rawValue - 1
            switch card.shape {
            case .spade:
                shapeRankTable[.spade]![rank2Index] += 1
            case .diamond:
                shapeRankTable[.diamond]![rank2Index] += 1
            case .club:
                shapeRankTable[.club]![rank2Index] += 1
            case .heart:
                shapeRankTable[.heart]![rank2Index] += 1
            }
        }
        return shapeRankTable
    }
    
    private func getSumOfShapes(_ cardTable: [Shape : [Int]] ) -> [Int] {
        var array = [Int](repeating: 0, count: 13)
        for value in cardTable.values {
            for index in 0..<array.count {
                array[index] += value[index]
            }
        }
        return array
    }
    
    // 같은 숫자의 패가 있는지 확인
    private func checkSameRankCard(_ lineForNumber: [Int]?) {
        guard let sumOfShapes = lineForNumber else {
            return
        }
        sumOfShapes.forEach { index in
            switch index {
            case 2:
                pairsCount += 1
            case 3:
                isTriple = true
            case 4:
                isFourCard = true
            default:
                print("")
            }
        }
    }
}