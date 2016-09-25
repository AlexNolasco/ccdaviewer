# C-CDA Viewer for iOS

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://raw.githubusercontent.com/alexandern/ccdaviewer/master/LICENSE)

C-CDA viewer is an iOS application for viewing C-CDAs on the iPhone or iPad developed as part of the C-CDA Rendering Tool Challenge - HL7.
---

C-CDA viewer for iOS is a native application written in
Objective-C.  It consists of two projects, a C-CDA parser and
a viewer.
The parser extracts what it considers to be “necessary” from
specific sections and maps the information to simpler
objects for the viewer to display.

## How to run
1. Be sure to install Carthage. See https://github.com/Carthage/Carthage
2. git clone this repository
3. cd ccdaviewer
4. run _carthage update_
5. Open XCode and then compile

## Screenshots
![alt text](https://github.com/alexandern/ccdaviewer/blob/master/screenshots/screenshots.png "Screenshot")
                        
## See also
 * [Live demo provided by appetize.io](https://appetize.io/embed/ub13ea2zkuemdb0gg115u5kv78?device=iphone5s&scale=100&autoplay=false&orientation=portrait&deviceColor=white)

 * [C-CDA Rendering Tool Challenge](http://www.hl7.org/events/toolingchallenge.cfm)