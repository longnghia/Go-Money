import LinkPresentation

class GMActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    var image: UIImage?

    init(title: String, text: String, image: UIImage? = nil) {
        self.title = title
        self.text = text
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        if let image = image {
            metadata.imageProvider = NSItemProvider(object: image)
        }
        metadata.originalURL = URL(fileURLWithPath: text)
        return metadata
    }
}
