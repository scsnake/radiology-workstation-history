/* 
scsnake@gmail.com 
scsnake @ ptt & ptt2
*/


#SingleInstance,ignore
#NoEnv
#include ../portalLib/portalLib.ahk
#Include ../com.ahk


coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; setting

;~ while !loginId
   ;~ inputbox,loginId,Portal login ID
;~ while !loginPw
   ;~ inputbox,loginPw,Portal login password
askForPortalIdPw()
;~ tabs1:=["__tab_caseTab_caseTabPerson","__tab_caseTab_caseTabEvent","__tab_caseTab_caseTabAviso","__tab_caseTab_caseTabImmediate","__tab_caseTab_caseTabPrevent","__tab_caseTab_caseTabRehappen","__tab_caseTab_caseTabImprove"]

tabs2:=["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabSurgery","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabFalldown","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabDrug","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabBlood","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabTreatment","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAccident","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabSecurity","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabHurt","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabIntubate","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabHeart","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabInspect","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAnesthesia","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAdmin","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabChemotherapyLeak","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabChemotherapyOver","__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabOther"]

;~ textarea:=["t$QPerson$Diagnosis","t$QSurgery$SurgeryName","t$QSurgery$Desc","t$QFalldown$Desc","t$QDrug$Desc","t$QBlood$Desc","t$QTreatment$Desc","t$QAccident$Desc","t$QSecurity$Desc","t$QHurt$Desc","t$QIntubate$Desc","t$QHeart$Desc","t$QInspect$Desc","t$QAnesthesia$Desc","t$QAdmin$Desc","t$QChemotherapyLeak$PatientSize","t$QChemotherapyLeak$PatientSense","t$QChemotherapyLeak$Desc","t$QChemotherapyOver$PlaceRegion","t$QChemotherapyOver$Desc","t$QOther$Desc","t$QImmediate$OtherDispose","t$QImprove$ImproveDesc","t$QImprove$BossComment","t$QImprove$SubChiefComment","t$QImprove$ChiefComment"]

;~ select:=["s$QPerson$HappenTime","s$QPerson$AgeUnit","s$QAviso$NurseBoss","s$QAviso$NurseSubChief","s$QAviso$AgentSubChief","s$QAviso$NurseChief"]

tabs:=[]
tabs["__tab_caseTab_caseTabPerson"]:=array("txbHappenDate","txbHappenHour","txbHappenMin","txbPersonName","rdoPersonGrender_0","rdoPersonGrender_1","txbPersonAge","rdoPersonMarital_0","rdoPersonMarital_1","txbPersonId","txbTreatmentDate","txbBedNo","rdoPersonIsPersonAttendee_0","rdoPersonIsPersonAttendee_1","rdoPersonIsAttendee_0","rdoPersonIsAttendee_1","txbEventDept","btnEventDept","chkPersonRole_0","chkPersonRole_1","chkPersonRole_2","chkPersonRole_3","chkPersonRole_4","txbPersonRole_4","rdoPersonSickRoomType_0","rdoPersonSickRoomType_1","rdoPersonSickRoomType_2","rdoPersonSickRoomType_3","rdoPersonSickRoomType_4","txbPersonSickRoomType_4","rdoPersonEmpType_0","rdoPersonEmpType_1","rdoPersonEmpType_2","rdoPersonEmpType_3","rdoPersonEmpType_4","chkPersonEventVenue_0","chkPersonEventVenue_1","chkPersonEventVenue_2","chkPersonEventVenue_3","chkPersonEventVenue_4","chkPersonEventVenue_5","chkPersonEventVenue_6","chkPersonEventVenue_7","chkPersonEventVenue_8","chkPersonEventVenue_9","chkPersonEventVenue_10","chkPersonPoliclinic_0","chkPersonPoliclinic_1","chkPersonPoliclinic_2","chkPersonPoliclinic_3","txbPersonPoliclinic_3","chkPersonPublicPlace_0","chkPersonPublicPlace_1","chkPersonPublicPlace_2","chkPersonPublicPlace_3","chkPersonPublicPlace_4","txbPersonPublicPlace_4","txbPersonPublicPlace_5","chkPersonInspectRoom_0","chkPersonInspectRoom_1","chkPersonInspectRoom_2","chkPersonInspectRoom_3","chkPersonInspectRoom_4","chkPersonInspectRoom_5","chkPersonInspectRoom_6","chkPersonInspectRoom_7","chkPersonInspectRoom_8","chkPersonInspectRoom_9","chkPersonInspectRoom_10","chkPersonInspectRoom_11","txbPersonInspectRoom_11","chkPersonCareArea_0","chkPersonCareArea_1","chkPersonCareArea_2","chkPersonCareArea_3","chkPersonCareArea_4","chkPersonCareArea_5","chkPersonCareArea_6","chkPersonCareArea_7","chkPersonCareArea_8","chkPersonCareArea_9","txbPersonCareArea_9","chkPersonVenueOther_0","chkPersonVenueOther_1","chkPersonVenueOther_2","chkPersonVenueOther_3","chkPersonVenueOther_4","txbPersonVenueOther_4","chkPersonAffectPerson_0","chkPersonAffectPerson_1","chkPersonAffectPerson_2","chkPersonAffectPerson_3","chkPersonAffectPerson_4","chkPersonAffectPerson_5","chkPersonAffectPerson_6","txbPersonAffectPerson_6","rdoPersonPatientGrender_0","rdoPersonPatientGrender_1","rdoPersonPatientGrender_2","rdoPersonPatientAge_0","rdoPersonPatientAge_1","rdoPersonPatientAge_2","rdoPersonPatientAge_3","rdoPersonPatientAge_4","rdoPersonPatientAge_5","rdoPersonPatientAge_6","rdoPersonPatientAge_7","rdoPersonPatientTreatment_0","rdoPersonPatientTreatment_1","rdoPersonPatientTreatment_2","rdoPersonPatientTreatment_3","rdoPersonPatientTreatment_4","rdoPersonPatientTreatment_5","rdoPersonPatientDept_0","rdoPersonPatientDept_1","rdoPersonPatientDept_2","rdoPersonPatientDept_3","rdoPersonPatientDept_4","rdoPersonPatientDept_5","rdoPersonPatientDept_6","rdoPersonPatientDept_7","rdoPersonPatientDept_8","rdoPersonPatientDept_9","rdoPersonPatientDept_10","rdoPersonPatientDept_11","rdoPersonPatientDept_12","rdoPersonPatientDept_13","rdoPersonPatientDept_14","rdoPersonPatientDept_15","rdoPersonPatientDept_16","rdoPersonPatientDept_17","rdoPersonPatientDept_18","rdoPersonPatientDept_19","rdoPersonPatientDept_20","rdoPersonPatientDept_21","rdoPersonPatientDept_22","rdoPersonPatientDept_23","rdoPersonPatientDept_24","rdoPersonPatientDept_25","rdoPersonPatientDept_26","rdoPersonPatientDept_27","rdoPersonPatientDept_28","txbPersonPatientDept_28","rdoPersonPatientDept_29","rdoPersonAffectHealth_0","rdoPersonAffectHealth_1","rdoPersonAffectHealth_2","rdoPersonAffectHealth_3","rdoPersonAffectHurt_0","rdoPersonAffectHurt_1","rdoPersonAffectHurt_2","rdoPersonAffectHurt_3","rdoPersonAffectHurt_4","chkPersonRelPerson_0","chkPersonRelPerson_1","chkPersonRelPerson_2","chkPersonRelPerson_3","chkPersonRelPerson_4","chkPersonRelPerson_5","chkPersonRelPerson_6","chkPersonRelPerson_7","chkPersonRelPerson_8","chkPersonRelPerson_9","txbPersonRelPerson_9","chkPersonDoctor_0","chkPersonDoctor_1","chkPersonDoctor_2","chkPersonNurse_0","chkPersonNurse_1","chkPersonNurse_2","chkPersonDispenser_0","chkPersonDispenser_1","chkPersonInspect_0","chkPersonInspect_1","chkPersonTreatmentMan_0","chkPersonTreatmentMan_1","chkPersonRadiateMan_0","chkPersonRadiateMan_1","chkPersonStaff_0","chkPersonStaff_1","chkPersonStaff_2","chkPersonStaff_3","chkPersonStaff_4","txbPersonStaff_4","chkPersonSupport_0","chkPersonSupport_1","chkPersonSupport_2","chkPersonSupport_3","chkPersonSupport_4","chkPersonSupport_5","chkPersonSupport_6","chkPersonSupport_7","chkPersonSupport_8","txbPersonSupport_8","s$QPerson$AgeUnit")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabSurgery"]:=array("chkSurgeryHappenStep_0","chkSurgeryHappenStep_1","chkSurgeryHappenStep_2","chkSurgeryHappenStep_3","chkSurgeryHappenStep_4","chkSurgeryHappenStep_5","txbSurgeryHappenStep_5","chkSurgeryHappenStep_6","chkSurgeryHappenStep_7","chkSurgeryHappenStep_8","chkSurgeryHappenStep_9","chkSurgeryPrepare_0","chkSurgeryPrepare_1","txbSurgeryScheduleDate","txbSurgeryScheduleHour","txbSurgeryScheduleMin","txbSurgeryQuitDate","txbSurgeryQuitHour","txbSurgeryQuitMin","rdoSurgeryAnesthesiaDegree_0","rdoSurgeryAnesthesiaDegree_1","rdoSurgeryAnesthesiaDegree_2","rdoSurgeryAnesthesiaDegree_3","rdoSurgeryAnesthesiaDegree_4","chkSurgeryEventType_0","chkSurgeryEventType_1","chkSurgeryEventType_2","chkSurgeryEventType_3","chkSurgeryEventType_4","chkSurgeryEventType_5","chkSurgeryEventType_6","chkSurgeryEventType_7","chkSurgeryEventType_8","chkSurgeryEventType_9","chkSurgeryEventType_10","chkSurgeryEventType_11","chkSurgeryEventType_12","chkSurgeryEventType_13","chkSurgeryEventType_14","chkSurgeryEventType_15","chkSurgeryEventType_16","txbSurgeryEventType_16","chkSurgeryProcess_0","chkSurgeryProcess_1","chkSurgeryProcess_2","chkSurgeryProcess_3","chkSurgeryProcess_4","txbSurgeryProcess_4","chkSurgeryProcessDr_0","chkSurgeryProcessDr_1","chkSurgeryProcessDr_2","chkSurgeryProcessDr_3","chkSurgeryProcessDr_4","chkSurgeryProcessDr_5","chkSurgeryProcessDr_6","rdoSurgeryIsSOA_0","rdoSurgeryIsSOA_1","rdoSurgeryIsSOA_2","chkSurgerySOA_0","chkSurgerySOA_1","chkSurgerySOA_2","chkSurgerySOA_3","chkSurgerySOA_4","txbSurgerySOA_4","chkSurgeryReason_0","chkSurgeryReason_1","chkSurgeryReason_2","chkSurgeryReason_3","chkSurgeryReason_4","chkSurgeryReason_5","txbSurgeryReason_5","chkSurgeryReason_6","chkSurgeryFlow_0","chkSurgeryFlow_1","chkSurgeryFlow_2","chkSurgeryFlow_3","chkSurgeryFlow_4","chkSurgeryFlow_5","chkSurgeryFlow_6","chkSurgeryFlow_7","chkSurgeryFlow_8","chkSurgeryFlow_9","chkSurgeryFlow_10","txbSurgeryFlow_10","chkSurgeryPerson_0","chkSurgeryPerson_1","chkSurgeryPerson_2","chkSurgeryPerson_3","chkSurgeryPerson_4","chkSurgeryPerson_5","txbSurgeryPerson_5","chkSurgeryPerson_6","chkSurgeryDevice_0","chkSurgeryDevice_1","chkSurgeryDevice_2","txbSurgeryDevice_2","chkSurgeryDevice_3","chkSurgeryCommunicate_0","chkSurgeryCommunicate_1","chkSurgeryCommunicate_2","chkSurgeryCommunicate_3","chkSurgeryCommunicate_4","chkSurgeryCommunicate_5","txbSurgeryCommunicate_5")

txt="rdoFalldownCount_0","rdoFalldownCount_1","rdoFalldownCount_2","rdoFalldownIsHigh_0","rdoFalldownIsHigh_1","rdoFalldownIsHigh_2","rdoFalldownIsHigh_3","txbFalldownBarthel","rdoFalldownAct_0","rdoFalldownAct_1","rdoFalldownAct_2","rdoFalldownAct_3","rdoFalldownIsAttendeeUsual_0","rdoFalldownIsAttendeeUsual_1","rdoFalldownIsAttendeeUsual_2","rdoFalldownIsAttendeeHappen_0","rdoFalldownIsAttendeeHappen_1","rdoFalldownIsAttendeeHappen_2","chkFalldownAttendee_0","chkFalldownAttendee_1","chkFalldownAttendee_2","chkFalldownAttendee_3","txbFalldownAttendee_3","chkFalldownAttendee_4","chkFalldownAttendee_5","chkFalldownAttendee_6","rdoFalldownIsAidUsual_0","rdoFalldownIsAidUsual_1","rdoFalldownIsAidUsual_2","chkFalldownAidUsual_0","chkFalldownAidUsual_1","chkFalldownAidUsual_2","chkFalldownAidUsual_3","chkFalldownAidUsual_4","txbFalldownAidUsual_4","rdoFalldownIsAidHappen_0","rdoFalldownIsAidHappen_1","rdoFalldownIsAidHappen_2","chkFalldownAidHappen_0","chkFalldownAidHappen_1","chkFalldownAidHappen_2","chkFalldownAidHappen_3","chkFalldownAidHappen_4","txbFalldownAidHappen_4","rdoFalldownGate_0","rdoFalldownGate_1","rdoFalldownGate_2","rdoFalldownGate_3","rdoFalldownGate_4","rdoFalldownGate_5","rdoFalldownPlace_0","rdoFalldownPlace_1","rdoFalldownPlace_2","rdoFalldownPlace_3","rdoFalldownPlace_4","rdoFalldownPlace_5","rdoFalldownPlace_6","txbFalldownPlace_6","rdoFalldownActHappen_0","rdoFalldownActHappen_1","rdoFalldownActHappen_2","rdoFalldownActHappen_3","rdoFalldownActHappen_4","rdoFalldownActHappen_5","rdoFalldownActHappen_6","rdoFalldownActHappen_7","rdoFalldownActHappen_8","rdoFalldownActHappen_9","rdoFalldownActHappen_10","rdoFalldownActHappen_11","rdoFalldownActHappen_12","rdoFalldownActHappen_13","rdoFalldownActHappen_14","txbActHappen_14","rdoFalldownActHappen_15","rdoFalldownActHappen_16","rdoFalldownSense_0","rdoFalldownSense_1","rdoFalldownSense_2","rdoFalldownSense_3","rdoFalldownIsSOA_0","rdoFalldownIsSOA_1","rdoFalldownIsSOA_2","chkFalldownSOA_0","chkFalldownSOA_1","chkFalldownSOA_2","chkFalldownSOA_3","chkFalldownSOA_4","txbFalldownSOA_4","chkFalldownDiscoverer_0","chkFalldownDiscoverer_1","chkFalldownDiscoverer_2","chkFalldownDiscoverer_3","chkFalldownDiscoverer_4","chkFalldownDiscoverer_5","txbFalldownDiscoverer_5","chkFalldownHurtRegion_0","chkFalldownHurtRegion_1","chkFalldownHurtRegion_2","chkFalldownHurtRegion_3","chkFalldownHurtRegion_4","chkFalldownHurtRegion_5","txbFalldownHurtRegion_5","chkFalldownHurtRegion_6","rdoFalldownIsTakeDurg_0","rdoFalldownIsTakeDurg_1","chkFalldownTakeDrug_0","chkFalldownTakeDrug_1","chkFalldownTakeDrug_2","chkFalldownTakeDrug_3","txbFalldownTakeDrug_3","chkFalldownTakeDrug_4","chkFalldownTakeDrug_5","chkFalldownTakeDrug_6","chkFalldownTakeDrug_7","chkFalldownTakeDrug_8","chkFalldownTakeDrug_9","txbFalldownTakeDrug_9","chkFalldownTakeDrug_10","txbFalldownTakeDrug_10","chkFalldownSleepDrug_0","chkFalldownSleepDrug_1","chkFalldownSleepDrug_2","chkFalldownSleepDrug_3","chkFalldownSleepDrug_4","txbFalldownSleepDrug_4","chkFalldownHypertensionDrug_0","chkFalldownHypertensionDrug_1","chkFalldownHypertensionDrug_2","chkFalldownHypertensionDrug_3","chkFalldownHypertensionDrug_4","chkFalldownHypertensionDrug_5","chkFalldownHypertensionDrug_6","chkFalldownHypertensionDrug_7","chkFalldownHypertensionDrug_8","chkFalldownHypertensionDrug_9","chkFalldownHypertensionDrug_10","chkFalldownHypertensionDrug_11","txbFalldownHypertensionDrug_11","chkFalldownHypertensionDrug_12","chkFalldownHypotensionDrug_0","chkFalldownHypotensionDrug_1","chkFalldownHypotensionDrug_2","chkFalldownHypotensionDrug_3","chkFalldownHypotensionDrug_4","chkFalldownSedative_0","chkFalldownSedative_1","chkFalldownSedative_2","chkFalldownSedative_3","chkFalldownSedative_4","chkFalldownSedative_5","txbFalldownSedative_5","chkFalldownUretic_0","chkFalldownUretic_1","chkFalldownUretic_2","chkFalldownUretic_3","chkFalldownUretic_4","chkFalldownUretic_5","chkFalldownUretic_6","chkFalldownUretic_7","chkFalldownCoagulen_0","chkFalldownCoagulen_1","chkFalldownCoagulen_2","chkFalldownCoagulen_3","chkFalldownCoagulen_4","chkFalldownCoagulen_5","chkFalldownCoagulen_6","chkFalldownCoagulen_7","chkFalldownCoagulen_8","chkFalldownCoagulen_9","chkFalldownAntihistamine_0","chkFalldownAntihistamine_1","txbFalldownAntihistamine_1","chkFalldownAnesthesia_0","chkFalldownAnesthesia_1","chkFalldownAnesthesia_2","txbFalldownAnesthesia_2","rdoFalldownDrip_0","rdoFalldownDrip_1","txbFalldownDrip_1","rdoFalldownIsBridle_0","rdoFalldownIsBridle_1","chkFalldownBridle_0","chkFalldownBridle_1","chkFalldownBridle_2","chkFalldownBridle_3","chkFalldownReason_0","chkFalldownReason_1","chkFalldownReason_2","chkFalldownReason_3","chkFalldownReason_4","chkFalldownReason_5","chkFalldownReason_6","chkFalldownReason_7","txbFalldownReason_7","chkFalldownReason_8","chkFalldownPatient_0","chkFalldownPatient_1","chkFalldownPatient_2","chkFalldownPatient_3","chkFalldownPatient_4","chkFalldownPatient_5","chkFalldownPatient_6","chkFalldownPatient_7","chkFalldownPatient_8","chkFalldownPatient_9","chkFalldownPatient_10","chkFalldownPatient_11","chkFalldownPatient_12","txbFalldownPatient_12","chkFalldownDevice_0","chkFalldownDevice_1","chkFalldownDevice_2","chkFalldownDevice_3","chkFalldownDevice_4","chkFalldownDevice_5","chkFalldownDevice_6","txbFalldownDevice_6","chkFalldownEnv_0","chkFalldownEnv_1","chkFalldownEnv_2","chkFalldownEnv_3","chkFalldownEnv_4","chkFalldownEnv_5","chkFalldownEnv_6","chkFalldownEnv_7","txbFalldownEnv_7","chkFalldownDrug_0","chkFalldownDrug_1","chkFalldownDrug_2","chkFalldownDrug_3","chkFalldownDrug_4","chkFalldownDrug_5","chkFalldownDrug_6","chkFalldownDrug_7","chkFalldownDrug_8","chkFalldownDrug_9","txbFalldownDrug_9","chkFalldownFlow_0","chkFalldownFlow_1","chkFalldownFlow_2","chkFalldownFlow_3","chkFalldownFlow_4","chkFalldownFlow_5","txbFalldownFlow_5","chkFalldownPerson_0","chkFalldownPerson_1","chkFalldownPerson_2","chkFalldownPerson_3","txbFalldownPerson_3","txbFalldownVST","txbFalldownVSP","txbFalldownVSR","txbFalldownVSBPHigh","txbFalldownVSBPLow","txbFalldownVSDate","txbFalldownVSHour","txbFalldownVSMin","rdoFalldownJCIAHurtDegree_0","rdoFalldownJCIAHurtDegree_1","rdoFalldownJCIAHurtDegree_2","rdoFalldownJCIAHurtDegree_3","rdoFalldownJCIAHurtDegree_4","rdoFalldownJCIAHurtDegree_5","chkFalldownJCIAHurtL_0","chkFalldownJCIAHurtL_1","chkFalldownJCIAHurtL_2","chkFalldownJCIAHurtL_3","chkFalldownJCIAHurtL_4","chkFalldownJCIAHurtL_5","chkFalldownJCIAHurtL_6","chkFalldownJCIAHurtM_0","chkFalldownJCIAHurtM_1","chkFalldownJCIAHurtM_2","chkFalldownJCIAHurtH_0","chkFalldownJCIAHurtH_1","chkFalldownJCIAHurtH_2","chkFalldownJCIAHurtH_3","chkFalldownJCIAHurtH_4","txbFalldownAnalyRiskScore","txbFalldownAnalyDate","rdoFalldownAnalyIsScore_0","chkFalldownAnalyStyle_0","chkFalldownAnalyStyle_1","chkFalldownAnalyStyle_2","chkFalldownAnalyStyle_3","chkFalldownAnalyStyle_4","chkFalldownAnalyStyle_5","chkFalldownAnalyStyle_6","chkFalldownAnalyStyle_7","chkFalldownAnalyStyle_8","txbFalldownAnalyStyle_8","chkFalldownAnalyStyle_9","chkFalldownAnalyStyle_10","chkFalldownAnalyStyle_11","chkFalldownAnalyStyle_12","chkFalldownAnalyStyle_13","chkFalldownAnalyStyle_14","rdoFalldownAnalyPain_0","rdoFalldownAnalyPain_1","rdoFalldownAnalyDegree_0","rdoFalldownAnalyDegree_1","rdoFalldownAnalyDegree_2","rdoFalldownAnalyDegree_3","rdoFalldownAnalyDegree_4","rdoFalldownAnalyDegree_5","rdonFalldownAnalyReason_0","rdonFalldownAnalyReason_1","rdonFalldownAnalyReason_2","rdonFalldownAnalyReason_3","chkFalldownAnalyImprove_0","chkFalldownAnalyImprove_1","chkFalldownAnalyImprove_2","chkFalldownAnalyImprove_3","txbFalldownAnalyImprove_3","chkFalldownAnalyImprove_4","txbFalldownAnalyImprove_4","chkFalldownAnalyTreatItem_0","chkFalldownAnalyTreatItem_1","chkFalldownAnalyTreatItem_2","chkFalldownAnalyTreatItem_3","chkFalldownAnalyTreatItem_4","chkFalldownAnalyTreatItem_5","txbFalldownAnalyTrearItem_5","chkFalldownAnalyCareItem_0","chkFalldownAnalyCareItem_1","chkFalldownAnalyCareItem_2","chkFalldownAnalyCareItem_3","chkFalldownAnalyCareItem_4","chkFalldownAnalyCareItem_5","chkFalldownAnalyCareItem_6","txbFalldownAnalyCareItem_6","chkFalldownAnalyPatientItem_0","chkFalldownAnalyPatientItem_1","chkFalldownAnalyPatientItem_2","chkFalldownAnalyPatientItem_3","chkFalldownAnalyPatientItem_4","chkFalldownAnalyPatientItem_5","txbFalldownAnalyPatientItem_5","rdoFalldownAnalyMind_0","rdoFalldownAnalyMind_1","rdoFalldownAnalyMind_2","rdoFalldownAnalyMind_3","rdoFalldownAnalyMind_4","txbFalldownAnalyMind_4","rdoFalldownAnalyIsFirst_0","rdoFalldownAnalyIsFirst_1","txbFalldownAnalyMonth","rdoFalldownAnalyDispute_0","rdoFalldownAnalyDispute_1","rdoFalldownAnalyDispute_2","t$QFalldown$Desc"
arr:=[]
loop,parse,txt,`,,`"
   arr.push(a_loopfield)
tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabFalldown"]:=arr

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabDrug"]:=array("chkDrugErrorStep_0","chkDrugErrorStep_1","chkDrugErrorStep_2","chkDrugErrorStep_3","chkDrugErrorStep_4","chkDrugErrorStep_5","chkDrugErrorStep_6","txbDrugErrorStep_6","chkDrugAdviceAdd_0","chkDrugAdviceAdd_1","chkDrugAdviceAdd_2","chkDrugAdviceAdd_3","chkDrugAdviceAdd_4","chkDrugAdviceAdd_5","chkDrugAdviceAdd_6","chkDrugAdviceAdd_7","chkDrugAdviceAdd_8","chkDrugAdviceAdd_9","chkDrugAdviceAdd_10","chkDrugAdviceAdd_11","txbDrugAdviceAdd_11","chkDrugAdviceAdd_12","chkDrugAdviceKeyin_0","chkDrugAdviceKeyin_1","chkDrugPreparatin_0","chkDrugPreparatin_1","chkDrugPreparatin_2","chkDrugPreparatin_3","chkDrugPreparatin_4","chkDrugPreparatin_5","chkDrugPreparatin_6","chkDrugPreparatin_7","chkDrugPreparatin_8","chkDrugPreparatin_9","txbDrugPreparatin_9","chkDrugDeliver_0","chkDrugDeliver_1","chkDrugDeliver_2","chkDrugDeliver_3","chkDrugMedication_0","chkDrugMedication_1","chkDrugMedication_2","chkDrugMedication_3","chkDrugMedication_4","chkDrugMedication_5","chkDrugMedication_6","chkDrugMedication_7","chkDrugMedication_8","chkDrugMedication_9","chkDrugMedication_10","chkDrugMedication_11","chkDrugMedication_12","chkDrugMedication_13","chkDrugMedication_14","txbDrugMedication_14","chkDrugMedication_15","chkDrugMedicineForm_0","chkDrugMedicineForm_1","chkDrugMedicineForm_2","chkDrugMedicineForm_3","chkDrugMedicineForm_4","chkDrugMedicineForm_5","chkDrugMedicineForm_6","txbDrugMedicineForm_6","txbDrugName","txbWrongName","txbWrongTimes","rdoDrugIsSOA_0","rdoDrugIsSOA_1","rdoDrugIsSOA_2","chkDrugSOA_0","chkDrugSOA_1","chkDrugSOA_2","chkDrugSOA_3","chkDrugSOA_4","txbDrugSOA_4","chkDrugReason_0","chkDrugReason_1","chkDrugReason_2","chkDrugReason_3","chkDrugReason_4","chkDrugReason_5","chkDrugReason_6","txbDrugReason_6","chkDrugFlow_0","chkDrugFlow_1","chkDrugFlow_2","chkDrugFlow_3","chkDrugFlow_4","chkDrugFlow_5","chkDrugFlow_6","chkDrugFlow_7","chkDrugFlow_8","txbDrugFlow_8","chkDrugPatient_0","chkDrugPatient_1","chkDrugPatient_2","chkDrugPatient_3","txbDrugPatient_3","chkDrugPerson_0","chkDrugPerson_1","chkDrugPerson_2","chkDrugPerson_3","chkDrugPerson_4","chkDrugPerson_5","chkDrugPerson_6","txbDrugPerson_6","chkDrugDevice_0","chkDrugDevice_1","chkDrugDevice_2","chkDrugDevice_3","chkDrugDevice_4","chkDrugDevice_5","chkDrugDevice_6","chkDrugDevice_7","chkDrugDevice_8","chkDrugDevice_9","txbDrugDevice_9","chkDrugCommunicate_0","chkDrugCommunicate_1","chkDrugCommunicate_2","chkDrugCommunicate_3","chkDrugCommunicate_4","chkDrugCommunicate_5","chkDrugCommunicate_6","txbDrugCommunicate_6","t$QDrug$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabBlood"]:=array("chkBloodErrorStep_0","chkBloodErrorStep_1","chkBloodErrorStep_2","chkBloodErrorStep_3","chkBloodTest_0","chkBloodTest_1","chkBloodTest_2","txbBloodTest_2","chkBloodPrepare_0","chkBloodPrepare_1","chkBloodPrepare_2","chkBloodPrepare_3","chkBloodPrepare_4","chkBloodPrepare_5","chkBloodPrepare_6","txbBloodPrepare_6","chkBloodDeliver_0","chkBloodDeliver_1","chkBloodDeliver_2","chkBloodDeliver_3","chkBloodDeliver_4","chkBloodDeliver_5","chkBloodDeliver_6","chkBloodDeliver_7","chkBloodDeliver_8","chkBloodDeliver_9","txbBloodDeliver_9","chkBloodTransfusion_0","chkBloodTransfusion_1","chkBloodTransfusion_2","chkBloodTransfusion_3","chkBloodTransfusion_4","chkBloodTransfusion_5","chkBloodTransfusion_6","txbBloodTransfusion_6","rdoBloodBack_0","rdoBloodBack_1","rdoBloodBack_2","rdoBloodBack_3","rdoBloodBack_4","rdoBloodBack_5","rdoBloodBack_6","txbBloodBack_6","chkBloodResponse_0","chkBloodResponse_1","chkBloodResponse_2","chkBloodResponse_3","chkBloodResponse_4","chkBloodResponse_5","chkBloodResponse_6","chkBloodResponse_7","chkBloodResponse_8","chkBloodResponse_9","chkBloodResponse_10","chkBloodResponse_11","chkBloodResponse_12","chkBloodResponse_13","chkBloodResponse_14","chkBloodResponse_15","txbBloodResponse_15","rdoBloodIsSOA_0","rdoBloodIsSOA_1","rdoBloodIsSOA_2","chkBloodSOA_0","chkBloodSOA_1","chkBloodSOA_2","chkBloodSOA_3","chkBloodSOA_4","txbBloodSOA_4","chkBloodReason_0","chkBloodReason_1","chkBloodReason_2","chkBloodReason_3","chkBloodReason_4","txbBloodReason_4","chkBloodFlow_0","chkBloodFlow_1","chkBloodFlow_2","chkBloodFlow_3","chkBloodFlow_4","chkBloodFlow_5","chkBloodFlow_6","txbBloodFlow_6","chkBloodPerson_0","chkBloodPerson_1","chkBloodPerson_2","chkBloodPerson_3","txbBloodPerson_3","chkBloodCommunicate_0","chkBloodCommunicate_1","chkBloodCommunicate_2","chkBloodCommunicate_3","txbBloodCommunicate_3","t$QBlood$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabTreatment"]:=array("chkTreatmentKind_0","chkTreatmentKind_1","chkTreatmentKind_2","chkTreatmentKind_3","chkTreatmentKind_4","txbTreatmentKind_4","chkTreatmentKind_5","rdoTreatmentIsInvade_0","rdoTreatmentIsInvade_1","rdoTreatmentIsInvade_2","chkTreatmentErrorKind_0","chkTreatmentErrorKind_1","chkTreatmentErrorKind_2","chkTreatmentErrorKind_3","chkTreatmentErrorKind_4","chkTreatmentErrorKind_5","chkTreatmentErrorKind_6","chkTreatmentErrorKind_7","chkTreatmentErrorKind_8","chkTreatmentErrorKind_9","chkTreatmentErrorKind_10","txbTreatmentErrorKind_10","chkTreatmentErrorKind_11","chkTreatmentErrorKind_12","rdoTreatmentIsSOA_0","rdoTreatmentIsSOA_1","rdoTreatmentIsSOA_2","chkTreatmentSOA_0","chkTreatmentSOA_1","chkTreatmentSOA_2","chkTreatmentSOA_3","chkTreatmentSOA_4","txbTreatmentSOA_4","chkTreatmentReason_0","chkTreatmentReason_1","chkTreatmentReason_2","chkTreatmentReason_3","chkTreatmentReason_4","chkTreatmentReason_5","chkTreatmentReason_6","txbTreatmentReason_6","chkTreatmentFlow_0","chkTreatmentFlow_1","chkTreatmentFlow_2","chkTreatmentFlow_3","chkTreatmentFlow_4","chkTreatmentFlow_5","txbTreatmentFlow_5","chkTreatmentPerson_0","chkTreatmentPerson_1","chkTreatmentPerson_2","chkTreatmentPerson_3","chkTreatmentPerson_4","chkTreatmentPerson_5","txbTreatmentPerson_5","chkTreatmentPerson_6","chkTreatmentCommunicate_0","chkTreatmentCommunicate_1","chkTreatmentCommunicate_2","chkTreatmentCommunicate_3","chkTreatmentCommunicate_4","chkTreatmentCommunicate_5","txbTreatmentCommunicate_5","chkTreatmentCommunicate_6","chkTreatmentDevice_0","chkTreatmentDevice_1","chkTreatmentDevice_2","txbTreatmentDevice_2","chkTreatmentDevice_3","txbTreatmentDevice_3","chkTreatmentPatient_0","chkTreatmentPatient_1","txbTreatmentPatient_1","t$QTreatment$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAccident"]:=array("chkAccidentType_0","chkAccidentType_1","chkAccidentType_2","chkAccidentType_3","chkAccidentType_4","chkAccidentType_5","chkAccidentType_6","chkAccidentType_7","chkAccidentType_8","chkAccidentType_9","chkAccidentType_10","chkAccidentType_11","chkAccidentType_12","chkAccidentType_13","chkAccidentType_14","chkAccidentType_15","chkAccidentType_16","txbAccidentType_16","chkAccidentType_17","rdoAccidentIsSOA_0","rdoAccidentIsSOA_1","rdoAccidentIsSOA_2","chkAccidentSOA_0","chkAccidentSOA_1","chkAccidentSOA_2","chkAccidentSOA_3","chkAccidentSOA_4","txbAccidentSOA_4","chkAccidentReason_0","chkAccidentReason_1","chkAccidentReason_2","chkAccidentReason_3","txbAccidentReason_3","chkAccidentDevice_0","chkAccidentDevice_1","chkAccidentDevice_2","chkAccidentDevice_3","chkAccidentDevice_4","chkAccidentDevice_5","chkAccidentDevice_6","chkAccidentDevice_7","txbAccidentDevice_7","chkAccidentEnv_0","chkAccidentEnv_1","chkAccidentEnv_2","chkAccidentEnv_3","txbAccidentEnv_3","t$QAccident$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabSecurity"]:=array("chkSecurityType_0","chkSecurityType_1","chkSecurityType_2","chkSecurityType_3","chkSecurityType_4","chkSecurityType_5","chkSecurityType_6","chkSecurityType_7","chkSecurityType_8","chkSecurityType_9","chkSecurityType_10","chkSecurityType_11","chkSecurityType_12","chkSecurityType_13","txbSecurityType_13","chkSecurityType_14","chkSecurityReason_0","chkSecurityReason_1","chkSecurityReason_2","chkSecurityReason_3","chkSecurityReason_4","chkSecurityReason_5","chkSecurityReason_6","chkSecurityReason_7","txbSecurityReason_7","t$QSecurity$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabHurt"]:=array("chkHurtType_0","chkHurtType_1","chkHurtType_2","chkHurtType_3","chkHurtType_4","chkHurtType_5","txbHurtType_5","chkHurtReason_0","chkHurtReason_1","chkHurtReason_2","chkHurtReason_3","txbHurtReason_3","chkHurtPatient_0","chkHurtPatient_1","chkHurtPatient_2","chkHurtPatient_3","chkHurtPatient_4","chkHurtPatient_5","txbHurtPatient_5","chkHurtPerson_0","chkHurtPerson_1","chkHurtPerson_2","txbHurtPerson_2","chkHurtCommunicate_0","chkHurtCommunicate_1","chkHurtCommunicate_2","chkHurtCommunicate_3","chkHurtCommunicate_4","chkHurtCommunicate_5","txbHurtCommunicate_5","t$QHurt$Desc")

txt="chkIntubateErrorType_0","chkIntubateErrorType_1","chkIntubateErrorType_2","chkIntubateErrorType_3","chkIntubateErrorType_4","txbIntubateErrorType_4","rdoIntubateRemoveType_0","rdoIntubateRemoveType_1","rdoIntubateRemoveType_2","txbIntubateRemoveType_2","chkIntubateType_0","chkIntubateType_1","chkIntubateType_2","chkIntubateType_3","chkIntubateType_4","chkIntubateType_5","chkIntubateType_6","chkIntubateType_7","chkIntubateType_8","chkIntubateType_9","chkIntubateType_10","txbIntubateType_10","chkIntubateType_11","chkIntubateType_12","chkIntubateType_13","chkIntubateType_14","chkIntubateType_15","chkIntubateType_16","chkIntubateInspirator_0","chkIntubateInspirator_1","chkIntubateInspirator_2","chkIntubateInspirator_3","chkIntubateInspirator_4","rdoIntubateDegree_0","rdoIntubateDegree_1","rdoIntubateDegree_2","chkIntubateSlipReason_0","chkIntubateSlipReason_1","chkIntubateSlipReason_2","chkIntubateSlipReason_3","chkIntubateSlipReason_4","chkIntubateSlipReason_5","chkIntubateSlipReason_6","chkIntubateSlipReason_7","txbIntubateSlipReason_7","rdoIntubateSense_0","rdoIntubateSense_1","rdoIntubateSense_2","rdoIntubateSense_3","rdoIntubateIsUseSedative_0","rdoIntubateIsUseSedative_1","rdoIntubateIsBridle_0","rdoIntubateIsBridle_1","rdoIntubateRemove_0","rdoIntubateRemove_1","rdoIntubateRemove_2","rdoIntubateIsAttendee_0","rdoIntubateIsAttendee_1","rdoIntubateIsAttendee_2","rdoIntubateIsHappenAttendee_0","rdoIntubateIsHappenAttendee_1","rdoIntubateIsHappenAttendee_2","chkIntubateHappenAttendee_0","chkIntubateHappenAttendee_1","chkIntubateHappenAttendee_2","chkIntubateHappenAttendee_3","txbIntubateHappenAttendee_3","chkIntubateHappenAttendee_4","chkIntubateHappenAttendee_5","chkIntubateHappenAttendee_6","rdoIntubateHappenActive_0","rdoIntubateHappenActive_1","rdoIntubateHappenActive_2","rdoIntubateHappenActive_3","rdoIntubateHappenActive_4","rdoIntubateHappenActive_5","rdoIntubateHappenActive_6","rdoIntubateHappenActive_7","rdoIntubateHappenActive_8","rdoIntubateHappenActive_9","rdoIntubateHappenActive_10","txbIntubateHappenActive_10","rdoIntubateHappenActive_11","rdoIntubateHappenActive_12","rdoIntubateHappenActive_13","rdoIntubateHappenActive_14","rdoIntubateHappenActive_15","rdoIntubateMaterial_0","rdoIntubateMaterial_1","rdoIntubateMaterial_2","rdoIntubateMaterial_3","rdoIntubateMaterial_4","rdoIntubateMaterial_5","txbIntubateMaterial_5","rdoIntubateIsReIntubate_0","rdoIntubateIsReIntubate_1","rdoIntubateIsReIntubate_2","rdoIntubateIsReIntubate_3","rdoIntubateIsSOA_0","rdoIntubateIsSOA_1","rdoIntubateIsSOA_2","chkIntubateSOA_0","chkIntubateSOA_1","chkIntubateSOA_2","chkIntubateSOA_3","chkIntubateSOA_4","txbIntubateSOA_4","chkIntubateReason_0","chkIntubateReason_1","chkIntubateReason_2","chkIntubateReason_3","chkIntubateReason_4","txbIntubateReason_4","chkIntubatePatient_0","chkIntubatePatient_1","chkIntubatePatient_2","chkIntubatePatient_3","txbIntubatePatient_3","chkIntubateFlow_0","chkIntubateFlow_1","chkIntubateFlow_2","chkIntubateFlow_3","chkIntubateFlow_4","chkIntubateFlow_5","chkIntubateFlow_6","txbIntubateFlow_6","chkIntubatePerson_0","chkIntubatePerson_1","chkIntubatePerson_2","chkIntubatePerson_3","chkIntubatePerson_4","txbIntubatePerson_4","chkIntubateCommunicate_0","chkIntubateCommunicate_1","chkIntubateCommunicate_2","chkIntubateCommunicate_3","chkIntubateCommunicate_4","txbIntubateCommunicate_4","txbIntubateOutPersonName","txbIntubateOutPersonId","txbIntubateOutGrender","txbIntubateOutBornDate","txbIntubateOutBedNo","txbIntubateOutDept","rdoIntubateOutSlipType_0","rdoIntubateOutSlipType_1","txbIntubateOutTubeDate","txbIntubateOutTubeHour","txbIntubateOutTubeMin","txbIntubateOutSlipDate","txbIntubateOutSlipHour","txbIntubateOutSlipMin","rdoIntubateOutIsReTube_0","rdoIntubateOutIsReTube_1","rdoIntubateOutNoReTube_0","rdoIntubateOutNoReTube_1","rdoIntubateOutNoReTube_2","txbIntubateOutReTubeDate","txbIntubateOutReTubeHour","txbIntubateOutReTubeMin","rdoIntubateOutTimeGap_0","rdoIntubateOutTimeGap_1","rdoIntubateOutTimeGap_2","rdoIntubateOutTimeGap_3","rdoIntubateOutSelfCase_0","rdoIntubateOutSelfCase_1","rdoIntubateOutSelfCase_2","rdoIntubateOutSelfCase_3","chkIntubateOutNewSelfType_0","chkIntubateOutNewSelfType_1","chkIntubateOutNewSelfType_2","chkIntubateOutNewSelfType_3","chkIntubateOutNewSelfType_4","chkIntubateOutNewSelfType_5","chkIntubateOutNewSelfType_6","chkIntubateOutNewSelfType_7","chkIntubateOutNewSelfType_8","chkIntubateOutNewSelfType_9","chkIntubateOutNewSelfType_10","txbIntubateOutNewSelfType_10","chkIntubateOutNewSelfType_11","chkIntubateOutNewSelfType_12","chkIntubateOutNewSelfType_13","chkIntubateOutNewSelfType_14","rdoIntubateOutIsAnodyne_0","rdoIntubateOutIsAnodyne_1","rdoIntubateOutAnodyne_0","rdoIntubateOutAnodyne_1","rdoIntubateOutAnodyne_2","rdoIntubateOutAnodyne_3","txbIntubateOutAnodyne_3","rdoIntubateOutIsTranquilizer_0","rdoIntubateOutIsTranquilizer_1","rdoIntubateOutTranquilizer_0","rdoIntubateOutTranquilizer_1","rdoIntubateOutTranquilizer_2","rdoIntubateOutTranquilizer_3","rdoIntubateOutTranquilizer_4","txbIntubateOutTranquilizer_4","rdoIntubateOutRASS_0","rdoIntubateOutRASS_1","rdoIntubateOutRASS_2","rdoIntubateOutRASS_3","rdoIntubateOutRASS_4","rdoIntubateOutRASS_5","rdoIntubateOutRASS_6","rdoIntubateOutRASS_7","rdoIntubateOutRASS_8","rdoIntubateOutRASS_9","rdoIntubateOutRASS_10","rdoIntubateOutVAS_0","rdoIntubateOutVAS_1","rdoIntubateOutVAS_2","rdoIntubateOutVAS_3","rdoIntubateOutVAS_4","rdoIntubateOutVAS_5","rdoIntubateOutVAS_6","rdoIntubateOutFaceScale_0","rdoIntubateOutFaceScale_1","rdoIntubateOutFaceScale_2","rdoIntubateOutFaceScale_3","rdoIntubateOutFaceScale_4","rdoIntubateOutFaceScale_5","rdoIntubateOutOEPacify_0","rdoIntubateOutOEPacify_1","rdoIntubateOutOEPacify_2","rdoIntubateOutOEFace_0","rdoIntubateOutOEFace_1","rdoIntubateOutOEFace_2","rdoIntubateOutOEBody_0","rdoIntubateOutOEBody_1","rdoIntubateOutOEBody_2","rdoIntubateOutOECry_0","rdoIntubateOutOECry_1","rdoIntubateOutOECry_2","rdoIntubateOutOEBreath_0","rdoIntubateOutOEBreath_1","rdoIntubateOutOEBreath_2","rdoIntubateOutNIPSCry_0","rdoIntubateOutNIPSCry_1","rdoIntubateOutNIPSCry_2","rdoIntubateOutNIPSFace_0","rdoIntubateOutNIPSFace_1","rdoIntubateOutNIPSBreath_0","rdoIntubateOutNIPSBreath_1","rdoIntubateOutNIPSArm_0","rdoIntubateOutNIPSArm_1","rdoIntubateOutNIPSLeg_0","rdoIntubateOutNIPSLeg_1","rdoIntubateOutNIPSSober_0","rdoIntubateOutNIPSSober_1","rdoIntubateOutIsDaily_0","rdoIntubateOutIsDaily_1","rdoIntubateOutIsDaily_2","rdoIntubateOutIsRestrict_0","rdoIntubateOutIsRestrict_1","rdoIntubateOutIsRestrict_2","chkIntubateOutRestric_0","chkIntubateOutRestric_1","chkIntubateOutRestric_2","chkIntubateOutRestric_3","chkIntubateOutRestric_4","rdoIntubateOutBelt_0","rdoIntubateOutBelt_1","rdoIntubateOutBelt_2","rdoIntubateOutBelt_3","rdoIntubateOutSelfReason_0","rdoIntubateOutSelfReason_1","rdoIntubateOutSelfReason_2","rdoIntubateOutSelfReason_3","rdoIntubateOutSelfReason_4","rdoIntubateOutSelfReason_5","rdoIntubateOutSelfReason_6","txbIntubateOutSelfReason_6","chkIntubateOutReason_0","chkIntubateOutReason_1","chkIntubateOutReason_2","chkIntubateOutReason_3","chkIntubateOutReason_4","txbIntubateOutReason_4","chkIntubateOutHurt_0","chkIntubateOutHurt_1","chkIntubateOutHurt_2","chkIntubateOutHurt_3","chkIntubateOutHurt_4","chkIntubateOutHurt_5","chkIntubateOutHurt_6","chkIntubateOutHurt_7","rdoIntubateOutSeniority_0","rdoIntubateOutSeniority_1","rdoIntubateOutSeniority_2","rdoIntubateOutSeniority_3","rdoIntubateOutSeniority_4","rdoIntubateOutNurseLevel_0","rdoIntubateOutNurseLevel_1","rdoIntubateOutNurseLevel_2","rdoIntubateOutNurseLevel_3","rdoIntubateOutNurseLevel_4","chkIntubateOutImprove_0","chkIntubateOutImprove_1","chkIntubateOutImprove_2","chkIntubateOutImprove_3","chkIntubateOutImprove_4","txbIntubateOutImprove_4","t$QIntubate$Desc"
arr:=[]
loop,parse,txt,`,,`"
   arr.push(a_loopfield)
tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabIntubate"]:=arr

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabHeart"]:=array("chkHeartFactor_0","chkHeartFactor_1","chkHeartFactor_2","chkHeartFactor_3","chkHeartFactor_4","chkHeartFactor_5","chkHeartFactor_6","chkHeartFactor_7","chkHeartFactor_8","chkHeartFactor_9","chkHeartFactor_10","txbHeartFactor_10","chkHeartFactor_11","chkHeartCause_0","chkHeartCause_1","chkHeartCause_2","chkHeartCause_3","chkHeartCause_4","chkHeartCause_5","chkHeartCause_6","chkHeartCause_7","txbHeartCause_7","rdoHeartIsWitness_0","rdoHeartIsWitness_1","chkHeartWitness_0","chkHeartWitness_1","chkHeartWitness_2","chkHeartWitness_3","chkHeartWitness_4","txbHeartWitness_4","rdoHeartIsCPR_0","rdoHeartIsCPR_1","rdoHeartIsDNR_0","rdoHeartIsDNR_1","rdoHeartIsExpect_0","rdoHeartIsExpect_1","rdoHeartRhythm_0","rdoHeartRhythm_1","rdoHeartRhythm_2","rdoHeartRhythm_3","rdoHeartRhythm_4","txbHeartRhythm_4","rdoHeartIsROSC_0","txbHeartIsROSC_0","rdoHeartIsROSC_1","rdoHeartStopCPRReason_0","rdoHeartStopCPRReason_1","rdoHeartStopCPRReason_2","rdoHeartStopCPRReason_3","rdoHeartAfterFAType_0","rdoHeartAfterFAType_1","rdoHeartAfterFAType_2","rdoHeartAfterFAType_3","rdoHeartAfterFAType_4","rdoHeartLeave_0","rdoHeartLeave_1","rdoHeartLeave_2","rdoHeartTrans_0","rdoHeartTrans_1","txbHeartHospitalDays","rdoHeartCPCBeforeEA_0","rdoHeartCPCBeforeEA_1","rdoHeartCPCBeforeEA_2","rdoHeartCPCBeforeEA_3","rdoHeartCPCBeforeEA_4","rdoHeartCPCAfterEA_0","rdoHeartCPCAfterEA_1","rdoHeartCPCAfterEA_2","rdoHeartCPCAfterEA_3","rdoHeartCPCAfterEA_4","rdoHeartCPCLeave_0","rdoHeartCPCLeave_1","rdoHeartCPCLeave_2","rdoHeartCPCLeave_3","rdoHeartCPCLeave_4","chkHeartReason_0","chkHeartReason_1","chkHeartReason_2","chkHeartReason_3","chkHeartReason_4","chkHeartReason_5","chkHeartReason_6","txbHeartReason_6","chkHeartPatient_0","chkHeartPatient_1","txbHeartPatient_1","chkHeartFlow_0","chkHeartFlow_1","chkHeartFlow_2","chkHeartFlow_3","chkHeartFlow_4","chkHeartFlow_5","chkHeartFlow_6","chkHeartFlow_7","chkHeartFlow_8","txbHeartFlow_8","chkHeartPerson_0","chkHeartPerson_1","chkHeartPerson_2","chkHeartPerson_3","chkHeartPerson_4","chkHeartPerson_5","chkHeartPerson_6","chkHeartPerson_7","chkHeartPerson_8","txbHeartPerson_8","chkHeartDevice_0","chkHeartDevice_1","chkHeartDevice_2","txbHeartDevice_2","chkHeartCommunicate_0","chkHeartCommunicate_1","chHeartCommunicate_2","chkHeartCommunicate_3","txbHeartCommunicate_3","chkHeartCommunicate_4","t$QHeart$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabInspect"]:=array("chkInspectType_0","chkInspectType_1","chkInspectType_2","chkInspectType_3","rdoInspectIsInvasion_0","rdoInspectIsInvasion_1","rdoInspectIsInvasion_2","chkInspectErrorStep_0","chkInspectErrorStep_1","chkInspectErrorStep_2","chkInspectErrorStep_3","chkInspectErrorStep_4","chkInspectErrorStep_5","chkInspectErrorStep_6","txbInspectErrorStep_6","chkInspectAdvice_0","chkInspectAdvice_1","chkInspectAdvice_2","chkInspectAdvice_3","txbInspectAdvice_3","chkInspectSend_0","chkInspectSend_1","chkInspectSend_2","chkInspectSend_3","chkInspectSend_4","chkInspectSend_5","chkInspectSend_6","chkInspectSend_7","chkInspectSend_8","chkInspectSend_9","chkInspectSend_10","chkInspectSend_11","chkInspectSend_12","txbInspectSend_12","chkInspectAnalysis_0","chkInspectAnalysis_1","chkInspectAnalysis_2","chkInspectAnalysis_3","chkInspectAnalysis_4","chkInspectAnalysis_5","chkInspectAnalysis_6","chkInspectAnalysis_7","chkInspectAnalysis_8","chkInspectAnalysis_9","txbInspectAnalysis_9","chkInspectReport_0","chkInspectReport_1","chkInspectReport_2","chkInspectReport_3","chkInspectReport_4","chkInspectReport_5","chkInspectReport_6","chkInspectReport_7","txbInspectReport_7","chkInspectDecipher_0","chkInspectDecipher_1","chkInspectDecipher_2","chkInspectDecipher_3","chkInspectDecipher_4","chkInspectDecipher_5","txbInspectDecipher_5","chkInspectErrorKind_0","chkInspectErrorKind_1","chkInspectErrorKind_2","chkInspectErrorKind_3","rdoInspectIsSOA_0","rdoInspectIsSOA_1","rdoInspectIsSOA_2","chkInspectSOA_0","chkInspectSOA_1","chkInspectSOA_2","chkInspectSOA_3","chkInspectSOA_4","txbInspectSOA_4","chkInspectReason_0","chkInspectReason_1","chkInspectReason_2","chkInspectReason_3","chkInspectReason_4","chkInspectReason_5","chkInspectReason_6","chkInspectReason_7","txbInspectReason_7","chkInspectPatient_0","chkInspectPatient_1","txbInspectPatient_1","chkInspectFlow_0","chkInspectFlow_1","chkInspectFlow_2","chkInspectFlow_3","chkInspectFlow_4","txbInspectFlow_4","chkInspectPerson_0","chkInspectPerson_1","chkInspectPerson_2","chkInspectPerson_3","chkInspectPerson_4","chkInspectPerson_5","chkInspectPerson_6","txbInspectPerson_6","chkInspectDevice_0","chkInspectDevice_1","chkInspectDevice_2","chkInspectDevice_3","chkInspectDevice_4","chkInspectDevice_5","txbInspectDevice_5","chkInspectCommunicate_0","chkInspectCommunicate_1","chkInspectCommunicate_2","chkInspectCommunicate_3","txbInspectCommunicate_3","chkInspectEnv_0","chkInspectEnv_1","chkInspectEnv_2","txbInspectEnv_2","t$QInspect$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAnesthesia"]:=array("rdoAnesthesiaASA_0","rdoAnesthesiaASA_1","rdoAnesthesiaASA_2","rdoAnesthesiaASA_3","rdoAnesthesiaASA_4","rdoAnesthesiaASA_5","rdoAnesthesiaASA_6","rdoAnesthesiaASA_7","rdoAnesthesiaSurgery_0","rdoAnesthesiaSurgery_1","rdoAnesthesiaSurgery_2","chkAnesthesiaMode_0","chkAnesthesiaMode_1","chkAnesthesiaMode_2","chkAnesthesiaMode_3","chkAnesthesiaFull_0","chkAnesthesiaFull_1","chkAnesthesiaFull_2","chkAnesthesiaFull_3","chkAnesthesiaArea_0","chkAnesthesiaArea_1","chkAnesthesiaArea_2","chkAnesthesiaArea_3","chkAnesthesiaType_0","chkAnesthesiaType_1","chkAnesthesiaType_2","chkAnesthesiaType_3","chkAnesthesiaType_4","chkAnesthesiaType_5","chkAnesthesiaType_6","chkAnesthesiaType_7","chkAnesthesiaType_8","chkAnesthesiaType_9","chkAnesthesiaType_10","chkAnesthesiaType_11","txbAnesthesiaType_11","rdoAnesthesiaTime_0","rdoAnesthesiaTime_1","rdoAnesthesiaTime_2","rdoAnesthesiaTime_3","rdoAnesthesiaPlace_0","rdoAnesthesiaPlace_1","rdoAnesthesiaPlace_2","rdoAnesthesiaPlace_3","rdoAnesthesiaPlace_4","rdoAnesthesiaPlace_5","rdoAnesthesiaPlace_6","txbAnesthesiaPlace_6","rdoAnesthesiaIsSOA_0","rdoAnesthesiaIsSOA_1","rdoAnesthesiaIsSOA_2","chkAnesthesiaSOA_0","chkAnesthesiaSOA_1","chkAnesthesiaSOA_2","chkAnesthesiaSOA_3","chkAnesthesiaSOA_4","txbAnesthesiaSOA_4","chkAnesthesiaReason_0","chkAnesthesiaReason_1","chkAnesthesiaReason_2","chkAnesthesiaReason_3","chkAnesthesiaReason_4","chkAnesthesiaReason_5","chkAnesthesiaReason_6","chkAnesthesiaReason_7","chkAnesthesiaReason_8","txbAnesthesiaReason_8","chkAnesthesiaPatient_0","chkAnesthesiaPatient_1","chkAnesthesiaPatient_2","chkAnesthesiaPatient_3","chkAnesthesiaPatient_4","chkAnesthesiaPatient_5","chkAnesthesiaPatient_6","txbAnesthesiaPatient_6","chkAnesthesiaFlow_0","chkAnesthesiaFlow_1","chkAnesthesiaFlow_2","chkAnesthesiaFlow_3","chkAnesthesiaFlow_4","chkAnesthesiaFlow_5","txbAnesthesiaFlow_5","chkAnesthesiaPerson_0","chkAnesthesiaPerson_1","chkAnesthesiaPerson_2","chkAnesthesiaPerson_3","chkAnesthesiaPerson_4","chkAnesthesiaPerson_5","txbAnesthesiaPerson_5","chkAnesthesiaDevice_0","chkAnesthesiaDevice_1","chkAnesthesiaDevice_2","chkAnesthesiaDevice_3","chkAnesthesiaDevice_4","txbAnesthesiaDevice_4","chkAnesthesiaCommunicate_0","chkAnesthesiaCommunicate_1","chkAnesthesiaCommunicate_2","chkAnesthesiaCommunicate_3","chkAnesthesiaCommunicate_4","chkAnesthesiaCommunicate_5","chkAnesthesiaCommunicate_6","txbAnesthesiaCommunicate_6","chkAnesthesiaDrug_0","chkAnesthesiaDrug_1","chkAnesthesiaDrug_2","chkAnesthesiaDrug_3","chkAnesthesiaDrug_4","chkAnesthesiaDrug_5","txbAnesthesiaDrug_5","chkAnesthesiaSurgeryRel_0","chkAnesthesiaSurgeryRel_1","chkAnesthesiaSurgeryRel_2","chkAnesthesiaSurgeryRel_3","txbAnesthesiaSurgeryRel_3","t$QAnesthesia$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabAdmin"]:=array("chkAdminReason_0","chkAdminReason_1","chkAdminReason_2","chkAdminReason_3","txbAdminReason_3","t$QAdmin$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabChemotherapyLeak"]:=array("txbChemotherapyLeakDate","rdoChemotherapyLeakTube_0","rdoChemotherapyLeakTube_1","rdoChemotherapyLeakTube_2","rdoChemotherapyLeakTube_3","rdoChemotherapyLeakTube_4","txbChemotherapyLeakTube_4","rdoChemotherapyLeakRegion_0","rdoChemotherapyLeakRegion_1","rdoChemotherapyLeakRegion_2","rdoChemotherapyLeakRegion_3","rdoChemotherapyLeakRegion_4","rdoChemotherapyLeakRegion_5","rdoChemotherapyLeakRegion_6","rdoChemotherapyLeakRegion_7","rdoChemotherapyLeakRegion_8","rdoChemotherapyLeakRegion_9","rdoChemotherapyLeakRegion_10","rdoChemotherapyLeakRegion_11","rdoChemotherapyLeakRegion_12","rdoChemotherapyLeakRegion_13","rdoChemotherapyLeakRegion_14","rdoChemotherapyLeakRegion_15","rdoChemotherapyLeakRegion_16","rdoChemotherapyLeakRegion_17","rdoChemotherapyLeakRegion_18","txbChemotherapyLeakRegion_18","rdoChemotherapyLeakIsBlood_0","rdoChemotherapyLeakIsBlood_1","txbChemotherapyLeakBlood","txbChemotherapyLeakDrugName","txbChemotherapyLeakDrugAmount","txbChemotherapyLeakRemainAmount","txbChemotherapyLeakLookDesc","chkChemotherapyLeakLook_0","chkChemotherapyLeakLook_1","chkChemotherapyLeakLook_2","chkChemotherapyLeakLook_3 name","chkChemotherapyLeakLook_4","txbChemotherapyLeakLook_4","txbChemotherapyLeakSize","rdoChemotherapyLeakActive_0","rdoChemotherapyLeakActive_1","rdoChemotherapyLeakActive_2","rdoChemotherapyLeakActive_3","rdoChemotherapyLeakActive_4","rdoChemotherapyLeakActive_5","rdoChemotherapyLeakActive_6","rdoChemotherapyLeakActive_7","rdoChemotherapyLeakActive_8","rdoChemotherapyLeakActive_9","rdoChemotherapyLeakActive_10","rdoChemotherapyLeakActive_11","rdoChemotherapyLeakActive_12","rdoChemotherapyLeakActive_13","rdoChemotherapyLeakActive_14","rdoChemotherapyLeakActive_15","rdoChemotherapyLeakActive_16","txbChemotherapyLeakActive_16","rdoChemotherapyLeakSense_0","rdoChemotherapyLeakSense_1","rdoChemotherapyLeakSense_2","rdoChemotherapyLeakSense_3","chkChemotherapyLeakReason_0","chkChemotherapyLeakReason_1","chkChemotherapyLeakReason_2","chkChemotherapyLeakReason_3","txbChemotherapyLeakReason_3","t$QChemotherapyLeak$PatientSize","t$QChemotherapyLeak$PatientSense","t$QChemotherapyLeak$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabChemotherapyOver"]:=array("txbChemotherapyOverDate","txbChemotherapyOverDrugName","txbChemotherapyOverSize","rdoChemotherapyOverActive_0","rdoChemotherapyOverActive_1","rdoChemotherapyOverActive_2","rdoChemotherapyOverActive_3","rdoChemotherapyOverActive_4","rdoChemotherapyOverActive_5","rdoChemotherapyOverActive_6","rdoChemotherapyOverActive_7","rdoChemotherapyOverActive_8","rdoChemotherapyOverActive_9","rdoChemotherapyOverActive_10","rdoChemotherapyOverActive_11","rdoChemotherapyOverActive_12","rdoChemotherapyOverActive_13","rdoChemotherapyOverActive_14","rdoChemotherapyOverActive_15","rdoChemotherapyOverActive_16","txbChemotherapyOverActive_16","rdoChemotherapyOverActive_17","rdoChemotherapyOverSense_0","rdoChemotherapyOverSense_1","rdoChemotherapyOverSense_2","rdoChemotherapyOverSense_3","rdoChemotherapyOverSense_4","rdoChemotherapyOverHurt_0","rdoChemotherapyOverHurt_1","txbChemotherapyOverHurtMan","txbChemotherapyOverHurtPosition","chkChemotherapyOverReason_0","chkChemotherapyOverReason_1","chkChemotherapyOverReason_2","chkChemotherapyOverReason_3","chkChemotherapyOverReason_4","chkChemotherapyOverReason_5","chkChemotherapyOverReason_6","chkChemotherapyOverReason_7","chkChemotherapyOverReason_8","chkChemotherapyOverReason_9","txbChemotherapyOverReason_9","t$QChemotherapyOver$PlaceRegion","t$QChemotherapyOver$Desc")

tabs["__tab_caseTab_caseTabEvent_EventContainer_eventTab_tabOther"]:=array("chkOtherType_0","chkOtherType_1","chkOtherType_2","chkOtherType_3","chkOtherType_4","chkOtherType_5","chkOtherType_6","chkOtherType_7","chkOtherType_8","chkOtherType_9","txbOtherType_9","chkOtherType_10","chkOtherType_11","chkOtherChemical_0","chkOtherChemical_1","chkOtherReason_0","chkOtherReason_1","chkOtherReason_2","chkOtherReason_3","chkOtherReason_4","chkOtherReason_5","chkOtherReason_6","chkOtherReason_7","txbOtherReason_7","t$QOther$Desc")

tabs["__tab_caseTab_caseTabAviso"]:=array("txbAvisoName","txbAvisoTel","txbAvisoDept","btnAvisoDept","rdoIsBoss_0","rdoIsBoss_1","rdoAvisoRole_0","rdoAvisoRole_1","rdoAvisoRole_2","rdoAvisoRole_3","rdoAvisoRole_4","rdoAvisoRole_5","rdoAvisoRole_6","rdoAvisoRole_7","rdoAvisoRole_8","rdoAvisoRole_9","rdoAvisoRole_10","txbAvisoRole_10","rdoAvisoDoctor_0","rdoAvisoDoctor_1","rdoAvisoDoctor_2","rdoAvisoNurse_0","rdoAvisoNurse_1","rdoAvisoNurse_2","rdoAvisoDispenser_0","rdoAvisoDispenser_1","rdoAvisoInspect_0","rdoAvisoInspect_1","rdoAvisoTreatmentMan_0","rdoAvisoTreatmentMan_1","rdoAvisoRadiateMan_0","rdoAvisoRadiateMan_1","rdoAvisoStaff_0","rdoAvisoStaff_1","rdoAvisoStaff_2","rdoAvisoStaff_3","rdoAvisoStaff_4","txbStaff_4","rdoAvisoSupport_0","rdoAvisoSupport_1","rdoAvisoSupport_2","rdoAvisoSupport_3","rdoAvisoSupport_4","rdoAvisoSupport_5","rdoAvisoSupport_6","rdoAvisoSupport_7","rdoAvisoSupport_8","txbAvisoSupport_8","rdoAvisoPatient_0","rdoAvisoPatient_1","rdoAvisoPatient_2","txbAvisoSeniorityYear","txbAvisoSeniorityMonth","rdoAvisoSeniority_0","rdoAvisoSeniority_1","rdoAvisoSeniority_2","rdoAvisoSeniority_3","rdoAvisoSeniority_4","rdoAvisoSeniority_5","rdoAvisoSeniority_6","txbAvisoNowSeniorityYear","txbAvisoNowSeniorityMonth","rdoAvisoNowSeniority_0","rdoAvisoNowSeniority_1","rdoAvisoNowSeniority_2","rdoAvisoNowSeniority_3","rdoAvisoNowSeniority_4","rdoAvisoNowSeniority_5","s$QAviso$NurseBoss","s$QAviso$NurseSubChief","s$QAviso$NurseChief")

tabs["__tab_caseTab_caseTabImmediate"]:=array("chkImmediateNotify_0","chkImmediateNotify_1","chkImmediateNotify_2","chkImmediateNotify_3","chkImmediateNotify_4","chkImmediateNotify_5","chkImmediateNotify_6","chkImmediateNotify_7","chkImmediateNotify_8","chkImmediateNotify_9","chkImmediateNotify_10","chkImmediateNotify_11","chkImmediateNotify_12","txbImmediateNotify_12","chkImmediateNotify_13","chkImmediateNotify_14","chkImmediateNotify_15","txbImmediateNotify_15","chkImmediateDispose_0","chkImmediateDispose_1","chkImmediateDispose_2","chkImmediateDispose_3","chkImmediateUnconcerned_0","chkImmediateUnconcerned_1","chkImmediateUnconcerned_2","txbImmediateUnconcerned_2","chkImmediateTreatmentInterpose_0","chkImmediateTreatmentInterpose_1","chkImmediateTreatmentInterpose_2","chkImmediateTreatmentInterpose_3","chkImmediateTreatmentInterpose_4","chkImmediateTreatmentInterpose_5","chkImmediateTreatmentInterpose_6","chkImmediateTreatmentInterpose_7","chkImmediateTreatmentInterpose_8","chkImmediateTreatmentInterpose_9","txbImmediateTreatmentInterpose_9","chkImmediateOtherInterpose_0","chkImmediateOtherInterpose_1","chkImmediateOtherInterpose_2","chkImmediateOtherInterpose_3","chkImmediateOtherInterpose_4","chkImmediateOtherInterpose_5","txbImmediateOtherInterpose_5","chkImmediateFollowDispose_0","chkImmediateFollowDispose_1","chkImmediateFollowDispose_2","chkImmediateFollowDispose_3","txbImmediateFollowDispose_3","chkImmediateFollowDispose_4","chkImmediateFollowDispose_5","txbImmediateFollowDispose_5","t$QImmediate$OtherDispose")

tabs["__tab_caseTab_caseTabPrevent"]:=array("chkPreventRehappen_0","chkPreventRehappen_1","chkPreventRehappen_2","chkPreventRehappen_3","chkPreventRehappen_4","chkPreventRehappen_5","txbPreventRehappen_5","chkPreventTrain_0","chkPreventTrain_1","chkPreventTrain_2","chkPreventTrain_3","chkPreventTrain_4","txbPreventTrain_4","chkPreventTreatment_0","chkPreventTreatment_1","chkPreventTreatment_2","chkPreventTreatment_3","txbPreventTreatment_3","chkPreventManage_0","chkPreventManage_1","chkPreventManage_2","chkPreventManage_3","chkPreventManage_4","chkPreventManage_5","txbPreventManage_5","chkPreventCommunicate_0","chkPreventCommunicate_1","chkPreventCommunicate_2","chkPreventCommunicate_3","txbPreventCommunicate_3")

tabs["__tab_caseTab_caseTabRehappen"]:=array("rdoRehappenRate_0","rdoRehappenRate_1","rdoRehappenRate_2","rdoRehappenRate_3","rdoRehappenRate_4","rdoRehappenRate_5","rdoRehappenLocation_0","rdoRehappenLocation_1","rdoRehappenLocation_2","rdoRehappenLocation_3","rdoRehappenLocation_4","txbRehappenLocation_4","rdoRehappenAffect_0","rdoRehappenAffect_1","rdoRehappenHurtDegree_0","rdoRehappenHurtDegree_1","rdoRehappenHurtDegree_2","rdoRehappenHurtDegree_3","rdoRehappenHurtDegree_4")

tabs["__tab_caseTab_caseTabImprove"]:=array("t$QImprove$ImproveDesc","t$QImprove$BossComment","t$QImprove$SubChiefComment","t$QImprove$ChiefComment")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;embedded ie
Gui,font,verdana s12
COM_AtlAxWinInit()
Gui, +LastFound +Resize
;pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),top,left,width,height, "Shell.Explorer") )  ;left these here just for reference of the parameters
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN") 
OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN") 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; login

sid:=Login(loginId,loginPw)

gosub 通報網頁(&N)
;~ gosub 暫存網頁(&T)




menu,mainMenu,add,讀取設定(&R)
menu,mainMenu,add,儲存設定(&S)
menu,mainMenu,add,通報網頁(&N)
;~ menu,mainMenu,add,暫存網頁(&T)
gui,menu,mainMenu



gui,show, Maximize ,異常通報系統增強版

return





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SUBROUTINE
;選單們
讀取設定(&R):
readConfig=
FileSelectFile, readConfig, , , Open configuration, Ini file (*.ini)
if !readConfig || !RegExMatch(readConfig,".ini$")
   return
;~ gui,hide
;~ for k,v in tabs1
;~ {
   ;~ pwb.document.getElementById(v).click()
   ;~ loop
      ;~ sleep 100
   ;~ until !pwb.busy
;~ }
;~ for k,v in tabs2
;~ {
   ;~ pwb.document.getElementById(v).click()
   ;~ loop
      ;~ sleep 100
   ;~ until !pwb.busy
;~ }
;~ gui,show
;~ clipboard:=pwb.document.documentElement.innerHTML
clickedTab:=[]
loop,read,% readConfig
{
   if instr(A_LoopReadLine,"[Config]")
      continue
   RegExMatch(a_loopreadline,"([^=]+?)=([^\n]*)",match)
   if !match1
      continue
   if !elementTest(pwb,match1)
   {
      if (whichTab:=findInTabs(tabs,match1))
      {
         if findInArr(tabs2,whichTab)
         {
            pwb.document.getElementById("__tab_caseTab_caseTabEvent").click()
            loop
               sleep 200
            until !pwb.busy
         }
         pwb.document.getElementById(whichTab).click()
         Loop
            sleep 200
         until !pwb.busy
      }
   }
   if !elementTest(pwb,match1)
   {
      traytip,,% "No id of " match1
      continue
   }
   
   if ! instr(match1,"$")
      if(pwb.document.getElementById(match1).tagName="select")
         pwb.document.getElementById(match1).selectedIndex:=match2
      else if(pwb.document.getElementById(match1).type="radio" || pwb.document.getElementById(match1).type="checkbox")
         pwb.document.getElementById(match1).checked:=match2
      else
         pwb.document.getElementById(match1).value:=match2
   else
      elementTest(pwb,match1).value:=match2
   
   Loop
      sleep 100
   until !pwb.busy
}
traytip,,讀取完成,5
return

儲存設定(&S):
savedConfig=
FileSelectFile, savedConfig, S, , Save configuration, Ini file (*.ini)
if !savedConfig
   return
if !RegExMatch(savedConfig,".ini$")
   savedConfig.=".ini"
loop % pwb.document.all.tags("input").length
{
   
   if(pwb.document.all.tags("input")[a_index-1].type="hidden")
      continue
   if(pwb.document.all.tags("input")[a_index-1].id="txbAvisoDate")
      continue
   if(pwb.document.all.tags("input")[a_index-1].type="radio" || pwb.document.all.tags("input")[a_index-1].type="checkbox")
      iniwrite,% pwb.document.all.tags("input")[a_index-1].checked,% savedConfig,Config,% pwb.document.all.tags("input")[a_index-1].id
   else
      iniwrite,% pwb.document.all.tags("input")[a_index-1].value,% savedConfig,Config,% pwb.document.all.tags("input")[a_index-1].id
}
loop % pwb.document.all.tags("select").length
{
   if(pwb.document.all.tags("select")[a_index-1].type="hidden")
      continue
   iniwrite,% pwb.document.all.tags("select")[a_index-1].selectedIndex,% savedConfig,Config,% pwb.document.all.tags("select")[a_index-1].id
}
loop % pwb.document.all.tags("textarea").length
{
      continue
   iniwrite,% pwb.document.all.tags("textarea")[a_index-1].value,% savedConfig,Config,% pwb.document.all.tags("textarea")[a_index-1].name
}
traytip,,儲存完成,5
return

通報網頁(&N):
if !checkSID(sid)
   sid:=login(loginId,loginPw)
pwb.Navigate(AvisoPage "?SESSION=" sid)
waitLoaded(pwb)
pwb.document.getElementById("ctl07t4").click()
waitLoaded(pwb)
if instr(pwb.LocationURL,"General/Login.aspx")
   msgbox Try this on ANOTHER computer !
return

;~ 暫存網頁(&T):
;~ if !checkSID(sid)
   ;~ sid:=login(loginId,loginPw)
;~ pwb.Navigate(AvisoPage "?SESSION=" sid)
;~ waitLoaded(pwb)
;~ pwb.document.getElementById("ctl07t5").click()
;~ waitLoaded(pwb)
;~ if instr(pwb.LocationURL,"General/Login.aspx")
   ;~ msgbox Try this on ANOTHER computer !
;~ return




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS
elementTest(byref pwb,elementId)
{
   
   Loop % pwb.document.all.length
   {
      if (elementId=pwb.document.all[a_index-1].id)
         return pwb.document.all[a_index-1]
   }
   Loop % pwb.document.all.length
   {
      if (elementId=pwb.document.all[a_index-1].name)
         return pwb.document.all[a_index-1]
   }
   
   return 0
}
 


findInTabs(byref arr,str)
{
   for k,v in arr
      for l,m in v
         if m=str
            return k
         
   return 0
}
   
findInArr(byref arr,el)
{
   for k,v in arr
      if (v=el)
         return k
   return 0
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HOTKEYS

GuiClose:
!q::
exitapp

#IfWinActive,異常通報系統增強版
!left::
com_invoke(pwb,"Navigate","javascript:history.go(-1);void(0);")
return

F5::
com_invoke(pwb,"Navigate","javascript:history.go(0);void(0);")
return

!right::
com_invoke(pwb,"Navigate","javascript:history.go(1);void(0);")
return

#ifwinactive