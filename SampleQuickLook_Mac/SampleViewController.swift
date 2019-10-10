//
//	ViewController.swift
//	SampleQuickLook_Mac
//
//	Created by Kaz Yoshikawa on 2/23/16.
//	Copyright (c) Kaz Yoshikawa, All rights reserved.
//

import Cocoa
import Quartz


class SamplePreviewItem: NSObject, QLPreviewItem {
	var previewItemURL: URL
	var previewItemTitle: String
	init(URL: Foundation.URL, title: String) {
		self.previewItemURL = URL
		self.previewItemTitle = title
	}
}

class SampleViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet var tableView: NSTableView!
	@IBOutlet var rightView: NSView!
	var previewView: QLPreviewView!

	lazy var previewItems: [SamplePreviewItem] = {
		let directory = (Bundle.main.resourcePath! as NSString).appendingPathComponent("SampleData")
		var items = [SamplePreviewItem]()
		if let files = FileManager.default.enumerator(atPath: directory) {
			for file in files {
				let filePath = (directory as NSString).appendingPathComponent(file as! String)
				let fileURL = URL(fileURLWithPath: filePath)
				let item = SamplePreviewItem(URL: fileURL, title: (file as AnyObject).lastPathComponent)
				items.append(item)
			}
		}
		return items
	}()


	override func viewDidLoad() {
		super.viewDidLoad()

		self.previewView = QLPreviewView(frame: self.rightView.bounds, style: .compact) // .Normal, .Compact
		self.rightView.addSubview(previewView)

		let views = ["previewView": self.previewView!]
		for constraint in
			NSLayoutConstraint.constraints(withVisualFormat: "V:|-[previewView]-|", options: [], metrics: nil, views: views) +
			NSLayoutConstraint.constraints(withVisualFormat: "H:|-[previewView]-|", options: [], metrics: nil, views: views) {
			self.rightView.addConstraint(constraint)
		}
		self.previewView.translatesAutoresizingMaskIntoConstraints = false
	}

	override var representedObject: Any? {
		didSet {
		}
	}

	func numberOfRows(in tableView: NSTableView) -> Int {
		return previewItems.count
	}
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		switch tableColumn!.identifier.rawValue {
		case "title": return self.previewItems[row].previewItemTitle
		default: return ""
		}
	}

	func tableViewSelectionDidChange(_ notification: Notification) {
		if self.tableView.selectedRow >= 0 {
			let previewItem = self.previewItems[self.tableView.selectedRow]
			self.previewView.previewItem = previewItem
		}
		else {
			self.previewView.previewItem = nil
		}
	}
}

