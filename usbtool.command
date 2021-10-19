#!/usr/bin/swift

import Cocoa

let kAppTitle = "USB Tool"
let kTargetBoard = "GA-H97N-WIFI"
let kBundleName = "USBTool"
let kBundleIdentifier = "org.usbtool.kext"
let kIONameMatch = "XHC"
let kIOProviderClass = "AppleUSBXHCILPTHB"
let kFallbackModelIdentifier = "iMac18,1"
let kInfoPlistSourceData = """
	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgcGxpc3QgUFVCTElD
	ICItLy9BcHBsZS8vRFREIFBMSVNUIDEuMC8vRU4iICJodHRwOi8vd3d3LmFwcGxlLmNvbS9EVERzL1By
	b3BlcnR5TGlzdC0xLjAuZHRkIj48cGxpc3QgdmVyc2lvbj0iMS4wIj48ZGljdD48a2V5PkNGQnVuZGxl
	SW5mb0RpY3Rpb25hcnlWZXJzaW9uPC9rZXk+PHN0cmluZz42LjA8L3N0cmluZz48a2V5PkNGQnVuZGxl
	UGFja2FnZVR5cGU8L2tleT48c3RyaW5nPktFWFQ8L3N0cmluZz48a2V5PkNGQnVuZGxlU2hvcnRWZXJz
	aW9uU3RyaW5nPC9rZXk+PHN0cmluZz4xLjA8L3N0cmluZz48a2V5PkNGQnVuZGxlU3VwcG9ydGVkUGxh
	dGZvcm1zPC9rZXk+PGFycmF5PjxzdHJpbmc+TWFjT1NYPC9zdHJpbmc+PC9hcnJheT48a2V5PkNGQnVu
	ZGxlVmVyc2lvbjwva2V5PjxzdHJpbmc+MS4wPC9zdHJpbmc+PGtleT5PU0J1bmRsZVJlcXVpcmVkPC9r
	ZXk+PHN0cmluZz5Sb290PC9zdHJpbmc+PC9kaWN0PjwvcGxpc3Q+
"""
let kDriverIdentifier = "com.apple.driver.AppleUSBHostMergeProperties"
let kDriverClass = "AppleUSBHostMergeProperties"
let kIOPersonalitiesKey = "IOKitPersonalities"
let kIOProviderMergePropertiesKey = "IOProviderMergeProperties"
let kModelIdentifierKey = "model"
let kPortCountKey = "port-count"
let kPortsKey = "ports"
let kPortKey = "port"
let kUSBConnectorKey = "UsbConnector"
let kWindowWidth: CGFloat = 400.0
let kPortListEdgeInsets = NSEdgeInsets(top: 4.0, left: 8.0, bottom: 8.0, right: 8.0)
let kPortListRowSpacing: CGFloat = 8.0
let kContentSpacing: CGFloat = 16.0

class PortMap {
	static let shared = PortMap()
	
	public let data: [USBPort] = [
		.init(
			name: "HS01",
			address: 0x1,
			connector: .a3,
			info: "USB 3 Header"
		), .init(
			name: "HS02",
			address: 0x2,
			connector: .a3,
			info: "USB 3 Header"
		), .init(
			name: "HS03",
			address: 0x3,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "HS04",
			address: 0x4,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "HS05",
			address: 0x5,
			connector: .a3,
			info: "USB 2 Header"
		), .init(
			name: "HS06",
			address: 0x6,
			connector: .a3,
			info: "USB 2 Header"
		), .init(
			name: "HS07",
			address: 0x7,
			connector: .a2,
			info: "Rear Panel USB 2 Connector"
		), .init(
			name: "HS08",
			address: 0x8,
			connector: .a2,
			info: "Rear Panel USB 2 Connector"
		), .init(
			name: "HS09",
			address: 0x9,
			connector: .a2,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "HS10",
			address: 0xA,
			connector: .a2,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "HS11",
			address: 0xB,
			connector: .proprietary,
			info: "Mini PCI Express"
		), .init(
			name: "SS01",
			address: 0x10,
			connector: .a3,
			info: "USB 3 Header"
		), .init(
			name: "SS02",
			address: 0x11,
			connector: .a3,
			info: "USB 3 Header"
		), .init(
			name: "SS03",
			address: 0x12,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "SS04",
			address: 0x13,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "SS05",
			address: 0x14,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		), .init(
			name: "SS06",
			address: 0x15,
			connector: .a3,
			info: "Rear Panel USB 3 Connector"
		)
	]
}

extension FixedWidthInteger {
	public var data: Data {
		var tmp = self
		return .init(bytes: &tmp, count: MemoryLayout<Self>.size)
	}
}

extension FileHandle {
	public func print(_ string: String, terminator: String = "\n") {
		if let data = (string + terminator).data(using: .utf8) {
			self.write(data)
		}
	}
}

extension NSMenu {
	convenience init(title: String, items: [NSMenuItem]) {
		self.init(title: title)
		self.items = items
	}
}

extension String: LocalizedError {
	public var errorDescription: String? {
		return self
	}
}

extension DispatchQueue {
	static let work = DispatchQueue(label: "work")
}

extension URL {
	static let desktop: URL? = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first
}

enum USBConnector: UInt8 {
	case a2 = 0x0 // Type A (USB 2)
	case a3 = 0x3 // Type A (USB 3)
	case c2 = 0x8 // Type C (USB 2)
	case c3s = 0x9 // Type C (USB 3, switched)
	case c3 = 0xA // Type C (USB 3)
	case proprietary = 0xFF // Not user visible (e.g. internal bluetooth)
}

@objc class USBPort: NSObject {
	public let name: String
	public let address: UInt32
	public let connector: USBConnector
	public let info: String
	@objc private(set) var isEnabled: Bool
	
	init(name: String, address: UInt32, connector: USBConnector, info: String, isEnabled: Bool = true) {
		self.name = name
		self.address = address
		self.connector = connector
		self.info = info
		self.isEnabled = isEnabled
	}
}

class BundleWriter {
	static let shared = BundleWriter()
	
	private let infoPlistSource: NSDictionary
	
	private static func decodeInfoPlistSourceData() throws -> NSDictionary {
		do {
			guard let data = Data(base64Encoded: kInfoPlistSourceData, options: .ignoreUnknownCharacters) else {
				throw "failed to decode plist source data from base64"
			}
			
			var format = PropertyListSerialization.PropertyListFormat.xml
			
			guard let result = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format) as? NSDictionary else {
				throw "failed to cast serialized property list to dictionary"
			}
			
			return result
		}
		
		catch {
			throw "\(#function): \(error.localizedDescription)"
		}
	}
	
	public init() {
		do {
			infoPlistSource = try Self.decodeInfoPlistSourceData()
		}
		
		catch {
			fatalError(error.localizedDescription)
		}
	}
	
	private lazy var modelIdentifier: String = {
		var identifier: String?
		let entry = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/")
		
		if let data = IORegistryEntryCreateCFProperty(entry, "model" as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? Data {
			identifier = String(data: data, encoding: .macOSRoman)?.filter { $0 != "\0"}
		}
		
		IOObjectRelease(entry)
		
		guard identifier != nil else {
			FileHandle.standardError.print("warning: using fallback model identifier \(kFallbackModelIdentifier)!")
			return kFallbackModelIdentifier
		}
		
		return identifier!
	}()
	
	public func write(destinationURL url: URL?, userMap: [USBPort]) throws -> URL {
		guard !userMap.isEmpty else {
			throw "\(#function): userMap is empty"
		}
		
		guard let bundleURL = url?.appendingPathComponent("\(kBundleName).kext") else {
			throw "\(#function): failed to build bundle path"
		}
		
		let userInfoPlist = NSMutableDictionary(dictionary: infoPlistSource)
		let ioKitPersonalitiesDict = NSMutableDictionary()
		let driverPersonalityDict = NSMutableDictionary()
		let ioProviderMergePropertiesDict = NSMutableDictionary()
		let portsDict = NSMutableDictionary()
		
		userInfoPlist.setObject(kBundleName, forKey: kCFBundleNameKey as NSString)
		userInfoPlist.setObject(kBundleIdentifier, forKey: kCFBundleIdentifierKey as NSString)
		userInfoPlist.setObject(ioKitPersonalitiesDict, forKey: kIOPersonalitiesKey as NSString)
		
		ioKitPersonalitiesDict.setObject(driverPersonalityDict, forKey: "Generated by \(kAppTitle) for \(kTargetBoard)" as NSString)
		
		driverPersonalityDict.setObject(kDriverIdentifier, forKey: kCFBundleIdentifierKey as NSString)
		driverPersonalityDict.setObject(kDriverClass, forKey: kIOClassKey as NSString)
		driverPersonalityDict.setObject(kIONameMatch, forKey: kIONameMatchKey as NSString)
		driverPersonalityDict.setObject(kIOProviderClass, forKey: kIOProviderClassKey as NSString)
		driverPersonalityDict.setObject(ioProviderMergePropertiesDict, forKey: kIOProviderMergePropertiesKey as NSString)
		
		ioProviderMergePropertiesDict.setObject(modelIdentifier, forKey: kModelIdentifierKey as NSString)
		ioProviderMergePropertiesDict.setObject(userMap.last!.address.data, forKey: kPortCountKey as NSString)
		ioProviderMergePropertiesDict.setObject(portsDict, forKey: kPortsKey as NSString)
		
		for port in userMap {
			let portDict = NSMutableDictionary()
			portDict.setObject(port.address.data, forKey: kPortKey as NSString)
			portDict.setObject(port.connector.rawValue, forKey: kUSBConnectorKey as NSString)
			portsDict.setObject(portDict, forKey: port.name as NSString)
		}
		
		let data = try PropertyListSerialization.data(fromPropertyList: userInfoPlist, format: .xml, options: 0)
		let contentsURL = bundleURL.appendingPathComponent("Contents")
		let infoPlistURL = contentsURL.appendingPathComponent("Info.plist")
		try FileManager.default.createDirectory(atPath: contentsURL.path, withIntermediateDirectories: true, attributes: nil)
		try data.write(to: infoPlistURL, options: .atomic)
		try? FileManager.default.setAttributes([.modificationDate: NSDate()], ofItemAtPath: bundleURL.path)
		
		return bundleURL;
	}
}

class ViewController: NSViewController {
	static let shared = ViewController()
	
	private lazy var portListView: NSStackView = {
		let view = NSStackView()
		
		for port in PortMap.shared.data {
			let button = Self.makePortSwitchButton(title: "\(port.name) (\(port.info))", initialState: port.isEnabled ? .on : .off)
			button.bind(NSBindingName.value, to: port, withKeyPath: #keyPath(USBPort.isEnabled), options: nil)
			button.target = self
			button.action = #selector(ViewController.switchButtonPressed(_:))
			view.addArrangedSubview(button)
		}
		
		view.orientation = .vertical
		view.spacing = kPortListRowSpacing
		view.edgeInsets = kPortListEdgeInsets
		view.distribution = .fill
		view.alignment = .left
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var writeButton: NSButton = {
		let button = NSButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.bezelStyle = .rounded
		button.title = "Write Bundle to Desktop"
		button.isEnabled = false
		return button
	}()
	
	private var userMap: [USBPort] {
		return PortMap.shared.data.filter { $0.isEnabled }
	}
	
	override func loadView() {
		view = AppDelegate.shared.mainWindow.contentView!
	}
	
	override func viewDidLoad() {
		/* set the window title */
		view.window?.title = kAppTitle
		
		/* add subviews to window */
		view.addSubview(portListView)
		view.addSubview(writeButton)
		
		/* add layout constraints */
		portListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: kContentSpacing).isActive = true
		portListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kContentSpacing).isActive = true
		portListView.topAnchor.constraint(equalTo: view.topAnchor, constant: kContentSpacing).isActive = true
		portListView.bottomAnchor.constraint(equalTo: writeButton.topAnchor, constant: -kContentSpacing).isActive = true
		writeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kContentSpacing).isActive = true
		writeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -kContentSpacing).isActive = true
		
		/* setup save button */
		writeButton.target = self
		writeButton.action = #selector(ViewController.writeButtonPressed(_:))
		writeButton.isEnabled = userMap.count <= 15
	}
	
	@objc func switchButtonPressed(_ sender: NSButton) {
		writeButton.isEnabled = userMap.count <= 15
	}
	
	@objc func writeButtonPressed(_ sender: NSButton) {
		DispatchQueue.work.async {
			do {
				let url = try BundleWriter.shared.write(destinationURL: URL.desktop, userMap: self.userMap)
				print("Wrote bundle to \(url.path)")
			}
			
			catch {
				FileHandle.standardError.print(error.localizedDescription)
			}
		}
	}

	private static func makePortSwitchButton(title: String, initialState state: NSControl.StateValue) -> NSButton {
		let button = NSButton()
		button.setButtonType(.switch)
		button.title = title
		button.focusRingType = .none
		button.state = state
		return button
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	static let shared = AppDelegate()
	
	public lazy var mainWindow: NSWindow = {
		let window = NSWindow()
		window.styleMask = [.titled, .closable]
		window.standardWindowButton(.miniaturizeButton)?.isHidden = true
		window.standardWindowButton(.zoomButton)?.isHidden = true
		window.contentView?.widthAnchor.constraint(greaterThanOrEqualToConstant: kWindowWidth).isActive = true
		return window
	}()
	
	private lazy var mainMenu: NSMenu = {
		let menu = NSMenu(title: "Main", items: [
			NSMenuItem(title: ProcessInfo.processInfo.processName, action: nil, keyEquivalent: "")
		])
		
		menu.items[0].submenu = NSMenu(title: "Application", items: [
			NSMenuItem(title: "About \(ProcessInfo.processInfo.processName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
			NSMenuItem.separator(),
			NSMenuItem(title: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
		])
		
		return menu
	}()
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		NSApp.activate(ignoringOtherApps: true)
	}
	
	public func runApp() {
		NSApp = NSApplication.shared
		NSApp.delegate = AppDelegate.shared
		NSApp.mainMenu = mainMenu
		NSApp.setActivationPolicy(.regular)
		mainWindow.contentViewController = ViewController.shared
		mainWindow.makeKeyAndOrderFront(self)
		mainWindow.center()
		NSApp.run()
	}
}

AppDelegate.shared.runApp()
