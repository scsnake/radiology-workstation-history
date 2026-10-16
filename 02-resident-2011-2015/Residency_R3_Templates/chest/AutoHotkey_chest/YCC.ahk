;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; write & send out report and enter next
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

; find study and copy serial number
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

;**********************************
;Y分院

;IPAX: 003924
;PW:003924

;大同

;ID:03924
;PW:5586

;*********************************

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.

::AB::of abdomen. 
::ABD::Standing abdominal film shows no definite abnormal bowel dilatation and normal bowel gas pattern.
::ABDILEUS::Standing abdominal film shows dilated bowel loops with air fluid level consistent with ileus.
::ABN::abnormal
::ACR::ACR BI-RADS category
::AD::no definite abnormality of both adrenals. 
::ADPS::no definite abnormality of the adrenals, pancreas and spleen.
::ART::Artherosclerotic change with mural calcification of the aorta.
::ATX::atelectasis. 


::BAPT::bilateral apical pleural thickening
::BAPTCA::bilateral apical pleural thickening with calcification
::LAPT::left apical pleural thickening
::LAPTCA::left apical pleural thickening with calcification
::RAPT::right apical pleural thickening
::RAPTCA::right apical pleural thickening with calcification
::APTCA::apical pleural thickening and calcificatio.

::As comp::as compared with prior study at
::AX::bilateral small axillary lymph nodes.
 
::B0::no definite abnormal bone change of this study.
::B1::Dense breasts and no mammographic finding (ACR BI-RADS category 1). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::B2::Dense breasts and benign mammographic finding (ACR BI-RADS category 2). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::B3::Dense breasts and probably benign mammographic finding (ACR BI-RADS category 3). Suggest short term follow up and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::B6L::the superior segment of the LLL.
::B6R::the superior segment of the RLL.
::B10L::the posterior basal segment of the LLL.
::B10R::the posterior basal segment of the RLL.
::BAP::bilateral apical pleural thickening.
::BAPCA::bilateral apical pleural thickening with calcification.
::BCA::bilateral benign calcifications.
::BCT::placement of bilateral chest tubes. 
::BEC::bronchiectasis
::BI::bilateral
::BIA::irregular acetabular fossa,
::BJV::placement of bilateral jugular venous catheters (lines). 
::BK::status post operation with total knee replacement, 
::BMH::more healing noted,
::BN::bilateral lung nodules. 
::BO::absence of breast shadow, compatible with previous mastectomy, 
::BPL::bilateral pleural effusion.

::C0::Chest PA shows normal heart size and no definite lung lesion.
::C0ER::Chest PA shows normal heart size, no definite lung lesion and elevated right diaphragm.
::C0EL::Chest PA shows normal heart size, no definite lung lesion and elevated left diaphragm.
::C0OP::Chest PA shows normal heart size, no definite abnormal ung lesion and postoperative change of the mediastinum with placement of multiple sternal wires.
::C0TA::Chest PA shows normal heart size, no deifnite lung lesion and tortuous aorta.
::C1::Chest PA shows cardiomegaly, tortuous aorta and no definite abnormal lung opacity.
::CA::calcification of aorta.
::CABG0::Chest PA shows normal heart size and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CABG::Chest PA shows cardiomegaly and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CAD::calcifiction of the coronary arteries, indicates CAD. 
::ch::Chest PA/AP shows
::chopl::Chest PA/AP shows postoperative change of the left lung. 
::chopr::Chest PA/AP shows postoperative change of the right lung.
::CHM::Chest PA (AP) shows cardiomegaly and no definite lung lesion.
::ChCT::CT of the chest without and with contrast enhancement shows:

::ChCTbrr::
(
CT of the chest without and with contrast enhancement shows:
1. postoperative change with right mastectomy and placement of a left port A catheter. 
)

::ChCTbrl::
(
CT of the chest without and with contrast enhancement shows:
1. postoperative change with left mastectomy and placement of a right port A catheter. 
)

::ChCTN::CT of the chest without contrast enhancement and HRCT show:
::ChCTC::CT of the chest with contrast enhancement shows:
::CDH::relative shallow of the acetabular roof,
::CF::Suggest clinical correlation and follow up. 
::CL::Chest lateral view shows
::CL0::Chest lateral view shows no definite abnormality. Suggest correlation with chest PA. 
::CLM::Chest lateral view shows cardiomegaly and no definite abnormal opacity. Suggest correlation with chest PA.

::CMABD::Chest AP shows cardiomegaly, marked abdominal distention and lower lung capacity. Suggest clinical correlation.  
::CMBPL::Chest PA shows cardiomegaly and bilateral pleural effusion.
::CMLPL::Chest PA shows cardiomegaly and left pleural effusion.
::CMRPL::Chest PA shows cardiomegaly and right pleural effusion.
::CMCABG::Chest film (PA /AP) shows cardiomegay and postoperative change with placement of sternal wires and multiple clips at the mediastinum, compatible with CABG.
::CMCPM::Chest PA shows cardiomegaly, no definite lung lesion and placement of cardiac pacemaker.
::CMEM::Chest PA/AP shows cardiomegaly and bilateral pulmonary emphysema.

::COM::decreased pneumotization of mastoid antrum with sclerotic change, otitis medium is compatible. 
::CMOP::Chest PA (AP) shows cardiomegaly and postoperative change.
::CMWIRE::Chest PA/AP shows cardiomegaly and postoperative change with placement multiple sternal wires.
::comp::as compared with prior study at
::compare chest::CT of the chest without and with contrast enhancement is read and compared with prior study dated  . This CT study shows: 
::consd::bilateral diffuse lung consolidation.
::consp::bilateral patchy consolidation.
::consr::right lung consolidation.
::consl::left lung consolidation.
::COPD::hyperinflation and increased volume of both lungs and flattening of diaphragms.
::CORREL::Please correlate with the imaging findings and report of the abdominal/pelvic CT study.
::CPAC::cardiophrenic angle
::CPAL::costophrenic angle
::CPM::placement of a cardiac pacemaker.
::CPS::hazziness/fluid of the paranasal sinuses, sinusitis is compatible, 
::CPS2::mucosal thickening of the maxillary sinuse, 
::CS::of C-spine.
::CTAS::an accessory spleen is noted.  
::CTASS::accessory spleens are noted, n=
::CTAT::artherosclerosis representing by calcifications on the aortic wall. 
::CTATA::arteriosclerotic change with calcifed plaque at intraabdominal vessels.
::CTATH::arteriosclerotic change with calcifed plaque at intracranial vessels.
::CTBA::prominent sulci, fissure and ventricles, brain atrophy is compatible. 
::CTBS::diffsue brain swelling with diminished sulci, fissure and CSF spaces. 
::CTC::well-definded homogenous low density shadow indicates cystic lesion is noted, 
::CTCA::paucity of the soft tissue and fatty tissue in body wall, cacaxia compatible.
::CTCC::hyperdense shadows are noted at pineal gland and choroid plexuses, indicates calcifications. 
::CTD::the estimated radiation dose (mSv) of this study is: 
::CTFL::generalized decreased liver density indicates fatty change of liver. 
::CTIL::generalized increased liver density and prominence of hepatic vasculature, iron overiding of liver is compatible. 
::CTLA::low density change at bil. periventricular white matter, leukoaraiosis is considered. 
::CTLC::uneven hepatic surface, coarse texture, splenomegaly, indicates liver cirrhosis. 
::CTLD::low density lesion noted at 
::CTLM::multiple heterogenous low density shadows in the liver, indicates liver metastasis. 
::CTLN::enlarged (>1cm) lymphadenopahty is recognized, 
::CTM::heterogenous soft tissue density shadow indicates mass lesion is noted, 
::CTN::no definite obvious lesion or abnormality is recognized in this study. 
::CTNA::no definite ascites is found. 
::CTNC::no definite focal pulmonary nodule is noted, bilateral lungs are clear. 
::CTNICH::no definite hyperdense shadow is noted in the brain or CSF spaces, no gross ICH is recognized. 
::CTNM::no definite focal mass lesion is identified in this study. 
::CTNN::no definite enlarged (>1cm) lymphadenopathy is recognized in the visible field of this study. 
::CTOB::obesity with a lot of subcutaneous fat. 
::CTPA::atrophic change of the pancreas, compatible to aging process.
::CTPF::fatty replacement of the pancreas.
::CTPC::radiopaque shadow at the pineal gland, compatible with pineal gland calcification. 
::CTPE::bilateral basal lung field pleural effusion at the dependent part, 
::CTPEA::bilateral basal lung field pleural effusion at the dependent part with adjacent lung partial atelectasis, 
::CTRC::homogenous low density lesions in the kidney, renal cysts are considered. 
::CTSC::status post-operation with a scar in the anterior abdominal wall. 
::CVPNG::placement of central venous catheter(s) and a NG tube.
::CVPET::placement of central venous catheter(s) and an endotracheal tube.
::CX::cardiomegaly.
::cybk::bilateral renal cysts.
::cybl::bilateral liver cysts.
::cylk::left renal cysts.
::cyrk::right renal cysts.

::DIS::distal
::DISL::dislocation
::DJDBK::degenerative change of both knees with marginal spur formation and joint space narrowing.
::DJDlK::degenerative change of the left knee with marginal spur formation and joint space narrowing.
::DJDRK::degenerative change of the right knee with marginal spur formation and joint space narrowing.
::DJDC::degenerative change of the C spine.
::DJDT::degenerative change of the T spine.
::DJDTL::degenerative change of the T and L spine.
::DJDTLM::mild degenerative change of the T and L spine.
::DJDTLS::degenerative change and scoliosis of the T and L spine. 
::DJDL::degenerative change of the L spine.
::DJDSS::degenerative change of the spine and shoulders.
::DRB::deformed right ribs.
::DLB::deformed left ribs.
::DBB::deformed bilateral ribs.
::DS::the stomach is distended,
::db1::Dense breasts and no definite mammographic abnormality in this study (ACR BI-RADS category 1). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
::db2::Dense breasts and benign mammographic findings in this study (ACR BI-RADS category 2). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
::db3::Dense breasts and probably benign mammographic findings in this study (ACR BI-RADS category 3). Suggest short term follow up andand ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
  

::ECMO::placement of large bore vascular cannula, consistent with ECMO.
::EE::the bowel gas pattern is unremarkable. 
::EF::much fecal material is noted in the bowel. 
::EFA::much fecal material is noted in the bowel at
::EM::bilateral pulmonary emphysema.
::EMFC::bilateral pulmonary emphysema with superimposed fibrotic change and ill defined patches.
::EN::enhancement 
::EO::disproportional dilated bowel loops, suggestive of obstructive ileus,
::ER::elevated right diaphragm.
::ERCX::Chest PA shows carciomegaly and bilateral lung consolidation, predominantly at lower lung fields.
::ERCX0::Chest PA shows normal heart size and bilateral lung consolidation.
::ERCXR::Chest PA shows cardiomegaly and right lower lung consolidation.
::ERCXL::Chest PA shows cardiomegaly and left lower lung consolidation.
::ERCHEST::Chest PA/AP shows cardiomegaly and bilateral lower lung consolidations.
::ERCHEST0::Chest PA/AP shows normal heart size and consolidation of bilateral lower lung fields.
::EL::elevated left diaphragm.
::esop::postoperative change with total esophagectomy. There is bypass grafting at the mediasitnum. Placement of multiple surgical clips at the mediastinum and upper abdomen. 
::et::placement of an endotracheal tube.
::etcvp::placement of an endotracheal tube and a central venous catheter. 
::etng::placement of an endotracheal tube and a NG tube.

::FB::fibrotic band(s)
::FC::fibrotic change
::FCRMLU::fibrotic change of the RML and inferior lingular segment of the LUL.
::FCM::mild fibrotic change
::FCMBU::mild fibrotic change of both upper lobes.
::FCBU::fibrotic change of both upper lobes.
::FCA::fibrocalcified change
::FCABU::fibrocalcified change of both upper lobes.
::FCALU::fibrocalcified change of the left upper lobe.
::FCARU::fibrocalcified change of the right upper lobe. 
::FX::fracture
::CFX::compression fracture

::GB::gall bladder
::BGS::gall stone(s).

::HET::heterogenous
::HETERODNB2::
(
Digital mammograms of both breasts in CC and MLO views are read without available prior mammograms for comparison. This study shows: 
1. heterogeneously dense fibroglandular tissue of both breasts which may decrease the sensitivity of this study. 
2. 

IMP: benign findings of this mammography, ACR BI-RADS category 2. Suggest annual mammogram follow up or ultrasound study if there is any clinical palpable lump or prior ultrasound detected abnormality.
)
::HY::hydronephrosis


::IC::in compare to previous similar study
::ICU::Chest AP shows cardiomegaly and bilateral consolidation.
::ICU0::Chest AP shows normal heart size and bilateral consolidation.
::ICUCUFF::Chest AP shows cardiomegaly and bilateral peribronchial cuffing.
::ICUCUFF0::Chest AP shows normal heart size and bilateral peribronchial cuffing.
::ICUD::Chest AP shows cardiomegaly and bilateral diffuse consolidation.
::ICUD0::Chest AP shows normal heart size and bilateral diffuse consolidation.
::ICUDPL::Chest AP shows cardiomegaly, bilateral diffuse consolidation and pleural effusion.
::ICUD0PL::Chest AP shows normal heart size, bilateral diffuse consolidation and pleural effusion.
::ICUDTRANG::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of a tracheostomy tube and a NG tube.
::ICUDTUBE::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of an endotracheal tube, a central venous catheter and a NG tube.
::ICUPL::Chest AP shows cardiomegaly, bilateral consolidation and pleural effusion.
::ICUTRA::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy tube.
::ICUTRANG::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy and a NG tubes.
::ICUTUBE::Chest AP shows cardiomegaly, bilateral consolidation and placement of an endotracheal tube, a NG tube and central venous catheter(s).
::ICUWIRE::Chest AP shows cardiomegaly, bilateral consolidation and placement of sternal wires.
::IUD::IUD is noted superimposed in the pelvic cavity. 

::K0::KUB shows normal bowel gas, no definite abnormal opacity, no definite abnormal bone change.
::Kdjd:: KUB shows normal bowel gas, no definite abnormal opacity, and degenerative change of the L spine.
::Kgas0::KUB shows decreased bowel gas.
::KGAS::KUB shows prominent bowel gas.
::KI::KUB shows dilated bowel loops and prominent gas, consistent with ileus.
::KST::KUB shows stool impaction and no definite bowel dilatation.

::L0::no definite abnormal lung abnormality.
::Lax::linear or subsegmental atelectasis
::LAPAX::bilateral axillary lymphadenopathy.
::LAPM::bilateral mediastinal lymphadenopathy.
::LAPMAX::bilateral mediastinal and axillary lymphadenopathy.
::LAPMH::bilateral mediastinal and hilar lymphadenopathy.
::LAPML::left mediastinal lymphadenopathy.
::LAPMHL::left mediastinal and hilar lymphadenopathy.
::LAPMR::right mediastinal lymphadenopathy.
::LAPMHR::right mediastinaland hilar lymphadenopathy.
::LAT::atelectasis
::LB::increased bilateral basal lungs infiltration. 
::LC::absence of the gall bladder with opaque clips in the hepatic hilum, compatible with laparoscopy cholecystectomy.
::LD::elevation of the diaphragm is noted, 
::LF::increased fibrotic change, 
::LG::diffusely linear shadows over bilateral lungs, chronic interstial lung disease is considered. 
::LH::increased pulmonary infiltration at bil peribronchial parahilar region; bronchitis is compatible. 
::LHH::prominent increased bilateral pulmonary infiltrations at peribronchial parahilar regions; bronchopneumonia is compatible.
::Ling::inferior lingular segment of the left upper lobe.
::LJV::placement of a left jugular venous catheter.
::LMRM::postoperative change with left mastectomy. 
::LMRMR::postoperative change with left mastectomy and placement of a right port A catheter.
::LOBECTOMYRU::postoperative change with lobectomy of the RUL and placement of surgical clips at the right hilum and mediastinum.
::LOBECTOMYRM::postoperative change with lobectomy of the RML and placement of surgical clips at the right hilum and mediastinum.
::LOBECTOMYRL::postoperative change with lobectomy of the RLL and placement of surgical clips at the right hilum and mediastinum.
::LOBECTOMYLU::postoperative change with lobectomy of the LUL and placement of surgical clips at the light hilum and mediastinum.
::LOBECTOMYLL::postoperative change with lobectomy of the LLL and placement of surgical clips at the left hilum and mediastinum.
::LO::low lung capacity.
::LOWABD::low lung capacity and abdominal distention. 
::LPL::left pleural effusion.
::LPORT::placement of a left port A catheter.
::LCT::placement of a left chest tube.
::LCVP::placement of a left central venous catheter.
::LSV::placement of a left subclavian venous catheter. 


::mcm::Chest PA shows mild cardiomegaly and no definite abnormal lung opacity.
::MCX::mild cardiomegaly. 
::ME::mediastinum 
::MED::bilateral small mediastinal lymph nodes.
::MEDAX::bilateral small mediastinal and axillary lymph nodes.
::MH0::no definite mediastinal or hilar lymphadenopathy.
::MN::multiple bilateral lung nodules, consistent with metastases.
::MOL::, more on left side.
::MOR::, more on right side.
::MRMR::postoperative change consistent with right mastectomy.
::MRML::postoperative change consistent with left mastectomy.

::NC::normal heart size.
::NG::placement of a NG tube.
::NF::no definite obvious bone fracture is recognized. 
::NICH::no definite intracranial hemorrhage. 

::OA::joint space narrowing with spur formation, compatible with degenerative change.
::OBSCL::obscured left lateral costophrenic angle. 
::OBSCR::obscured right lateral costophrenic angle. 
::OBSCB::obscured bilateral costophrenic angles. 
::OP::postoperative change 
::oprl::postoperative change of the right lung with placement of clips and suture at the right hilum and mediastinum.
::opru::postoperative change of the right upper abdomen with placement of clips.
::opll::postoperative change of the left lung with placement of clips and suture at the left hilum and mediastinum.
::oplu::postoperative change of the left upper abdomen with placement of clips.  
::opsp::postoperative change of the spine with placement of metallic transpedicle fixation.

::PL::pleural effusion.
::peri::increased bilateral peribronchial cuffing and infiltration. 
::PHVP::the poral & hepatic veins are patent.
::PK::apical pleural is irregular thickening, 
::PR::proximal 
::PRE::previous
::PTX::pneumothorax

::PSK::(Please refer to the uploaded key image with annotation in the Summary series) 
::PVL::increased low density in the peri-ventricular white matter, 
::PVLM::increased signal intensity in the peri-ventricular white matter, 

::RADL::post-radiation lung parenchymal change is considered.
::RAT::remove the endotracheal tube, 
::RC::remove the chest tube, 
::RCC::remove casting, 
::RJV::placement of a right jugular venous catheter.
::rport::placement of a right port A catheter.
::rct::placement of a right chest tube.
::rcvp::placement of a right central venous catheter.

::BRB::deformity of bilateral rib(s).
::RBR::deformity of right rib(s).
::LBR::deformity of left rib(s).

::RPL::right pleural effusion. 
::RMRM::postoperative change with right mastectomy.
::RMRML::postoperative change with right mastectomy and placement of a left port A catheter.
::RSV::placement of a right subclavian venous catheter.

::SABD::Standing abdominal film shows normal bowel gas and no definite abnormal bone change.
::SABDI::Standing abdominal film shows dilated bowel loops with prominent gas and air fluid level, consistent with an ileus.
::SABD0::Standing abdominal film shows decreased bowel gas and no definite abnormal bone change.
::SCOL::scoliosis of the spine 
::SCANL::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with L leg longer than R one about 
::SCANN::Low extremeties scanogram  with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows no definite obvious length discrepancy of the bilateral legs. 
::SCANR::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with R leg longer than L one about 
::scolt::Scoliosis of the T spine.
::scoltl::Scoliosis of the T and L spine.
::scoltlm::Mild scoliosis of the T and L spine.
::scoltm::Mild scoliosis of the T spine.

::screening::
(
Indication: screening for lung cancer or abnormality.
Low dose spiral CT (50mA, 120 kVP) without contrast enhancement and with coronal reconstruction shows:
1) no definite lung parenchymal lesion or mediastinal lymphadenopathy.
2) normal appearance of the adrenals.

IMP: no definite abnormality in the screening chest CT study.
)
 
::SG::placement of a Swan-Ganz catheter. 
::stat::stationary imaging findings as compared with prior study.
::SUB::bilateral subcutaneous emphysema.
::subatx::subsegmental atelectasis
::SUBR::right subcutaneous emphysema.
::SUBL::left subcutaneous emphysema. 
::SUCT::Suggest CT for further evaluation.
::SUS::Suggest ultrasound for further evaulation.

::TA::tortuous aorta.
::TAC::tortuous aorta with calcification. 
::TACE::post-TAE change with opaque contrast retention in the liver.
::TM::status post mediastineal tube insertion for drainage, 
::TOA::status post upper chest wall Port-A implantation, 
::TRA::placement of a tracheostomy tube.
::TRANG::placement of a tracheostomy tube and a NG tube.
::TRACVP::placement of a tracheostomy tube and a central venous catheter.
::TRATUBE::placement of a tracheostomy tube, a NG tube and a central venous catheter. 
::TUBE::placement of an endotracheal tube, a NG tube and a central venous catheter. 

::UB::urinary bladder
::UDC::double contour of the urinary bladder base is noted. 
::UU::smooth concaved cephalic contour of the urinary bladder, compatible with uterus indentation.

::VP::placement of a ventriculo-peritoneal (VP) shunt tube from the neck to the abdomen. 

::WIRE::placement of multiple sternal wires.
::wiretube::placement of multiple sternal wires, mediastinal drain, endotracheal and NG tubes.
::WX::without
::WT::wall thickening is noted, 
::WTE::wall thickening is noted with abnormal enhancement, 
::WTI::irregular wall thickening is noted, 




;1. 打完報告按Ctrl-Alt-Q關閉RIS與退出autohotkey:
^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.
IfWinExist ahk_class com.pohai.client.application.MainFrame
{
 WinActivate ahk_class com.pohai.client.application.MainFrame
 SendPlay !{F4}
}
ExitApp
 

 
;2. 設定Ctrl-Alt-E 叫出Notepad編輯autohotkey:
^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.
Edit
return
 



;3. 設定Ctrl-Alt-R reload script
^!r:: ; Assign Ctrl-Alt-R as a hotkey to restart the script.
Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return






 ;5. 設定Window-1 = Open the last ONE report
#1::
Click 857,552
Click 2
return

 ;6.  設定Window-2 = Open the last ONE report and Copy it
#2::
Click 857,552
Click 2
Sleep 100
Click 170,400
Click 2
return


;7.  設定Window-3 = Open the last ONE PACS image parallel 
; ( 1238,42 ) at report room-3 ( 1095,42 ) at room-1 & Ped-2 ( 1088,42 ) at CT & room-4
#3::
Click 857,552
Click right
Sleep 200
Click right 1012,635
Sleep 200
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return


;  設定Window-4 = open the images parallel...
#4::
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 26,579
return




;7-2.   設定Window-O = add "suggest correlated with clinical manifestration." then send report and  Open the last ONE PACS image parallel
#O::
Send suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 5000
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 300
Click 857,552
Sleep 100
Click right
Sleep 80
Click right 1012,635
Sleep 80
WinActivate, ahk_class #32770
Sleep 300
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return


;7-3.  設定 Window-I = add "sationary in compare to previous similar study, suggest correlated with clinical manifestration." then send send report and Open the last ONE PACS image parallel
#I::
Send sationary in compare to previous similar study, suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 5000
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 300
Click 857,552
Sleep 100
Click right
Sleep 80
Click right 1012,635
Sleep 80
WinActivate, ahk_class #32770
Sleep 300
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return

;7-4.  設定 Window-K =  add "status post-operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration." than send report and Open the last ONE PACS image parallel
#K::
Send status post-operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 3000
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 857,552
Sleep 100
Click right
Sleep 80
Click right 1012,635
Sleep 80
WinActivate, ahk_class #32770
Sleep 300
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 26,579
return

;8. 設定Window-A = Open the last TWO report
#A::
Click 944,578
Click 2
return

;9.  設定Window-S = Open the last TWO report and Copy it
#S::
Click 944,578
Click 2
Sleep 100
Click 170,400
Click 2
return


;10.  設定Window-D = Open the last TWO PACS image parallel
#D::
Click 944,578
Click right
Sleep 200
Click right 1012,670
Sleep 200
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 200
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return



; 設定Window-M = move cursor to IMAX and split image parallel for Whole -spine
#M::
WinActivate, ahk_class #32770
Sleep 200
Click 250,228
Sleep 100
Click 300, 1000
Sleep 100
Click 300, 1000
return


; 設定Window-N = move cursor back to RIS
#N::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 300, 800
return


; 設定Window-B = move cursor to IMAX only
#B::
WinActivate, ahk_class #32770
Sleep 100
Click 300, 1000
Sleep 100
Click 300, 1000
return




