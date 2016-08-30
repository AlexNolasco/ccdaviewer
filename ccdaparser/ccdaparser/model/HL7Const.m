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


#import "HL7Const.h"

// Common
NSString *const HL7ElementId = @"id";
NSString *const HL7ElementEffectiveTime = @"effectiveTime";
NSString *const HL7ElementTemplateId = @"templateId";
NSString *const HL7ElementTitle = @"title";
NSString *const HL7ElementText = @"text";
NSString *const HL7ElementAct = @"act";
NSString *const HL7ElementCode = @"code";
NSString *const HL7ElementValue = @"value";
NSString *const HL7ElementOriginalText = @"originalText";
NSString *const HL7ElementTranslation = @"translation";
NSString *const HL7ElementLow = @"low";
NSString *const HL7ElementHigh = @"high";

// Attributes
NSString *const HL7AttributeId = @"ID";
NSString *const HL7AttributeCode = @"code";
NSString *const HL7AttributeCodeSystem = @"codeSystem";
NSString *const HL7AttributeCodeSystemName = @"codeSystemName";
NSString *const HL7AttributeValue = @"value";
NSString *const HL7AttributeNullFlavor = @"nullFlavor";
NSString *const HL7AttributeUse = @"use";
NSString *const HL7AttributeRoot = @"root";
NSString *const HL7AttributeExtension = @"extension";
NSString *const HL7AttributeDisplayName = @"displayName";
NSString *const HL7AttributeTypeCode = @"typeCode";
NSString *const HL7AttributeMediaType = @"mediaType";
NSString *const HL7AttributeValueType = @"xsi:type";
NSString *const HL7AttributeClassCode = @"classCode";
NSString *const HL7AttributeMoodCode = @"moodCode";
NSString *const HL7AttributeDeterminerCode = @"determinerCode";
NSString *const HL7AttributeInversionInd = @"inversionInd";
NSString *const HL7AttributeXmlns = @"xmlns";
NSString *const HL7AttributeNegationInd = @"negationInd";
NSString *const HL7AttributeQualifier = @"qualifier";
NSString *const HL7AttributeUnit = @"unit";

// ClinicalDocument
NSString *const HL7ElementClinicalDocument = @"ClinicalDocument";
NSString *const HL7ElementClinicalDocumentConfidentialityCode = @"confidentialityCode";

// recordTarget
NSString *const HL7ElementRecordTarget = @"recordTarget";
NSString *const HL7ElementPatientRole = @"patientRole";
NSString *const HL7ElementPatient = @"patient";
NSString *const HL7ElementBirthTime = @"birthTime";
NSString *const HL7ElementAddr = @"addr";
NSString *const HL7ElementStreetAddress = @"streetAddressLine";
NSString *const HL7ElementCity = @"city";
NSString *const HL7ElementState = @"state";
NSString *const HL7ElementPostalCode = @"postalCode";
NSString *const HL7ElementCountry = @"country";
NSString *const HL7ElementTelecom = @"telecom";
NSString *const HL7ElementName = @"name";
NSString *const HL7ElementGiven = @"given";
NSString *const HL7ElementFamily = @"family";
NSString *const HL7ElementSuffix = @"suffix";
NSString *const HL7ElementPrefix = @"prefix";
NSString *const HL7ElementAdministrativeGenderCode = @"administrativeGenderCode";
NSString *const HL7ElementMaritalStatusCode = @"maritalStatusCode";
NSString *const HL7ElementGuardian = @"guardian";
NSString *const HL7ElementGuardianPerson = @"guardianPerson";
NSString *const HL7ElementReference = @"reference";
NSString *const HL7ElementEthnicGroupCode = @"ethnicGroupCode";
NSString *const HL7ElementRaceCode = @"raceCode";
NSString *const HL7ElementReligiousAffilition = @"religiousAffiliationCode";
NSString *const HL7ElementLanguageCommunication = @"languageCommunication";
NSString *const HL7ElementLanguageCode = @"languageCode";
NSString *const HL7ElementModeCode = @"modeCode";
NSString *const HL7ElementProficiencyLevelCode = @"proficiencyLevelCode";
NSString *const HL7ElementPreferenceInd = @"preferenceInd";

// medications
NSString *const HL7ElementSubstanceAdministration = @"substanceAdministration";
NSString *const HL7ElementConsumable = @"consumable";
NSString *const HL7ElementManufacturedProduct = @"manufacturedProduct";
NSString *const HL7ElementManufacturedMaterial = @"manufacturedMaterial";
NSString *const HL7ElementRouteCode = @"routeCode";
NSString *const HL7ElementDoseQuantity = @"doseQuantity";
NSString *const HL7ElementAdministrationUnitCode = @"administrationUnitCode";

// Time
NSString *const HL7ElementEffectiveTimeLow = @"low";
NSString *const HL7ElementEffectiveTimeHigh = @"high";
NSString *const HL7ElementTime = @"time";
NSString *const HL7ElementPeriod = @"period";

// documentationOf
NSString *const HL7ElementDocumentationOf = @"documentationOf";

// component
NSString *const HL7ElementComponent = @"component";
NSString *const HL7ElementStructuredBody = @"structuredBody";
NSString *const HL7ElementSection = @"section";
NSString *const HL7ElementEntry = @"entry";
NSString *const HL7ElementAuthor = @"author";
NSString *const HL7ElementAssignedAuthor = @"assignedAuthor";
NSString *const HL7ElementStatusCode = @"statusCode";
NSString *const HL7ElementParticipant = @"participant";
NSString *const HL7ElementParticipantRole = @"participantRole";
NSString *const HL7ElementPlayingEntity = @"playingEntity";
NSString *const HL7ElementObservation = @"observation";
NSString *const HL7ElementEntryRelationship = @"entryRelationship";
NSString *const HL7ElementInterpretationCode = @"interpretationCode";
NSString *const HL7ElementOrganizer = @"organizer";
NSString *const HL7ElementReferenceRange = @"referenceRange";
NSString *const HL7ElementObservationRange = @"observationRange";
NSString *const HL7ElementEncounter = @"encounter";
NSString *const HL7ElementProcedure = @"procedure";
NSString *const HL7ElementSupply = @"supply";
NSString *const HL7ElementPriorityCode = @"priorityCode";
NSString *const HL7ElementMethodCode = @"methodCode";
NSString *const HL7ElementTargetSiteCode = @"targetSiteCode";

// values
NSString *const HL7ValueTypeCodeSubj = @"SUBJ";
NSString *const HL7ValueClassCodeObs = @"OBS";
NSString *const HL7ValueTypeCodeMsft = @"MSFT";
NSString *const HL7ValueTrue = @"true";

// templates
NSString *const HL7TemplateAnnotationComment = @"2.16.840.1.113883.10.20.1.40";
NSString *const HL7TemplateAllergySectionEntriesRequired = @"2.16.840.1.113883.10.20.22.2.6.1";
NSString *const HL7TemplateAllergyObservation = @"2.16.840.1.113883.10.20.22.4.7";
NSString *const HL7TemplateAllergyReactionObservation = @"2.16.840.1.113883.10.20.22.4.9";
NSString *const HL7TemplateAllergySeverityObservation = @"2.16.840.1.113883.10.20.22.4.8";
NSString *const HL7TemplateAllergyStatusObservation = @"2.16.840.1.113883.10.20.22.4.28";
NSString *const HL7TemplateChiefComplainAndReasonForVisit = @"2.16.840.1.113883.10.20.22.2.13";
NSString *const HL7TemplateSocialHistory = @"2.16.840.1.113883.10.20.22.2.17";
NSString *const HL7TemplateSocialHistoryObservation = @"2.16.840.1.113883.10.20.22.4.38";
NSString *const HL7TemplateSocialHistoryObservationTobaccoUse = @"2.16.840.1.113883.10.20.22.4.85";
NSString *const HL7TemplateSocialHistoryObservationSocialHistory = @"2.16.840.1.113883.10.20.22.4.38";
NSString *const HL7TemplateSocialHistoryObservationSmokingStatus = @"2.16.840.1.113883.10.20.22.4.78";
NSString *const HL7TemplateVitalSignsEntriesRequired = @"2.16.840.1.113883.10.20.22.2.4.1";
NSString *const HL7TemplateMedications = @"2.16.840.1.113883.10.20.22.2.1.1";
NSString *const HL7TemplateResultsEntriesRequired = @"2.16.840.1.113883.10.20.22.2.3.1";

NSString *const HL7TemplatePlanOfCare = @"2.16.840.1.113883.10.20.22.2.10";
NSString *const HL7TemplatePlanOfCareActivityAct = @"2.16.840.1.113883.10.20.22.4.39";
NSString *const HL7templatePlanOfCareActivityEncounter = @"2.16.840.1.113883.10.20.22.4.40";
NSString *const HL7TemplatePlanOfCareActivityObservation = @"2.16.840.1.113883.10.20.22.4.44";
NSString *const HL7TemplatePlanOfCareActivityProcedure = @"2.16.840.1.113883.10.20.22.4.41";
NSString *const HL7TemplatePlanOfCareActivitySibstanceAdministration = @"2.16.840.1.113883.10.20.22.4.42";
NSString *const HL7TemplatePlanOfCareActivitySupply = @"2.16.840.1.113883.10.20.22.4.43";
NSString *const HL7TemplatePatientInstructions = @"2.16.840.1.113883.10.20.22.2.45";
NSString *const HL7TemplateProblems = @"2.16.840.1.113883.10.20.22.2.5.1";
NSString *const HL7TemplateProblemsAct = @"2.16.840.1.113883.10.20.22.4.3";
NSString *const HL7TemplateProblemsObservation = @"2.16.840.1.113883.10.20.22.4.4";
NSString *const HL7TemplateFunctionalStatusProblemObservation = @"2.16.840.1.113883.10.20.22.4.68";
NSString *const HL7TemplateAgeObservation = @"2.16.840.1.113883.10.20.22.4.31";
NSString *const HL7TemplateHealthStatusObservation = @"2.16.840.1.113883.10.20.22.4.5";
NSString *const HL7TemplateStatusObservation = @"2.16.840.1.113883.10.20.22.4.6";
NSString *const HL7TemplateProcedures = @"2.16.840.1.113883.10.20.22.2.7.1";
NSString *const HL7TemplateEncounters = @"2.16.840.1.113883.10.20.22.2.22.1";
NSString *const HL7TemplateEncounterActivity = @"2.16.840.1.113883.10.20.22.4.49";
NSString *const HL7TemplateIndicationObservation = @"2.16.840.1.113883.10.20.22.4.19";
NSString *const HL7TemplateEncounterDiagnosis = @"2.16.840.1.113883.10.20.22.4.80";
