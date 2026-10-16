﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <physician@hospital.example.com>
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
;#f::
;Send {ENTER}
;Click 72,371
;Send ^c
;Sleep, 1000
;Click 38,500
;Click 2
;Sleep, 200
;WinActivate, ahk_class AcucobolWClass
;Send ^v
;Send {ENTER}
;return

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

::3DR:: Reconstructed Three-dimensional (3D) images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation.
::VRR:: Reconstructed Virtual Reality scope (VR) images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 
::CINER:: Reconstructed CINE images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 
::MPRR::  Reconstructed Multi-planar reformat (MPR) images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 
::CTAR:: Reconstructed Computed Tomographic Angoigraphy (CTA) images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 
::VBR:: Reconstructed Virtual Bronchogram (VB) images had been created and successfully uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 
::CHDCT:: EKG-gated cardiac CT was performed, and the images were uploaded into PACS. Please review these images. Please contact me if you have any question. Thanks for your consultation. 

::AB::of abdomen. 
::ABN::abnormal
::ABD::abdominal distension noted,
::AA::suspect amorphous radiolucency is noted, 
::AD::distended and swelling of the abdomen wall 
::AG::radiopaque density over RUQ of abdomen, gall bladder stone is compatible. 
::AGG::aggravated condition/size increased in compare to previous similar imaging study, 
::AH::prominent soft tissue shadow at the nasopharyngeal roof, adenoid hypertrophy is compatible. 
::AK::radiopaque density over renal shadow represent renal stone, 
::AL::increased liver span with blunting of the hepatic angle represented of hepatomegaly. 
::ALN::mottled calcified nodule(s), probable of calcified lymph node(s). 
::ANG::relative paucity of the bowel gas, 
::AO::atherosclerosis with wall calcification of the aorta, 
::APC::scattered opaque density below symphysis pubis because of prostatic calcification,
::ASP::enlarged splenic shadow represent splenomegaly, 
::ASDD::s/p ASD occluder at the usual location, 
::ATO::the aorta is tortuous, 
::ATH::absence of the uterus, compatible with previous history of ATH,
::AU::opaque density over paraspinal region, suggestive of ureter stone, 

::BA::the alignment is preserved, 
::BFF::relative flatten bony arcs of bilateral feet, 
::BHF::hypoplastic femoral head,
::BI::bilateral
::BIIN::bilateral inguinal regions
::BIA::irregular acetabular fossa, 
::BK::status post operation with total knee replacement, 
::BMH::more healing noted, 
::BO::absence of breast shadow, compatible with previous mastectomy, 
::BP::diffusely decreased visible bone density, 
::BPR::with periosteal reaction,
::BR::status post operation with total hip replacement,

::CAM::cardiomegaly is noted,
::CAA::calcification 
::CAD::calcification of the coronary arteries, indicates CAD. 
::CB::borderline heart size,
::CC::normal heart size,
::CDH::relative shallow of the acetabular roof,   
::CK::increased bilateral lung markings, 
::CME::contrast medium
::CMI::presence of contrast medium in 
::COM::decreased pneumatization of mastoid antrum with sclerotic change, otitis medium is compatible. 
::COPD::hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible. 
::CPAC::cardiophrenic angle
::CPAL::costophrenic angle
::CPS::haziness/fluid of the paranasal sinuses, sinusitis is compatible, 
::CPS2::mucosal thickening of the maxillary sinus, 
::CS::of C-spine.
::CTAS::an accessory spleen is noted.  
::CTASS::accessory spleens are noted, n=
::CTAT::atherosclerosis representing by calcifications on the aortic wall. 
::CTATA::arteriosclerotic change with calcified plaque at intra-abdominal vessels.
::CTATH::arteriosclerotic change with calcified plaque at intracranial vessels.
::CTBA::prominent sulci, fissure and ventricles, brain atrophy is compatible. 
::CTBS::diffuse brain swelling with diminished sulci, fissure and CSF spaces. 
::CTC::well-defined homogenous low density shadow indicates cystic lesion is noted, 
::CTCA::paucity of the soft tissue and fatty tissue in body wall, cachexia compatible.
::CTCC::hyper-dense shadows are noted at pineal gland and choroid plexuses, indicates calcifications. 
::CTD::the estimated radiation dose (mSv) of this study is about: 
::CTFL::generalized decreased liver density indicates fatty change of liver. 
::CTIL::generalized increased liver density and prominence of hepatic vasculature, iron overriding of liver is compatible. 
::CTLA::low density change at bilateral peri-ventricular white matter, leukoaraiosis is considered. 
::CTLC::uneven hepatic surface, coarse texture, splenomegaly, indicates liver cirrhosis. 
::CTLD::low density lesion noted at 
::CTLM::multiple heterogenous low density shadows in the liver, indicates liver metastasis. 
::CTLN::enlarged (>1cm) lymphadenopathy is recognized, 
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
::CTSN::small (<1cm) lymphadenopathy is noted, 
::CTTB::fibro- &/or calcify- &/or cystic change on the bilateral apical lungs, indicates pulmonary T.B. infection. 

::D::   day(s) ago, 
::DEX::dextrocardia noted,
::DIS::distal
::DISL::dislocation
::DS::the stomach is distended, 

::ECMO::ECMO used,
::EE::the bowel gas pattern is unremarkable. 
::EF::much fecal material is noted in the bowel. 
::EFA::much fecal material is noted in the bowel at
::EL::focal dilated bowel loops, suggestive of local ileus, 
::EN::enhancement 
::EO::disproportional dilated bowel loops, suggestive of obstructive ileus, 
::EP::proportional dilated bowel loops, suggestive of paralytic ileus. 
::FC::compression bony fracture is noted,
::FF::bone fracture is noted, 
::FFD::displaced bone fracture is noted, 

::G::suggest correlated with clinical manifestation.
::GB::gall bladder 
::GCCT::suggest coronary CT for further evaluation. 
::GD::suggest decubitus (>3min) abdomen with cross-table x-ray or standing (>3min) CXR cover upper abdomen image to detect possible free air.
::GG::suggest follow up & correlated with clinical manifestation. 
::GEB::suggest alimentary barium study for further workup. 
::GES::suggest alimentary-scopy study for further workup. 
::GL::suggest lateral view for further evaluation. 
::GR::suggest MRI study for further evaluation. 
::GS::suggest further workup & correlated by sonography. 
::GT::suggest CT study for further evaluation. 
::GTT::suggest non-contrast CT for further screening. 
::GU::suggest IVP for further evaluation. 

::HET::heterogenous
::HY::hydronephrosis


::IC::in compare to previous similar study 
::ICV::CVP line insertion from the inguinal region, 
::IDM::ill-defined margin
::II::increased infiltration 
::IMP::condition improved/size decreased in compare to previous similar study,
::INF::inflammation 
::ING::inguinal region.
::IP::compatible. 
::IRR::irregular
::ISD::increased soft tissue density shadow
::IUD::IUD is noted superimposed in the pelvic cavity. 
::IVO::_IVP_OK.

::K10:: Chest CT without contrast shows:
::K1::Chest CT with contrast shows:
::K11::Chest CT with & without contrast shows: 
::K20::Abdominal CT without contrast shows:
::K2::Abdominal CT with contrast shows:
::K22::Abdominal CT with & without contrast shows:
::K2X::(P.S. The detail findings in chest & thorax please refer to the report from Chest CT.)
::K30::Chest and abdominal CT without contrast shows: 
::K3::Chest and abdominal CT with contrast shows: 
::K33::Chest & abdomen CT with & without contrast shows:
::K333::Chest & upper abdomen CT with & without contrast shows: 
::K40::Abdominal and pelvic CT without contrast shows:
::K4::Abdominal and pelvic CT with contrast shows: 
::K44::Abdomen & pelvic CT with & without contrast shows: 
::K5::Tri-phase dynamic abdominal CT study (pre-, arterial- and portal venous phases) shows:
::K60::Head CT without contrast show: 
::K6::Head CT with contrast show: 
::K66::Head CT with & without contrast shows: 
::K70::Head MRI without contrast show: 
::K77::Head MRI with & without contrast show:
::KR::Request report with Images created from outside Hospital by 
::KRP::Request report with Images created from outside Hospital but poor quaity that will limited the reporting confidence 

::L::left
::LS::of the L-spine. 

::LAT::atelectasis
::LB::increased bilateral basal lungs infiltration. 
::LC::absence of the gall bladder with opaque clips in the hepatic hilum, compatible with laparoscopy cholecystectomy.
::LD::elevation of the diaphragm is noted, 
::LE::emphysematous change of the lung, 
::LF::increased fibrotic change, 
::LG::diffusely linear shadows over bilateral lungs, chronic interstitial lung disease is considered. 
::LH::increased pulmonary infiltration at bilateral peri-bronchial para-hilar region; bronchitis is compatible. 
::LHH::prominent increased bilateral pulmonary infiltrations at peri-bronchial para-hilar regions; bronchopneumonia is compatible. 
::LI::increased pulmonary infiltration, 
::LL::essential clear of the bilateral lung fields without definite nodular shadow. 
::LN::nodular lesion is noted, 
::LO::increased opacity, 
::LOO::status post operation with multiple suture materials and metallic clips in the hilum, 
::LP::ill-defined hyperdense patchy lesion suggestive of pneumonia,
::LPS::small patch shadow noted, 
::LR:: dilated bronchi, suggestive of bronchiectasis, 
::LSS::fine interstitial pattern of the bilateral lungs; senile change is compatible. 
::LT::multiple pulmonary nodules of variable size, suggestive of lung metastasis. 
::LTB::fibrotic change of the bilateral upper lungs, pulmonary T.B. is considered. 
::LU::prominent pulmonary hilum is noted, 
::LWM::widen of the mediastinum is noted, 
::LX::free air collection in the pleural space suggestive of pneumothorax, 

::M::mild 
::MAF::severe motion artifact due to the involuntary movement of the patient that may mask the detail finding. 
::ME::mediastinum 
::MGC::much gas collection in the bowel loops,
::MGCA::much gas collection in the bowel loops at
::MGEC::much gas & fecal material collection in the bowel loops,
::MI::minimal
::MID::middle
::MO::moderate 
::MOL:: more on L.
::MOR:: more on R.

::N::no definite 
::NA::no definite bone lesion, the bowel gas pattern is unremarkable. 
::NAF::no definite bone lesion, much fecal material is noted in the bowel loops, suggest correlated with clinical presentation & follow up. 
::NAG::no definite bone lesion, the bowel gas pattern is unremarkable, suggest correlated with clinical presentation and follow up study if clinically indicates. 
::NAT::nature ? 
::NAT2::the lesion too small to be further characterized.
::NB::no definite obvious bone lesion. 
::NBG::no definite obvious bone lesion, no definite obvious fracture. please correlated with clinical presentation or follow up. 
::NC::essential clear of the bilateral lung fields, the heart and diaphragm are normal. 
::NCG::essential clear of the bilateral lungs, normal heart size. No definite abnormal shadow. Suggest correlated with clinical presentation and follow up. 
::ND::no definite obvious bone lesion, the joint space and alignment are normal. 
::NF::no definite obvious bone fracture is recognized. 
::NFA::no definite free air is noted at the non-dependent portion, 
::NFB::no definite radiopaque foreign body is noted at the pharynx, upper trachea & esophagus. 
::NFSPK::no definite focal lesion in the pancreas, spleen and bilateral adrenal glands & kidneys.
::NFLSP::no definite focal lesion in the liver, pancreas and spleen. 
::NFLSPK::no definite focal lesion in the liver, pancreas, spleen and bilateral adrenal glands & kidneys. 
::NFLSU::no definite focal lesion in the visible upper liver and spleen. 
::NICH::no definite intra-cranial hemorrhage. 
::NLC::nuchal ligament calcification is noted, 
::NLN::no definite enlarged (>1cm) lymphadenopathy is noted. 
::NNBL::no definite focal nodular lesion in the bilateral basal lungs. 
::NOB::no definite gross osteolytic / osteosclerotic bone lesion is recognized. 
::NOP::no definite radiopaque nodular shadow noted,
::NR::bilateral clear psoas and renal shadows are recognized. 
::NRT::no definite recurrent tumor mass is noted. 
::NS::no definite bone lesion, the disc spaces and alignment are normal, 
::NVT::no definite viable tumor could be identified that representing as enhanced nodule, 


::O::others
::OA::joint space narrowing with spurs formation, degenerative change is compatible, 
::OC::external cast fixation is found which may mask the details findings, 
::OK:: the report of this study is OK.
::OO::status post operation change, 
::OOC::status post operative change with clips, 
::OOCS::status post operative change with clips & suture materials, 
::OOI::status post operation change with implant,
::OOS::status post operative change with suture materials, 
::OOT::status post-operative changes with tube(s) in the field of view with appropriate position, 
::OOTSSG::status post-operative changes with tube(s) in the field of view with appropriate position, stationary in compare to previous similar study, suggest correlated with clinical manifestation. 
::OST::others stationary in compare to previous similar study. 
::OW::status post operative change with wiring, 
::OWS::status post operative change with wiring at sternum, 
::OX::status post internal fixation, 

::P::prominent 
::PC::calcified pleural peel is noted, 
::PDAC::s/p coil embolization of the PDA at the usual location, 
::PDAD::s/p device embolization of the PDA at the usual location, 
::PE::pleural effusion is noted, 
::PHVP::the portal & hepatic veins are patent.
::PK::apical pleural is irregular thickening, 
::PP::pelvic floor phlebolith(s) is(are) noted,
::PR::proximal 
::PRE::previous

::PSK::(Please refer to the uploaded key image with annotation in the Summary series) 
::PVL::increased low density in the peri-ventricular white matter, 
::PVLM::increased signal intensity in the peri-ventricular white matter, 

::QQ::the nature should be further determined ?

::R::right
::RAT::remove the endotracheal tube, 
::RC::remove the chest tube, 
::RCC::remove casting, 
::RG::remove the NG tube, 
::RM::remove the mediastinal drainage tube, 
::RP::remove the CVP line, 
::RT::soft tissue density shadow indicates recurrent lesion is noted,
::RX::remove fixation, 

::SC::spine scoliosis is noted, 
::SCANL::Lower extremity scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with L leg longer than R one about 
::SCANN::Low extremity scanogram  with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows no definite obvious length discrepancy of the bilateral legs. 
::SCANR::Lower extremity scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with R leg longer than L one about 
::SCI::faint cerebral gyral indentation on the skull bone, 
::SD::spine lordosis is noted, 
::SH::shadow
::SK::spine kyphosis is noted, 
::SL::spondylolithesis is noted, 
::SN::essential clear of the bilateral paranasal sinuses without definite bone change, 
::SO::bone defect is noted over posterior part of spine represented previous laminectomy, 
::SOP::s/p
::SP::spondylosis and degenerative changes with marginal spurs are noted, 
::SS::stationary in compare to previous similar study, 
::SSD::stationary in compare to previous similar study.
::SSG::stationary in compare to previous similar study, suggest correlated with clinical manifestation. 
::STS::soft tissue swelling noted,
::SU::suspect
::SUP::superimposed
::SVI::vascular indentation on the skull bone, 


::TA::status post endotracheal tube insertion. 
::TAE::status post-TAE effect with opaque shadow
::TAN::s/p anal tube insertion,
::TC::status post chest tube insertion, 
::TD::status post drainage tube insertion, 
::TE::status post tracheostomy with airway tube insertion, 
::TG::status post NG tube insertion, 
::TK::status post PCN catheter insertion, 
::TL::of the T-L spine. 
::TLJ::at the junction of the T-L spine. 
::TM::status post mediastinal tube insertion for drainage, 
::TN::with normal position,
::TOA::status post upper chest wall Port-A implantation, 
::TP::status post CVP line insertion, 
::TR::status post pacemaker implantation, 
::TRT::status post rectal tube insertion, 
::TS::of the T-spine. 
::TSA::s/p tracheostomy with airway insertion, 
::TU::status post double-J catheter insertion, 
::TUA::s/p umbilical arterial line insertion, 
::TUAV::s/p umbilical arterial & venous lines insertion, 
::TUV::s/p umbilical vein line insertion, 
::TVP::s/p ventriculo-peritoneal (VP) shunt tube placement, 

::UB::urinary bladder
::UDC::double contour of the urinary bladder base is noted. 
::UU::smooth concaved cephalic contour of the urinary bladder, compatible with uterus indentation.

::VT::viable tumor is noted with presenting as enhanced mass at 

::WI::with
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








;設定Window-1 Open the last ONE report
#1::
Click 857,565
Click 2
return

;設定Window-2 Open the last ONE report and Copy it
#2::
Click 857,565
Click 2
Sleep 100
Click 170,400
Click 2
return

;設定Window-3 Open the last ONE PACS image parallel 
; ( 1238,42 ) at report room-3 ( 1095,42 ) at room-1 & Ped-2 ( 1088,42 ) at CT & room-4
#3::
Click 857,565
Click right
Sleep 200
Click right 1012,656
Sleep 200
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 300
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return

;設定Window-4 open the images parallel...
#4::
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 26,579
return








;設定Window-A Open the last TWO report
#A::
Click 944,585
Click 2
return

;設定Window-S Open the last TWO report and Copy it
#S::
Click 944,585
Click 2
Sleep 100
Click 170,400
Click 2
return

;設定Window-D Open the last TWO PACS image parallel
#D::
Click 944,585
Click right
Sleep 200
Click right 1012,676
Sleep 200
WinActivate, ahk_class #32770
Sleep 100
Click 1095,42 
Sleep 200
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return

;設定Window-F Open the last 2nd PACS image parallel when the last ONE has been opened
#F::
Click 944,585
Click right
Sleep 200
Click right 1012,676
Sleep 200
WinActivate, ahk_class #32770
Sleep 300
Click 1000,50 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return







;設send say:suggest correlated with clinical manifestration and Open the last ONE PACS image parallel
#O::
Send suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 5000
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 300
Click 857,565
Sleep 100
Click right
Sleep 180
Click right 1012,650
Sleep 200
WinActivate, ahk_class #32770
Sleep 200
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return

;設say:Send sationary in compare to previous similar study,  and  Open the last ONE PACS image parallel
#I::
Send sationary in compare to previous similar study, suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 5000
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 300
Click 857,565
Sleep 100
Click right
Sleep 180
Click right 1012,650
Sleep 200
WinActivate, ahk_class #32770
Sleep 200
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 200
Click 26,579
return

;設 say:status post-operative changes with tube(s) in the field of view with appropriate position, send report and 定Window-3 Open the last ONE PACS image parallel
#K::
Send status post-operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration. 
Click 637, 1481
Sleep 3800
winActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 300
Click 857,565
Sleep 300
Click right
Sleep 200
Click right 1012,650
Sleep 200
WinActivate, ahk_class #32770
Sleep 200
Click 1095,42 
Sleep 500
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 26,579
return







; consult by add "Report Passed" and send to Resident PHS 
#P::
Click 703,501
Sleep 800
Send "Report Passed"
Sleep 100
Click 153, 119
Sleep 1000
Click 130, 101
Sleep 500
Click 600, 900
Sleep 100
Click 640, 1485
return

; Copy Chart number and type "Report corrected" send to Resident PHS 
#C::
Click 703,501
Sleep 1200
Click 163, 132
Sleep 1200
Click 140, 110
Sleep 1200
Click 640, 1485
return






; move cursor to IMAX and split image parallel for Whole -spine
#M::
WinActivate, ahk_class #32770
Sleep 200
Click 250,228
Sleep 100
Click 300, 1000
Sleep 100
Click 300, 1000
return

; move cursor back to RIS
#N::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Sleep 100
Click 300, 800
return

; move cursor to IMAX only
#B::
WinActivate, ahk_class #32770
Sleep 100
Click 300, 1000
Sleep 100
Click 300, 1000
return






; consult by add "Gornad protection is not adequate" and send to 蘇茂源 PHS 
#L::
Click 703,501
Sleep 2000
Send "Poor Gornad protection"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return

; consult by add "poor collimation" and send to 蘇茂源 PHS 
#6::
Click 703,501
Sleep 2000
Send "Poor collimation"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return


; consult by add "poor position" and send to 蘇茂源 PHS 
#7::
Click 703,501
Sleep 2000
Send "Poor position"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return

; consult by add "poor quality"(KV?MA?)" and send to 蘇茂源 PHS 
#8::
Click 703,501
Sleep 2000
Send "Poor quality(KV?MA?)"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return

; consult by add "Good collimation/quality/position" and send to 蘇茂源 PHS 
#9::
Click 703,501
Sleep 2000
Send "Good collimation/quality/position"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return

; consult by add "Good protection" and send to 蘇茂源 PHS 
#0::
Click 703,501
Sleep 2000
Send "Good gornad protection"
Sleep 500
Click 153, 119
Sleep 500
Click 130, 101
Sleep 500
return



