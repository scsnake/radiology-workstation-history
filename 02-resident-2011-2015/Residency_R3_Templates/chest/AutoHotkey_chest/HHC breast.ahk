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
::b1m::ACR BI-RADS 1, negative finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. (if there is any clinical palpable finding, ultrasound is suggested)
::b2m::ACR BI-RADS 2, benign finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician. (if there is any clinical palpable finding, ultrasound is suggested)
::b2md::ACR BI-RADS 2, dense breasts; benign finding. Suggest annual follow up and ultrasound correlation if palpable mass.
::b3m::ACR BI-RADS 3, probably benign finding. Suggest 6-month mammogram follow up.
::b4m::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.


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

::bil::bilateral
::bb::bilateral breasts
::bcab::There are benign scattered and regional calcifications present bilaterally
::bctr::History of right breast cancer s/p BCT.
::bctl::History of left breast cancer s/p BCT.
::bctm::History of breast cancer s/p BCT with marking wire.
::br::breast

::cal::calcification

::HJ::(HHC/Dr.JW)
::HY::(HHC/Dr.YCC)
::com::as compared with previous
::cw0::without prior study for comparison
::cw1::compared with prior mammogram study dated on
::cys::a round, anechoic lesion with distinct margin at left breast / region, sized *cm, r/o cyst
::cysb::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, r/o simple cysts and or fibroadenoma, size up to cm
::cysl::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of cyst.
::cysr::a round, well-defined, hypoechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of cyst.
::cor::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 
::sta::the size is stationary when comparing with previous study.

::fa::fibroadenoma 
::fal::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma
::far::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma
::fc::fibrocystic change
::fh::family history of breast cancer (sister/mother/grandmother)
::fu::for follow-up.

::hm::History of menopause.
::he::For check up.
::hrt::History of HRT.
::hx::Hx:
::hypo::hypoechoic lesion
::hyper::hyperechoic lesion
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
::lnnp::no definite lymphadenopathy is noted at bilateral axillae and neck region.
::lna::no definite lymphadenopathy is noted at bilateral axillae. 

::mcal::microcalcifications
::MC::There are benign scattered calcifications present bilaterally.
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.

::mfg::There are bilateral scattered fibroglandular tissues

::mm::mammogram
::mmb::Bilateral CC and MLO are read and compared with prior mammograms on 200
::mmb0::Bilateral CC and MLO are read without prior study for comparison.
::mop::post-operative scarring with parenchymal loss at the
::mrml::Hx of left breast cancer s/p MRM.
::mrmr::Hx of right breast cancer s/p MRM.

::nd::nodule
::ndfr::no definite focal lesion at right breast.
::ndfl::no definite focal lesion at left breast. 
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
 
::scr::for screening.
::sugu::suggest breast ultrasound correlation.
::sugm::suggest mammography correlation.
::sugb::suggest tissue sampling.

::uif::ultrasound correlation if palpable mass.

::wd::well-defined







::b0msugus::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities.


::CAOP::no definite focal mass at  breast. No definite lymphadenopathy at bilateral axillae, supraclavicular regions and anterior chest wall. Suggest regular follow-up.
::DIG::(digital)



::MAG::spot magnification views
::MASY::Focal asymmetry is noted at right anterior UOQ near central, suggest ultrasound or mag. views.
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.

::MCOM::Bilateral MLO/CC digital mammograms are read and compared with prior mammograms dated
::MCOMN::Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison.

::MD1::The breast is almost entirely fat.
::MD2::There are scattered fibroglandular densities.
::MD3::The breast is heterogeneously dense, which could obscure detection of small masses.
::MD4::The breast is extremely dense. This may lower the sensitivity of mammography.

::MHX::History: right breast tumor s/p op. Family history of breast cancer (mother). 
::MN::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
::MN0::There are no definite mass, and no architectural distortion in this study. 
::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.
::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.

::MOP::Focal parenchymal loss, architectural distortion and skin retraction are noted at  breast under the wire, compatible with post-op change. 
::MOP2::Focal architectural distortion, parenchymal retraction is noted at right UOQ under the wire and focal asymmetry near the surgical bed.
::MOP3::Post-op. changes at left UIQ breast with parenchymal loss, architectural deformity, skin retraction and thickening.
::MRM::History of breast cancer s/p MRM,
::MSUG::suggest breast ultrasound correlation and right mag. views.
::NP::No definite focal mass lesion. Suggest follow-up.

::oc::oral contraceptives medication from age of 22-30 y/o. 

::PL::pleomorphic
::RB::right breast
::SEG::segmental
::amo::amorphous
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

::msr::s/p right MRM with surgical scar.
::msl::s/p left MRM with surgical scar.
::bsr::s/p right BCT with surgical scar.
::bsl::s/p left BCT with surgical scar.
::nlm::s/p right MRM without local recurrence, suggest follow-up of ultrasound. 
::nlb::s/p right BCT with surgical scar, no definite evidence of local recurrence. 
::fccl::an amorphous hypoechoic lesion at left breast 3/2, size 0.5 cm, r/o focal fibrocystic change.

::mrou::The breast is heterogeneously dense, which could obscure detection of small masses. There are benign scattered and regional calcifications present bilaterally. 
::mfa1::a cluster of dense tightly packed calcifications, representing hyalinizing fibroadenomas.
::mfa2::there are two oval mass lesions with coarse or popcorn calcifications at bilateral breasts, involuting fibroadenomas are favored (right deep upper breast, 1.56cm and left deep central breast, 0.9cm).
::mfa3::macrolobulated masses with dense, coarse calcifications, representing hyalinizing fibroadenomas.
::mfn::a radiolucent mass with mural and internal curvilinear calcification is noted at ** breast, suggesting fat necrosis.
::mskin::some round, lucent-centered calcifications, consist with skin calcification. 
::uli::a homogenous iso- to slightly hyperechoic, well-circumscribed solid mass, suggesting a lipoma.
::uex::round and irregular hypoechoic masses, some with angular margins and an echogenic halo, representing an extracapsular implant rupture.
::usnow::an irregular curvilinear echogenic focus with shadowing, representing an extracapsular implant rupture.
::uimp::right breast MRM with implant insertion, with smooth surface without evidence of rupture.

::mmass::A mass lesion (about 1.9cm in size) with somewhat irregular shape and microlobulated margin at left posterior inner central breast. Suggest correlate with ultrasonographic findings.
::mcc::Benign coarse calcifications are noted at right deep UIQ. There is no definite mass or architectural distortion in this study.
::mpuc::A focal spiculated mass lesion (about 1.3cm) with punctate microcalfications and adjacent architectural distortion at left middle upper central breast. Left breast cancer is suspected.
::mplc::A cluster of pleomorphic microcalcifications at middle upper cental breast, which is not noted at prior study, suggest biopsy.
::mamc::There are clustered amorphous microcalcifications at left UOQ, more prominent than prior study, suggest left mag.  
::mex::high-density globules adjacent to the ** implant, representing an extracapsular implant rupture.
::hj::(HHC/Dr.JW) 



; JW breast US templates

; Hx:
::JOP::right/left breast cancer, MRM.
::JBCT::right/left breast cancer, BCT.
::JMam::mammo showed asymmetry at **.
::JFH::family history breast cancer (**).
::Jcheck::breast checkup.

; Content:
::JNP::no definite focal mass lesions. 
::Jfa::an oval hypoechoic, wider than tall lesion, r/o fibroadenoma at
::Jfas::oval hypoechoic, wider than tall lesions, r/o fibroadenomas at
::JCy::cysts at
::JLN::benign appearing node at ** axilla, size***, having fat hilum.
::JLNs::benign appearing nodes at ** axilla, size***, and ** axilla, size***, having fat hilum.
::JFCC::fibrocystic change, ***.
::JCal::r/o calcifications at ***, suggest mammography correlation. 
::JFNA::*****, suggest FNA.
::JCAOP::no definite focal mass at ** breast. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. Suggest regular f/u.

; Impression
::JB1::no definite focal lesions in this study.
::JB2::benign findings, suggest regular imaging f/u.
::JB3::probably benign findings, left? Right? Suggest short-term echo f/u.
::JB4::susp finding(s), left? Right? Suggest tissue sampling.
::JCor::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 

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
 Bilateral MLO/CC II and ID views are read and no prior mammography for comparison. 
The breast is heterogeneously dense, which could obscure detection of small masses. 
Bilateral retropectoral saline implants are noted without definite evidence of rupture.
There are no definite mass, no suspicious microcalcifications, and no architectural 
distortion in this study. (HHC/JW) 
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
Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison. 
There are bilateral scattered fibroglandular tissues. There are benign appearing vascular 
wall calcifications at bilateral breasts. There are no definite mass, and no architectural 
distortion in this study.  (HHC/Dr.JW) 
)

::BrE::
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
::asp::ultrasound-guided fine needle aspiration is performed smoothly without obvious discomfort and two imprint for cytology. No more bleeding after manual compression.
::core:: core biopsy with 15G*6cm coaxial introducer needle and 16G*11cm biopsy needle and two tissue stripes are sent for pathology.

::mw::
(
Hx: Left breast fibroadenoma s/p partial mastectomy. Right breast DCIS s/p partial 
mastectomy in 2007. Right breast fibrocystic change with microcalcification s/p excisional
biopsy in 2010. Wires marked. For follow-up. 
Bilateral CC and MLO, bil MLO spot mag read and compared with prior mammogram on 
2010-02-25, 2009-12-30 (needle localization), 2009-07-28, 2008-08-21, 2007-9-11. 
The breast is heterogeneously dense, which could obscure detection of small masses. Focal 
parenchymal loss, architectural distortion and skin retraction are noted at right upper outer
 breast under the wire, compatible with postop change. There are benign scattered and 
regional calcifications present bilaterally. Focal grouped remaining faint punctate 
microcalcification is noted beneath the scar at right upper breast, and segmental punctate 
microcalcifications at left upper breast. Suggest short-term follow-up. (HYS/Dr.JW)
ACR BI-RADS 3, probably benign finding of bil upper breast. Suggest 6-month mammographic 
follow up with magnification views (bil upper). 
)
::bmr::
(
PH: 2011-1-18, Breast, right, ultrasound-guided core biopsy, invasive ductal carcinoma.
MRI of the breasts with multiple pulse sequences (axial TSE T2, DWI, axial T1WI, axial 3D FLASH without and with dynamic enhancement and high resolution 3D volumetric enhanced T1WI) is performed in 3T MR scanner with dedicated breast coils in prone position. This MR study is read with prior mammograms (2011-1-12) for comparision and it shows:
1. breast composition: bilateral heterogeneously dense fibroglandular tissue.
2. ill defined regional enhancement and small nodules at the LOQ right breast, associated with increased vascularity. The nodules show rim enhancement with suspicious kinetic curves (plateau and mild wash out).  Some linear branching enhancement is also found localized at the outer hemisphere and LOQ right breast towards right nipple. The possibility of EIC should be suspected. The findings are compatible with breast malignancy.
3. no definite suspicious lesion or focal enhancement in the left breast.
4. bilateral small axillary lymph nodes. 
ACR BI-RADS category 6, known biopsy-proven malignancy of the right breast. Appropriate action is suggested. 
)
::mamobiopsy::
(
Hx: right breast microcalcifications , for biopsy.
 Initially, magnification views for left and right in CC projection showed no interval change compared to prior exam of Nov/'07, so biopsy was then performed.
 Stereotactic vacuum-assisted breast biopsy was performed smoothly for the microcalcifications clustered in right UOQ via cephalid approach. After informed consent was signed, the breast was positioned at stereotacic unit, the target was determined by stereotactic device. A total of 10cc 2% Xylocaine with 1/200,000 Bosmin was given, an incision was made by #11 scalpel, a 11G Mammotome biopsy probe was inserted to the target area. A total of 17 specimens were retrieved. The specimen radiograph revealed that there are adequate amount of microcalcifications in the specimens. A clip was then deployed into the biopsy cavity to mark the biopsy site. The post-biopsy CC/MLO mammograms revealed that there are no residual calcifications at target site. The specimens with and without calcifications were separted into two formalin bottles and sent for histopathology. A post-biopsy instruction sheet was given to the patient, there was no evident complications after the procedure.
 The pathology result revealed fibrocystic change with microcalcifications, suggest postbiopsy 6 month f/u with right mag views.
)

::mnp::Hx: For screening Bilateral CC and MLO are read without prior study for comparison. The breast tissue is heterogeneously dense, which could obscure detection of small masses. There are benign scattered and regional calcifications present bilaterally. There is no definite mass or architectural distortion in this study.

::mca5::
(
HX: right lump, BB marked.
Bilateral MLO and CC, right CC/MLO spot mag are read without prior mammograms available for comparison. The breast tissue is heterogeneously dense, which could obscure detection of small masses. There is architectural distortion, spiculated mass associated with segmental pleomorphic to linear, branching and casting microcalcifications at right upper central breast, under the BB with focal skin thickening, breast cancer is highly suggested and spanning about 5.6cm in dimension, suggest immediate management. Focal asymmetry at right upper breast, axillary tail, suggest ultrasound. 
1). BI-RADS 5, highly suggestive right breast cancer, suggest immediate management
2). right axillary tail asymmetry, suggest ultrasound (BI-RADS 0). 
)