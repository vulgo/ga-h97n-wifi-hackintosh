#!/usr/bin/swift

import Cocoa

let kAppTitle = "USB Tool for H97N-WIFI"
let kBundleName = "USBTool"
let kBundleIdentifier = "org.usbtool.kext"
let kIONameMatch = "XHC"
let kIOProviderClass = "AppleUSBXHCILPTHB"
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
let kUndeterminedModelID = "MacPro1,1"

class PortMap {
	static let shared = PortMap()
	
	private init() { }
	
	public let data = [
		USBPort(
			name: "HS01",
			address: 0x1,
			connectorType: .a3,
			description: "USB 3 Header"
		), USBPort(
			name: "HS02",
			address: 0x2,
			connectorType: .a3,
			description: "USB 3 Header"
		), USBPort(
			name: "HS03",
			address: 0x3,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "HS04",
			address: 0x4,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "HS05",
			address: 0x5,
			connectorType: .a3,
			description: "USB 2 Header"
		), USBPort(
			name: "HS06",
			address: 0x6,
			connectorType: .a3,
			description: "USB 2 Header"
		), USBPort(
			name: "HS07",
			address: 0x7,
			connectorType: .a2,
			description: "Rear Panel USB 2 Connector"
		), USBPort(
			name: "HS08",
			address: 0x8,
			connectorType: .a2,
			description: "Rear Panel USB 2 Connector"
		), USBPort(
			name: "HS09",
			address: 0x9,
			connectorType: .a2,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "HS10",
			address: 0xA,
			connectorType: .a2,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "HS11",
			address: 0xB,
			connectorType: .proprietary,
			description: "Mini PCI Express"
		), USBPort(
			name: "SS01",
			address: 0x10,
			connectorType: .a3,
			description: "USB 3 Header"
		), USBPort(
			name: "SS02",
			address: 0x11,
			connectorType: .a3,
			description: "USB 3 Header"
		), USBPort(
			name: "SS03",
			address: 0x12,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "SS04",
			address: 0x13,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "SS05",
			address: 0x14,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		), USBPort(
			name: "SS06",
			address: 0x15,
			connectorType: .a3,
			description: "Rear Panel USB 3 Connector"
		)
	]
}

extension FixedWidthInteger {
	func data() -> Data {
		var tmp = self
		return Data(bytes: &tmp, count: MemoryLayout<Self>.size)
	}
}

extension FileHandle {
	public func print(_ string: String, terminator: String = "\n") {
		if let data = (string + terminator).data(using: .utf8) {
			self.write(data)
		}
	}
}

struct USBPort {
	let name: String
	let address: UInt32
	let connectorType: ConnectorType
	let description: String
	
	var addressData: Data {
		return address.data()
	}
	
	enum ConnectorType: UInt8 {
		case a2 = 0x0 // Type A (USB 2)
		case a3 = 0x3 // Type A (USB 3)
		case c2 = 0x8 // Type C (USB 2)
		case c3s = 0x9 // Type C (USB 3, switched)
		case c3 = 0xA // Type C (USB 3)
		case proprietary = 0xFF // Not user visible (e.g. internal bluetooth)
	}
	
	init(name: String, address: UInt32, connectorType: ConnectorType, description: String) {
		self.name = name
		self.address = address
		self.connectorType = connectorType
		self.description = description
	}
}

extension String: LocalizedError {
	public var errorDescription: String? { return self }
}

class BundleWriter {
	private var infoPlistSource: NSDictionary
	
	private static func decodeInfoPlistSourceData() throws -> NSDictionary {
		do {
			guard let data = Data(base64Encoded: kInfoPlistSourceData, options: .ignoreUnknownCharacters) else {
				throw "\(#function): failed to decode plist source data from base64!"
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
	
	lazy var desktopURL: URL? = {
		let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
		return paths.first
	}()
	
	lazy var modelIdentifier: String = {
		let entry = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/")
		
		guard let data = IORegistryEntryCreateCFProperty(entry, "model" as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? Data,
		      let id = String(data: data, encoding: .macOSRoman)?.trimmingCharacters(in: CharacterSet(charactersIn: "\0")) else {
			FileHandle.standardError.print("error: using model identifier \(kUndeterminedModelID)!")
			return kUndeterminedModelID
		}
		
		return id
	}()
	
	func writeToDesktop(bundleName: String, bundleIdentifier: String, ioNameMatch: String, ioProviderClass: String, userMap: [USBPort]) throws -> URL {
		guard !userMap.isEmpty else {
			throw "\(#function): userMap is empty"
		}
		
		guard let bundleURL = desktopURL?.appendingPathComponent("\(bundleName).kext") else {
			throw "\(#function): failed to build bundle path"
		}
		
		let userInfoPlist = NSMutableDictionary(dictionary: infoPlistSource)
		let ioKitPersonalitiesDict = NSMutableDictionary()
		let driverPersonalityDict = NSMutableDictionary()
		let ioProviderMergePropertiesDict = NSMutableDictionary()
		let portsDict = NSMutableDictionary()
		
		userInfoPlist.setObject(bundleName, forKey: kCFBundleNameKey as NSString)
		userInfoPlist.setObject(bundleIdentifier, forKey: kCFBundleIdentifierKey as NSString)
		userInfoPlist.setObject(ioKitPersonalitiesDict, forKey: kIOPersonalitiesKey as NSString)
		
		ioKitPersonalitiesDict.setObject(driverPersonalityDict, forKey: "Generated by \(kAppTitle)" as NSString)
		
		driverPersonalityDict.setObject(kDriverIdentifier, forKey: kCFBundleIdentifierKey as NSString)
		driverPersonalityDict.setObject(kDriverClass, forKey: kIOClassKey as NSString)
		driverPersonalityDict.setObject(ioNameMatch, forKey: kIONameMatchKey as NSString)
		driverPersonalityDict.setObject(ioProviderClass, forKey: kIOProviderClassKey as NSString)
		driverPersonalityDict.setObject(ioProviderMergePropertiesDict, forKey: kIOProviderMergePropertiesKey as NSString)
		
		ioProviderMergePropertiesDict.setObject(modelIdentifier, forKey: kModelIdentifierKey as NSString)
		ioProviderMergePropertiesDict.setObject(userMap.last!.address.data(), forKey: kPortCountKey as NSString)
		ioProviderMergePropertiesDict.setObject(portsDict, forKey: kPortsKey as NSString)
		
		for port in userMap {
			let portDict = NSMutableDictionary()
			portDict.setObject(port.address.data(), forKey: kPortKey as NSString)
			portDict.setObject(port.connectorType.rawValue, forKey: kUSBConnectorKey as NSString)
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

struct Factory {
	/* unused */
	static func makeLabel(stringValue: String, width: CGFloat = -1.0) -> NSTextField {
		let view = NSTextField()
		view.isBezeled = false
		view.drawsBackground = false
		view.isEditable = false
		view.isSelectable = false
		view.stringValue = stringValue
		
		if (width > 0.0) {
			view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
		}
		
		return view
	}
	
}

class PortListStackView: NSStackView {
	override init(frame: NSRect) {
		super.init(frame: frame)
		orientation = .vertical
		distribution = .fill
		alignment = .left
		translatesAutoresizingMaskIntoConstraints = false
		
		for port in PortMap.shared.data {
			let button = Self.makePortSwitchButton(title: "\(port.name) (\(port.description))")
			_buttons.append(button)
			addArrangedSubview(Self.makeHorizontalStackView(subviews: button))
		}
	}
	
	convenience init() {
		self.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var _buttons = [NSButton]()
	
	public var buttons: [NSButton] {
		return _buttons
	}
	
	public func getEnabledIndices() -> [Int] {
		return (_buttons.filter { $0.state == .on }).map { $0.tag }
	}
	
	/* factory method */
	private static func makeHorizontalStackView(subviews: NSView...) -> NSStackView {
		let view = NSStackView()
		view.orientation = .horizontal
		view.distribution = .fill
		view.alignment = .firstBaseline
		view.translatesAutoresizingMaskIntoConstraints = false
		
		for subview in subviews {
			view.addArrangedSubview(subview)
		}
		
		return view
	}
	
	/* factory method */
	private static func makePortSwitchButton(title: String) -> NSButton {
		let button = NSButton()
		button.setButtonType(.switch)
		button.title = title
		button.focusRingType = .none
		button.state = .on
		return button
	}
}

class ViewController: NSViewController {
	static let shared: ViewController = ViewController(nibName: nil, bundle: nil)
	
	private lazy var portListView = PortListStackView()
	
	private lazy var saveButton: NSButton = {
		let title = "Save Bundle to Desktop"
		let button = NSButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.bezelStyle = .rounded
		button.title = title
		button.isEnabled = false
		return button
	}()
	
	private var portMap: PortMap {
		return representedObject as! PortMap
	}
	
	private var userMap: [USBPort] {
		var ports = [USBPort]()
		
		for idx in portListView.getEnabledIndices() {
			ports.append(portMap.data[idx])
		}
		
		return ports
	}
	
	override func loadView() {
		view = AppDelegate.shared.mainWindow.contentView!
	}
	
	override func viewDidLoad() {
		let spacing: CGFloat = 20.0
		
		/* set the represented object */
		representedObject = PortMap.shared
		
		/* set the window title */
		view.window?.title = kAppTitle
		
		/* add subviews to window */
		view.addSubview(portListView)
		view.addSubview(saveButton)
		
		/* add layout constraints */
		portListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
		portListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
		portListView.topAnchor.constraint(equalTo: view.topAnchor, constant: spacing).isActive = true
		portListView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -spacing).isActive = true
		saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacing).isActive = true
		saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
		
		/* setup port list view */
		var idx = 0
		for button in portListView.buttons {
			button.tag = idx
			button.target = self
			button.action = #selector(ViewController.switchButtonPressed(_:))
			idx += 1
		}
		
		/* setup save button */
		saveButton.target = self
		saveButton.action = #selector(ViewController.saveButtonPressed(_:))
		saveButton.isEnabled = portListView.getEnabledIndices().count <= 15
	}
	
	@objc func switchButtonPressed(_ sender: NSButton) {
		saveButton.isEnabled = portListView.getEnabledIndices().count <= 15
	}
	
	@objc func saveButtonPressed(_ sender: NSButton) {
		saveButton.isEnabled = false
		
		DispatchQueue.main.async {
			do {
				let url = try AppDelegate.shared.bundleWriter.writeToDesktop(
					bundleName: kBundleName,
					bundleIdentifier: kBundleIdentifier,
					ioNameMatch: kIONameMatch,
					ioProviderClass: kIOProviderClass,
					userMap: self.userMap
				)
				
				print("Wrote bundle to \(url.path)")
			}
			
			catch {
				FileHandle.standardError.print(error.localizedDescription)
			}
			
			self.saveButton.isEnabled = true
		}
	}
}

extension NSMenu {
	convenience init(title: String, items: [NSMenuItem]) {
		self.init(title: title)
		self.items = items
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	static let shared = AppDelegate()
	
	public let bundleWriter = BundleWriter()
	
	public lazy var mainWindow: NSWindow = {
		let minimumWidth: CGFloat = 400.0
		let window = NSWindow()
		window.styleMask = [.titled, .closable]
		window.standardWindowButton(.miniaturizeButton)?.isHidden = true
		window.standardWindowButton(.zoomButton)?.isHidden = true
		window.contentView?.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth).isActive = true
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
	
	public func run() {
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

AppDelegate.shared.run()

