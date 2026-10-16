;
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

^!x::
suspend
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
::b1u::ACR BI-RADS 1, no definite abnormal finding in this study. Suggest annual follow up or at the recommendation of the patient's physician.
::b2u::ACR BI-RADS 2, benign finding. Suggest annual follow up or at the recommendation of the patient's physician.
::b3u::ACR BI-RADS 3, probably benign finding. Suggest 6-month interval follow up.
::b4u::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.

::b0m::ACR BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation). Suggest breast ultrasound or mag. spot view correlation.
::b1m::ACR BI-RADS 1, negative finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. ( if there is clinical relevant finding, ultrasound is suggested. )
::b2m::ACR BI-RADS 2, benign finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. (if there is any clinical palpable finding, ultrasound is suggested)
::b2md::ACR BI-RADS 2, dense breasts; benign finding. Suggest annual follow up and ultrasound correlation if palpable mass.
::b3m::ACR BI-RADS 3, probably benign finding. Suggest 6-month mammogram follow up.
::b3mag::BI-RADS 3, probably benign finding, suggest 6-month f/u MAG (right). (if there is any clinical relevant finding, ultrasound is suggested) 
::b4m::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.

::b3mnodule::There is an oval nodule about 0.71cm at right UOQ with well circumscribed, sharp margin, suggest 6 month f/u. 

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
::cysb::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, r/o simple cysts and/or fibroadenoma, size up to cm{left 3}
::cysl::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of cyst.
::cysr::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of cyst.
::correlate::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 


::fa::oval hypoechoic, wider than tall lesions, r/o fibroadenomas at  breast, region, sized  cm.
::fal::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma
::far::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma
::fc::fibrocystic change
::fh::family history of breast cancer (sister/mother/grandmother)
::fu::for follow-up.
::faex::
(
Hx of left breast cancer s/p MRM.
1. post-operative change with scar formation at left anterior chest wall. No evidence of local recurrence. 
2. oval hypoechoic, wider than tall lesions, r/o fibroadenomas at right breast, 1/0.5 and 2/0.5 region, sized 0.5*0.2cm and 0.5*0.3cm.
3. benign appearing lymph node with fat hilum at right axilla and left supraclavicular region. 
4. no definite lymphadenopathy in this study.
(LYF/Dr.JW)
ACR BI-RADS 3, probably benign findings. Suggest 6-month interval follow up.
)

::hm::History of menopause.
::he::for health check up.
::hrt::History of HRT.
::hx::History:
::id::ill-defined


::l::left
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
::LY::(YCH/Dr.YCC)
::LJ::(YCH/Dr.JW)


::mca::microcalcifications
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.
::md::The breast tissue is extremely dense, and this may lower the sensitivity of mammography.
::mf::The breast tissue is almost entire fat
::mfg::There are bilateral scattered fibroglandular tissues
::mhd::The breast tissue is heterogeneously dense, and this may obscure a lesion on mammography.
::mm::mammogram
::mmb::Bilateral CC and MLO mammogram is read and compared with prior mammogram on 200--
::mmb0::Bilateral CC and MLO mammogram is read without prior study for comparison
;::mop::post-operative scarring with parenchymal loss at the
::mrml::left breast cancer s/p MRM
::mrmr::right breast cancer s/p MRM
::bmcr::There are benign coarse calcifications at right upper central to UIQ.
::bmcb::There are benign scattered calcifications present bilaterally.
::mca3::There are segmental to regional faint punctate microcalcifications in right central breast region, suggest 6 month f/u MAG.

::nd::nodule
::ndf::no definite focal lesion
::nmm::There is no definite mass, no focal suspicious microcalcifications, and no architectural distortion in this study
::nlap::no definite lymphadenopathy at bil axillae, supraclavicular regions and anterior chest wall.
::nlna::no definite axillary lymphadenopathy
::nlnan::no definite axillary or neck lymphadenopathy
::nre::no evidence of local recurrence
::nsln::non-specific small lymph nodes at

::op::post-operative change
::opsc::post-operative change with scar formation at
::opscl::post-operative scarring at left breast, which is stationary compared with prior ultrasound on
::opscr::post-operative scarring at right breast, which is stationary compared with prior ultrasound on



::r::right
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
::MASYMAG::There is focal asymmetry in left far medial breast on CC, suggest left spot mag.
::MASYUS::There is focal asymmetry in left far outer breast on CC, most likely in upper breast on MLO, preserved on CC spot compression view, suggest ultrasound. 
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.
::bmcmag::There are multiple areas of segmental to regional punctate to amorphous microcalcifications in bilateral breasts, more at bilateral upper to central and more on left, suggest bilateral mag. views.  

::MCOM::Bilateral MLO/CC digital mammograms are read and compared with prior mammograms dated
::MCOMN::Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison.

::MD1::The breast is almost entirely fat.
::MD2::There are scattered fibroglandular densities.
::MD3::The breast is heterogeneously dense, which could obscure detection of small masses.
::MD4::The breast is extremely dense. This may lower the sensitivity of mammography.

::MHX::History: right breast tumor s/p op. Family history of breast cancer (mother). 
::MN::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.
::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.
::MNE::There are no definite mass, and no architectural distortion in this study. 
::MNO::Bilateral MLO and CC digital mammograms are read without prior exams available for comparison.
::MOP::Focal parenchymal loss, architectural distortion and skin retraction are noted at left upper central breast under the wire, compatible with postop change. 
::MOP2::Focal architectural distortion, parenchymal retraction is noted at right UOQ under the wire and near the surgical bed.
::MOP3::Post-op. changes at left UIQ breast with parenchymal loss, architectural deformity, skin retraction and thickening.
:o:MRM::History of breast cancer s/p MRM.{left 4}
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

; JW breast US templates

; Hx:
::JOP::right/left breast cancer, MRM.
::JBCT::right/left breast cancer, BCT.
::JMam::mammo showed asymmetry at **.
::JFH::family history breast cancer (**).
::Jcheck::breast checkup.

; Content:
::JNP::no definite focal mass lesions. suggest f/u.
::JB9::oval hypoechoic, wider than tall lesions, r/o fibroadenomas at
::JCy::cysts at
::JLN::benign appearing node at ** axilla, size***, having fat hilum.
::JFCC::fibrocystic change, ***.
::JCal::r/o calcifications at ***, suggest mammography correlation. 
::JFNA::*****, suggest FNA.
::JCAOP::no definite focal mass at ** breast. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. Suggest regular f/u.

; Impression
::JB1::no definite focal lesions in this study.
::JB2::benign findings, suggest regular imaging f/u.
::JB3::probably benign findings, left? Right? Suggest short-term echo f/u.
::JB4::susp finding(s), left? Right? Suggest tissue sampling.
::JCorrelate::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 

::MRMR::s/p right MRM with scar.
::BCTL::s/p left BCT with scar.
::MRMRFU::s/p right MRM without local recurrence, suggest follow-up of ultrasound. 
::BCTR::Hx of right breast cancer s/p BCT. 

::EXMRM::
(
Hx of right breast cancer s/p MRM. 
A 0.75x 0.4 cm oval hypoechoic, wider than tall lesions, r/o fibroadenomas at rigth breast 10/1.
benign appearing node at ** axilla, size***, having fat hilum.
no enlarged axillary lymph node.

 SONAR FINDINGS:
    1. s/p right BCT with surgical scar, no definite evidence of local 
    recurrence. 
    2. A 0.5 cm anechoic cyst at left breast 4/3.
    3. No enlarged axillary LAPs. 
 IMPRESSION:
    s/p right BCT with surgical scar, no definite evidence of local 
    recurrence.  
)

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



::NB::
(
1. No definite mass lesion detected in bilateral breast. 
2. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
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

::com::as compared to prior study on
::sta::stationary

; 以下為罐頭區
;
::asp::ultrasound-guided fine needle aspiration is performed smoothly without obvious discomfort and two imprint for cytology. No more bleeding after manual compression.
::core:: core biopsy with 15G*6cm coaxial introducer needle and 16G*11cm biopsy needle and two tissue stripes are sent for pathology.

::t::the
::mas::mastectomy
::pmas::partial mastectomy
::sz::size up to
::z::sized
::brca::breast cancer
::stp::suggest tissue proof
::pas::posterior acoustic shadowing
::pae::posterior acoustic enhancement
::reg::region
::w::with
::dis::distinct
::ind::indistinct
::mar::margin
::ae::anechoic
::oe::hypoechoic
::re::hyperechoic
::ie::isoechoic
::ov::oval
::ro::round
::le::lesion
::ir::irregular
::fba::fibroadenoma
::cy::cyst
::wtt::wider than tall
::ttw::taller than wide
