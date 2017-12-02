//
//  SafariExtensionHandler.swift
//  k2yExtension
//
//  Created by zonble on 12/3/17.
//  Copyright © 2017 KKBOX Taiwan Co., Ltd. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }

	func getCurrentURL(in window: SFSafariWindow, callback: @escaping (URL?)->()) {
		window.getActiveTab { tab in
			guard let tab = tab else {
				callback(nil); return
			}
			tab.getActivePage {page in
				guard let page = page else {
					callback(nil); return
				}
				page.getPropertiesWithCompletionHandler { properties in
					guard let properties = properties else {
						callback(nil); return
					}
					guard let url = properties.url else {
						callback(nil); return
					}
					callback(url)
				}
			}
		}
	}

	static let pattern = "(http|https)://([a-zA-Z0-9]+).kkbox.com(/[a-z][a-z]|)(/[a-z][a-z]|)/playlist/([a-zA-Z0-9\\_\\-]+)(#[a-zA-Z0-9]+|)"
    override func toolbarItemClicked(in window: SFSafariWindow) {
		getCurrentURL(in: window) { url in
			guard let url = url else {
				return
			}
			let urlstring = url.absoluteString
			do {
				let regEx = try NSRegularExpression(pattern: SafariExtensionHandler.pattern, options: NSRegularExpression.Options(rawValue: 0))
				let matches = regEx.matches(in: urlstring, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, urlstring.count))
				if matches.count == 0 {
					return
				}
				let playlistIDRange = matches[0].range(at: 5)
				let start = urlstring.index(urlstring.startIndex, offsetBy: playlistIDRange.location)
				let end = urlstring.index(start, offsetBy: playlistIDRange.length)
				let plaulistUD = urlstring[start..<end]
				if let newURL = URL(string: "https://k2y.herokuapp.com/playlists/\(plaulistUD)") {
					window.openTab(with: newURL, makeActiveIfPossible: true, completionHandler: {_ in})
				}
			} catch {
			}
		}
    }

    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
		getCurrentURL(in: window) { url in
			guard let url = url else {
				validationHandler(false, "")
				return
			}
			let urlstring = url.absoluteString
			do {
				let regEx = try NSRegularExpression(pattern: SafariExtensionHandler.pattern, options: NSRegularExpression.Options(rawValue: 0))
				let matches = regEx.matches(in: urlstring, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, urlstring.count))
				if matches.count > 0 {
					validationHandler(true, "")
					return
				}
				validationHandler(false, "")
			} catch {
				validationHandler(false, "")
			}
		}
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
