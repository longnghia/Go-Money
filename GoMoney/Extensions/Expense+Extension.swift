import UIKit

extension Expense {
    func getDate(_ type: ExpenseSort = .occuredOn, formatter: DateFormatter = DateFormatter.ddmmyyyy) -> String {
        var date: Date?
        switch type {
        case .createdAt:
            date = createdAt
        case .updatedAt:
            date = updatedAt
        case .occuredOn:
            date = occuredOn
        }
        return formatter.string(from: date ?? Date())
    }
}

extension [Expense] {
    func sumAmount() -> Double {
        guard count > 0 else {
            return 0
        }
        return reduce(0) { $0 + $1.amount }
    }

    func medium() -> Double {
        guard count > 0 else {
            return 0
        }
        return sumAmount() / Double(count)
    }

    /// Group expenses that in the same date / month / year
    func groupExpensesByDate(type: ExpenseFilter = .week) -> [DateAmount] {
        guard count > 0 else {
            return []
        }

        // sort expenses by date.
        let allDateAmount = map {
            DateAmount(date: $0.occuredOn, totalAmount: $0.amount)
        }
        .filter { $0.totalAmount > 0 }
        .sorted { $0.date < $1.date }

        var result = [DateAmount]()
        result.append(allDateAmount[0])

        if count == 1 {
            return result
        }

        // if nextday is the same day as current day, sum it's amount to current day.
        for i in 0 ... allDateAmount.count - 2 {
            let isNextSame: Bool?
            switch type {
            case .week, .month:
                isNextSame = allDateAmount[i + 1].date.isSameDayAs(allDateAmount[i].date)
            case .year:
                isNextSame = allDateAmount[i + 1].date.isInSameMonth(as: allDateAmount[i].date)
            case .all:
                isNextSame = false
            }

            guard let isNextSame = isNextSame else {
                return result
            }

            if isNextSame {
                result[result.endIndex - 1].totalAmount += allDateAmount[i + 1].totalAmount
            } else {
                result.append(allDateAmount[i + 1])
            }
        }

        return result
    }

    /// Group expense by tags then calculate sum.
    func groupExpensesByTag() -> [TagAmount] {
        guard count > 0 else {
            return []
        }

        // sort expenses by tag
        let allTagAmount = map {
            TagAmount(tag: $0.tag, totalAmount: $0.amount)
        }
        .filter { $0.totalAmount > 0 }
        .sorted { $0.tag < $1.tag }

        var result = [TagAmount]()
        result.append(allTagAmount[0])

        if count == 1 {
            return result
        }

        // if nextExpense's tag is equal currentag, sum it's amount to current expense.
        for i in 0 ... allTagAmount.count - 2 {
            if allTagAmount[i + 1].tag == allTagAmount[i].tag {
                result[result.endIndex - 1].totalAmount += allTagAmount[i + 1].totalAmount
            } else {
                result.append(allTagAmount[i + 1])
            }
        }

        return result
    }

    func getTopExpenses(quanlity: Int = 7) -> [Expense] {
        let mediumExpense = medium()
        if count < quanlity {
            return sorted { $0.amount > $1.amount }
        }
        let slice = filter { $0.amount > mediumExpense }
            .sorted { $0.amount > $1.amount }.prefix(quanlity)
        return Array(slice)
    }
}
