﻿﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Hsu Jui-shan <physician@hospital.example.com>
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 全域設定區 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Hotstring EndChars ()[]{};'"\,.?!`n `t
SendMode Input  
SetWorkingDir %A_ScriptDir%
#WinActivateForce
SetTitleMatchMode,2
DetectHiddenWindows,on

;;;;;;;;;;;;;;;;;;;;;;;;;;;rrrr
;讀入其他ahk的腳本
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;#include %A_ScriptDir%\AutoCorrect.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; F4 暫存
F4::
click 391,1481
return

; window+w  write & send out report and enter next
#w::
WinActivate, ahk_class AcucobolWClass
Send {F9}
SetWinDelay, 100
WinActivate, IMPAX 6.2.1.149 Radiologist 
Click 709,971
Click 715,1121
Click 50,41
Click 73,369
Send X320
return

; window+f  find study and copy serial number
#f::
Send {ENTER}
Click 72,371
Send ^c
Sleep, 1000
Click 38,500
Click 2
Sleep, 200
WinActivate, ahk_class AcucobolWClass
Send ^v
Send {ENTER}
return

;1. 打完報告按Ctrl-Q關閉RIS與退出autohotkey:
^q:: ; Assign Ctrl-Q as a hotkey to quit RIS and the script.
IfWinExist ahk_class com.pohai.client.application.MainFrame
{
 WinActivate ahk_class com.pohai.client.application.MainFrame
 SendPlay !{F4}
}
ExitApp
 
 
;2. 設定Ctrl-E 叫出Notepad編輯autohotkey:
^e:: ; Assign Ctrl-E as a hotkey to edit the script.
Edit
return
 
~LButton & r:: ; 滑鼠左鍵 + r = Reload the ahk file.
Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return

;4. 設定Ctrl-0 switch to Impression
^0::
Click 28,1064
return


;5. 設定Window-1 Open the last ONE report
#1::
Click 857,570
Click 2
return

 ;6.  設定Window-2 Open the last ONE report and Copy it
#2::
Click 857,570
Click 2
Sleep 100
Click 170,400
Click 2
return


;7.  設定Window-z  Open the last ONE PACS image parallel 
; ( 1238,42 ) at report room-3 ( 1095,42 ) at room-1 & Ped-2 ( 1088,42 ) at CT & room-4
#3::
Click 857,570
Click right
Sleep 200
Click right 1012,650
Sleep 200
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return


; open the images parallel...
#4::
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 26,579
return

; send out report and enter next in IMPAX 6.2
#s::
WinActivate, ahk_class AcucobolWClass
Send {F9}
SetWinDelay, 100
WinActivate, IMPAX 6.2.1.149 Radiologist 
Click 810,590
Click 810,740
Click 650,50 
Click 1165,1520
Click 100,430
Click 2
SetWinDelay, 100
WinActivate, ahk_class AcucobolWClass
Send X321
return

; 自動啟動 RIS + IMPAX + N hospital 並輸入帳號密碼
#r::   ; 按Win-key + r 鍵自動啟動
ris="http://10.0.0.100:8888/NH/NH.jnlp"
impax="C:\impax\select\bin\impax_select.exe"
uname=017295   ;RIS和IMPAX的帳號 (6位數字員工代號)
rpasswd=6          ;RIS密碼
ipasswd=6          ;IMPAX密碼

Run, %impax%,,,
WinWait,登入,,,,
WinActivate,ahk_class ThunderRT6FormDC,,,
control,editpaste,%uname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,
control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,
controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,

Run, %ris%,,,
Winwait, Login,,,,
WinActivate,ahk_class SunAwtDialog,,,
winget,rpid,PID, ahk_class SunAwtDialog,,,
controlsend, ,%uname%{enter}, ahk_pid %rpid%
controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%
Return




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Hotstrings-Phrase
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;常用器官單字片語
::B::bilateral
::R::right
::L::left

::CW::compatible with
::SG::The finding is suggestive of 
::SP::s/p
::RO::r/o
::W::with
::WO::without
::WNL::within normal limit.
::ND::no definite
::NE::no evidence of
::CBE::can't be excluded.
::PRA::presenting as
::COMW::as compared with prior study on 2011//
::COMWS::The size of the lesion is stationary as compared with prior study on 2011//
::OP::postoperative change 
::AX::axilla
::AXL::left axillary region
::AXR::right axillary region
::AXS::axillae
::ESO::esophagus
::TORAC::tortuous aorta with atherosclerotic change
::TORA::tortuous aorta
::CA::calcification of aorta
::MW::mediastinal widening
::PE::pleural effusion
::PEB::bilateral pleural effusion
::BBL::bilateral basal lungs
::BR::breast
::UA::upper abdomen
::BBR::bilateral breasts
::GB::gallbladder
::GS::gallstone
::FL::fatty liver
::SPL::spleen
::SPLM::splenomegaly
::CAM::cardiomegaly
::NHS::normal heart size
::PAN::pancreas
::KID::kidney
::RCR::right renal cyst
::RCL::left renal cyst
::RCB::bilateral renal cysts
::RCBT::bilateral tiny renal cysts
::ADR::adrenal gland
::ADRS::adrenal glands
::PV::portal vein
::MED::mediastinum
::BKJ::bilateral knee joints
::LN::lymph node
::LNS::lymph nodes
::LAP::lymphadenopathy
::BM::bone marrow
::FX::fracture
::NSOLID::there is no definite lesion in liver, gallbladder, spleen, pancreas, bilateral kidneys, or adrenal glands.
::NBL::There is no definite focal lesion in the basal lungs or bone window settings. 
::ART::atherosclerotic change with mural calcification of the aorta.
::THY::multiple low densities in bilateral thyroid. 
::AAP::abdomen and pelvis
::SSD::Due to inadequate SSD and degraded imaging quality, the diagnostic value of the plain radiography might be compromised. Advise further imaging study while the patient's condition becomes stable. 


::LN0::no definite enlarged (>1cm) lymphadenopathy is recognized in the visible field of this study.
::LNA::there is no evidence of paraaortic LAPs in abdomen.
::LNP::there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
::LNAX::Bilateral small axillary lymph nodes.
::LNAXR::small right axillary lymph nodes.
::LNAXL::small left axillary lymph nodes.
::LNM::small nonspecific lymph nodes at mediastinum.
::LNAXM::bilateral small mediastinal and axillary lymph nodes.
::LNHM::no definite mediastinal or hilar lymphadenopathy.
::LNAXBB::benign appearing bilateral axillary nodes with fat hilum.
::LNAXBR::benign appearing right axillary nodes with fat hilum.
::LNAXBL::benign appearing left axillary nodes with fat hilum.
::LNAXC::no definite LAP at bilateral axillae or anterior chest wall. 
::LNN::no obvious abnormally enlarged LAPs in bilateral neck.


::LAP::lymphadenopathy.
::LAPAX::axillary lymphadenopathy.
::LAPM::mediastinal lymphadenopathy.
::LAPHM::mediastinal and hilar lymphadenopathy.
::LAPAXM::bilateral mediastinal and axillary lymphadenopathy.
::LAPA::lymphadenopathy at paraaortic region.
::LAPAM::lymphadenopathy at paraaortic and mesentaric region.




;前言後敘
::CONSULT::We will evaluate this patient. Thank you for your consultation.
::HX::History of
::H::Hx:
::HXN::Clinical history is not available.
::CI::Clinical information:
::AFP::AFP ng/ml (2011/04/

::FS::For screening. 
::FU::For follow-up.
::CU::For check up.
::FHC::For health check up.
::SUB::Suboptimal study due to
::CAP::Chest AP view shows
::CPA::Chest PA view shows
::CL::Chest lateral view shows
::KS::KUB shows:
::C::CT of the
::M::MRI of the
::TRIKID::Triphase dynamic abdominal CT study (pre-, arterial- and portal venous phases) for the kidney shows:
::TRILIVER::Triphase dynamic abdominal CT study (pre-, arterial- and portal venous phases) for the liver shows:
::CTAP::Biphasic abdominal and pelvis CT, without and with contrast enhancement shows:
::WWS::without/with contrast enhancement shows:
::WS::with contrast contrast enhancement shows:
::WOS::without contrast enhancement shows: 
::CCT::CT of the chest without and with contrast enhancement is read without prior study for comparison. This CT study shows: 
::CCT0::CT of the chest without and with contrast enhancement is read and compared with prior study dated on 2011--. This CT study shows:

::AC::suggest clinical correlation and follow up. 
::ACI::advise correlate with other imaging study, if clinically indicated.
::ACO::however, small osseous or soft tissue lesion(s) may not be detected by the plain radiography. Advise correlate with other imaging study, if clinically indicated. 
::ACC::Advise correlate with chest CT. 

::ACH::Please correlate with the imaging findings and report of the head CT study.
::ACC::Please correlate with the imaging findings and report of the chest CT study.
::ACA::Please correlate with the imaging findings and report of the abdomen/pelvis CT study.

::XX::However, this is a tentative report only. If your patient may be discharged and followed up at OPD, re-check the formal report is suggested.
::YY::(HJS/Dr.YCC)
::WW::(HJS/Dr.WJL)
::JJ::(HJS/Dr.JW)

;;abdominal CT區;;
::SL::smooth liver surface
::LC::coarse surface with multiple nodularity of liver, compatible with liver cirrhosis. 
::LCS::liver cirrhosis with splenomegaly.
::LCSS::liver cirrhosis with splenomegaly. No evidence of EV, GV, ascites, or splenorenal shunts.
::EV::Hyperemic venous plexus surround lower segment of esophagus, paraesophageal varices is considered.  
::DN::dysplasia nodule
::DNS::dysplasia nodules
::PPH::hepatic veins and portal veins are patent
::CHRL::Smooth liver surface with sharp bilateral hepatic tips. Elongation of left hepatic lobe and prominent caudate lobe.  Patent PV.  This is not compatible with cirrhosis of liver but chronic liver diseasre may be present.
::APP::Diffuse swelling (cm) of appendix with adjacent fat infiltration and an appendicolith in the distal appendix. Compatible with acute appendicitis. 
::ACHO::Multiple hyperdense gall stones at dependent part; a 1cm gall stone at gall bladder neck. Distended gall bladder with peripheral fluid accumulation and infiltration, in association with hyperemic change of the adjacent liver parenchyma. Acute cholecystitis is considered. 
::EP::Enlargement with central zone calcfication of prostate gland. 
::NPH::No pneumoperitoneum or hemoperitoneum.
::PTAE::Status post TAE, multiple lipiodol retension at
::LOC::no evidence of local recurrence is noted
::FUN::functioning or non-functioning status should be correlated with clinical findings.
::NAS::there is no ascites. 
::UGI::Unremarkable gastrointestinal tract.
::UCHO::The CT diagnosis of acute cholecystitis is less sensitive and less specific than ultrasonography. The surrounding fat planes are still clear. 
::OU::obstructive uropathy


;;Chest CT區;;
::NP::nonspecific
::NPL::nonspecific lung parenchymal change
::NPN::a tiny nonspecific lung nodule
::NPNS::tiny nonspecific lung nodules
::SE::(SE IM)
::NAD::no definite abnormality of both adrenals. 
::B0::no definite abnormal bone change of this study.
::SA::subsegmental atelectasis
::ATX::atelectasis
::LSA::linear subsegmental atelectasis
::BEC::bronchiectasis
::NSOC::Unremarkable imaged spleen, pancreas, gallbladder and adrenals. 
::NPPE::No evidence of pneumothroax. No definite filling defect within major branches of pulomary arteries.

;;Neuro CT神放;;
::OPN::postoperative change at nasal septum. 
::OPNC::s/p craniectomy with postoperative change at fronal-temporal-parietal region.
::OLD::Old insult with parenchymal loss at


;;Neuro MRI神放;;
::DW::no abnormal bright up on DWI
::SW::no abnormal hemosiderin deposition on SWI.
::SW0::SWI shows diffuse and multiple susceptibiltiy effects at bilateral cerebral, cerebellar hemispheres, basal ganglia, and brainstem, r/o small vessel cerebrovascular disease.
::CVS::the cranial vault and skull base appear normal.
::VS::symmetrical sulci, fissures and bilateral lateral ventricles. 
::VS1::mild brain atrophy with dilated and symmetrical sulci, fissures and ventricles.
::NBR::no obvious focal signal change in the brain.
::LEUC::Confluent hypodensity at bilateral frontal-parietal white matter, suggestive of leukoaraiosis.
::LEUM::Multiple confluent small hyperintense patches at bilateral frontal-parietal white matter on FLAIR, suggestive of leukoaraiosis.
::SINU::Mucosal thickening in paranasal sinuses.
::SINU0::the paranasal sinuses are clear.
::PW::periventricular white matter
::TCA::TOF MRA of circle of Willis and contrast-enhanced MRA of cervicocranial vessels appear normal.
::TA::TOF MRA of circle of Willis appears normal.

::AWC::Atherosclerosis with calcification
::VTSHUNT::Placement of a ventricular shunt from frontal region.
::VPSHUNT::Placement of a ventriculoperitoneal shunt tube. 
::BG::basal ganglion
::BGS::bilateral basal ganglia


;描述finding單字片語
::ARD::architectural distortion
::SI::signal intensity
::T2::T2WI
::T1::T1WI
::HO1::hypointensity on T1WI
::HE1::hyperintensity on T1WI
::HO2::hypointensity on T2WI
::HE2::hyperintensity on T2WI
::ISO1::isointensity on T1WI
::ISO2::isointensity on T2WI
::HEE::hyperechoic
::HOE::hypoechoic
::ANE::anechoic
::ISE::isoechoic
::WD::well-defined
::ID::ill-defined
::EN::enhancement
::POS::posterior shadowing
::POE::posterior enhancement
::MSA::magnetic susceptibility artifacts
::MA::motional artifacts
::MAR::respiratory motion artifacts make less sensitivity and specific quality.
::MOR::more on right side
::MOL::more on left side
::NLL::no definite lung lesion is noted
::NL::no evidence of focal lesion in

;Breast區
::MRMB::History of bilateral breast cancer s/p MRM. For follow-up. 
::MRMR::History of right breast cancer s/p MRM. For follow-up.  
::BCTL::History of left breast cancer s/p BCT. For follow-up. 
::BCTR::History of right breast cancer s/p BCT. For follow-up. 
::BCTB::History of bilateral breast cancer s/p BCT. For follow-up. 
::BCTM::History of breast cancer s/p BCT with marking wire
::FH::family history of breast cancer (sister/mother/grandmother)
::HRT::History of HRT.
::HM::History of menopause.


::BCM0::Digital mammograms of both breasts in CC and MLO views are read with prior mammograms on  for comparison. This study shows: 
::BCM0J::Bilateral MLO and CC are read and compared with prior mammograms dated
::BCM::Digital mammograms of both breasts in CC and MLO views is read without prior study available for comparision. This study shows:
::BCMJ::Bilateral MLO and CC are read without prior mammograms available for comparison.
::MAG::spot magnification view

::MD1::The breast is almost entirely fat.
::MD2::There are scattered fibroglandular densities.
::MD3J::The breast tissue is heterogeneously dense, which could obscure detection of small masses. 
::MD3::Heterogeneously dense fibroglandular tissue of both breasts which may decrease the sensitivity of this study (approximately 51-75% of glandular tissue). 
::MD4::The breast is extremely dense. This may lower the sensitivity of mammography.

::NMM::There is no definite mass, focal suspicious microcalcifications, or architectural distortion in this study.
::NMMJ::There are no definite worrisome mass, and no architectural distortion in this study. 
::MOP::Focal parenchymal loss, architectural distortion and skin retraction are noted at left upper outer breast under the wire, compatible with postoperative change.
::MSUG::suggest breast ultrasound correlation and right mag. views.
::SFU::Suggest follow up.
::MN::There are no definite mass, no suspicious microcalcifications, or architectural distortion in this study.

::FC::fibrocystic change
::FAS::focal asymmetry
::MIC::microcalcifications
::BUN::No definite focal mass lesion detected in this study. 
::BCABJ::There are benign scattered and regional calcifications present bilaterally.
::BCAB::bilateral benign calcifications.
::BCAV::There are benign appearing vascular wall calcifications at bilateral breasts.
::CYSB::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, r/o simple cysts and or fibroadenoma, size up to cm
::CYSL::a round, well-defined, anechoic to hypoechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of a cyst.
::CYSR::a round, well-defined, anechoic to hypoechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of a cyst.
::CYSM::Multiple round, well-defined, hypoechoic lesions with distinct margin and posterior enhancement at bilateral breasts. The largest one at right breast is /, sized cm. The largest one at left breast is /, sized cm, suggestive of cysts. 
::FAD::fibroadenoma
::FAL::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma.
::FAR::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma.
::FAM::Multiple oval, parallel, hypoechoic lesions with distinct margin at bilateral breasts. The largest one at right breast is / region, sized cm. The largest one at left breast is / region, sized cm, r/o fibroadenomas. 
::LNAXL::benign appearing node at left axilla, size , having fat hilum.
::LNAXR::benign appearing node at right axilla, size , having fat hilum. 
::LNAXB::benign appearing node at bilateral axillae, size , having fat hilum. 
::b0u::ACR BI-RADS 0, indeterminate ultrasonographic finding (need additional imaging evaluation). Suggest breast mammogram correlation.
::b1u::ACR BI-RADS 1, no definite abnormal finding in this study. Suggest annual follow up or at the recommendation of the patient's physician.
::b2u::ACR BI-RADS 2, benign finding. Suggest annual follow up or at the recommendation of the patient's physician.
::b3u::ACR BI-RADS 3, probably benign finding. Suggest 6-month interval follow up.
::b4u::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.
::b6u::ACR BI-RADS 6, breast findings confirmed to be malignant. Suggest further appropriate treatment.
::b0m::ACR BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation). Suggest targeted breast ultrasound or magification spot view correlation.
::b1m::ACR BI-RADS 1, negative finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician.
::b2m::ACR BI-RADS 2, benign finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. (if there is any clinical relevant finding, ultrasound is suggested)
::b2md::ACR BI-RADS 2, dense breasts; benign finding. Suggest annual follow up and ultrasound correlation if palpable mass.
::b3m::ACR BI-RADS 3, probably benign finding. Suggest 6-month mammogram follow up.
::b4m::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.
::b6m::ACR BI-RADS 6, breast findings confirmed to be malignant. Suggest further appropriate treatment.

::B1MY::Negative mammographic finding (ACR BI-RADS category 1). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::B2MY::Benign mammographic finding (ACR BI-RADS category 2). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::B3MY::Probably benign mammographic finding (ACR BI-RADS category 3). Suggest short term follow up and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.

;angio區
::AANGIO::Abdominal angiography of 
::CHA::common hepatic artery
::RHA::right hepatic artery
::LHA::left hepatic artery
::RC1::is performed by 4.1Fr RC1 catheter
::MICRO::2.7Fr Progreat microcatheter
::RTA::right transfemoral approach
::CORK::Corkscrew appearance of intrahepatic vessels, indicating liver cirrhosis.


;CXR區;
;;;;位置描述;;;;
::RL::right lower lung field
::LL::left lower lung field
::RU::right upper lung field
::LU::left upper lung field  
::RM::right middle lung field
::LM::left middle lung field 
::LF::lung field
::LFS::lung fields



;;;;罐頭片語;;;;
::C0::Chest PA shows normal heart size and no definite lung lesion.
::C1::Chest PA shows cardiomegaly, tortuous aorta and no definite abnormal lung opacity.
::C0OP::Chest PA shows normal heart size, no definite abnormal lung lesion and postoperative change of the mediastinum with placement of multiple sternal wires.
::C0TORA::Chest PA shows normal heart size, no definite lung lesion and tortuous aorta.

::CL0::Chest lateral view shows no definite abnormality. Suggest correlation with chest PA. 
::CL1::Chest lateral view shows cardiomegaly and no definite abnormal opacity. Suggest correlation with chest PA.

::CABG::Chest PA shows cardiomegaly and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CABG0::Chest PA shows normal heart size and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CMABD::Chest AP shows cardiomegaly, marked abdominal distention and lower lung capacity. Suggest clinical correlation.

::ICUDTRANG::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of a tracheostomy tube and a NG tube.
::ICUDTUBE::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of an endotracheal tube, a central venous catheter and a NG tube.
::ICUPL::Chest AP shows cardiomegaly, bilateral consolidation and pleural effusion.
::ICUTRA::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy tube.
::ICUTRANG::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy and a NG tubes.
::ICUTUBE::Chest AP shows cardiomegaly, bilateral consolidation and placement of an endotracheal tube, a NG tube and central venous catheter(s).
::ICUWIRE::Chest AP shows cardiomegaly, bilateral consolidation and placement of sternal wires.

::ICU::Chest AP shows cardiomegaly and bilateral consolidation.
::ICU0::Chest AP shows normal heart size and bilateral consolidation.
::ICUCUFF::Chest AP shows cardiomegaly and bilateral peribronchial cuffing.
::ICUCUFF0::Chest AP shows normal heart size and bilateral peribronchial cuffing.
::ICUD::Chest AP shows cardiomegaly and bilateral diffuse consolidation.
::ICUP::Chest AP shows cardiomegaly and bilateral patchy consolidation. 
::ICUDI::Chest AP shows cardiomegaly. bilateral diffuse consolidation and increased infiltration.
::ICUPI::Chest AP shows cardiomegaly. bilateral patchy consolidation and increased infiltration.
::ICUD0::Chest AP shows normal heart size and bilateral diffuse consolidation.
::ICUP0::Chest AP shows normal heart size and bilateral patchy consolidation. 
::ICUDI0::Chest AP shows normal heart size. bilateral diffuse consolidation and increased infiltration.
::ICUPI0::Chest AP shows normal heart size. bilateral patchy consolidation and increased infiltration.
::ICUDPE::Chest AP shows cardiomegaly, bilateral diffuse consolidation and pleural effusion.
::ICUDPE0::Chest AP shows normal heart size, bilateral diffuse consolidation and pleural effusion.

::APTB::bilateral apical pleural thickening
::APTBC::bilateral apical pleural thickening with calcification
::APTR::right apical pleural thickening
::APTL::left apical pleural thickening
::OBSCL::obscured left lateral costophrenic angle
::OBSCR::obscured right lateral costophrenic angle
::OBSCB::obscured bilateral costophrenic angles
::SCP::bilateral costophrenic angles are sharp 
::CUFF::peribronchial cuffing
::FXRR::fracture of right ribs
::FXRL::fracture of left ribs
::FXRB::fracture of bilateral ribs

::EDL::elevated left diaphragm.
::EDR::elevated right diaphragm.
::GGO::ground glass opacity (GGO)
::HI::prominent bilateral hilar shadows
::HIL::prominent left hilar shadow
::HIR::prominent right hilar shadow
::BAPT::bilateral apical pleural thickening
::BAPTC::bilateral apical pleural thickening with calcification
::LAPT::left apical pleural thickening
::LAPTC::left apical pleural thickening with calcification
::RAPT::right apical pleural thickening
::RAPTC::right apical pleural thickening with calcification
::APTC::apical pleural thickening and calcification
::CON::consolidation
::COND::bilateral diffuse lung consolidation
::CONP::bilateral patchy consolidation
::CONR::right lung consolidation
::CONL::left lung consolidation
::PIB::increased bilateral perihilar infiltration
::INF::increased infiltration

;;;;外來物區;;;;
::PAC::port-A catheter
::DJ::s/p double J catheter insertion from pelvic cavity into renal region over  side
::NG::placement of a nasogastric tube
::POAL::placement of a left port A catheter
::POAR::placement of a right port A catheter
::CVCR::placement of a right central line
::CVCL::placement of a left central line
::CVCET::placement of central venous catheter(s) and an endotracheal tube
::CVCNG::placement of central venous catheter(s) and a NG tube
::CVCTRA::placement of a tracheostomy tube and central venous catheter(s)
::ET::placement of an endotracheal tube
::ETNG::placement of an endotracheal tube and a NG tube
::ETCVC::placement of central venous catheter(s) and an endotracheal tube
::NGCVC::placement of central venous catheter(s) and a NG tube
::CVCTRA::placement of a tracheostomy tube and central venous catheter(s)
::NGET::placement of an endotracheal tube and a NG tube
::NGTRA::placement of a tracheostomy tube and a NG tube 
::3T::placement of an endotracheal tube, a NG tube, and a central venous line
::3Ts::placement of an endotracheal tube, a NG tube, and central venous lines 
::TRA::placement of a tracheostomy tube
::TRANG::placement of a tracheostomy tube and a NG tube
::TRACVC::placement of a tracheostomy tube and central venous catheter(s)
::TRATUBE::placement of a tracheostomy tube, a NG tube and a central venous catheter
::CHTR::placement of right chest tube(s)
::CHTL::placement of left chest tube(s)
::CHTB::placement of bilateral chest tubes
::MT::mediastinal drainage tube(s)
::PM::placement of a cardiac pacemaker
::SGC::placement of a Swan-Ganz catheter
::OPW::postoperative change with sternal wiring
::OPCW::postoperative change with sternal wiring and metallic clips at the mediastinum
::OPS::postoperative change with sutures at 
::OPC::postoperative change with metallic clips at
::CV::placement of a cardiac valve


::LO::low lung capacity.
::BLO::bilateral low lung capacity. 
::EM::pulmonary emphysema
::SQEM::subcutaneous emphysema



;KUB區;
::K0::Clear bilateral psoas shadows. Unremarkable small bowel gas pattern. No evidence of abnormal calcification or radiopaque lesion.
::KU::Non-specific bowel gas distribution is noted. Bilateral psoas shadows are clear. No definite radiopaque density is noted in the urinary collecting system. Suggest correlation with clinical manifestations. 
::STAN::Standing film of abdomen shows no subphrenic free air. Bilateral sharp CP angles. Unremarkable intestinal air pattern. No definite radiopaque lesion in the abdomen.

::ILE::Increased bowel gas and fluid retention are noted in the abdomen, compatible with ileus.
::ILEM::Markedly increased bowel gas is noted in the abdomen, compatible with prominent ileus. 
::ILES::Slightly increased bowel gas is noted in the abdomen, compatible with mild ileus.

::RSOB::The bilateral renal shadows are obscured by the bowel gas and content.
::RSOL::The left renal shadow is obscured by the bowel gas and content.
::RSOR::The right renal shadow is obscured by the bowel gas and content.
::PSOB::The bilateral psoas shadows are obscured by the bowel gas and content.
::PSOL::The left psoas shadow is obscured by the bowel gas and content.
::PSOR::The right psoas shadow is obscured by the bowel gas and content.
::RPS::The bilateral psoas and renal shadows are obscured by the bowel gas and content.
::P0::Bilateral psoas shadows are clear.
::RP0::The psoas and renal shadows are clear on both sides.
::HSS::The hepatic and splenic shadows are within normal limit.
::RS0::No evidence of radiopaque lesion is shown in urinary tracts.
::RSR::some radiopaque lesion superimposed on right renal shadow, r/o right renal stone. 
::RSL::some radiopaque lesion superimposed on left renal shadow, r/o left renal stone.
::PHLE::Radiopaque lesion(s) at the lower pelvis, compatible with phlebolith(s).
::BO0::Unremarkable bowel gas pattern.
::FEC::Increased fecal material in the abdomen is noted.
::SPO::spondylosis with marginal spur formation of the
::SPOL::spondylosis with marginal spur formation of the lumbar spine.
::SPOTL::spondylosis with marginal spur formation of the throacolumbar spine.
::BBT::Basal identation of the bladder trigone, compatible with enlargement of prostate gland.  amount of residual urine. 





;Ortho區
::LSP::lumbar spine
::CSP::cervical spine
::TSP::throacic spine
::TLSP::throacolumbar spine
::THR::total hip replacment.
::TKR::total knee replacement.
::TE::traction enthesophyte formation over the 
::TRFX::(previous) transverse fracture(s) at the 
::SB::suprapatellar bursa(e). 
::KJ::knee joint
::RKJ::right knee joint.
::LKJ::left knee joint
::BKJ::bilateral knee joints.

::IE::increased joint effusion(s) in the
::IE0::no evidence of abnormal joint effusion in the
::NB::no evidence of focal bony or joint lesion. No evidence of fracture or dislocation.
::NA::normal alignment of
::NAB::normal alignment of bony structures.

::CS::cervical spondylosis with posterior spur formation at the 
::CS1::cervical spondylosis with disc space narrowing and posterior spur formation at the 
::CS1M::cervical spondylosis with disc space narrowing and posterior spur formation at multiple levels. 
::CS2::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomenon and posterior spur formation at the 
::CS2M::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomena and posterior spur formation at multiple levels.
::CSM::cervical spondylosis with posterior spur formation at multiple levels. 
::ACAA::atherosclerotic change of the abdominal aorta and its bifurcation.
::DCSF::degenerative change of the spine with marginal spur formation.
::DACB::degenerative arthrosis of the bil. acromioclavicular joints with marginal spur formation. 
::DACL::degenerative arthrosis of the left acromioclavicular joint with marginal spur formation. 
::DACR::degenerative arthrosis of the right acromioclavicular joint with marginal spur formation. 
::LS::lumbar spondylosis with marginal spur formation at the 
::LS1::lumbar spondylosis with disc space narrowing and marginal spur formation at the 
::LS1L::lumbar spondylosis with disc space narrowing and marginal spur formation at the lower lumbar levels. 
::LS1M::lumbar spondylosis with disc space narrowing and marginal spur formation at multiple levels. 
::LS2::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomenon and marginal spur formation at the 
::LS2L::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at the lower lumbar levels. 
::LS2M::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at multiple levels. 
::LSL::lumbar spondylosis with marginal spur formation at the lower lumbar levels. 
::LSM::lumbar spondylosis with marginal spur formation at multiple levels. 
::SIJ::sacroiliac joint

::NFX::No definite fracture line can be identified.
::NF::neural foramen
::MCL::medial collateral ligament
::LCL::lateral collateral ligament
::L.::ligament
::PCL::posterior cruciate ligament
::ACL::anterior cruciate ligament
::FAA::facet arthroses 
::FAAL::facet arthroses at the lower lumbar levels. 
::NFN::neural foraminal narrowing
::NNFB::no evidence of neural foraminal narrowing on both sides. 
::NIDH1::no evidence of intervertebral disk herniation or neural foraminal narrowing. 
::SUBO::suboptimal study due to underexposure/overexposure/rotation/motion artifacts/improper postioning (malpositioning)
::DEV::Status post external cast/splint application and the bony detail may be obliterated
::ESF::s/p external splint fixation.
::CF::s/p casting fixation.
::BAB::s/p bipolar arthroplasty with postoperative changes at the bil. hip joints. 
::SSP::scoliosis of the spine, probably due to positioning factor.
::CS::cervical spondylosis with posterior spur formation at multiple levels.
::OSP::osteopenia of the visible bony structures. 
::OA1::minimal osteoarthritis with subtle or tiny marginal spur formation at the 
::OA2::mild osteoarthritis with small or tiny marginal spur formation at the 
::OA3::moderate osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OA4::advanced osteoarthritis with joint space narrowing, uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::C21::C2-3, C3-4, C4-5, C5-6, C6-7 and C7-T1 levels. 
::C23::C2-3 level. 
::C24::C2-3 and C3-4 levels. 
::C25::C2-3, C3-4 and C4-5 levels. 
::C26::C2-3, C3-4, C4-5 and C5-6 levels. 
::C27::C2-3, C3-4, C4-5, C5-6 and C6-7 levels. 
::C31::C3-4, C4-5, C5-6, C6-7 and C7-T1 levels. 
::C34::C3-4 level. 
::C35::C3-4 and C4-5 levels. 
::C36::C3-4, C4-5 and C5-6 levels. 
::C37::C3-4, C4-5, C5-6 and C6-7 levels. 
::C41::C4-5, C5-6, C6-7 and C7-T1 levels. 
::C45::C4-5 level. 
::C46::C4-5 and C5-6 levels. 
::C47::C4-5, C5-6 and C6-7 levels. 
::C51::C5-6, C6-7 and C7-T1 levels. 
::C56::C5-6 level. 
::C57::C5-6 and C6-7 levels. 
::C61::C6-7 and C7-T1 levels. 
::C67::C6-7 level. 
::C71::C7-T1 level. 
::T121::T12-L1 level. 
::T12E::type 1 and 2 endplate change(s) at the 
::T13E::type 1 and 3 endplate change(s) at the 
::T1E::type 1 endplate change(s) at the 
::T1EC::type 1 endplate change(s) at the 
::T23E::type 2 and 3 endplate change(s) at the 
::T2E::type 2 endplate change(s) at the 
::T2EC::type 2 endplate change(s) at the 
::T3E::type 3 endplate change(s) at the 
::T3EC::type 3 endplate change(s) at the 
::L11::L1-2, L2-3, L3-4, L4-5 and L5-S1 levels. 
::L12::L1-2 level. 
::L13::L1-2 and L2-3 levels. 
::L14::L1-2, L2-3 and L3-4 levels. 
::L15::L1-2, L2-3, L3-4 and L4-5 levels. 
::L1MC::left 1st metacarpal 
::L1MT::left 1st metatarsal 
::L1O2::L1 on L2 
::L21::L2-3, L3-4, L4-5 and L5-S1 levels. 
::L23::L2-3 level. 
::L24::L2-3 and L3-4 levels. 
::L25::L2-3, L3-4 and L4-5 levels. 
::L31::L3-4, L4-5 and L5-S1 levels. 
::L34::L3-4 level. 
::L35::L3-4 and L4-5 levels. 
::L41::L4-5 and L5-S1 levels. 
::L45::L4-5 level. 
::L51::L5-S1 level. 
::TKRB::s/p total knee replacement with postoperative changes on both sides. 
::TKRL::s/p total knee replacement with postoperative changes on left side. 
::TKRR::s/p total knee replacement with postoperative changes on right side. 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 以下為中文片語區
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

::B0C::
  clipboard=性質未定之乳房攝影發現，建議乳房超音波對照，與放大攝影。
  Send ^v
  return
::b1c::
  clipboard=乳房攝影無異常發現，建議每年追蹤，若有臨床可觸摸之腫塊或已知之超音波異常則需乳房超音波檢查。
  Send ^v
  return
::b2c::
  clipboard=良性乳房攝影發現建議每年追蹤，若有臨床可觸摸之腫塊或已知之超音波異常則需乳房超音波檢查。

  Send ^v
  return
::B3C::
  clipboard=可能為良性乳房攝影發現。建議短期追蹤，若有臨床可觸摸之腫塊或已知之超音波異常則需乳房超音波檢查。
  Send ^v
  return
::B4C::
  clipboard=疑似不正常的乳房攝影發現，建議乳房超音波對照。
  Send ^v
  return
::LBC::
  clipboard=左乳
  Send ^v
  return
::RBC::
  clipboard=右乳
  Send ^v
  return
::BBC::
  clipboard=雙乳
  Send ^v
  return

::b2cd::
  clipboard=緻密型乳房，無異常乳房攝影發現，但乳房攝影的敏感度會因此減低，甚至遮蔽病灶。若摸到腫塊，則需施行乳房超音波對照。
  send ^v
  return
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 罐頭區
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

::BXB::
(After the patient signed the informed consent,
1. Ultrasound-guided FNAC for the right axillary LYMPHADENOPATHY by 22-G long spinal needle.
2. Ultrasound-guided large core biopsy for the right 12-1 o'clock mass by 16G biopsy gun with 15-G coaxial sheath (4 specimens were retrieved)
The patient tolerated the procedure well.

BI-RADS 5, right, post-FNAC for right axillay LAP, and core biopsy for right breast mass. Suggest persue final result.
)

::NOPL::
(
1. s/p left mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in right breast. 
3. No definite LAP at bilateral axillae, supraclavicular regions, or anterior chest wall. 
)

::NOPR::
(
1. s/p right mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in left breast. 
3. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
)



::BXM::    ;CT-guided mediastinum biopsy  M=mediastinum
(
CT-guided biopsy of the mediastinal mass is performed in  position with the use of a 19G coaxial guiding needle and a 20G biopsy needle:
-- Location of the lesion: mediastinal mass (about 9cm at the largest transverse diameter) (SE3 IM27). There is small pericardial effusion.
-- Underlying lung condition: no obvious emphysema.
-- Total length of the needle from skin to lesion: 3.4 cm. The needle is placed through right parasternal region to avoid penetration of internal mammary vessels and some prominent tumor vessels.
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 1
-- Pneumothorax: nil
-- Hemothorax: nil
-- Hemoptysis: nil
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: supine
-- There are total 1 tissue stripe, 4 imprint smears obtained for pathology and cytology studies. Suggest complete bed rest for 4 hours in supine position and follow up chest radiography 6 hours later after biopsy.

IMPRESSION:
Anterior mediastinal mass, status post CT-guided biopsy.
)



::CHMRM0::                       ;chest MR for mediastinum
(
Purpose: History of atypical chest pain, r/o mediastinal mass lesion clinically.
Pulse sequences: EKG-gating coronal and axial T2 TrueFISP, axial T1 HASTE with/without fat suppression for morphology of mediastinum. 
MR findings:
* mild cardiomegaly. Left side aoric arch and descending aorta with normal three cephalic branches. 
* no eveidence of abnormal mass lesion is noted in mediastinum. Please correlate with clinical findings. 
* lung can't be well evaluated in MR study.

IMP:
no eveidence of mediastinal mass.  
)



::CHMRLVOT0::              ;chest MR for LVOT normal Form
(
Purpose: History of subvalvular aortic stenosis causing LVOT obstruction and LV hypertrophy s/p Morrows operation and aortoplasty. For post-op LVOT and LV function.
Pulse sequences: ECG-gating axial and sagittal T1WI dark blood HASTE and T2 TrueFISP cine. 
MR findings: 
* increased diameter of LVOT and supravalvular ascending aorta (about 2.8 cm) as compared with the previous MR (pre-operation) in 2007/09/11. The cross sectional area of the LVOT at end systole measures about 3.0 cm^2.     
* moderate aortic regurgitation and mitral regurgitation. Mild trucuspid regurgitation.
* no definite hypertrophy of the LV wall.
* LV function: To be continued
)



::CHMRDAA::
(
Purpose: aortic dissection, Stanford type B, for follow up.
Pulse sequences: ECG-gating T1W dark blood HASTE, and T2W TrueFISP.
MRI findings:
* aortic dissection from proximal descending aorta down to bil common iliac arteries. Both true lumen and false lumen are patent. There is mild partial thrombus in the false lumen. The maximal diameter of the descending aorta measures about 5.5 cm. As compared with the previous MRI study on 2007-07-04, it was 5.2 cm. Progressive enlargement of the aneurysm is impressed. The diameter of the ascending aorta measures about 4.5 cm. 
* The celiac trunk, SMA, and right renal artery arise from the true lumen. The orifice of the left renal artery seems to arise from the false lumen. Atrophy of the left kidney is noted.
* mild bilateral pleural effusions.
* The maximal diameter of the abdominal aorta measures about 4.3 cm at the level just above the celiac trunk.
IMP:
Aortic dissection, Stanford type B. Progressive enlargement of the aneurysm in the descending aorta.
)

::CHMRAOV::
(
Hx: Marfan's syndrome, for evaluation of aorta and valvular function.
Pulse sequences: ECG-gating T1 HASTE axial and coronal, T2 TrueFIST axial views, and TrueFISP cine for evaluation of AR. 
MRI findings:
1. Annuloaortic ectasia, with dilatation of the sinuses valsalva into ascending aorta, and with the maximal diameter measured 6 cm at the aortic root and 4.2 cm at the ascending aorta. 
2. No definite aortic dissection. 
3. No obvious AR. 

IMP: annuloaortic ectasia, without obvious aortic dissection or AR.
)

::CHMRCAD::
(
Purpose: CAD, 3VD, ICMP, s/p CABG, AVP, MVP, TVP and SAVER. For LV function.
Pulse sequences: ECG-gating TrueFISP cine for LV function, and post-Gd IR-prepped segmented TurboFLASH for myocardial scarring.
MRI findings:
* relatively reduced sizes of LV and LA. There is no transvalvular regurgitation or stenosis.
* relatively improved contractility of the LV walls at basal and mid LV level. The LV apex is separated from the main LV cavity by a disk. Akinesia of the wall of the LV apex and a small mural thrombus are noted. 
* hyperenhancement (>50% transmurality) at the akinetic segments mentioned above. There is diffuse faint hyperenhancement of the LV myocardium. Diffuse myocardial fibrosis due to ischemic cardiomyopathy is considered.
* LV function and mass: to be continued.
)



::CHMRHCM::                   ;hypertrophic cardiomyopathy
(
Purpose: R/O hypertrophic cardiomyopathy.
Pulse sequences: ECG-gating TrueFISP cine for LV function, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* normal sizes of cardiac chamber. No definite hypertrophy of the LV wall is noted. There is mild mitral regurgitation.
* normal contractility of the LV/RV walls. There is sluggish early LV dilatation followed by atrial kick. R/O diastolic dysfunction.
* no definite hyperenhancement in the LV/RV walls.
* LV function and mass: to be continued.
)



::CHMRPA::                         ; pulmonary atresia.
(
Purpose: SOB, palpitation, Echo: R/O pulmonary HT, Eisenmenger syndrome.
Pulse sequences: ECG-gating T1W dark blood HASTE, TrueFSIP, contrast-enhanced 3D MRA, TrueFISP cine, and IR-prepped segmented TurboFLASH.
MRI findings:
* normal sizes of the cardiac chambers. Mild hypertrophy of the RV wall is noted. There is no transvalvular stenosis or regurgitation. Minimal pericardial effusion is noted. 
* Straightening of the interventricular septum at early diastole. Elevated RV diastolic pressure is considered. Normal contractility of the LV/RV walls.
* Abscence of right pulmonary artery is noted. Congenital right pulmonary artery aplasia is considered. Prominent bronchial arteries are noted supplying the right lung. Focal infiltrates are found in the periphery of right lower lobe.
* Engorged pulmonary trunk and left pulmonary artery. There are suspicious multiple stenoses at the left pulmonary arteries with post-stenotic dilatation. 
* no definite hyperenhancement in the LV/RV myocardium.
* LV function and mass: to be continued.
)



::CHMREBS::                   ;Ebstein anomaly s/p Brock procedure
(
Purpose: Ebstein anomaly s/p Brock procedure and PVP, TVP, ASD repair and right heart MAZE.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, 3D contrast enhanced MRA for pulmonary arteries imaging, TrueFISP cine for RV function and IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* mildly dilated RV and RA. Moderate pulmonary regurgitation, moderate pulmonary stenosis, and mild tricuspid regurgitation are found.
* corrected positin of the tricuspid valves. 
* normal contractility of the RV wall.
* engorged MPA.
* no definite hyperenhancement in the RV or LV myocardium.
* PR index (To be continued)
)



::CHMRAMI::                   ;for acute myocardial infarction.
(
Purpose: R/O AMI or acute myocarditis.
Pulse sequences: ECG-gating contrast enhanced MRA, TrueFISP cine for LV function, and delayed enhanced IR-prepped segmented TurboFALSH for myocardial scarring.
MRI findings:
* normal sizes of cardiac chambers. Moderate mitral regurgitation and mild aortic regurgitation and stenosis are found. There is mild pericardial effusion and bil pleural effusions.
* global hypokinesia of the LV wall. 
* scattered small patches of hyperenhancement mostly at the outerwall of the septum and anterior wall of the LV. The enhancement pattern is compatible with acute myocarditis. Advise clinical correlation.
* LV function and mass: to be continued.
)



::CHMRICM::
(
Purpose: ICM s/p CABG + MVP + SVR. HYHA2. For LV function and myocardial scarring.
Pulse sequences: ECG-gating TrueFISP cine for LV function and IR-prepped segmented TurboFLASH for myocardial scarring.
MRI findings:
* cardiomegaly with mild pericardial effusion and pleural effusion.
* global hypokinesia of the LV walls. The apical LV is separted by a patch due to SVR, and shows akinesia. There is no leakage of the patch.
* transmural hyperenhancement at the mid anterior, mid anteroseptal, mid inferior, apical anterior, apical septal, apical inferior segments. 
* LV function and mass:to be continued.
)



::CHMRVSD::
(
Purpose: VSD s/p repair. For PR fraction and RV function.
Pulse sequences: ECG-gating free breathing contrast enhanced 3D MRA, Turbo FLASH cine for RV function and navigator-echo gated IR-prepped 3D segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* mild dilatation of RV. Moderate to severe pulmonary regurgitation is found.
* normal contractility of the LV/RV walls.
* no definite hypernehancement of the LV/RV myocardium.
* PR fraction (To be continued)
* RV function (To be continued)
)

::CHMRPerf::
(
Clincal information: a 46 y/o male with exertional chest tightness. Treadmill and resting Tl-201 myocardial perfusion imaging showed visualization of RV after stress.
Pulse sequences: ECG-gating SR-prepped TurboFLASH for testing, resting, and stress first-pass myocardial perfusion, TrueFISP cine for LV function, and post-Gd IR-prepped segmented TurboFLASH for myocardial scarring
Medications:
> Dipyridamole 50 mg slow IV injection for 4 mins before stress perfusion imaging.
> Aminophylline 250 mg/10 ml slow IV injection after stress perfusion imaging.
MRI findings:
> No evidence of perfusion defect during resting or stress status.
> No chamber enlargement or hypertrophy.
> Normal contractility of LV and RV.
> No transvalvular regurgitation or stenosis.
> No abnormal hyperenhancement in RV or LV walls.
> LV function and mass: please refer to the uploaded images (series 27) on PACS.

)

::CHMRARVD::
(
Purpose: PSVT and family history of ARVD. For follow up.
Pulse sequences: ECG-gating T1W dark blood HASTE with and without fat suppression for cardiac morphology, TrueFISP cine for RV/LV function, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* normal sizes of cardiac chambers. No definite transvalvular stenosis or regurgitation is found.
* no definite hypokinesia or focal bulging in the LV/RV walls.
* no definite hyperenhancement in the LV/RV myocardium.
The above MRI findings do not provide evidence for the diagnosis of ARVD.
* RV function (To be continued)
)



::CHMRTOF::
(
Purpose: TOF s/p total correction. For RV function, pulmonary arteries morphology, RV function and PR fraction.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, contrast enhanced 3D MRA for vascular imaging, TrueFISP cine for RV function and regional wall motion, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* Mild dilatation of the RV and RVOT. There are mild to moderate pulmonary regurgitation and pulmonary stenosis. 
* mild hypokinesia of the RV wall. Straightening of the interventricular septum during diastole. Elevated RV diastolic pressure is considered.
* no definite segmental stenosis in the MPA or bilateral pulmonary arteries.
* focal hyperenhancement at the RVOT and basal septum, probably due to OP change.
* PR fraction (To be continued)
)



::CHMRTOF2::
(
Purpose: TOF s/p total correction. For RV function, PR fraction, pulmonary arteries morphology and RV myocardial fibrosis.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, contrast enhanced 3D MRA for vascular imaging, TrueFISP cine for RV function, and IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* dilated RV. Moderate pulmonary regurgitation and mild pulmonary stenosis are found. 
* normal contractility of the LV/RV walls. Mild straightening of the interventricular septum is noted at early diastole.
* right side aortic arch with abberant left subclavian artery. The first branch is left common carotid artery, the second branch is right innominate artery, and the third branch is ALSA.
* no definite hyperenhancement of the LV/RV myocardiu.
* PR fraction (To be continued)
)



::CHMRCOA::
(
Purpose: R/O coarctation of aorta.
Pulse sequences: ECG-gating T1W dark blood HASTE and T2W TrueFISP.
MRI findings:
* normal caliber of the aorta; ascending aorta measures about 4.1 cm, and descending aorta measures about 2.7 cm.
* no definite aneurysm or coarctation of aorta.
* no evidence of aortic dissection.
* mild fibrotic change at left lower lobe of lung.
)



::CHCTPH::                     ;chest ct for pulmonary hypertension for heart lung transplant evalutation
(
CT of the chest without and with contrast enhancement is read and compared with prior study dated 2007-2-5. This CT study shows: 
1. marked dilatation of the right heart including RV and RA, associated with hypertrophy of the myocardium. There is larger cardiac chambers and more compression of the left lung as compared with prior study. Compression of the LV and bilateral superior pulmonary veins by enlarged right heart is noted. Marked dilation of the pulmonary trunk (3.2 cm) with prominent bronchial collaterals which also supply the lung parenchyma. The ascending aorta is 2.3 cm, descending aorta 2.1 cm. Constriction of the peripheral pulmonary arterioles is noted, consistent with severe pulmonary arterial hypertension. 
2. no definite filling defect or thrombus in the dilated pulmonary arteries. 
3. increased bilateral pleural effusion and faint opacity of both lungs with ground glass attenuation and thickening of septal lines. Pulmonary venous congestion and edema is considered.
4. hepatomegaly and small periheptic ascites.MArked dilatation of the IVC and hepatic veins, possibly due to right heart failure.

IMP: severe pulmonary arterial hypertension wiht hepatic congestion and progression.
)



::HCTA::
(
History of multiple CVAs.
CT scan of head without/with IV contrast enhancement shows:
1. Multiple lacunar infarcts at bilateral thalami, basal ganglia, periventricular white matter.
2. Decreased density surrounding the lateral ventricles. Leukoaraiosis is considered.
3. Atherosclerotic chanage of the intracranial arteries.
4. No definite acute intracranial hemorrhage.
5. A polyp at left maxillary sinus.
6. No evidence of bony defect.

CT angiography shows:
1. Atherosclerotic change with calcified plaque of bilateral proximal internal carotid artery and right intracranial internal carotid artery. Segmental severe stenosis at right proximal cervical internal carotid artery.
2. Segmental stenosis at distal M1 segment of right middle cerebral artery.

Perfusion CT shows:
1. Decreased CBF, CBV and prolonged MTT at right frontal, temporal and parietal regions.
)


::BOTOX::
(
CT of the neck without and with contrast enhancement shows no definite neck mass or lymphadenopathy. After identification of bilateral carotic arteries and neck vessels, CT guided placement of needles with EMG monitoring is performed through bilateral paramedial approach. The tips of needles are finally located at the location of criocopharyngeal muscle which are confirmed on CT images and signal of EMG. There is 35U Botox injected for each sides of CP muscle successfully. This gentleman stood well during and immediately after the procedure. Clinical correlation and follow up with VFSS is suggested. 

IMPRESSION:
Severe dysphagia related to CP muscle spasm, s/p CT guided bilateral Botox injection at CP muscle.
)

::BX::    ; CT-guided lung biopsy  L=lung
(
History of Right external ear canal and middle ear squamous cell carcinoma status post CCRT, status post revised operation, status post CCRT, status post right side superficial parotidectomy.

CT-guided biopsy of the lung is performed in supine position with the use of 19G coaxial guiding needle and 20G automatic biopsy needle. 
-- Indication of biopsy: multiple lung nodules at bilateral lungs. R/O metastasis.
-- Size and location of the lesion: a nodule (1.2cm) at the lingular segment of the left upper lobe beneath the pleura.
-- Emphysema: no
-- Total length of the needle from skin to lesion: 2.3 cm
-- Total length of the needle traversing lung: 0 cm
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 2
-- Pneumothorax: moderate
-- Hemorrhage: no
-- Hemoptysis: no
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: supine or left decubitus.
-- There are total 2 tissue stripes and 4 imprint smears obtained for pathology and cytology studies. 
Suggest complete bed rest for 4 hours in supine position, follow up chest radiography 6 hours later after biopsy, give adequate O2 supply and moniter his respiratory pattern closely at the first 24 hours.

Impression:
Left lingular lobe nodule status post CT-guided biopsy, with moderate pneumothorax.
)

::FNL::
(
History of right breast cancer s/p MRM. Endometrial cancer s/p TAH and BSO. Lung metastasis S/P VATS RML lobectomy. Two nodular ground glass opacities at LUL. 

CT-guided fine needle localization is performed in right lateral decubitus position with the use of 20G fine localization needle (10.7cm, Bard).
-- Indication: two faint subpleural nodules at LUL (7mm and 9mm in largest transverse dimension), for pre-operative localization.
-- the first fine needle demarcates the upper aspect of upper nodule at a vertical distance of 9mm.
-- the second fine needle passes 1cm through the center of the lower nodule.
-- Pneumothorax: mild.
-- Hemorrhage: no.
-- Hemoptysis: no.
-- Vital signs after the procedure: stable
-- Recommanded position after procedure: supine or right decubitus.
)


::CHCTER::             ;chest CT in emergency room
(
History: chest pain
CT of the chest without and with contrast enhancement shows:
1. placement of a right jugular venous catheter with its tip in the SVC.
2. bilateral pleural effusion and diffuse ground glass opacity with superimposed septal thickening, peribronchial cuffing, and patchy consolidation with dependent lower lung predominance. Bilateral pulmonary emphysema with bullae formation. Fibrotic change at the LUL and bilateral basal lungs. No pneumothorax.
3. cardiomegaly. Atherosclerosis of the aorta and coronary arteries. Mural thrombus and penetrating ulcer at the descending aorta. The ascending aorta is 3.1 cm and descending aorta 2.7 cm in diameter. 
4. The diameter of MPA is 3.5cm. No pulmonary thromboembolism. 
5. mediastinal lymph adenopathy.
6. gall stones. Bilateral renal cysts. Enlarged bilateral adrenals. No definite focal lesion in the liver, pancreas, and spleen.
7. calcifications in bilateral thyroid lobes.
8. Degenerative change of the spine with marginal spur formation. (CHM/Dr.YCC) 
)

::CHCTPMF::         ;chest CT for progressive massive fibrosis
(
Emergent chest CT without/with contrast enhancement shows:
1. bilateral pulmonary emphysema with fibrotic change. Large opacities at bilateral upper lobes, associated with peripheral traction emphysema and tiny calcified spots, consistent with bilateral progressive massive fibrosis (PMF) in pneumoconiosis. There are diffuse tiny nodular opacities. Superimposed diffuse ground glass opacity and septal thickening more evident at bilateral lower lobes. bilateral small pleural effusion. 
2. small bilateral mediastinal and hilar lymph nodes with calcification.
3. diffuse osteopenia with marked degenerative change of the T and L spine as well as multiple compression fractures.

Impression:
highly suggestive of pneumoconiosis with bilateral PMFs. Suggest clinical correlation and follow up. 
)

::CHCTPH::                     ;chest ct for pulmonary hypertension for heart lung transplant evaluation
(
CT of the chest without and with contrast enhancement is read and compared with prior study dated 2007-2-5. This CT study shows: 
1. marked dilatation of the right heart including RV and RA, associated with hypertrophy of the myocardium. There is larger cardiac chambers and more compression of the left lung as compared with prior study. Compression of the LV and bilateral superior pulmonary veins by enlarged right heart is noted. Marked dilation of the pulmonary trunk (3.2 cm) with prominent bronchial collaterals which also supply the lung parenchyma. The ascending aorta is 2.3 cm, descending aorta 2.1 cm. Constriction of the peripheral pulmonary arterioles is noted, consistent with severe pulmonary arterial hypertension. 
2. no definite filling defect or thrombus in the dilated pulmonary arteries. 
3. increased bilateral pleural effusion and faint opacity of both lungs with ground glass attenuation and thickening of septal lines. Pulmonary venous congestion and edema is considered.
4. hepatomegaly and small periheptic ascites.MArked dilatation of the IVC and hepatic veins, possibly due to right heart failure.

IMP: severe pulmonary arterial hypertension wiht hepatic congestion and progression.
)

::CHCTGGO::                ; diffuse GGO, patchy consolidation, and effusion
(
CT of the chest without and with contrast enhancement is read and compared with prior study at *-*-*. This CT study shows:
1. Bilateral pleural effusion and diffuse infiltration of lung parenchyma with predominantly ground-glass opacities and superimposed area of fibrosis and small patchy consolidation. The opacities and pleural effusion are increased as compared with prior study at 2008-1-2. There is superimposed pulmonary emphysema.
2. Multiple bilateral small mediastinal lymphadenopathy including paratracheal region and AP window. These lymph nodes are larger in size as compared with prior study. 
3. small low density nodules in the right lobe of liver which were not seen in prior study at 2008-1-2. There is normal appearance of the pancreas, spleen, kidneys and adrenals. 
4. Placement of a NG tube and a tracheostomy tube. 
5. No definite abdominal or pelvic lymphadenopathy. There is diffuse osteopenia. 
)

::CHCTLAM::
(
CT of the chest without and with contrast enhancement is read and compared with prior study dated 2008-4-9. This CT study shows: 
1. multiple variable-sized thin-wall cysts at bilateral lungs, compatible with lymphangioleiomyomatosis. Mild fibrotic change in the left basal lung. Stationary imaging findings as compared with prior study on 2008-4-9. 
2. a small subpleural nodule in the lateral aspect of LUL. (4mm SE2 IM17 SE900 IM35)
3. small lymph nodes in the anterior mediastinum.
4. ascending aorta is 3.0 cm in diameter, pulmonary trunk 3.0cm and descending aorta 2.2 cm. (CHM/Dr.YCC) 
)


::CHCTBRCA::               ;breast cancer and mets
(
CT of the chest and abdomen without and with contrast enhancement shows:
1. A large tumor (5.3cm) at the lateral aspect of the right breast. There is tumor involvement of the skin and nipple and multiple subcutaneous nodules of the right chest wall and susp. nodules on the skin of the right breast. There are enlarged right axillary lymph nodes, edematous change and swelling of the right chest wall and breast. Compared with prior study at 2007-1-9, disease progression is considered.
2. Multiple small non-specific left axillary lymph nodes. There is no definite mediastinal lymphadenopathy.
3. A tiny subpleural nodule at the RML and susp. nodule in both lungs. R/O metastases.
4. Distended gall bladder and a laminated gall stone. There are multiple bil. hepatic cysts. Both adrenals, pancreas, spleen and kidneys are not remarkable. 
5. Enlarged thyroid with low density nodule and calcification at the right thyroid. 
)

::CHCTLUNGCA::          ;single lung cancer with interstitial mets
(
CT of chest without and with contrast ehancement is read and compared with prior non-enhanced chest CT at 2007-1-26. This CT study shows:
1. a lung tumor about 3.4cm in diameter at the superior segment of the RLL.  There is adjacent pleural thickening. Stationary in size as compared with prior study. 
2. decreased bil. lung capacity with prominent bil. subpleural opacities with interstitial pattern and patches more at lower lobe. There are deformed airway with traction bronchiectasis.  Small reticulation and subpleural patches are noted at lower lobe. The finding seems stationary as compared with prior study. 
3. Marked enlarged pulmonary trunk (4.9cm in diameter) dilatation of the ascending aorta (4.07cm) is also noted. The picture is consistent with pulmonary arterial hypertension. Hypertrophy of RV, myocardium is also noted. 
4. Lymph nodes are noted at bil. mediastinum.
5. No definite abnormality of visible liver, adrenals, spleen and pancreas. There are large laminated gall stone. 
)


::CHCTHRCT::          ;lung HRCT with pneumonia or pulmonary edema
(
HRCT with full inspiration and expiration shows:
1. Bilateral prominent consolidation at dependent lower lobes and bilateral peribronchial region at upper lung field. There are superimposed areas of the ground-glass infiltration and smooth septal thickening at both upper lung fields. 
2. Bilateral pleural effusion. 
3. Normal appearance of the pericardium. There is cardiomegaly. Placement of a cardiac pacemaker. 
4. Multiple non-specific bil. small mediastinal lymph nodes. 
5. Mild air trapping the left lower lobe. 
6. No evidence of bronchiectasis. 
7. Marked atherosclerotic change with dense calcification of the aorta, splenic artery and coronary artery. 
8. Normal appearance of both adrenals. 
)

::CHCTMETA::             ;Chest CT for metastasis survey
(
History: Nasopharyngeal carcinoma, cT3N3bM1, stage IVC
CT of the chest without and with contrast enhancement shows: 
1. bilateral pleural effusion. Multiple nodules of variable size in bilateral lungs more in the dependent lower lobes, lung metastases most likely.
2. extensive lymphadenopathy in the lower neck and right supraclavicular region with confluent mass. there are enlarged lymph nodes at bilateral supraclavicular fossa, and mediastinum. 
3. multiple variable-sized bull-eye lesions in liver, liver metastases compatible. Please correlate with the imaging findings and report of the abdominal/pelvic CT study. 
4. multiple sclerotic lesions in bones, bony metastases compatible. (CHM/Dr.YCC) 

IMP:
Prominent neck and some mediastinal lymphadenopathy and multiple lung, bone, and liver metastases.
)

::CHCT3RO::               ;Chest pain triple rule-out CT
(
History: chest pain
CT of the chest without and with contrast enhancement shows: 
1. a clacified nodule at the subpleural region of the LUL.
2. no pneumothorax; no aortic dissection; no definite hypodense change of myocardium. The ascending aorta is 3.4 cm and descending aorta 2.5 cm in diameter.
3. No definite mediastinal or hilar lymphadenopathy. 
4. no definite focal lesion in the liver, pancreas, spleen and bilateral adrenal glands & kidneys. 
5. mild scoliosis of the T and L spine; mild deformity of the sternum and left lower costosternal junction, consistent with pigeon chest. (CHM/Dr.YCC) 
)

::CHCTUIP::           ;lung fibrosis or UIP
(
Paired inspiration/expiration thin section CT and ECG-gating chest CT with 3D and multiplanar reformation show:
1. bilateral diffuse ground glass opacity, prominent reticulation, honeycombing, traction bronchiectasis, predominantly at subpleural and basal lungs, compatible with pulmonary fibrosis with UIP pattern. There is decreased bilateral lung capacity. mild airtrapping at the left upper lobe.
2. bilateral small mediastinal lymph nodes. There is dilatation of the pulmonary trunk (3.2 cm). The ascending aorta 3.0cm, descending aorta 2.3 cm in diameter. Thickening of the myocardium of the RV and RVOT is noted. 
3. bilateral mediastinal lymph nodes.
)

::CHCTILD::
(
HRCT with full inspiration and expiration  without contrast enhancement  shows:
1. Bilateral diffuse interstitial opacities predominantly at subpleural region and peribronchial areas of both lungs, lower lobe predominance. There is patchy consolidation and ground-glass infiltrations. Traction bronchiectasis are suspected within the airway of the consolidation at lower lobe. The possibility of interstitial lung disease should be suspected, including cryptogenic organizing pneumonitis, usual interstitial pneumonitis, and others. Suggest clinical correlation or tissue proof. 
2. No evidence of mediastinal or hilar lymphadenopathy. There is suspicious pericardiac effusion or pericardiac thickening.  Suggest clinical correlation and follow up.
)

::CHCTIP::              ;interstitial pneumonitis
(
CT of the chest without contrast enhancement in full inspiration and expiration shows:
1. Extensive subcutaneous emphysema from the neck to bilateral upper chest walls and axillae. 
2. There is pneumomediastinum with prominent air at mediastinum and extend to parapharyngeal region at neck. 
3. Marked interstitial lung opacities with ground-glass opacities, honeycombing, reticulation and traction bronchiectasis of both lungs, predominantly at both lower lobes, subpleural location. There is also decreased lung capacities of both lower lobes. Lung fibrosis and interstitial pneumonitis should be highly suspected. 
4. No definite mediastinal or hilar lymphadenopathy.
5. No definite air trapping. 
6. Normal appearance of both adrenals. 
)

::CHCTEMPY::          ;empyema
(
CT of the chest without and with contrast enhancement shows: 
1. Placement of an endotracheal tube, a NG tube, and a left chest tube. 
2. left plerual effusion and small loculated left pneumothorax. There is marked thickening of the left pleura with split pleural sign. Chronic empyema and pleuritis is considered first. 
3. bilateral patchy consolidation and ground glass opacities in the LUL, RLL, and LLL with posterior and dependent area predominance. Lobar collapse of the RUL with bronchiectasis. Fibrotic change in the bilateral lower lobes. 
4. bilateral enlarged lymph nodes in the mediastinum and the left supraclavicular fossa.
5. small hepatic cysts and renal cysts. no definite focal lesion in the pancreas, spleen and bilateral adrenal glands. There are multiple small abdominal lymph nodes.

IMP:
1. Chronic empyema and pleuritis associated with pneumothorax at the left lung. 2. RUL lobar collapse. 3. possible bronchopneumonia. Suggest clinical correlation and follow up. 
)


::STA::  ;for normal standing abdomen film
(
Standing abdomen film shows:
> No evidence of pneumoperitoneum. 
> Nonspecific bowel gas. No obvious air-fluid levels. 
> Bilateral clear psoas and renal shadows. 
)

::PAOD::
(
MRA of the lower abdomen, pelvis and bil. lower limbs without/with IV contrast enhancement shows: 
1. fine opacification of the lower abdominal aorta and its bifurcation. focal stenosis of the right common iliac artery near its orifice; fine opacification of the left common iliac, and bilateral external iliac and common femoral arteries. 
2. multifocal severe stenosis and segmental total occlusion of the bil. superficial femoral arteries with recanalization of their distal portions via collateral vessels; mild atherosclerotic change of the bilateral popliteal arteries.
3. total occlusion of the bil. anterior tibial arteries without opacification of the bil. dorsalis pedis arteries. multifocal mild to moderate stenosis of the bil. posterior tibial, fibular and plantar arteries.
)

::CTH0::       ;for normal head CT
(
Head CT without IV contrast enhancement shows:
> The ventricles and sulci are symmetric. 
> No intracranial hemorrhage or extra-axial fluid collection is identified. 
> There is no evidence of acute infarct, focal mass lesion or midline shift. 
> The osseous structures are intact. 
> The paranasal sinuses are well-aerated. 
)

::CTH1::  ;for trauma head CT
(
Head CT without IV contrast enhancement shows: 
> traumatic brain injury with hemorrhage and some low density change at frontal and temporal lobe. 
> subdural hematoma at 
> midlnie shift
> no obvious skull fracture.
)

::CTN0::         ;for normal neck CT
(
Neck CT without/with contrast enhancement shows:
> no obvious mass lesion noted.
> no abnormal LAPs at neck.
> the parotid, submandibular glands and nasopharynx appear normal.
)

::CTNOP::            ;for post-op change of neck CT
(
Neck CT without/with contrast enhancement shows:
> post-operative change with neck dissection. soft tissue swelling and blurring fat planes are found due to recent operation.
> no obvious abnormal mass lesion is noted.
> no obvious abnormal lymph adenopathy.

suggest follow-up.
)

::NPC1::             ;fresh case of NPC
(
MRI of neck without/with contrast enhancement shows:
> abnormal mucosal thickening at nasopharynx, NPC is considered.
> no obvious abnormality at skull base and visible brain.
> abnormally enlarged LAPs at carotid and posterior cervical spaces.
> the paranasal sinuses are clear. 
)

::NPC2::            ;NPC s/p R/T
(
MRI of neck without/with contrast enhancement shows:
> post-RT change with flattened mucosa at nasopharynx, no obvious local recurrent tumor is found.
> no obvious abnormality at skull base and visible brain.
> no evidence of abnormally enlarged LAPs.
> mild paranasal sinusitis change and mastoiditis change.  
)

::IVP0::
(
KUB and IVU shows:  
> Bilateral clear psoas shadows.  
> Bilateral functioning kidneys with normal size, shape and axis.  
> No definite filling defect or obstruction at the bilateral collecting system.  
> Well-distended urinary bladder with smooth contour. 
)

::IVP1::
(
KUB and IVU shows:
> Bilateral clear psoas shadows.
> Bilateral functioning kidneys with normal size, shape and axis.
> Bilateral normal collecting system without definite filling defect.
> Left hydronephrosis with an opaque lesion superimposed on renal pelvis.
> Left functioning kidney and collecting system without definite filling defect or dilatation.
> Right hydronephrosis with an opaque lesion superimposed on renal calyx.
> Right functioning kidney and collecting system without definite filling defect or dilatation.

> Well-distended bladder with smooth contour.

> Some phleboliths are noted in pelvis.
> One phlebolith is noted in pelvis.
)

::LGI0::
(
Clinical history:
Double contrast study of the colon under the fluoroscopic control was performed smoothly and it shows:
> normal haustration, caliber and profile of the lower GI tract.
> no definite filling defect nor obstructive lesion.
> no widening of the presacral space.
> the ileocecal valve is unremarkable. 
> the appendix is unremarkable.
> normal mucosal pattern after evacuation. 
)

::REQ::
(
The medical images from outside hospital for shared information have been successfully uploaded into the PACS (Picture Archiving and Communication System) server for reference purpose. Please check the attached original formal report from the source hospital. If a second opinion of these images is required, please send a formal consultation to the Department of Medical Imaging with the mention of "Request a Second Opinion".
)

::MRH0::     ;MRI of brain without contrast
(
MRI of brain without IV chelated Gd enhancement shows:
> No definite diffusion restriction on DWI and ADC map.
> No abnormal focal SI change in the brain parenchyma.
> Some non-specific hyperintense spots on FLAIR images over bilateral cerebral white matter.
> Symmetrical sulci, fissures and ventricles. 
> TOF MRA of circle of Willis and/or cervicocranial vessels appears normal.
> The cranial vault and skull base appear normal.
)

::MRH0C::     ;MRI of brain without/with contrast 
(
MRI of brain with/without IV chelated Gd enhancement shows:
1. Mild brain atrophy with dilated sulci and ventricles. 
2. No definite restriction on ADC and DWI maps. 
3. No definite focal abnormal SI nor enhancement in brain parenchyma. 
4. Nonspecific hyperintense foci in bilateral centrum semiovale on T2WI and FLAIR. 
5. Contrast enhanced MRA shows mild multifocal stenosis of bilateral distal ICAs and MCAs.

IMP:
Mild brain atrophy with nonspecific white matter change.
)


::MRN0::
(
MRI of neck without/with contrast enhancement shows:
> dental artifacts on the right side.
> no obvious local recurrent tumor is found.
> no evidence of abnormally enlarged LAPs.
> no obvious abnormality at skull base and visible brain.
> mild paranasal sinusitis change and mastoiditis change.  
)

::CAV::              ;for cavernous sinus protocol
(
MRI of head without/with contrast enhancement shows:
> no abnormal bright up on DWI
> no abnormal focal SI change in the brain parenchyma
> symmetrical sulci, fissures and ventricles. 
> no obvoius abnormality along the cisternal portion of upper cranial nerves, the cavernous sinuses, retrobulbar region.
> post-contrast TOF MRA of circle of Willis appears normal.
> the cranial vault and skull base appear normal
)

::CTCPS::
(
CT for paranasal sinuses without contrast enhancement shows:
> increased soft tissue in maxillary, ethmoid, frontal and sphenoid sinuses, paranasal sinusitis is considered.
> no abnormal bone destruction.
)

::SINUS0::   ;for sinus view
(
abnormal opacity at bil. maxillary, ethmoid and frontal sinuses.
paranasal sinusitis change is considered.
no abnormal bony destruction.
)

::CSPINE::
(
MRI of cervical spine without contrast enhancement shows:
> cervical spondylosis with marginal spur formation and bulging disc at C5-6, C6-7 level with narrowing of thecal sac.
> no evidence of intrathecal lesion. no focal SI change in the visible spinal cord.
> normal alignment of C spine, no focal bony destruction is found.
> the paraspinal soft tissue is unremarkable. 
)

::BX::
(
CT guided biopsy of the     was performed smoothly with a 19G coaxial guiding needle and a 20G automated cutting biopsy needle.
1. Indication of CT-guided biopsy:
2. Number of coaxial needle pass:1. Number of biopsy needle pass:4.
Please send for pathology, culture and smear cytology.
3. The patient tolerated the whole procedure well.
)

::DEN::
(
Head CT without contrast enhancement for dental implantation shows:
> bony erosions are found at bil. superior alveolar process, more on the left/right side, and the inferior alveolar process, compatible with periodonditis.
)

::ENT1::
(
C spine: normal alignment without focal bony lesion.

Mastoid bone: decreased pneumatization at mastoid suggeseting mastoiditis.

Stenver's view: normal size of bil. IAC
)

::ENT2::
(
C spine: degenerative change at C spine with marginal spur formation.

Mastoid bone: decreased pneumatization at mastoid suggesting chronic mastoiditis.

Stenver's view: normal size of bilateral IAC.
)

::SEIZ::    ;MR for seizure patient
(
MRI of head without contrast enhancement shows
> no abnormal focal SI change in the brain parenchyma.
> symmetrical sulci, fissures and ventricles. 
> normal appearance of bil. hippocampus.
> MRS of bil. medial temporal lobe shows no obvious abnormality.
)


::BLOC1::     ;lumbar facet block
(
The study was for CT-guided facet block. The patient had low back pain, more on the right side.
> Image findings: lumbar spondylosis and facet arthrosis of L4-5, L5-S1 bilaterally. 
> RF needles were placed with tips in the rescess of right transverse process and facet joint of L4-5, L5-S1. RF thermocoagulation was done at 80 degree celsius for 120 seconds at each site. 
> Two 26G needles were inserted from left posterior approach with tip into the L4-5, L5-S1 facet joint region. 2.5cc mixed steroid, 2% xylocaine and contrast medium was injected slowly through the needle at two sites respectivley. 
> F/U CT showed well dispersion of the contrast medium in the left facet joint region.
> the patient tolerated the procedure well and experienced pain relief after the procedure.
)

::BLOC2::     ;periradicular therapy
(
The study is for CT-guided periradicular therapy for treatement of radiculopathy.
1. Image findings: lumbar spondylosis and L45 HIVD (lateral and far laterally) with compression of the L4, 5 nerve roots.
2. Two 26G needles were inserted from left posterior approach with tip into the L4, 5 periradicular region.
3. After confirmation of the exact location at periradicular epidural space using contrast medium injection, 2.5cc mixed steroid (40mg kenacort), 2% xylocaine and contrast medium was injected slowly through the needle at two sites respectively. 
4. F/U CT showed well dispersion of the contrast medium in the epidural space and along the nerve roots.
5. the patient tolerated the procedure well.
)

::BLOC3::       ;celiac nerve block
(
CT of abdomen without/with contrast enhancement for celiac nerve block shows:
1. Image findings: necrotic metastatic lymphadenopathy at lesser sac and foramen of Winslow, with rightward displacement and straightening of celiac trunk. IHD dilatation.
2. Indication: intractable abdominal pain despite large dosage of opioid use. For pain control.
3. A 22G 15cm Chiba needle is inserted from left posterior approach in prone position under CT guidance with tip adjacent to the celiac trunk.
4. After confirmation of the exact location of Chiba needle tip using contrast medium(1.5mL) mixed with Xylocaine injection(2% 8.5mL), 15mL 99.8% ethenol was injected slowly through the needle. 
5. follow-up CT showed well dispersion of the contrast medium in the majority of the necrotic lymphadenopathy adjacent to the celiac trunk as well as the celiac nerve plexus.
6. the patient tolerated the procedure well. No immediate complication such as hemorrhage, bowel perforation or pneumothorax occurred.
)

::CDOP1::
(
 post-op change with a cage in C3-4 disc and a drain tube at prespinal soft tissue.
 prespinal soft tissue swelling is found.
 mild degenerative change of C spine with marginal spur formation.
)

::CDOP2::
(
 post-op change with intervertebral fusion and anterior metallic plate fixation at C3-5 level.
 degenerative change of C spine with marginal spur formation.
 normal alignment.
)

::SELLA0::
(
MRI of sella without/with contrast enhancement shows:
> normal size and shape of the pituitary gland. 
> no evidence of focal lesion in the pituitary gland.
> normal dynamic enhancement pattern.
> the posterior lobe brightness is preserved. 
> normal size of sulci, fissures and ventricles of the visible brain.
)

::SELLA1::
(
MRI of sella without/with contrast enhancement shows:
> enlargement of the sellar turcica with a less enhancing mass lesion, about 1.6x1.8x1.4cm sized, in the sellar fossa, more on the right. pituitary tumor is considered.
> the stalk and residual pituitary tissue are displaced to the left.
> the optic chiasm is displaced upwardly.
> the posterior lobe brightness is preserved. 
> normal size of sulci, fissures and ventricles of the visible brain.
)

::SELLAOP::
(
MRI of sella without/with contrast enhancement shows:
> evidence of prior transsphenoid hypophysectomy with increased SI in the sphenoid sinus and bony defect at the sellar floor.
> no evidence of local recurrent tumor.
> the sellar turcica is enlarged with minimal residual normal glandular tissue. the stalk is deviated to the left.
> the postrior lobe brightness is found but ectopic.
> mild deformity of the optic chiasm.
> symmetrical sulci, fissures and ventricle of the brain without focal SI change.

IMP: post-op change of the sella without evidence of recurrent tumor.
)

::TEMP::  ;for temporal bone HRCT
(
HRCT for temporal bones without contrast enhancement:
> normal appearance of bilateral external ear canal and middle ear osscicles.
> normal appearance of bilateral inner ear bony labyrinthes.
> well pneumatization of bil. mastoid.
)

::RFALUMBAR::  ;for nerve RFA of lumbar nerve root
(
This study is for CT-guided radiofrequency thermocoagulation of L2 periradicular region for back pain treatment.
> Under CT-guidance, two RF probes were inserted from posterior approach with tips at around L2 dorsal root ganglion region bilaterally. 
> After RF stimulation to confirm the correct needle location, RF thermocoagulation at 49 degree Celsius for 90 seconds was performed. 
> The patient tolerated the whole procedure well. 
)

::LSPINE::
(
MRI of lumbar spine without contrast enhancement shows:
> lumbar spondylosis with marginal spur formation and bulging disc at L4-5, L5-S1 level with narrowing of thecal sac.
> no evidence of intrathecal lesion. no focal SI change in the visible spinal cord.
> normal alignment of L spine, no focal bony destruction is found.
> the paraspinal soft tissue is unremarkable. 
)

::PARO::     ;for parotid tumor benign favored.
(
Neck CT without/with contrast enhancement shows:
1. a  cm sized lobulated tumor in parotid gland, mainly superficial lobe, showing solid and cystic component. A benign tumor is more favered, suggest pathologic correlation.
2. no abnormal LAPs at neck.
3. no obvious pharyngeal mucosal mass lesion noted.
4. clear paranasal sinuses.
)

::SKULL0::
(
Skull: no abnormal bony destruction. Normal size of the sellar turcica.
)

::ORB0::
(
CT for orbits without contrast enhancement shows:
> normal size and shape of both eyeglobes.
> no obvious exophthalmos.
> no evidence of retrobulbar mass.
> normal size of the extraocular muscles and optic nerves.
)

::ORB1::
(
CT for orbits without/with contrast enhancement shows:
1. right exophthalmos, with fusiform shaped enlargement of right inferior, medial, superior and lateral rectus as well as superior oblique muscles. The tendinous insertion portion was spared. The left eye was spared.
Graves' ophthalmopathy with unilateral eye invovlement is considered first.
2. no obvious parasellar lesion.
3. clear paranasl sinuses.
)

::UGI0::
(
Esophageal and upper GI series with barium meal under fluoroscopy shows:
> smooth passage of barium through the esophagus and UGI tract with fine peristalsis, normal mucosal pattern and profile.
> visible E-G junction in normal position without focal lesion.
> well-distended duodenal bulb shows no ulcer formation or deformity.
> no widening and rigidity of the gastric angularis.

IMP: no definite abnormalities noted in this study.
)

::NANG::    ;neuroangiography general form.
(
Angiographies: 
Indication: 
Material: 5Fr. H1 catheter and 0.035 guide-wire.
Methods: The patient was put at supine position on exmination table. With complete aspetic technique, his/her right/left femoral artery puncture was conducted smoothly with a 5Fr catheter. Under fluroscopic guidance, a 5Fr diagnostic catheter navigated and cannulated the above vessels.
Findings:
* There is a lobulated aneurysm at right supraclinoid ICA, proximal to right PcoA orifice, pointing posteriorly. No evidence of extravasation.
* The left ICA, bil. VAs are unremarkable.
* Mild irregularity of the bil. MCA, intracranial left VA and BA, indicative of atherosclerosis.
* The intracranial venous structures are unremarkable.
)

::SAVF::     ;spinal AVF
(
Angiographies of bilateral VA, intercostal arteries, and lumbar arteries shows:
1. The patient was put at supine position.
2. A 5F RC1 catheter was used to navigate bil. intercostal arteries and lumbar arteries, and a 5Fr H1 catheter was used to navigate bilateral VA smoothly.
3. Early tortuous dilated venous drainage with aneurysmal sac formation at T8-9 level, supplied by arteries from right T5, left T6, left T7, left T9, right T12 intercostal arteries. 
4. Focal narrowing at the right L2 lumbar arteries. 
5. No arterial supply to the AVF via bilateral VA is noted.
)

::dAVF::      ;dural AVF
(
> dural arteriovenous fistula at the left transverse-sigmoid junction; the arterial supply is  from multiple branches of left ECA (including occipital artery, middle meningeal artery, and posterior auricular artery), and also from the left meningohypophyseal trunk and a small dural branch from left VA.
> early opacification of the left transverse-sigmoid sinus is noted with antegrade flow; however, there is to-and-fro flow to the left inferior petrosal sinus and the vein of Labbe.
)
::ICASTENT::
(
Stenting for left CCA-ICA.
Indication: Left ICA severe stenosis.
Stenosis degree: >90%, symptomatic. 
Guiding catheter: 6F.
Protective device: EZ filterwire (BSC)
Pre-stenting PTA: (+) 3.0-20mm Gazelle 135cm (BSC)
Stenting: 7.0mmx40mm Carotid Wallstent Monorail.
Post-stenting dilatation: 4.5mm-20mm x 135cm (BSC) 
Post-procedure: No fresh neurological deficit, however, BP was much decreased and cold sweating, so fluid challenge and dopamine (10 then 20cc/min) was infused.Cardiac emzyme was sent though EKG was normal. The one-stick glucose study was normal. Afterall, the blood present was kept at about 100 mmhg (SBP). The patient was consciousness clear and had no complaint. So he was send to ICU for further management and care.
)

::ANTAE::        ;intracranial aneurysm TAE
(
History:
Indication: 
Pre-procedural neurologic key findings: 
Method : transarterial arterial embolization with detachable GDCs.
Materials: femoral sheath (7 Fr), guiding catheter (MPC, 6 Fr), microcatheter (Excelsior SL-10, 1.7 Fr), two microguiding wire (Trensend Floppy, 0.014" 205cm and 300cm.), Neuroform Stent System(3.5mmx15mm), and detachable coils(MicroPLEX10 Hypersoft Helical 2mmx2cm and Matrix Helical Soft SR Coil 2mmx4cm).
Medication: Heparin 4000U, IV loading before TAE.
Procedure:
1. Under ETGA, the bilateral groins are disinfected with betaiodine solution and alcohol.
2. A cutaneous cutting wound in right groin about 2mm are made.
3. A 18-G puncture needle was introduced into right femoral artery, following a 0.035mm guiding wire was delivered into abdominal aorta for sheath delivery. A guiding wire was navigated into aortic arch via right femoral approach, and a guiding catheter was introduced into the right ICA.
4. Right ICA angiogram is taken with low-osmolality contrast medium (Hexabrix) injection, which shows a wide neck aneurysm at right MCA bifurcation. The Heparin (4000U) was given through IV route. The ACT was checked after 5 mins and shows 350 seconds.
5. Deployment of the Neuroform Stent System acrossing the parent branch of the aneurysm at the right MCA bifurcation.
6. One GDC was tried to deployed but not in safe position, then we use a hypercoil (2mm x2cm) were delivered into the aneurysmal sac with angiograms taken before and after each detachment.Since the purpose of this procedure is trying to protect the aneurysm and keep the branch patent. Further coiling might be dilimma between good packing and branch preservation. So for the benefit of the patient, the procedure stopped at this moment.
7. The post-embolization right MCA-angiogram showed coil packing of the aneurysmal sac with preservation of the right MCA branches.
8. Adequate manual compressions are applied on right groin with hemostatic material on arterial site.

Suggestions:
1. Bed rest or decreased physical activities for 3~7 days.
2. Follow up neurologic status. 
3. Aplly Plavix and Aspirin for 3 months then change to Aspirin for life-long.
)

::IAT::    ;IA(intraarterial) therapy for stroke. 
(
Indication: Basilar tip occlusion, for thrombolysis.
Medicine: Urokinase 180000U and autologous fresh arterial blood.
Materials: microcatheter microguide wire.
Procedures:
Left VA is canulated with 5Fr guiding catheter. A microcatehter is used to canulate bilateral PCA's. After recongized of right PCA, Urokinase is injected when the catheter is withdrawing into the thrombus. The thrombi are fragmented and migrate to bilateral PCA's. Further thrombolysis is tried but fails to lysis the thrombi. Sudden movement of the patient occurs, and left VA flow decreased after that. Left VA angiogram is taken and shows dissection of the left VA just at catheter tip, that's suggestive of traumatic dissection. Therefore, the guiding catheter is removed. Right VA angiogram shows that intracranial VA's and BA are patent. There is hyperemic change at perforators of basilar tip, and that's suggestive of reperfusion hyperemia. In fear of hemorrhage after additional Urokinase injection, only mechanical fragmentation and blood infusion are tried for the PCA thrombi, but in vain. Some collaterals to PCA territories can still bbe found. Therefore, we stop the procedure.
The pupils remain dilated without light reflex immediately after the procedure. The vital sign is not changed. 
Basilar tip occlusion, s/p thrombolysis, migration of thrombi to PCA's.
Complicated with traumatic left VA dissection because of abrupt movement of patient.
)

::CCFTAE::         ;TAE for CCF
(
History: sudden onset exophthalmos/ conjunctival injection/ chemosis/ ocular motor palsies/ head noise.
Indication: visual impairment/ progressive paresis of extraocular muscles/ intractable orbit pain or bruit/ progressive or severe exophthalmos/ cortical venous reflux or ischemia.
Pre-procedural neurologic key findings: 
Method : transarterial cavernous sinus packing with detachable balloon/  transvenous cavernous sinus packing with detachable coils.
Materials: femoral sheath (7 Fr), guiding catheter (MPC, 6 Fr) (JR 4, 6 or 7 or 8 Fr) (SL FLEXOR, 7 Fr)(JR 5, 5 Fr) (H1, 5 Fr) (SIM2, 5 Fr) (DHN2, 3 Fr), microcatheter ( SL 10, 1.7 Fr), microguiding wire (Floppy), detachable coils (GDC), embolic particles (Contour 250-355), gluemixture (> 40%).
Procedure:
1.Under ETGA, the bilateral groins are disinfected with betaiodine solution and alcohol. 
2.Subcutaneous injection of 10ml Xylocaine was applied on both groins for local anesthesia. Then a cutaneous cutting wound in bilateral groinsl about 2mm are made.
3.A 18 Fr. puncture needle was introduced into right femoral artery and left femoral vein  respectively, following a 0.035mm guiding wire was delivered into abdominal aorta for sheath delivery. A 5 Fr H1 catheter was navigated into aortic arch via right femoral approach, and a 7 Fr guiding sheath was introduced through a 8 Fr catheter via left femoral approach.
4.Series of angiograms were taken with low-osmolality contrast medium (Hexabrix) injection. Which shows a carotid cavernous fistula on the right/ left draining to the inferior petrous sinus. A tangle of abnormal vaculature with multiple engorged parent arteries and drainage veins at
5.Multiple detachable coils were delivered into cavernous sinus via transvenous approach with angiograms taken before and after each detachment.
6.The post-embolization right/left  ICA/CCA angiogram showed complete/ (80%) obliteration of the shunt flow without evidence of deep venous drainage vein .
7.Then the manual compressions are applied on bilateral groin with hemostatic material on arterial site. 
Complications: nil.
Suggestions: 
)

::MS1::          ; MRI of multiple sclerosis
(
MRI of head without/with contrast enhancement shows:
> multiple hyperintense patches on T2WI in bil. periventricular and subcortical white matter, bil. midbrain, some of the lesions show mild bright up on DWI
, but no significant enhancement after contrast injection. Multiple sclerosis is compatible.
> symmetrical sulci, fissures and ventricles. 
> no abnormal enhancement noted after contrast injection.
> TOF MRA of circle of Willis appears normal.
> the cranial vault and skull base appear normal.
)

::ENDOMETCA::                          ;endometrial cancer staging with MRI
(
Clinical history: 
MRI of abdomen and pelvis without/with contrast enhancement shows:
> a 40 x 31 x 28mm lobulated lesion originating from right-anterior aspect of the endometrium, with mild T2 hyperintensity and heterogeneous enhancement, compatible with endometrial cancer. It shows invasion more than half depth of the myometrium, and not exceeding beyond the parametrium, compatible with T1c.
> lymph adenopathy in bilateral pelvic side walls along the iliac chains, compatible with N1.
> No focal lesion in liver, spleen, gall bladder, bil. kidneys and both adrenal glands.
> No evidence of liver metastasis. No paraaortic lymph adenopathy. M0 is compatible.
> In summary, the staging is IIIc.
)

::TAEYMT::
(
Angiographies of celiac and common hepatic arteries with a 4Fr. RC1 catheter via right transfemoral
arterial approach are performed smoothly and show:
1. Contracted liver and splenomegaly.  Slight corkscrew appearance of hepatic arterial branches and heterogenous hepatic parenchyma in capillary phase.  Patent PV with abrupt intrahepatic tapering, engorgement of coronary vein with EV. Cirrhotic pattern is compatible. 
2. The opaque nodule in hepatic dome is due to previous TAE with Lipiodol accumulation.
3. In common hepatic angiogram, a 2-cm hypervascular nodule with heterogenous but global staining in hepatic dome, adjacent to the previously embolized lesion.  A cluster of several tiny hypervascular nodules also in hepatic dome, probably satellites. These are supplied by the S7, 8.
4. In left hepatic angiogram, the S4 branch also supplies the cluster of tumors at hepatic dome.  There is another 1.3 cm hypervascular nodule in S3.

Transarterial chemoembolization was performed first by infusion of a suspension of ADM 40 mg and Lipiodol 10 ml into the S7, S8, & S4 followed by Gelfoam particles. The S3 nodule was not embolized in this session because of impaired liver function. 
)


::HIPAVN::
(
MRI of pelvis without/with IV contrast enhancement shows:
> a geographic subchondral lesion at left femoral head with low signal intensity on both T1WI and T2WI, and peripheral enhancement on post-contrast T1WI with serpiginous sclerotic margin; ill-defined marrow edema and hyperemia at the adjacent femoral neck and intertrochanteric area; partial collapse with subchondral fractures at the left femoral head.
> increased effusions with synovial proliferation and enhancement in the left hip joint.
> the right hip is intact.
> bilateral sacroiliac joints are intact.
)

::ACLR::  ;ACL complete rupture
(
MRI of the left knee without IV contrast enhancement shows: 
1. subacute to chronic complete rupture of the anterior cruciate ligament with mild buckling of the posterior cruciate ligament, focal subchondral depression at the lateral femoral condyle, and residual contussion marrow edema at the lateral femoral and tibial condyles; an irregular nodular focus, most likely arising from the ACL stump, at the anterior intercondylar notch.
2. intact medial and fibular collateral ligaments.
3. longitudinal tear(s) at the medial meniscus with a mesially displaced fragment as truncated meniscus, flipped meniscus, fragment notch and double PCL sign(s); focal vertical tear at the posterior horn of lateral meniscus.
4. mild increased effusions with synovial proliferation in the suprapatellar bursa and knee joint; subtle or tiny marginal spur formation at the left medial and lateral femorotibial joint compartments; minimal effusion in the deep infrapatellar bursa.
5. subcutaneous edema and fat-stranding at the prepatellar and superficial infrapatellar areas.
6. no evidence of chondromalacia patellae.
7. a lobulated intermuscular lesion, about 1.5x1x0.5 cm in size, of intermediate SI on T1WI and increased SI on T2WI with some small foci of low SI on all sequences in the small intralesional lobules between the popliteus muscle, lateral head of gastrocnemius muscle and popliteal vessel(s).

IMP:
subacute to chronic complete ACL rupture with cyclops lesion, anterior intercondylar notch; bucket-handle tear, medial meniscus; lateral meniscal tear, posterior horn; posttraumatic synovitis and minimal arthritis, left knee joint; r/o soft tissue hemangioma, left popliteal area. 
)

