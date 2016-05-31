//
//  IGXMLReader.h
//  IGXMLReader
//
//  Created by Chan Fai Chong on 8/2/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IGXMLReaderNodeType) { IGXMLReaderNodeTypeNone = 0, IGXMLReaderNodeTypeElement = 1, IGXMLReaderNodeTypeAttribute = 2, IGXMLReaderNodeTypeText = 3, IGXMLReaderNodeTypeCDATA = 4, IGXMLReaderNodeTypeEntityReference = 5, IGXMLReaderNodeTypeEntity = 6, IGXMLReaderNodeTypeProcessingInstruction = 7, IGXMLReaderNodeTypeComment = 8, IGXMLReaderNodeTypeDocument = 9, IGXMLReaderNodeTypeDocumentType = 10, IGXMLReaderNodeTypeDocumentFragment = 11, IGXMLReaderNodeTypeNotation = 12, IGXMLReaderNodeTypeWhitespace = 13, IGXMLReaderNodeTypeSignificantWhitespace = 14, IGXMLReaderNodeTypeEndElement = 15, IGXMLReaderNodeTypeEndEntity = 16, IGXMLReaderNodeTypeXmlDeclaration = 17 };

extern NSString *const IGXMLReaderErrorDomain;

/**
 * The IGXMLReader parser allows you to effectively pull parse an XML document.
 * Once instantiated, call #nextObject to iterate over each node. Note that you may only iterate over the document once!
 */
@interface IGXMLReader : NSEnumerator

- (instancetype)initWithXMLString:(NSString *)XMLString;

- (instancetype)initWithXMLString:(NSString *)XMLString URL:(NSURL *)URL;

- (instancetype)initWithXMLData:(NSData *)data URL:(NSURL *)URL encoding:(NSString *)encoding;

- (instancetype)initWithXMLData:(NSData *)data URL:(NSURL *)URL encoding:(NSString *)encoding options:(int)options;

- (instancetype)nextObject;

/**
 * @return errors occurred
 */
- (NSArray *)errors;

/**
 * @return last errors occurred
 */
- (NSError *)lastError;

@end

@interface IGXMLReader (Node)

/**
 * @return name of current node.
 */
- (NSString *)name;

/**
 * @param name name of attribute
 * @return value of attribute with specified name, of current element. or nil if not an element.
 */
- (NSString *)attributeWithName:(NSString *)name;

/**
 * @param index number of index
 * @return value of n-th attribute of current element, or nil if not an element.
 */
- (NSString *)attributeAtIndex:(NSUInteger)index;

/**
 * @return number of attributes of current element, or 0 if not an element.
 */
- (NSInteger)attributeCount;

/**
 * @return attributes of current element. If current node is not an element, returns an empty Dictionary.
 */
- (NSDictionary *)attributes;

/**
 * @return Type of current node.
 */
- (IGXMLReaderNodeType)type;

/**
 * @return Type of current node, as string.
 */
- (NSString *)typeDescription;

/**
 * @return the text value of the node if present
 */
- (NSString *)value;

/**
 * @return The depth of the node in the tree.
 */
- (NSInteger)depth;

/**
 * @return the contents of child nodes and markup.
 */
- (NSString *)innerXML;

/**
 * @return the contents of the current node, including child nodes and markup.
 */
- (NSString *)outerXML;

/**
 * @return the contents of an element or a text node as a string.
 */
- (NSString *)text;

/**
 * @return return YES if this is an empty (self-closing) element. return NO if this is not an element, or not an empty element.
 */
- (BOOL)isEmpty;

/**
 * @return YES if this node has value.
 */
- (BOOL)hasValue;

/**
 * @return YES if this node has attributes.
 */
- (BOOL)hasAttributes;

@end