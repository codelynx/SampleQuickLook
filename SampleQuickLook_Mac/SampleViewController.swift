//
//	ViewController.swift
//	SampleQuickLook_Mac
//
//	Created by Kaz Yoshikawa on 2/23/16.
//
//

import Cocoa
import Quartz


class SamplePreviewItem: NSObject, QLPreviewItem {
	var previewItemURL: NSURL
	var previewItemTitle: String
	init(URL: NSURL, title: String) {
		self.previewItemURL = URL
		self.previewItemTitle = title
	}
}

class SampleViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet var tableView: NSTableView!
	@IBOutlet var rightView: NSView!
	var previewView: QLPreviewView!

	lazy var previewItems: [SamplePreviewItem] = {
		let directory = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent("SampleData")
		var items = [SamplePreviewItem]()
		if let files = NSFileManager.defaultManager().enumeratorAtPath(directory) {
			for file in files {
				let filePath = (directory as NSString).stringByAppendingPathComponent(file as! String)
				let fileURL = NSURL(fileURLWithPath: filePath)
				let item = SamplePreviewItem(URL: fileURL, title: file.lastPathComponent)
				items.append(item)
			}
		}
		return items
	}()


	override func viewDidLoad() {
		super.viewDidLoad()

		self.previewView = QLPreviewView(frame: self.rightView.bounds, style: .Compact) // .Normal, .Compact
		self.rightView.addSubview(previewView)

		let views = ["previewView": self.previewView]
		for constraint in
			NSLayoutConstraint.constraintsWithVisualFormat("V:|-[previewView]-|", options: [], metrics: nil, views: views) +
			NSLayoutConstraint.constraintsWithVisualFormat("H:|-[previewView]-|", options: [], metrics: nil, views: views) {
			self.rightView.addConstraint(constraint)
		}
		self.previewView.translatesAutoresizingMaskIntoConstraints = false
	}

	override var representedObject: AnyObject? {
		didSet {
		}
	}

	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return previewItems.count
	}
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		switch tableColumn!.identifier {
		case "title": return self.previewItems[row].previewItemTitle
		default: return ""
		}
	}

	func tableViewSelectionDidChange(notification: NSNotification) {
		if self.tableView.selectedRow >= 0 {
			let previewItem = self.previewItems[self.tableView.selectedRow]
			self.previewView.previewItem = previewItem
		}
		else {
			self.previewView.previewItem = nil
		}
	}
}

