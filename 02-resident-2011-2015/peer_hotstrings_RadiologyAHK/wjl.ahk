﻿﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         WJL <physician@hospital.example.com>
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; Run first
WinGet, active_id, ID, A
MsgBox,,,WJL's Autohotkey loaded on %A_ComputerName%,0.7 

SetTimer, Auto_Quit, 2000

Auto_Quit:
If A_TimeIdle > 1______
{
   Gosub, Quit_All
}
return

F10::Space

If A_ComputerName = XRAYRPT-05 ; 1st computer
{
 RISPath=C:\WINDOWS\system32\javaws.exe "C:\Documents and Settings\image\Application Data\Sun\Java\Deployment\cache\javaws\http\D172.31.11.128\P8888\DMNtuh\AMNtuh.jnlp"
 DS_X=2208
 DS_Y=-903
}
If A_ComputerName = XRAYRPT-62 ; New 3rd computer
{
 RISPath=C:\Program Files\Java\j2re1.4.2_05\javaws\javaws.exe "@C:\Documents and Settings\image\Application Data\Sun\Java\Deployment\javaws\cache\indirect\indirect50407.ind"
 DS_X=2510
 DS_Y=-482
}
If A_ComputerName = XRAYRPT-07 ; New 4th computer
{
 RISPath=C:\Program Files\Java\j2re1.4.2_05\javaws\javaws.exe "@C:\Documents and Settings\image.XRAYRPT-31\Application Data\Sun\Java\Deployment\javaws\cache\indirect\indirect32173.ind"
 DS_X=2510
 DS_Y=-914
}


If A_ComputerName = XRAYRPT-4 ; YMT's computer
{
 RISPath=C:\Program Files\Java\j2re1.4.2_05\javaws\javaws.exe "@C:\Documents and Settings\image\Application Data\Sun\Java\Deployment\javaws\cache\indirect\indirect20335.ind"
 DS_X=2508
 DS_Y=-383
}

If A_ComputerName = XRAYRPT-30 ; CT room
{
 RISPath=C:\Program Files\Java\j2re1.4.2_05\javaws\javaws.exe "@C:\Documents and Settings\image\Application Data\Sun\Java\Deployment\javaws\cache\indirect\indirect45049.ind"
 DS_X=2518
 DS_Y=-918
}


If A_ComputerName = wenjeng
 RISPath=C:\Program Files\Java\j2re1.4.2_05\javaws\javaws.exe "@C:\Documents and Settings\Administrator\Application Data\Sun\Java\Deployment\javaws\cache\indirect\indirect49981.ind"
WinActivate, ahk_id %active_id%
return

;--------------------------------------------------------------------------
^!s::Suspend  ; Assign the toggle-suspend function to a hotkey.

^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.
Gosub, Quit_All
return

Quit_All:
IfWinExist ahk_class com.pohai.client.application.MainFrame
{
 WinActivate ahk_class com.pohai.client.application.MainFrame
 SendPlay !{F4}
}
Sleep 800
run net use /delete /yes * 
Gosub, Quit_MSTSC
run net use /delete /yes * 
; Run, ejectusb.exe
IfWinExist,ahk_class IEFrame
 Winkill
ExitApp

^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.
Edit
return

^!r:: ; Assign Ctrl-Alt-R as a hotkey to restart the script.
Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return

;---------------------------------------
#i::
SendPlay 004582{Tab}
Sleep, 500
SendPlay A123456789{Enter}
return

#p::
SendPlay 671328{Enter}
return

#s::
IfWinNotExist, ahk_class SunAwtDialog
 {
  Run, %RISPath%
  WinWaitActive , ahk_class SunAwtDialog,,30
  if ErrorLevel
  {
    MsgBox, WinWait timed out.
    return
  }
 }
WinActivate, ahk_class SunAwtDialog
WinWaitActive, ahk_class SunAwtDialog,,2
SendPlay 004582{Tab}
Sleep, 300
SendPlay 4321
Sleep, 200
Click 337,261
IfWinExist,ahk_class ThunderRT6FormDC
 {
  Gosub, RUN_PACS
 }
return
;---------------------------------------


RUN_PACS:
 WinActivate, ahk_class ThunderRT6FormDC
 WinWaitActive, ahk_class ThunderRT6FormDC,,15
 SendPlay 004582{Tab}
 Sleep, 500
 SendPlay A123456789{Enter}
return

^z::
Gosub, MSTSC
return

^q::
Gosub, Quit_MSTSC
return


MSTSC:
IfWinNotExist, ahk_class TSSHELLWND
{
 Run, mstsc,exe
 Sleep, 300
 Winactivate, ahk_class#32770
 WinWaitActive, ahk_class#32770,,10
 Send 10.0.0.100
 Sleep, 300
 Send {Enter}
 Sleep, 600
}
WinActivate, ahk_class TSSHELLWND
WinWaitActive, ahk_class TSSHELLWND,,10
return

Quit_MSTSC:
IfWinExist,ahk_class TSSHELLWND
{
 Winkill
 Sleep, 500
 WinActivate, ahk_class#32770
 WinWaitActive , ahk_class#32770,,4
 SendInput {Enter}
}
return


^g::
IfWinExist,ahk_class IEFrame
 Winkill
Run, IEXPLORE.EXE, max
Sleep, 800
SendPlay 004582{Tab}
Sleep, 500
SendPlay A123456789{Enter}
WinActivate, ahk_class IEFrame
WinWaitActive, ahk_class IEFrame,,5
MouseMove 88,309
Click
Sleep, 500
MouseMove 70,547
Click
Sleep, 500
MouseMove 222,545
Sleep, 500
MouseMove 207,570
Click
Sleep, 500
MouseMove 375,575
Click
Sleep, 1500
Click 242, 198
Sleep, 300
SendPlay 671328{Enter}
Return

; For ultrasound


Send_Sono_report:
WinActivate, ahk_class TMainForm
MouseMove 602,607
Click
Sleep 200 
MouseMove 524,663
Click
MouseMove 264,639 
Click
Sleep 1000
Gosub, ID_Input
return

F12::   ; Enter ID number
Gosub, ID_Input
return


^LButton::  ; Click worklist and shows images
Gosub, Click_Sono_Worklist
return

^Numpad7::    ; Click first entry in worklist and shows images 
MouseMove, 517, 136 
Gosub, Click_Sono_Worklist
return

Click_Sono_Worklist:
Click 2 
Sleep 2000
WinActivate, ahk_class TMainForm
WinWaitActive , ahk_class TMainForm,,15
Click 421,84
Sleep 1000
Click 58,199
return

ID_Input:
InputBox, ID,ID,ID:,,200,120
clipboard=%ID%
WinActivate, ahk_class Twork_list
WinWaitActive , ahk_class Twork_list,,30
Click 76,671
Sleep 300
Click 91,698
Sleep 300
Sendplay %ID%{Enter}
MouseMove,425,136
return


;----------------------------------------------------------------
#IfWinExist ahk_class com.pohai.client.application.MainFrame
^r::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 257,86
Sleep, 500
Click 986,228
return

^Numpad1::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 594, 296
Gosub, ClickWorklist
return

^Numpad2::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 594, 316
Gosub, ClickWorklist
return

^Numpad3::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 594,337
Gosub, ClickWorklist
return

^Numpad4::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 594,359
Gosub, ClickWorklist
return

^Numpad5::
WinActivate, ahk_class com.pohai.client.application.MainFrame
Click 594,383
Gosub, ClickWorklist
return

Send_Report_and_Backtolist:
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendInput {F3}
Sleep, 3000
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,15
Click 257,86
Sleep, 900
Click 986,228
MouseMove, 986, 298
return

ClickWorklist:
Sleep, 500
Click 2
Sleep, 1000
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,10
SendPlay {F4}
Click 206,695
return


^e::
SendPlay {Esc}
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendPlay {F4}
return

^i::
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendPlay {F5}
return

^d::
Gosub, ToggleDualScreen
return

^b::
SendInput ^c
SendInput {F5}
Sleep, 300
SendInput ^v{Space}
SendInput {F4}
Return

^Down::
SendPlay {Backspace}{Backspace}-
return

^l::
MouseGetPos, xpos, ypos 
WinActivate, ahk_class #32770
MouseClick, right, 966, 1243
 Sleep, 400
Click 132, 249
WinActivate, ahk_class com.pohai.client.application.MainFrame
WinActivate, ahk_class #32770
Click 1374, 1489
WinActivate, ahk_class com.pohai.client.application.MainFrame
WinWaitActive, ahk_class com.pohai.client.application.MainFrame,,5
MouseMove %xpos%, %ypos%
return

ToggleDualScreen:
MouseGetPos, xpos, ypos 
WinActivate, ahk_class #32770
;Click %DS_X%, %DS_Y%
Click 319, 55
WinActivate, ahk_class com.pohai.client.application.MainFrame
WinWaitActive, ahk_class com.pohai.client.application.MainFrame,,5
MouseMove %xpos%, %ypos%
return

^Left::
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendInput {F11}
return

^Right::
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendInput {F12}
return

CapsLock::
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendInput {F3}
return


^Enter::
SendPlay {Home}{Enter}{Up}
return

#IfWinExist

#IfWinActive ahk_class com.pohai.client.application.MainFrame
Tab::
WinActivate, ahk_class com.pohai.client.application.MainFrame
SendInput The lung parenchyma are symmetrical in density with normal pulmonary markings and no masses evident. There is no pleural thickening and the costophrenic angles are sharp. 
Sleep 100
SendInput {F3}
return
#IfWinActive

;----------------------------------------------------------------------------
#Hotstring EndChars  `n `t.,:
::abd::abdomen
::ad::- Adrenal glands: Unremarkable.
:o:andc::及
::ao::Atherosclerosis with wall calcification of the aorta. 
::mao::Mild atherosclerosis with wall calcification of the aorta. 
:c:AS::
SendInput Calcification of the aortic valve, suspect aortic stenosis.{Space}
SendInput {F5}
Sleep, 300
SendInput Suspect aortic stenosis.{Space}
SendInput {F4}
Return
:c:AR::with incomplete coaptation, compatible with aortic regurgitation. 
:c:AP::aortopulmonary window
:c:AVR::aortic valve replacement
::bct::Placement of bilateral chest tubes. 
::b0::
SendInput BI-RADS Category 0 Need additional imaging evaluation.
SendInput {Enter}需附加其他影像檢查再評估
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b1::
SendInput No mammographic evidence of malignancy. Ultrasound correlation suggested if palpable lump. BI-RADS Category 1 Negative.
SendInput {Enter}無異常發現
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b2::
SendInput No mammographic evidence of malignancy. Ultrasound correlation suggested if palpable lump. BI-RADS Category 2 Benign Finding(s).
SendInput {Enter}良性發現
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b3::
SendInput BI-RADS Category 3 Probably Benign Finding - Short Interval Follow-Up Suggested.
SendInput {Enter}可能是良性發現－需六個月追蹤檢查
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b4a::
SendInput BI-RADS Category 4A Suspicious Abnormality (low suspicious for malignancy) - Biopsy Should Be Considered.
SendInput {Enter}可疑異常需考慮組織生檢
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b4b::
SendInput BI-RADS Category 4B Suspicious Abnormality (intermediate suspicious of malignancy) - Biopsy Should Be Considered.
SendInput {Enter}可疑異常需考慮組織生檢
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b4c::
SendInput BI-RADS Category 4C Suspicious Abnormality (moderate concern, but not classic) - Biopsy Should Be Considered.
SendInput {Enter}可疑異常需考慮組織生檢
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b5::
SendInput BI-RADS Category 5 Highly Suggestive of Malignancy - Appropriate Action Should Be Taken.
SendInput {Enter}高度疑似為惡性腫瘤必須採取適當的措施
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b6::
SendInput BI-RADS Category 6 Biopsy-Proven Malignancy - Appropriate Action Should Be Taken.
;Gosub, Send_Report_and_Backtolist
SendInput {F3}
return
::b0s::
SendInput BI-RADS Category 0 Need additional imaging evaluation. Mammography correlation suggested. 
Gosub Send_Sono_report
return
::b1s::
SendInput BI-RADS Category 1 Negative. No evidence of malignancy.
Gosub Send_Sono_report
return
::b2s::
SendInput BI-RADS Category 2 Benign Finding(s).
Gosub Send_Sono_report
return
::b3s::
SendInput BI-RADS Category 3 Probably Benign Finding - Short Interval Follow-Up Suggested.
Gosub Send_Sono_report
return
::b4s::
SendInput BI-RADS Category 4 Suspicious Abnormality - Biopsy Should Be Considered.
Gosub Send_Sono_report
return
::b5s::
SendInput BI-RADS Category 5 Highly Suggestive of Malignancy - Appropriate Action Should Be Taken.
Gosub Send_Sono_report
return
::b6s::
SendInput BI-RADS Category 6 Biopsy-Proven Malignancy - Appropriate Action Should Be Taken.
Gosub Send_Sono_report
return

::bbc::Blunted bilateral costophrenic angles. 
::bc::- A benign calcification in
::bi::Bilateral lung consolidations. 
::bil::bilateral 
:o:bilc::兩側
::bin::Bilateral lung nodular opacities and consolidations. 
::bl::Breast lump
::blc::Blunted left costophrenic angle. 
::bll::bilateral lower lung zones. 
::bul::bilateral upper lung zones. 	
::bo::Mildly increased cardiothoracic ratio.	
::bp::Diffusely decreased visible bone density, suggestive of osteoporosis. 
::bpl::Bilateral pleural effusion. 
::br::breast
::brc::Blunted right costophrenic angle. 
::brs::breasts
::bs::Breast cancer status post operation
:C:c::Cardiomegaly. 
::ca::- Scattered benign appearing calcifications.
:c:cabg::Status post coronary artery bypass surgery.
::calc::calcification
::CAD::
SendInput Calcified atherosclerotic plaque(s) in the coronary arteries, compatible with coronary atherosclerosis. 
SendInput {F5}
Sleep, 300
SendInput Coronary atherosclerosis.{Space}
SendInput {F4}
Return
::cao::coronary atherosclerosis 
::caoc::動脈硬化, 無顯著狹窄
::cap::calcified plaque
::caps::calcified plaques
::ccto::Chest CT without and with intravenous contrast enhancement shows: {Enter}-
:r0:cct::
(
TECHNIQUE: Multidetector row CT of the chest was performed before and after intravenous contrast administration.
FINDINGS:
- Lungs:{Space}
- Pleura: No effusion.{Space} 
- Thoracic lymph nodes: No adenopathy.{Space}
- Great vessels:{Space}
- Heart and pericardium:{Space}
- Adrenal glands: Unremarkable.{Space} 
- Bones/Soft tissues:{Space}
- Other: None. {Up 9}{End}
)
:r0:ccta::
(
TECHNIQUE: Multidetector row CT of the chest was performed before and after intravenous contrast administration.
FINDINGS:
- Lungs:{Space}
- Pleura: No effusion.{Space} 
- Thoracic lymph nodes: No adenopathy.{Space}
- Great vessels:{Space}
- Heart and pericardium:{Space}
- Bones/Soft tissues:{Space}
- Other: None. 
(For the abdominal images, please check the report of abdomen CT.) {Up 9}
)

:r0:cact::
(
TECHNIQUE: Multidetector row CT of the chest was performed after intravenous contrast administration.
FINDINGS:
- Lungs:{Space}
- Pleura: No effusion.{Space}
- Thoracic lymph nodes: No adenopathy.{Space}
- Great vessels:{Space}
- Heart and pericardium:{Space}
- Bones/Soft tissues:{Space}
- Other: None.{Space}
(For the abdominal images, please check the report of abdomen CT.){Up 9}
)
:r0:ncct::
(
TECHNIQUE: Multidetector row CT of the chest was performed without intravenous contrast administration.
FINDINGS:
- Lungs:{Space}
- Pleura: No effusion.{Space} 
- Thoracic lymph nodes: No adenopathy.{Space}
- Great vessels:{Space}
- Heart and pericardium:{Space}
- Adrenal glands: Unremarkable.{Space} 
- Bones/Soft tissues:{Space}
- Other: None. {Up 9}
)
:r0:nccta::
(
TECHNIQUE: Multidetector row CT of the chest was performed without intravenous contrast administration.
FINDINGS:
- Lungs:{Space}
- Pleura: No effusion.{Space} 
- Thoracic lymph nodes: No adenopathy.{Space}
- Great vessels:{Space}
- Heart and pericardium:{Space}
- Bones/Soft tissues:{Space}
- Other: None. 
(For the abdominal images, please check the report of abdomen CT.){Up 9}
)
::cacto::Chest CT with intravenous contrast enhancement shows:{Enter}-{Enter}(For the abdominal images, please check the report of abdomen CT.){Left 67}
:o:com::COMPARISON: CT of the chest dated 2011-. {Left 2}
::nccto::Chest CT without intravenous contrast enhancement shows: {Enter}-
::CM::No significant interval change as compared with prior study. 
::cn::calcified nodule
::cns::calcified nodules
::CO::Consolidation in 
::CP::costophrenic angle. 
::CPs::Costophrenic angles. 
:C:cv::Placement of artificial cardiac valve. 
::cw::compatible with
::de::- Focal asymmetry in Ultrasound correlation suggested.{Left 34}
::dec::decreased
::dist::distal 
::dl::Placement of a double lumen catheter. 
::DJ::Degenerative change of both shoulders. 	
::EF::Much of fecal material in the bowel. 	
::EL::Focal dilated bowel loops, suggestive of focal ileus at
::ell::Elevated left hemidiaphragm. 
::elr::Elevated right hemidiaphragm.  	
::eln::enlarged lymph nodes 
::em::Emergent 
::emt::Emergent abdomen and pelvis CT without and with intravenous contrast enhancement shows: {Enter}- 
::eso::- Esophagus: 
::EU::Dilated bowel loops, suggestive of ileus. 
::fr::Fracture line in 
::frs::Fractures line in
::fa::fibroadenoma 
::fas::fibroadenomas
::FC::Compression fracture in 
::FCs::Compression fractures in 
::fi::Fibrotic change in
:C:F/U::follow up
::GB::Metallic clips in the right upper quadrant of the abdomen. 
::GG::Clinical correlation and follow up suggested. 
:o:gcv::建議心臟內科門診追蹤
:o:gchest::建議胸腔內科門診追蹤
::gu::Ultrasound correlation suggested. 
::ggn::ground glass nodule 
::ggns::ground glass nodules
::ggo::ground glass opacity
::ggos::ground glass opacities
::gm::Magnification view correlation suggested.
::GS::Radiopaque lesion(s) in the right upper quadrant of the abdomen, suggestive of gallstone(s). 
::GT::CT correlation suggested. 
::HD::hemidiaphragm. 
::hilar::hilar/peripheral zone. 
:C:i::Placement of line(s)/tube(s). 
::IC::suspected. 
::ICP::compatible. 
::ID::Ill-defined opacity in 
::IDs::Ill-defined opacities in
:C:IHDs::intrahepatic ducts
::II::Patchy infiltration in
::IOR::This study was performed in the operating room for evaluation of catheter placement. No evidence of malpositioning of the catheter is noted. 
::inc::increased
::isrs::in-stent restenosis. 
::KN::Normal alignment. Mild marginal osteophytes formation. 
:c:lad::the left anterior descending artery
:c:lmca::the left main coronary artery
:c:lcx::the left circumflex artery
:o:ladc::左前下行支
:o:lmcac::左冠狀動脈主支
:o:lcxc::左迴旋支
::LAP::lymphadenopathy 
::lb::left breast 
::lcct::Low dose chest CT without intravenous contrast enhancement shows: {Enter}* 
::LCT::Placement of chest tube(s) at left side.  
::LE::Emphysematous change in both lungs. 
:o:lec::肺氣腫
::ling::the lingula of the left upper lobe
::LIQ::lower inner quadrant
::LOQ::lower outer quadrant
::LG::Diffusely linear shadows in both lungs, compatible with chronic interstitial lung disease. 
::LL::The lung parenchyma are symmetrical in density with normal pulmonary markings and no masses evident. There is no pleural thickening and the costophrenic angles are sharp. 
:C:lll::the left lower lung zone. 
:C:LLL::the left lower lobe 
:c:lm::Prominent bilateral lung markings. 
:C:lml::the left middle lung zone.
:C:lul::the left upper lung zone.
:C:LUL::the left upper lobe
::ln::lymph node
::lns::lymph nodes
::LT::left 
:o:LTc::左 
:r0O:m1::
(
Mammography of bilateral breasts shows:
- The breast is almost entirely fat.
- No definite abnormal microcalcifications.
- No definite mass lesion.
- No focal skin thickening.
- No nipple retraction.
- No axillary lymphadenopathy.
)
:r0O:m2::
(
Mammography of bilateral breasts shows:
- There are scattered fibroglandular densities that could obscure a lesion on mammography.
- No definite abnormal microcalcifications.
- No definite mass lesion.
- No focal skin thickening.
- No nipple retraction.
- No axillary lymphadenopathy.
)
:r0O:m3::
(
Mammography of bilateral breasts shows:
- The breast tissue is heterogeneously dense. This may lower the sensitivity of mammography.
- No definite abnormal microcalcifications.
- No definite mass lesion.
- No focal skin thickening.
- No nipple retraction.
- No axillary lymphadenopathy.
)
:r0O:m4::
(
Mammography of bilateral breasts shows:
- The breast tissue is extremely dense, which lowers the sensitivity of mammography.
- No definite abnormal microcalcifications.
- No definite mass lesion.
- No focal skin thickening.
- No nipple retraction.
- No axillary lymphadenopathy.
)
::ma::- A cm mass in  Ultrasound correlation suggested. {Left 47}
:r0O:mag::
(
Magnification mammography of both breasts shows scattered microcalcifications. Benign lesion is more likely. Suggest follow up.
)
::mb::Myocardial bridge in the mLAD. 
::mcp::partially calcified plaque
::mcps::partially calcified plaques
::MCT::Placement of mediastinal drainage tube(s).  
::medi::the mediastinum 
::meta::metastasis 
::metas::metastases
::mfi::Mild fibrotic change in
::ml::Mammography of the left breast shows:
::mr::Mammography of the right breast shows:
::ms::masectomy 
::msl::Mild scoliosis. 
::msp::Mild spondylosis with degenerative marginal spurs. 
::mmt::- Status post stereotatic-guided mammotomy with metallic marker in 
::MT::Multiple varied-size nodules in both lungs, compatible with lung metastases. 
:c:MVR::mitral valve replacement
::N::Heart size normal. 
::NA::The bowel gas pattern is unremarkable. No abnormal calcific density in the region of the kidney or ureter is noted. 
::nd::No definite lesion in liver, spleen, pancreas, gallbladder, both adrenals and both kidneys. 
::NLC::Nuchal ligament calcification. 
::ncp::noncalcified plaque
::ncps::noncalcified plaques
::nct::No significant chest lesion
::nlt::No significant lung lesion
::nod::nodule
::nods::nodules
:o:nodc::肺結節
::NOS::non-specific small mediastinal lymph nodes. 
::NP::Non-specific bowel gas pattern. 
::NT::No significant abnormalities 
:C:oa::Joint space narrowing with spurs formation, compatible with osteoarthritis. 
::OC::Status post external casting. 
::OFA::Old fracture in 
::OFAs::Old fractures in 
::op::- Parenchymal loss and architectural distortion in compatible with postoperative change. Suggest follow up.{Left 57}
::OW::Postoperative change with sternal wiring. 
::PA::Placement of a portacath. 
::PC::(For the abdominal images, please check the report of abdomen CT.)  
:c:PFO::Patent foramen ovale.
::PICC::Placement of a peripherally inserted central catheter. 
::PM::Placement of a cardiac pacemaker.  
::PD::The size of the lesion enlarged as compared with previous CT study.
::PDs::The size of the lesions enlarged as compared with previous CT study.
::COPD::Hyperinflation and chronic infiltration in both lungs, compatible with chronic obstructive pulmonary disease. 
::PE::Infiltration in bilateral perihilar regions, compatible with pulmonary edema. 
::peri::perihilar region. 
::peg::Status post gastrostomy.
::PH::Phleboliths in the pelvic cavity. 
::PIGTAIL::pigtail catheter insertion 
::PL::pleural effusion. 
::pn::pneumonia
::PO::Postoperative change with 
::pobas::Status post coronary artery stenting. 
::POC::Postoperative change with clips in 
::POS::Postoperative change with suture material in
::PR::The size of the lesion decreased as compared with previous CT study. 
::PRs::The size of the lesions decreased as compared with previous CT study. 
::parat::paratracheal
::paras::paraspinal
::pcw::Status post pacing wire insertion. 
::plate::plate fixation in the 
::prox::proximal
::ptcd::Status post percutaneous transhepatic cholangiodrainage (PTCD). 
::ptgbd::Status post percutaneous transhepatic gallbladder drainage (PTGBD). 
::ptx::pneumothorax 
::RCT::Placement of chest tube(s) in the right side of the thorax. 
:C:rll::the right lower lung zone. 
:C:RLL::the right lower lobe
:C:rml::the right middle lung zone. 
:C:RML::the right middle lobe
:c:rca::the right coronary artery
:o:rcac::右冠狀動脈
::rb::right breast 
::RS::renal stone 
::RT::right 
:o:RTc::右
:C:rul::the right upper lung zone. 
:C:RUL::the right upper lobe
::s1::minimal (<25%) stenosis
::s2::mild (25%-49%) stenosis
::s3::moderate (50%-69%) stenosis
::s4::severe (70%-99%) stenosis
::s5::total occlusion
:o:s1c::非常輕微(<25%)狹窄
:o:s2c::輕微(25%-49%)狹窄
:o:s3c::中度(50%-69%)狹窄
:o:s4c::嚴重(70%-99%)狹窄
:o:s5c::阻塞
::sa::Partial atelectasis in
::SB::Suboptimal study due to motion artifacts. 
::screw::screw fixation in
::SD::Multiple marginal osteophytes with degenerative scoliosis. 
::SE::Subcutaneous emphysema in
::SG::Placement of a pulmonary artery catheter. 
::SH::Sharp bilateral costophrenic angles. 
::SI::superimposed at
::SKU::No definite bone lesion or fracture. Normal alignment. Clinical correlation suggested.
::sl::Scoliosis. 
::sn::A cm wider than tall hypoechoic nodule in breast :00/cm. {Left 56}
::sono::ultrasound
::SP::Spondylosis with degenerative marginal spurs. 
::s/p::Status post
::sprul::Status post right upper lobectomy. 
::sprml::Status post right middle lobectomy. 
::sprll::Status post right lower lobectomy. 
::splul::Status post left upper lobectomy. 
::splll::Status post left lower lobectomy. 
::su::suspect
::sug::Suggest 
::suture::suture material in
:C:t::Tortuous aorta. 
::TA::Placement of an endotracheal tube. 
::TAE::Radiopaque density in the right upper quadrant of the abdomen, compatible with Lipiodol retention from previous transcatheter arterial embolization. 
::TAG::Placement of an endotracheal and a nasogastric tubes. 
::tbc::Fibronodular change in the bilateral upper lungs, compatible with pulmonary tuberculosis. 
::TC::Tortuous aorta with calcification. 
::tdl::Trachea deviation to the left side. 
::tdr::Trachea deviation to the right side. 
::TG::Placement of a nasogastric tube. 
::TH::Bilateral apical pleural thickening. 
::tnm::TNM stage: T2bNXMX (AJCC TNM Staging System for Lung Cancer, 7th edition). 
::thi::Small nodules in the thyroid gland.
::THR::total hip replacement. 
::TKR::total knee replacement. 
::TP::Placement of a central venous catheter. 
::TPs::Placement of central venous catheters. 
::TR::Placement of a tracheostomy tube. 
::UD::Intrauterine device in the pelvic cavity. 
::UIQ::upper inner quadrant
::UOQ::upper outer quadrant
::u::Unremarkable. 
::unc::unchanged
::vp::Placement of a ventriculo-peritoneal shunt tube. 
:o:WA::was read and compared with previous study on 2011-. This study {Left 13}
::WM::Widening mediastinum. 
::wn::with no significant stenosis.

;----------------------------------------------------------------------------------
::h1::
Click 1024,569,2
return
::h2::
Click 1024,590,2
return
::h3::
Click 1024,611,2
return
::h4::
Click 1024,631,2
return
::h5::
Click 1024,657,2
return

::p1::
Gosub, ToggleDualScreen
Click right 1024,569
Sleep, 500
Click 1032,655
Sleep, 400
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,5
Click 1024,569,2
return
::p2::
Gosub, ToggleDualScreen
Click right 1024,590
Sleep, 500
Click 1032,677
Sleep, 400
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,5
Click 1024,590,2
return
::p3::
Gosub, ToggleDualScreen
Click right 1024,611
Sleep, 500
Click 1032,698
Sleep, 400
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,5
Click 1024,611,2
return
::p4::
Gosub, ToggleDualScreen
Click right 1024,631
Sleep, 500
Click 1032,718
Sleep, 400
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,5
Click 1024,631,2
return
::p5::
Gosub, ToggleDualScreen
Click right 1024,657
Sleep, 500
Click 1032,738
Sleep, 400
WinWaitActive , ahk_class com.pohai.client.application.MainFrame,,5
Click 1024,657,2
return



;----------------------------------------------------------------------------------
;0 No detectable calcified plaque
;1-10 Minimal detectable calcified plaque
;11-100 Mild atherosclerotic plaque burden
;101-400 Moderate atherosclerotic plaque burden
;>400 Extensive atherosclerotic plaque burden

::aj::
{
WinGet, active_id, ID, A
InputBox, CCS,,Calcium score:,,200,120
clipboard=%CCS%

Rank=Error

if (CCS = 0) 
{
 Rank=No detectable calcified plaque
}
if (CCS >0)
{
 Rank=Minimal detectable calcified plaque
}
if (CCS >10)
{
 Rank=Mild atherosclerotic plaque burden
}
if (CCS >100) 
{
 Rank=Moderate atherosclerotic plaque burden
}
if (CCS >400)
{
 Rank=Extensive atherosclerotic plaque burden
}

WinActivate, ahk_id %active_id%
SendPlay %CCS% (%Rank%)%A_EndChar%
return
}

;----------------------------------------------------------------------------------
;
::fs::
{
WinGet, active_id, ID, A
InputBox, size,,Lung nodule size:,,200,120

Rank=According to the Fleischner Society guidelines, suggest follow-up CT at around 3, 9, and 24 mo, dynamic contrast-enhanced CT, PET, and/or biopsy.

if (size < 4.1) 
{
 Rank=According to the Fleischner Society guidelines, for patient with history of smoking suggest follow-up CT at 12 mo; if unchanged, no further follow-up. For low risk patient, no further follow-up needed.
}
if size between 6 and 8 
{
 Rank=According to the Fleischner Society guidelines, for patient with history of smoking suggest follow-up CT at 3~6 mo then at 9~12 and 24 mo if no change. For low risk patient, follow-up CT at 6~12 mo then at 18~24 mo if no change.
}
if size between 4.1 and 6 
{
 Rank=According to the Fleischner Society guidelines, for patient with history of smoking suggest follow-up CT at 6~12 mo then at 18~24 mo if no change. For low risk patient, follow-up CT at 12 mo; if unchanged, no further follow-up.
}
WinActivate, ahk_id %active_id%
SendPlay A %size%mm nodule is noted at .%Rank%%A_EndChar%
return
}

::dlp::
WinGet, active_id, ID, A
InputBox, DLP,,DLP:,,200,120
mSv := Round(DLP * 0.014)
WinActivate, ahk_id %active_id%
SendPlay %DLP% mGy*cm (%mSv% mSv).
return

::mla::
WinGet, active_id, ID, A
InputBox, area,,Mininum luminal area:,,200,120
WinActivate, ahk_id %active_id%
SendPlay (minimum luminal area: %area% mm
SendPlay {raw}^2). 
SendPlay {Space}
return

::haller::
{
WinGet, active_id, ID, A
InputBox, HI,,Haller index:,,200,120

if (HI > 2.5) 
{
 Rank= 
}
if (HI > 3.2) 
{
 Rank= severe+{Space}
}

If (HI>2.5)
{
WinActivate, ahk_id %active_id%
SendPlay Inward desplacement of the sternum (Haller index: %HI%), compatible with %Rank%pectus excavatum. 
SendInput {F5}
Sleep, 300
SendInput Pectus excavatum.{Space}
SendInput {F4}
return
}
}


#Include AutocorrectWJL.ahk   
; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

#z::Run www.autohotkey.com

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
