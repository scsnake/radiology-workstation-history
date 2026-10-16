﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         WYH
;


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Hotstring EndChars ()[]{}:;'"\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;
; 快速鍵設定區
;;;;;;;;;;;;;;;;;;;;;;;

^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.
IfWinExist ahk_class com.pohai.client.application.MainFrame
{
 WinActivate ahk_class com.pohai.client.application.MainFrame
 SendPlay !{F4}
}
ExitApp

^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.
Edit
return

~LButton & r:: ; 滑鼠左鍵 + r = Reload the ahk file.
Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return


;
; 以下為片語區 
; 格式為 ::縮寫::完整語句
; 



::b0u::ACR BI-RADS 0, indeterminate ultrasonographic finding (need additional imaging evaluation). Suggest breast mammogram correlation.
::b1u::ACR BI-RADS 1, no definite abnormal finding in this study. Suggest annual follow up or at the recommendation of the patient's physician. Suggest ultrasound if palpable lump. 
::b2u::ACR BI-RADS 2, benign finding. Suggest annual follow up or at the recommendation of the patient's physician.Suggest ultrasound if palpable lump. 
::b3u::ACR BI-RADS 3, probably benign finding. Suggest 6-month interval follow up. Suggest ultrasound if palpable lump. 
::b4u::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.
::b0m::ACR BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation). Suggest breast ultrasound or mag. spot view correlation.
::b1m::ACR BI-RADS 1, negative finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. 
::b2m::ACR BI-RADS 2, benign finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. Suggest ultrasound correlation if palpable lump.
::b2md::ACR BI-RADS 2, dense breasts; benign finding. Suggest annual follow up and ultrasound correlation if palpable mass.
::b3m::ACR BI-RADS 3, probably benign finding. Suggest 6-month mammogram follow up.
::b4m::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.
::b5m::ACR BI-RADS 5, Highly suggestive of malignancy - Appropriate Action Should Be Taken. 


::B0C::
  clipboard=性質未定之乳房攝影發現，建議乳房超音波對照，與放大攝影。
  Send ^v
  return
::b1c::
  clipboard=無異常乳房攝影發現，建議每年追蹤或依臨床醫師建議追蹤。
  Send ^v
  return
::b2c::
  clipboard=良性乳房攝影發現，建議每年追蹤或依臨床醫師建議追蹤。

  Send ^v
  return
::B3C::
  clipboard=可能為良性乳房攝影發現，建議短期追蹤，並加超音波對照。
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


::akd::architectural distortion
::ax::axilla
::axl::left axillary region
::axr::right axillary region
::axs::axille

::bi::bilateral
::bb::bilateral breasts
::bcab::There are benign scattered and regional calcifications present bilaterally
::bctr::History of right breast cancer s/p BCT
::bctl::History of left breast cancer s/p BCT
::bctm::History of breast cancer s/p BCT with marking wire
::br::breast

::ca::calcification
::cw::as compared with previous
::cw0::without prior study for comparison
::cw1::compared with prior mammogram study dated on
::cys::a round, anechoic lesion with distinct margin at left breast / region, sized *cm, r/o cyst
::cysb::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, r/o simple cysts and or fibroadenoma, size up to cm
::cysl::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of cyst.
::cysr::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of cyst.
::correlate::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 


::fa::fibroadenoma 
::fal::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma
::far::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma
::fc::fibrocystic change
::fh::family history of breast cancer (sister/mother/grandmother)
::fu::for follow-up.

::hm::History of menopause.
::he::for health check up.
::hrt::History of HRT.
::h::History of
::id::ill-defined

::lap::lymphadenopathy
::lb::left breast
::ln::lymph node
::lnb::benign appearing lymph nodes with fat hilum at bilateral axillary regions.
::lnr::benign appearing lymph node with fat hilum at right axilla.
::lnl::benign appearing lymph node with fat hilum at left axilla.
::lnla::small left axillary lymph node, having fat hilum
::lnln::small lymph node at left neck region, having fat hilum
::lnra::small right axillarly lymph node, having fat hilum
::lnrn::small lymph node at right neck, having fat hilum


::mca::microcalcifications
::MC::There are benign scattered calcifications present bilaterally.
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.
::md::The breast tissue is extremely dense, and this may obscure a lesion on mammography
::mf::The breast tissue is almost entire fat
::mfg::There are bilateral scattered fibroglandular tissues
::mhd::The breast tissue is heterogeneously dense, and this may lower the sensitivity of mammography
::mm::mammogram
::mmb::Bilateral CC and MLO mammogram is read and compared with prior mammogram on 200--
::mmb0::Bilateral CC and MLO mammogram is read without prior study for comparison
::mop::post-operative scarring with parenchymal loss at the
::mrml::left breast cancer s/p MRM
::mrmr::right breast cancer s/p MRM

::nd::nodule
::ndf::no definite focal lesion
::nmm::There is no definite mass, no focal suspicious microcalcifications, and no architectural distortion in this study
::nlap::no definite lymphadenopathy at bil axillae, supraclavicular regions and anterior chest wall.
::nlna::no definite axillary lymphadenopathy
::nlnan::no definite axillary of neck lymphadenopathy
::nre::no evidence of local recurrence
::nsln::non-specific small lymph nodes at

::op::post-operative change
::opsc::post-operative change with scar formation at
::opscl::post-operative scarring at left breast, which is stationary compared with prior ultrasound on
::opscr::post-operative scarring at right breast, which is stationary compared with prior ultrasound on


::rb::right breast


::uhd::heterogeneous dense fibroglandular tissue
::ud::dense fibroglandular tissue
 
::scr::for screening
::sugu::suggest breast ultrasound correlation


::uif::ultrasound correlation if palpable mass.

::wd::well-defined
::b0msugus::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities.


::CAOP::no definite focal mass at ** breast. No definite lymphadenopathy at bilateral axillae, supraclavicular regions and anterior chest wall. Suggest regular follow-up.
::DIG::(digital)

::MAG::spot magnification views
::MASY::Focal asymmetry is noted at right anterior UOQ near central, suggest ultrasound or mag. views.
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.

::MCOM::Bilateral MLO/CC digital mammograms are read and compared with prior mammograms dated



::MHX::History: right breast tumor s/p op. Family history of breast cancer (mother). 
::MN::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.
::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.
::MNE::There are no definite mass, and no architectural distortion in this study. 
::MNO::Bilateral MLO and CC digital mammograms are read without prior exams available for comparison.

::MRM::History of breast cancer s/p MRM,
::MSUG::suggest breast ultrasound correlation and right mag. views.
::NP::No definite focal mass lesion. Suggest follow-up.

::oc::oral contraceptives medication from age of 22-30 y/o. 

::PL::pleomorphic
::RB::right breast
::SAR::subareolar region
::SFUFNA::Suggest follow up and considered FNA if there is interval change. 
::SFU::Suggest follow up.
::SM::History: screening mammogram.
::SR::skin retraction
::ST::skin thickening

::USB::Ultrasound of both breasts shows 
::USH::Heterogenous breast tissue of bilateral breasts.
::USL::A cm hypoechoic lesion in right/left breast at o'clock/cm,
::USN::Probably benign ultrasound findings. Suggest follow up.
::WM::wire marked.














::mamnc::Digital mammography of both breasts in CC and MLO views is read without prior study for comparision. This study shows:
::mamc::Digital mammography of both breasts in CC and MLO views is read with prior study for comparision. This study shows:
::bmcal::There are benign looking microcalcifications present bilaterally.
::bmcal1::there are benign looking punctate microcalcifications in the 
::nmcal::There is no definite mass, no suspicious microcalcifications, and no architectural distortion in this study
::slnab::small axillary lymph nodes at both sides. 
::slnar::small axillary lymph nodes at right side. 
::slnal::small axillary lymph nodes at left side. 


::MD1::The breast is almost entirely fat.
::MD2::There are scattered fibroglandular densities.
::MD3::Heterogeous dense fibroglandular tissue, which can cause decreased sensitivity of mammography.
::MD4::The breast is extremely dense. This may lower the sensitivity of mammography.
::MOP1::Focal parenchymal loss, architectural distortion and skin retraction are noted at beneath the wire, compatible with postop change. 
::MOP2::Focal architectural distortion, parenchymal retraction is noted at beneath the wire and focal asymmetry near the surgical bed.
::MOP3::Post-op. changes at with parenchymal loss, architectural deformity, skin retraction and thickening.
::maml::history of left breast cancer s/p MRM.
::mamr::history of right breast cancer s/p MRM.
::mamb::history of bilateral breast cancer s/p MRM.
::hxs::History:screening.








::EX::
(
Bilateral MLO and CC are read and compared to previous films dated on 2006-02-08. 
The breast tissue is heterogeneously dense, which could obscure detection of small masses. 
There is a round course calcification at the inner central left breast. 
There is focal asymmetry at left outer breast on CC, suggest ultrasound. 
THere are focal equivocal punctate microcalcifications at right subareolar region on MLO, suggest right mag. views. 
)

::implant::
(
 Hx: for screen. bil saline implants insertion. 
 Bilateral MLO/CC II and ID views are read and no prior mammography for comparison. The breast is heterogeneously dense, which could obscure detection of small masses. Bilateral retropectoral saline implants are noted without definite evidence of rupture. There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study. (HJY/JW) 
)



::NOPL::
(
1. s/p left mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in right breast. 
3. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
)

::NOPR::
(
1. s/p right mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in left breast. 
3. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
)

::MFS::
(
History: follow up. 
Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison. There are bilateral scattered fibroglandular tissues. There are benign appearing vascular wall calcifications at bilateral breasts. There are no definite mass, and no architectural distortion in this study.  (CHM/Dr.JW) 
)

::BE::
(
Ultrasound of breasts shows:
1. Heterogenous breast tissue of bilateral breasts. 
2. s/p right/left mastectomy/lumpectomy
3. A hypoechoic lesion in right/left breast at o'clock/cm sized cm, R/O
4. No definite axillary lymphadenopathy.
)


::NEG::
(
1. No suspicious lesion at bilateral breasts.
2. No definite lymph nodes.
Negative study.
)


::NEGLN::
(
1. No suspicious lesion at bilateral breasts.
2. Benign appearing lymph nodes at bilateral axillae, with fat hilum. 
Negative study.
)

; 以下為罐頭區
;
::asp::ultrasound-guide fine needle aspiration is performed smoothly without obvious discomfort and two impring for cysNo more bleeding after manual compression.
::core:: core biopsy with 15G*6cm coaxial introducer needle and 16G*11cm biopsy needle and two tissue stripes are sent for pathology.




