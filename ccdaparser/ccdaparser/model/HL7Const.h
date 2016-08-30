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


#import <Foundation/Foundation.h>

// Common
extern NSString *const HL7ElementId;
extern NSString *const HL7ElementEffectiveTime;
extern NSString *const HL7ElementTemplateId;
extern NSString *const HL7ElementTitle;
extern NSString *const HL7ElementText;
extern NSString *const HL7ElementAct;
extern NSString *const HL7ElementCode;
extern NSString *const HL7ElementValue;
extern NSString *const HL7ElementOriginalText;
extern NSString *const HL7ElementTranslation;
extern NSString *const HL7ElementLow;
extern NSString *const HL7ElementHigh;

// Attributes
extern NSString *const HL7AttributeId;
extern NSString *const HL7AttributeCode;
extern NSString *const HL7AttributeCodeSystem;
extern NSString *const HL7AttributeCodeSystemName;
extern NSString *const HL7AttributeValue;
extern NSString *const HL7AttributeNullFlavor;
extern NSString *const HL7AttributeUse;
extern NSString *const HL7AttributeRoot;
extern NSString *const HL7AttributeExtension;
extern NSString *const HL7AttributeDisplayName;
extern NSString *const HL7AttributeTypeCode;
extern NSString *const HL7AttributeMediaType;
extern NSString *const HL7AttributeValueType;
extern NSString *const HL7AttributeClassCode;
extern NSString *const HL7AttributeMoodCode;
extern NSString *const HL7AttributeDeterminerCode;
extern NSString *const HL7AttributeInversionInd;
extern NSString *const HL7AttributeXmlns;
extern NSString *const HL7AttributeNegationInd;
extern NSString *const HL7AttributeQualifier;
extern NSString *const HL7AttributeUnit;

// ClinicalDocument
extern NSString *const HL7ElementClinicalDocument;
extern NSString *const HL7ElementClinicalDocumentConfidentialityCode;

// recordTarget
extern NSString *const HL7ElementRecordTarget;
extern NSString *const HL7ElementPatientRole;
extern NSString *const HL7ElementPatient;
extern NSString *const HL7ElementBirthTime;
extern NSString *const HL7ElementAddr;
extern NSString *const HL7ElementStreetAddress;
extern NSString *const HL7ElementCity;
extern NSString *const HL7ElementState;
extern NSString *const HL7ElementPostalCode;
extern NSString *const HL7ElementCountry;
extern NSString *const HL7ElementTelecom;
extern NSString *const HL7ElementName;
extern NSString *const HL7ElementGiven;
extern NSString *const HL7ElementFamily;
extern NSString *const HL7ElementSuffix;
extern NSString *const HL7ElementPrefix;
extern NSString *const HL7ElementAdministrativeGenderCode;
extern NSString *const HL7ElementMaritalStatusCode;
extern NSString *const HL7ElementGuardian;
extern NSString *const HL7ElementGuardianPerson;
extern NSString *const HL7ElementReference;
extern NSString *const HL7ElementEthnicGroupCode;
extern NSString *const HL7ElementRaceCode;
extern NSString *const HL7ElementReligiousAffilition;
extern NSString *const HL7ElementLanguageCommunication;
extern NSString *const HL7ElementLanguageCode;
extern NSString *const HL7ElementModeCode;
extern NSString *const HL7ElementProficiencyLevelCode;
extern NSString *const HL7ElementPreferenceInd;

// medications
extern NSString *const HL7ElementSubstanceAdministration;
extern NSString *const HL7ElementConsumable;
extern NSString *const HL7ElementManufacturedProduct;
extern NSString *const HL7ElementManufacturedMaterial;
extern NSString *const HL7ElementRouteCode;
extern NSString *const HL7ElementDoseQuantity;
extern NSString *const HL7ElementAdministrationUnitCode;

// Time
extern NSString *const HL7ElementEffectiveTimeLow;
extern NSString *const HL7ElementEffectiveTimeHigh;
extern NSString *const HL7ElementTime;
extern NSString *const HL7ElementPeriod;

// documentationOf
extern NSString *const HL7ElementDocumentationOf;

// component
extern NSString *const HL7ElementComponent;
extern NSString *const HL7ElementStructuredBody;
extern NSString *const HL7ElementSection;
extern NSString *const HL7ElementEntry;
extern NSString *const HL7ElementAuthor;
extern NSString *const HL7ElementAssignedAuthor;
extern NSString *const HL7ElementStatusCode;
extern NSString *const HL7ElementParticipant;
extern NSString *const HL7ElementParticipantRole;
extern NSString *const HL7ElementPlayingEntity;
extern NSString *const HL7ElementObservation;
extern NSString *const HL7ElementEntryRelationship;
extern NSString *const HL7ElementInterpretationCode;
extern NSString *const HL7ElementOrganizer;
extern NSString *const HL7ElementReferenceRange;
extern NSString *const HL7ElementObservationRange;
extern NSString *const HL7ElementEncounter;
extern NSString *const HL7ElementProcedure;
extern NSString *const HL7ElementSupply;
extern NSString *const HL7ElementPriorityCode;
extern NSString *const HL7ElementMethodCode;
extern NSString *const HL7ElementTargetSiteCode;

// values

extern NSString *const HL7ValueTypeCodeSubj;
extern NSString *const HL7ValueClassCodeObs;
extern NSString *const HL7ValueTypeCodeMsft;
extern NSString *const HL7ValueTrue;

// templates
extern NSString *const HL7TemplateAllergySectionEntriesRequired;
extern NSString *const HL7TemplateAllergyReactionObservation;
extern NSString *const HL7TemplateAllergyObservation;
extern NSString *const HL7TemplateAnnotationComment;
extern NSString *const HL7TemplateAllergySeverityObservation;
extern NSString *const HL7TemplateAllergyStatusObservation;
extern NSString *const HL7TemplateChiefComplainAndReasonForVisit;
extern NSString *const HL7TemplateSocialHistory;
extern NSString *const HL7TemplateSocialHistoryObservation;
extern NSString *const HL7TemplateSocialHistoryObservationTobaccoUse;
extern NSString *const HL7TemplateSocialHistoryObservationSocialHistory;
extern NSString *const HL7TemplateSocialHistoryObservationSmokingStatus;
extern NSString *const HL7TemplateVitalSignsEntriesRequired;
extern NSString *const HL7TemplateMedications;
extern NSString *const HL7TemplateResultsEntriesRequired;

extern NSString *const HL7TemplatePlanOfCare;
extern NSString *const HL7TemplatePlanOfCareActivityAct;
extern NSString *const HL7templatePlanOfCareActivityEncounter;
extern NSString *const HL7TemplatePlanOfCareActivityObservation;
extern NSString *const HL7TemplatePlanOfCareActivityProcedure;
extern NSString *const HL7TemplatePlanOfCareActivitySibstanceAdministration;
extern NSString *const HL7TemplatePlanOfCareActivitySupply;
extern NSString *const HL7TemplatePatientInstructions;
extern NSString *const HL7TemplateProblems;
extern NSString *const HL7TemplateProblemsAct;
extern NSString *const HL7TemplateProblemsObservation;
extern NSString *const HL7TemplateFunctionalStatusProblemObservation;
extern NSString *const HL7TemplateAgeObservation;
extern NSString *const HL7TemplateHealthStatusObservation;
extern NSString *const HL7TemplateStatusObservation;
extern NSString *const HL7TemplateProcedures;
extern NSString *const HL7TemplateEncounters;
extern NSString *const HL7TemplateEncounterActivity;
extern NSString *const HL7TemplateIndicationObservation;
extern NSString *const HL7TemplateEncounterDiagnosis;
