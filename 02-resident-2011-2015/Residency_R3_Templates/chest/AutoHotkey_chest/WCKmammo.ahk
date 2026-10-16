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

::bc::breast cancer
::pm::partial mastectomy

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

::r::right
::l::left

::hsm::History: screening mammogram.
::hrbct::History: right breast cancer s/p BCT with marking wire.
::hlbct::History: left breast cancer s/p BCT with marking wire.
::hrmrm::History: breast cancer s/p right MRM.
::hlmrm::History: breast cancer s/p left MRM.
::hfh::History: family history of breast cancer ( ).
::hrl::History: right breast lump.
::hll::History: left breast lump.
::hbl::History: bilateral breasts lumps.

::bmc::Bilateral MLO/CC digital mammograms are read and compared with prior mammograms dated
::bmcn::Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison

::op::Focal parenchymal loss, architectural distortion and skin retraction are noted at       breast under the wire, compatible with postop change

::bcal::There are benign scattered calcifications present bilaterally
::bcalv::There are benign appearing vascular wall calcifications at bilateral breasts


::neg::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study
::negc::There are no definite mass, and no architectural distortion in this study


::b0u::BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest breast ultrasound correlation.
::b0m::BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest mag. spot view correlation.
::b1::BI-RADS 1, negative finding, suggest annual mammogram follow up or at the recommendation of the patient's physician. (If there is clinical relevant finding, ultrasound is suggested.)
::b2::BI-RADS 2, benign finding, suggest annual mammogram follow up or at the recommendation of the patient's physician. (If there is clinical relevant finding, ultrasound is suggested.)
::b2s::BI-RADS 2, benign finding, suggest annual mammogram follow up.
::b3::BI-RADS 3, probably benign finding, suggest 6-month mammogram follow up. (If there is clinical relevant finding, ultrasound is suggested.)
::b4::BI-RADS 4, suspicious malignant lesion. Suggest tissue proof.


::MD1::The breast is almost entirely fat
::MD2::There are scattered fibroglandular densities
::MD3::The breast is heterogeneously dense, which could obscure detection of small masses
::MD4::The breast is extremely dense. This may lower the sensitivity of mammography
::MDE::The breast tissue is extremely dense, and this may obscure a lesion on mammography


::bb::bilateral breasts
::rb::right breast
::lb::left breast

::wj::(WCK/Dr.JW)


::FA::fibroadenoma 
::FCC::fibrocystic change
::FHX::family history of breast cancer (sister/mother/grandmother),


::LNR::benign appearing node at right axilla, size , having fat hilum.
::LNL::benign appearing node at left axilla, size , having fat hilum.
::MAG::spot magnification views
::MASY::Focal asymmetry is noted at right anterior UOQ near central, suggest ultrasound or mag. views.


::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.
::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.

::MOP2::Focal architectural distortion, parenchymal retraction is noted at right UOQ under the wire and focal asymmetry near the surgical bed.
::MOP3::Post-op. changes at left UIQ breast with parenchymal loss, architectural deformity, skin retraction and thickening.

::MSUG::suggest breast ultrasound correlation and right mag. views.
::NP::No definite focal mass lesion. Suggest follow-up.
::PL::pleomorphic

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

::MMNL::
(
Hx: microcalcifications in left breast, for needle localization.
 Needle localization was performed smoothly for the three groups of microcalcifications in left LOQ to lower central breast via LM approach, with two 20-G 10cm needle wire systems bracketing the anterior and posterior groups of calcifications, with the wire tips passing throught the anterior and posterior groups microcalcifications. The patient tolerated the procedure well without definite complications.
 The specimen radiograph showed that there are microcalcifications in the specimen.
)