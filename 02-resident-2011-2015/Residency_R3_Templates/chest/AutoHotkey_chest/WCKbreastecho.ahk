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



:?*:``::^+{left}{bs}   ; press "`" to delete a word



::il::is likely
::al::are likely

::b0u::ACR BI-RADS 0, indeterminate ultrasonographic finding (need additional imaging evaluation). Suggest breast mammogram correlation.
::b1u::ACR BI-RADS 1, no definite abnormal finding in this study. Suggest annual follow up or at the recommendation of the patient's physician.
::b2u::ACR BI-RADS 2, benign finding. Suggest annual follow up or at the recommendation of the patient's physician.
::b3u::ACR BI-RADS 3, probably benign finding. Suggest 6-month interval follow up.
::b4u::ACR BI-RADS 4, suspicious lesion. Suggest tissue proof.
::b4au::ACR BI-RADS 4A, suspicious lesion. Suggest tissue proof.
::b4bu::ACR BI-RADS 4B, suspicious lesion. Suggest tissue proof.
::b4cu::ACR BI-RADS 4C, suspicious lesion. Suggest tissue proof.
::pae::posterior acoustic enhancement
::pas::posterior acoustic shadow
::br::Breast cancer s/p right BCT
::bl::Breast cancer s/p left BCT
::sbr::s/p right BCT with scar in
::sbrn::s/p right BCT with scar in No definite local recurrence.^{left}^{left}^{left}^{left}
::sbl::s/p left BCT with scar in
::sbln::s/p left BCT with scar in No definite local recurrence.^{left}^{left}^{left}^{left}
::mr::Breast cancer s/p right modified radical mastectomy
::ml::Breast cancer s/p left modified radical mastectomy
::smr::s/p right modified radical mastectomy
::smrn::s/p right modified radical mastectomy. No definite local recurrence
::sml::s/p left modified radical mastectomy
::smln::s/p left modified radical mastectomy. No definite local recurrence
::bc::breast cancer
::bb::bilateral breasts
::ndmr::No definite mass in the right breast
::ndml::No definite mass in the left breast
::ndmb::No definite mass in bilateral breasts
::pm::partial mastectomy
::sm::simple mastectomy
::nnn::
(
1. No definite mass lesion detected in both breasts.
2. No definite LAP at bilateral axillae. 
)
::wy::(WCK/Dr.YCC)
::wtt::wider than tall
::ttw::taller than wide
::fub::Breast lesion for follow up
::dp::Doppler ultrasound shows
::cir::circumscribed
::ncir::non-circumscribed

::nlap::No definite lymphadenopathy is found in this study
::cysb::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, r/o simple cysts and or fibroadenoma, largest size up to cm^{left}
::cysl::a oval, well-defined, anechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of cyst.^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}
::cysr::a oval, well-defined, anechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of cyst.^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}

::fa::fibroadenoma
::fab::oval, parallel, hypoechoic lesions with distinct margin at right breast / region and left breast / region, largest size up to cm, r/o fibroadenoma.^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}   
::fal::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma.^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}
::far::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma.^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}^{left}
::fc::fibrocystic change
::fh::family history of breast cancer (sister/mother/grandmother)
::fu::for follow-up.

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


::mm::mammogram


::ndlr::No definite local recurrence
::ndf::no definite focal lesion
::nmm::There is no definite mass, no focal suspicious microcalcifications, and no architectural distortion in this study
;::nlap::no definite lymphadenopathy at bil axillae, supraclavicular regions and anterior chest wall.
::nlna::no definite axillary lymphadenopathy
::nlnan::no definite axillary or neck lymphadenopathy
::nre::no evidence of local recurrence
::nsln::non-specific small lymph nodes at

::op::post-operative change
::opsc::post-operative change with scar formation at
::opscl::post-operative scarring at left breast, which is stationary compared with prior ultrasound on
::opscr::post-operative scarring at right breast, which is stationary compared with prior ultrasound on


::ro::r/o
::robl::r/o breast lesion(s)
::r::right
::rb::right breast





::mrm::modified radical mastectomy

::msr::s/p right MRM with surgical scar.
::msl::s/p left MRM with surgical scar.
::bsr::s/p right BCT with surgical scar.
::bsl::s/p left BCT with surgical scar.
::nlm::s/p right MRM without local recurrence, suggest follow-up of ultrasound. 
::nlb::s/p right BCT with surgical scar, no definite evidence of local recurrence. 
::fccl::an amorphous hypoechoic lesion at left breast 3/2, size 0.5 cm, r/o focal fibrocystic change.




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

::JC::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities. 



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