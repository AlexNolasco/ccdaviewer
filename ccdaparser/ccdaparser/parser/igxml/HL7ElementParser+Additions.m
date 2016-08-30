/********************************************************************************
 * The MIT License (MIT)                                                        *
 *                                                                              *
 * Copyright (C) 2016 Alex Nolasco                                              *
 *                                                                              *
 *Permission is hereby granted, free of charge, to any person obtaining a copy  *
 *of this software and associated documentation files (the "Software"), to deal *
 *in the Software without restriction, including without limitation the rights  *
 *to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     *
 *copies of the Software, and to permit persons to whom the Software is         *
 *furnished to do so, subject to the following conditions:                      *
 *The above copyright notice and this permission notice shall be included in    *
 *all copies or substantial portions of the Software.                           *
 *                                                                              *
 *THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 *IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      *
 *FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   *
 *AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        *
 *LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, *
 *OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     *
 *THE SOFTWARE.                                                                 *
 *********************************************************************************/


#import "HL7ElementParser+Additions.h"
#import "HL7Const.h"
#import "HL7Code.h"
#import "HL7Translation.h"
#import "HL7StatusCode.h"
#import "HL7Addr.h"
#import "HL7Telecom_Private.h"
#import "HL7Name_Private.h"
#import "HL7NamePart_Private.h"
#import "HL7Identifier_Private.h"
#import "HL7Text.h"
#import "HL7EffectiveTime.h"
#import "HL7Value.h"
#import "HL7Time.h"
#import "HL7TemplateId.h"
#import "HL7Author.h"
#import "HL7AssignedAuthor.h"
#import "HL7PlayingEntity.h"
#import "HL7Participant.h"
#import "HL7ParticipantRole.h"
#import "HL7OriginalText.h"
#import "HL7CodeSystem.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7PhysicalQuantityInterval.h"
#import "HL7InterpretationCode.h"
#import "HL7Period.h"
#import "HL7DoseQuantity.h"
#import "HL7CodeSystem_Private.h"
#import "HL7NullFlavorElement_Private.h"
#import "HL7Enums_Private.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ObjectiveSugar.h"

@implementation HL7ElementParser (Additions)

+ (void)fillCodeElement:(HL7CodeSystem *)element withReader:(IGXMLReader *)reader
{
    if ([reader hasAttributes]) {
        [element setCode:[reader attributeWithName:HL7AttributeCode]];
        [element setCodeSystem:[reader attributeWithName:HL7AttributeCodeSystem]];
        [element setCodeSystemName:[reader attributeWithName:HL7AttributeCodeSystemName]];
        [element setDisplayName:[reader attributeWithName:HL7AttributeDisplayName]];
        [element setNullFlavor:[reader attributeWithName:HL7AttributeNullFlavor]];
    }
}

+ (nonnull HL7Translation *)translationFromReader:(nonnull IGXMLReader *)reader
{
    HL7Translation *result = [[HL7Translation alloc] init];

    if ([reader isStartOfElementWithName:HL7ElementTranslation] && [reader hasAttributes]) {
        [self fillCodeElement:result withReader:reader];
    }
    return result;
}

+ (nonnull HL7Code *)codeFromReader:(nonnull IGXMLReader *)reader withElementName:(nonnull NSString *)name withBlock:(void (^_Nullable)(IGXMLReader *_Nonnull))blk
{
    __block HL7Code *result = [HL7Code new];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:name
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:name] && [reader hasAttributes]) {
                           [self fillCodeElement:result withReader:reader];
                       } else if ([node isStartOfElementWithName:HL7ElementTranslation]) {
                           [[result translations] addObject:[self translationFromReader:reader]];
                       } else if ([node isStartOfElementWithName:HL7ElementOriginalText]) {
                           [result setOriginalTextElement:[self originalTextFromReader:reader]];
                       } else if (blk != nil && ([node type] == IGXMLReaderNodeTypeElement || [node type] == IGXMLReaderNodeTypeText)) {
                           blk(reader);
                       }
                   }];
    return result;
}

+ (nonnull HL7CodeSystem *)codeSystemFromReader:(nonnull IGXMLReader *)reader withElementName:(nonnull NSString *)name
{
    __block HL7CodeSystem *result = [HL7CodeSystem new];
    [HL7ElementParser iterate:reader
        untilEndOfElementName:name
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:name] && [reader hasAttributes]) {
                           [self fillCodeElement:result withReader:reader];
                       }
                   }];
    return result;
}

+ (nonnull HL7Code *)codeFromReader:(nonnull IGXMLReader *)reader withElementName:(nonnull NSString *)name
{
    return [self codeFromReader:reader withElementName:name withBlock:nil];
}

+ (HL7Code *)codeFromReader:(IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementCode];
}

+ (nonnull HL7Code *)routeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementRouteCode];
}

+ (nonnull HL7Code *)administrationUnitCodeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementAdministrationUnitCode];
}

+ (nonnull HL7Code *)targetSiteCodeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementTargetSiteCode];
}

+ (nonnull HL7Code *)priorityCodeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementPriorityCode];
}

+ (nonnull HL7Code *)methodCodeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementMethodCode];
}

+ (nonnull HL7Code *)confidentialityCodeFromReader:(nonnull IGXMLReader *)reader
{
    return [self codeFromReader:reader withElementName:HL7ElementClinicalDocumentConfidentialityCode];
}

+ (nonnull HL7DoseQuantity *)doseFromCodeReader:(nonnull IGXMLReader *)reader
{
    HL7DoseQuantity *result = [[HL7DoseQuantity alloc] init];
    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementDoseQuantity
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementDoseQuantity] && [node hasAttributes]) {
                           [result setValue:[node attributeWithName:HL7AttributeValue]];
                           [result setUnit:[node attributeWithName:HL7AttributeUnit]];
                       }
                   }];
    return result;
}

+ (HL7InterpretationCode *)interpretationCodeFromReader:(nonnull IGXMLReader *)reader
{
    HL7Code *code = [self codeFromReader:reader withElementName:HL7ElementInterpretationCode];
    HL7InterpretationCode *result = [[HL7InterpretationCode alloc] initWithCodeSystem:(HL7CodeSystem *)code];
    return result;
}

+ (nonnull HL7StatusCode *)statusCodeFromReader:(nonnull IGXMLReader *)reader
{
    HL7StatusCode *result = [[HL7StatusCode alloc] init];
    if ([reader isStartOfElementWithName:HL7ElementStatusCode] && [reader hasAttributes]) {
        [result setCode:[[reader attributeWithName:HL7AttributeCode] copy]];
    }
    return result;
}

+ (nonnull HL7PhysicalQuantityInterval *)physicalQuantityIntervalFromReader:(nonnull IGXMLReader *)reader
{
    HL7PhysicalQuantityInterval *result = [[HL7PhysicalQuantityInterval alloc] init];
    [result setValue:[[reader attributeWithName:HL7AttributeValue] copy]];
    [result setUnit:[[reader attributeWithName:HL7AttributeUnit] copy]];
    return result;
}

+ (nonnull HL7Value *)valueFromReader:(nonnull IGXMLReader *)reader
{
    __block HL7PhysicalQuantityInterval *low;
    __block HL7PhysicalQuantityInterval *high;
    __block NSString *text;
    NSString *type = [[reader attributes] objectForKey:HL7AttributeValueType];

    HL7Code *code = [self codeFromReader:reader
                         withElementName:HL7ElementValue
                               withBlock:^(IGXMLReader *_Nonnull vReader) {
                                   if ([vReader isStartOfElementWithName:HL7ElementLow]) {
                                       low = [self physicalQuantityIntervalFromReader:vReader];
                                   } else if ([vReader isStartOfElementWithName:HL7ElementHigh]) {
                                       high = [self physicalQuantityIntervalFromReader:vReader];
                                   } else if ([vReader type] == IGXMLReaderNodeTypeText) {
                                       text = [[vReader text] copy];
                                   }
                               }];
    HL7Value *result = [[HL7Value alloc] initWithCode:code];

    if ([type length]) {
        [result setType:[type copy]];
    }
    [result setValue:[[reader attributeWithName:HL7AttributeValue] copy]];
    [result setUnit:[[reader attributeWithName:HL7AttributeUnit] copy]];
    [result setLow:low];
    [result setHigh:high];
    [result setText:text];
    return result;
}

//+ (HL7Use)useFromString:(NSString *)use
//{
//    if ([use length]) {
//        if ([use isEqualToString:HL7ValueUseAddressHome]) {
//            return HL7UseHome;
//        } else if ([use isEqualToString:HL7ValueUseWorkPlace]) {
//            return HL7UseWorkPlace;
//        } else if ([use isEqualToString:HL7ValueUsePrimaryHome]) {
//            return HL7UsePrimaryHome;
//        } else if ([use isEqualToString:HL7ValueUseBadAddress]) {
//            return HL7UseBadAddress;
//        } else if ([use isEqualToString:HL7ValueUseBirthPlace]) {
//            return HL7UseBirthPlace;
//        }
//    }
//    return HL7UseUnknown;
//}

//+ (nonnull NSSet<NSNumber *>*)nameUsesFromString:(NSString *)use:(nullable NSString *)use
//{
//    NSMutableArray <NSNumber *>* result = [[NSMutableArray alloc] initWithCapacity:3];
//
//    for (NSString * useToken in [use componentsSeparatedByString:@" "])
//    {
//        NSNumber * number = [NSNumber numberWithInteger:[self useFromString:useToken]];
//        [result addObject:number];
//    }
//    return [result copy];
//}

+ (HL7Addr *)addrFromReader:(IGXMLReader *)reader
{

    HL7Addr *addr = [[HL7Addr alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementAddr
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementAddr]) {
                           [addr setUses:[node attributeWithName:HL7AttributeUse]];
                           [addr setNullFlavor:[node attributeWithName:HL7AttributeNullFlavor]];
                       } else if ([node isStartOfElementWithName:HL7ElementStreetAddress]) {
                           NSString *text = [node text];
                           if (text != nil) {
                               [[addr streetAddressLines] addObject:[node text]];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementCity]) {
                           [addr setCity:[node text]];
                       } else if ([node isStartOfElementWithName:HL7ElementState]) {
                           [addr setState:[node text]];
                       } else if ([node isStartOfElementWithName:HL7ElementCountry]) {
                           [addr setCountry:[node text]];
                       }
                   }];
    return addr;
}

+ (HL7Telecom *)telecomFromReader:(IGXMLReader *)reader
{
    HL7Telecom *result = [[HL7Telecom alloc] init];
    if ([reader hasAttributes]) {
        [result setNullFlavor:[reader attributeWithName:HL7AttributeNullFlavor]];
        [result setUses:[reader attributeWithName:HL7AttributeUse]];
        [result setValue:[reader attributeWithName:HL7AttributeValue]];
    }
    return result;
}

+ (HL7Name *)nameFromReader:(IGXMLReader *)reader
{
    HL7Name *result = [[HL7Name alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementName
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementName]) {
                           NSString *text = [node text];
                           if ([text length]) {
                               [result setName:[text copy]];
                           }
                           if ([node hasAttributes]) {
                               [result setUse:[node attributeWithName:HL7AttributeUse]];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementGiven]) {
                           NSString *text = [node text];
                           if ([text length]) {
                               HL7NamePart *namePart = [[HL7NamePart alloc] initWithText:text];
                               if ([node hasAttributes]) {
                                   [namePart setQualifier:[[node attributeWithName:HL7AttributeQualifier] copy]];
                               }
                               [[result given] addObject:namePart];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementFamily]) {
                           NSString *text = [node text];
                           if ([text length]) {

                               HL7NamePart *namePart = [[HL7NamePart alloc] initWithText:text];
                               if ([node hasAttributes]) {
                                   [namePart setQualifier:[[node attributeWithName:HL7AttributeQualifier] copy]];
                               }
                               [[result family] addObject:namePart];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementTitle]) {
                           [result setTitle:[[node text] copy]];
                       } else if ([node isStartOfElementWithName:HL7ElementSuffix]) {
                           [result setSuffix:[[node text] copy]];
                       } else if ([node isStartOfElementWithName:HL7ElementPrefix]) {
                           [result setPrefix:[[node text] copy]];
                       }
                   }];
    return result;
}

+ (HL7Identifier *)identifierFromReader:(IGXMLReader *)reader
{
    HL7Identifier *result = [[HL7Identifier alloc] init];
    if ([reader hasAttributes]) {
        [result setRoot:[reader attributeWithName:HL7AttributeRoot]];
        [result setExtension:[reader attributeWithName:HL7AttributeExtension]];
    }
    return result;
}

+ (nonnull HL7TemplateId *)templateIdFromReader:(nonnull IGXMLReader *)reader
{
    HL7Identifier *identifier = [self identifierFromReader:reader];
    HL7TemplateId *result = [[HL7TemplateId alloc] initWithIdentifier:identifier];
    return result;
}

+ (HL7Text *)textFromReader:(nonnull IGXMLReader *)reader
{
    __block HL7Text *text = [[HL7Text alloc] init];
    __block BOOL textSet = NO;
    __block NSUInteger elementsFound = 0;

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementText
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {

                       if (!textSet) {
                           if ([reader isStartOfElementWithName:HL7ElementText]) {
                               if (![node isEmpty]) {
                                   NSString *innerXml = [[node innerXML] strip];
                                   if ([innerXml length]) {
                                       [[text innerXML] setString:[innerXml copy]];
                                       textSet = YES;
                                   }
                                   [[text text] setString:[[[node text] strip] copy]];
                               }
                           }
                           if ([node hasAttributes]) {
                               NSString *mediaType = [node attributeWithName:HL7AttributeMediaType];
                               if ([mediaType length]) {
                                   [text setMediaType:[mediaType copy]];
                               }
                           }
                       }

                       // reference
                       if ([reader isStartOfElementWithName:HL7ElementReference]) {
                           [text addReferenceWithValue:[node attributeWithName:HL7AttributeValue]];

                       } else if ([node type] == IGXMLReaderNodeTypeElement) {

                           if (![reader isStartOfElementWithName:HL7ElementText]) {
                               if ([[node attributeWithName:HL7AttributeId] length]) {
                                   [text addValue:[node text] forIdentifier:[node attributeWithName:HL7AttributeId]];
                               }
                               elementsFound += 1;
                           }
                       }
                   }];
    if ([[text references] count] > 0) {
        [text setIsHtml:NO];
    } else if (elementsFound > 0) {
        [text setIsHtml:YES];
    }

    return text;
}

+ (nonnull HL7EffectiveTime *)effectiveTimeFromReader:(nonnull IGXMLReader *)reader
{
    HL7EffectiveTime *effectiveTime = [[HL7EffectiveTime alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementEffectiveTime
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementEffectiveTime] && [node hasAttributes]) {
                           [effectiveTime setValue:[[node attributeWithName:HL7AttributeValue] copy]];
                           [effectiveTime setType:[[reader attributes] objectForKey:HL7AttributeValueType]]; // nocopy
                       }

                       if ([node isStartOfElementWithName:HL7ElementEffectiveTimeLow]) {
                           if ([node hasAttributes]) {
                               [[effectiveTime low] setValue:[node attributeWithName:HL7AttributeValue]];
                               [[effectiveTime low] setNullFlavor:[node attributeWithName:HL7AttributeNullFlavor]];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementEffectiveTimeHigh]) {
                           if ([node hasAttributes]) {
                               [[effectiveTime high] setValue:[node attributeWithName:HL7AttributeValue]];
                               [[effectiveTime high] setNullFlavor:[node attributeWithName:HL7AttributeNullFlavor]];
                           }
                       } else if ([node isStartOfElementWithName:HL7ElementPeriod]) {
                           if ([node hasAttributes]) {
                               HL7Period *period = [[HL7Period alloc] initWithValue:[node attributeWithName:HL7AttributeValue] unit:[node attributeWithName:HL7AttributeUnit]];
                               [effectiveTime setPeriod:period];
                           }
                       }
                   }];

    return effectiveTime;
}

+ (nonnull HL7Time *)timeFromReader:(nonnull IGXMLReader *)reader
{

    HL7Time *hl7Time = [[HL7Time alloc] init];

    if ([reader hasAttributes]) {
        [hl7Time setValue:[reader attributeWithName:HL7AttributeValue]];
        [hl7Time setNullFlavor:[reader attributeWithName:HL7AttributeNullFlavor]];
    }
    return hl7Time;
}

+ (nonnull HL7Author *)authorFromReader:(nonnull IGXMLReader *)reader
{
    HL7Author *result = [[HL7Author alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementAuthor
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementAuthor]) {
                           [result setTypeCode:[reader attributeWithName:HL7AttributeTypeCode]];
                       } else if ([node isStartOfElementWithName:HL7ElementTemplateId]) {
                           [result setTemplateId:[self templateIdFromReader:reader]];
                       } else if ([node isStartOfElementWithName:HL7ElementTime]) {
                           [result setTime:[self timeFromReader:reader]];
                       } else if ([node isStartOfElementWithName:HL7ElementAssignedAuthor]) {
                           [HL7ElementParser iterate:reader
                               untilEndOfElementName:HL7ElementAssignedAuthor
                                          usingBlock:^(IGXMLReader *node, BOOL *stop) {
                                              if ([node isStartOfElementWithName:HL7ElementId]) {
                                                  [[result assignedAuthor] setIdentifier:[self identifierFromReader:reader]];
                                              } else if ([node isStartOfElementWithName:HL7ElementCode]) {
                                                  [[result assignedAuthor] setCode:[self codeFromReader:reader]];
                                              }
                                          }];
                       }
                   }];
    return result;
}

+ (nonnull HL7PlayingEntity *)playingEntityFromReader:(nonnull IGXMLReader *)reader
{
    HL7PlayingEntity *result = [[HL7PlayingEntity alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementPlayingEntity
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementPlayingEntity]) {
                           [result setClassCode:[reader attributeWithName:HL7AttributeClassCode]];
                           [result setDeterminerCode:[reader attributeWithName:HL7AttributeDeterminerCode]];
                       } else if ([node isStartOfElementWithName:HL7ElementCode]) {
                           [result setCode:[self codeFromReader:reader]];
                       } else if ([node isStartOfElementWithName:HL7ElementName]) {
                           [result setName:[self nameFromReader:reader]];
                       }
                   }];
    return result;
}

+ (nonnull HL7Participant *)participantFromReader:(nonnull IGXMLReader *)reader
{
    HL7Participant *result = [[HL7Participant alloc] init];
    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementParticipant
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementParticipant] && [node hasAttributes]) {
                           [result setTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
                       } else if ([node isStartOfElementWithName:HL7ElementTemplateId]) {
                           [[result templateIds] addObject:[self templateIdFromReader:reader]];
                       } else if ([node isStartOfElementWithName:HL7ElementParticipantRole]) {

                           // participantRole
                           HL7ParticipantRole *participantRole = [[HL7ParticipantRole alloc] init];
                           [result setParticipantRole:participantRole];

                           [HL7ElementParser iterate:reader
                               untilEndOfElementName:HL7ElementParticipantRole
                                          usingBlock:^(IGXMLReader *node, BOOL *stop) {
                                              if ([node isStartOfElementWithName:HL7ElementParticipantRole]) {
                                                  [participantRole setClassCode:[node attributeWithName:HL7AttributeClassCode]];
                                              } else if ([node isStartOfElementWithName:HL7ElementAddr]) {
                                                  [[participantRole addresses] addObject:[self addrFromReader:reader]];
                                              } else if ([node isStartOfElementWithName:HL7ElementTelecom]) {
                                                  [[participantRole telecoms] addObject:[self telecomFromReader:reader]];
                                              } else if ([node isStartOfElementWithName:HL7ElementPlayingEntity]) {

                                                  // playing entity
                                                  HL7PlayingEntity *playingEntity = [[HL7PlayingEntity alloc] init];
                                                  [participantRole setPlayingEntity:playingEntity];

                                                  [playingEntity setClassCode:[node attributeWithName:HL7AttributeClassCode]];
                                                  [playingEntity setDeterminerCode:[node attributeWithName:HL7AttributeDeterminerCode]];
                                                  [HL7ElementParser iterate:reader
                                                      untilEndOfElementName:HL7ElementPlayingEntity
                                                                 usingBlock:^(IGXMLReader *node, BOOL *stop) {
                                                                     if ([node isStartOfElementWithName:HL7ElementCode]) {
                                                                         [playingEntity setCode:[self codeFromReader:reader]];
                                                                     } else if ([node isStartOfElementWithName:HL7ElementName]) {
                                                                         [playingEntity setName:[self nameFromReader:reader]];
                                                                     }
                                                                 }];
                                              }
                                          }];
                       }
                   }];
    return result;
}

+ (nonnull HL7OriginalText *)originalTextFromReader:(nonnull IGXMLReader *)reader
{
    HL7OriginalText *result = [[HL7OriginalText alloc] init];

    [HL7ElementParser iterate:reader
        untilEndOfElementName:HL7ElementOriginalText
                   usingBlock:^(IGXMLReader *node, BOOL *stop) {
                       if ([node isStartOfElementWithName:HL7ElementReference]) {
                           if ([node hasAttributes]) {
                               [result setReferenceValue:[[node attributeWithName:HL7AttributeValue] copy]];
                           }
                           [result setText:[[node text] copy]];
                       }
                   }];
    return result;
}
@end
