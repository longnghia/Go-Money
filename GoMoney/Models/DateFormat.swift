enum DateFormat: String {
    case dmy = "dd-MM-yyyy"
    case mdy = "MM-dd-yyyy"
    case ymd = "yyyy-MM-dd"
    case dmy_s = "dd/MM/yyyy"
    case mdy_s = "MM/dd/yyyy"
    case ymd_s = "yyyy/MM/dd"

    static let all: [DateFormat] = [.dmy, .mdy, .ymd, .dmy_s, .mdy_s, .ymd_s]
}
