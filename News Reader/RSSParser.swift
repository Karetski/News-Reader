//
//  NRRSSParser.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class RSSParser: NSObject, NSXMLParserDelegate {
    var channel = Channel()
    var activeItem: Item?
    var activeElement = ""
    var activeAttributes: [String: String]?
    
    let node_item = "item"
    let node_title = "title"
    let node_link = "link"
    let node_description = "description"
    let node_category = "category"
    let node_creator = "dc:creator"
    let node_pubDate = "pubDate"
    let node_language = "language"
    let node_copyright = "copyright"
    let node_mediaContent = "media:content"
    
    let attr_url = "url"
    let attr_domain = "domain"
    
    var delegate: RSSParserDelegate?
    
    func parseWithURL(url: NSURL) {
        self.parseWithRequest(NSURLRequest(URL: url))
    }
    
    func parseWithRequest(request: NSURLRequest) {
        self.delegate?.parsingWasStarted()
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if error != nil {
                self.delegate?.parsingWasFinished(nil, error: error)
            } else {
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            }
        }).resume()
    }
    
    // MARK: - NSXMLParserDelegate implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.delegate?.parsingWasFinished(self.channel, error: nil)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.delegate?.parsingWasFinished(nil, error: parseError)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            self.activeItem = Item()
        }
        self.activeElement = ""
        self.activeAttributes = attributeDict
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.activeElement += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == self.node_item {
            if let item = self.activeItem {
                self.channel.items.append(item)
            }
            self.activeItem = nil
            return
        }
        if let item = self.activeItem {
            if elementName == self.node_title {
                item.title = self.activeElement
            }
            if elementName == self.node_link {
                item.setLinkWithString(self.activeElement)
            }
            if elementName == self.node_description {
                item.itemDescription = self.activeElement
            }
            if elementName == self.node_category {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_domain] {
                        item.appendCategoryWithName(self.activeElement, stringWithURL: url)
                    }
                }
                self.activeAttributes = nil
            }
            if elementName == self.node_creator {
                item.creator = self.activeElement
            }
            if elementName == self.node_pubDate {
                item.date = self.activeElement
            }
            if elementName == node_mediaContent {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_url] {
                        item.appendMediaWithString(url)
                    }
                }
                self.activeAttributes = nil
            }
        } else {
            if elementName == self.node_title {
                self.channel.title = self.activeElement
            }
            if elementName == self.node_link {
                self.channel.setLinkWithString(self.activeElement)
            }
            if elementName == self.node_description {
                self.channel.channelDescription = self.activeElement
            }
            if elementName == self.node_language {
                self.channel.language = self.activeElement
            }
            if elementName == self.node_copyright {
                self.channel.copyright = self.activeElement
            }
            if elementName == self.node_pubDate {
                self.channel.date = self.activeElement
            }
        }
    }
}
