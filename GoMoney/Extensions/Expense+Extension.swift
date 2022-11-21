import UIKit

extension Expense {
    func getDate(_ type: ExpenseSort = .occuredOn, formatter: DateFormatter = DateFormatter.dmy()) -> String {
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

    func isExpense() -> Bool {
        return type == ExpenseType.expense.rawValue
    }

    func createShareText() -> String {
        return """
        ~~~~~~~~~~~~~~~~~
        Transaction type:
        \(type.capitalized)

        Category
        \(tag?.name ?? "")

        Amount
        \(String(amount))

        Date
        \(DateFormatter.date.string(from: occuredOn))

        Note:
        \(note)
        ~~~~~~~~~~~~~~~~~
        Shared from GoMoney with ❤️
        """
    }

    func toRemoteTransaction() -> RemoteTransaction {
        return RemoteTransaction(
            _id: _id.stringValue,
            type: type,
            tag: tag?.name ?? "",
            amount: amount,
            note: note,
            occuredOn: occuredOn,
            createdAt: createdAt,
            updatedAt: updatedAt)
    }
}

extension [Expense] {
    func sumAmount() -> Double {
        guard count > 0 else {
            return 0
        }
        return reduce(0) { $0 + $1.amount }
    }

    func average() -> Double {
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
    func groupExpensesByTag(maxTag: Int = 5) -> [TagAmount] {
        guard count > 0 else {
            return []
        }

        // sort expenses by tag
        let allTagAmount = map {
            TagAmount(tag: $0.tag?.name ?? "Other", totalAmount: $0.amount)
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

        // split maxTag and others
        if maxTag > 0, result.count > maxTag {
            let sortedResult = result.sorted { $0.totalAmount > $1.totalAmount }
            let topTags = sortedResult[0 ..< maxTag]
            let othersAmount = sortedResult[maxTag ... sortedResult.endIndex - 1].reduce(0) { $0 + $1.totalAmount }
            let otherTags = TagAmount(tag: "Others", totalAmount: othersAmount)
            return topTags + [otherTags]
        }

        return result
    }

    func getTopExpenses(quantity: Int = 7) -> [Expense] {
        let mediumExpense = average()
        if count < quantity {
            return sorted { $0.amount > $1.amount }
        }
        let slice = filter { $0.amount > mediumExpense }
            .sorted { $0.amount > $1.amount }.prefix(quantity)
        return Array(slice)
    }
}
