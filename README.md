# ccdaviewer for iOS

CCDA viewer is an iOS application for viewing CCDAs on the iPhone or iPad developed as part of the HL7 tool challenge.
---

CCDA viewer for iOS is a native application written in
Objective-C.  It consists of two projects, a CCDA parser and
a viewer.
The parser extracts what it considers to be “necessary” from
specific sections and maps the information to simpler
objects for the viewer to display.

##How to run
1. Be sure to install Carthage. See https://github.com/Carthage/Carthage
2. git clone this repository
3. cd ccdaviewer
4. run _carthage update_
5. Open XCode and then compile

![alt text](https://github.com/alexandern/ccdaviewer/blob/master/screenshots/screen1.png "Screenshot")
            