import SnackBar_swift

class GMSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = K.Color.actionBackground
        style.textColor = K.Color.white
        style.font = .nova(14)
        style.actionFont = .novaBold(17)
        style.actionTextColor = K.Color.primaryDarkColor
        return style
    }
}
