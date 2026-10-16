﻿﻿﻿;

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





; 自動啟動 RIS + IMPAX 並輸入帳號密碼 (VS)

#v::   ; 按Win-key + v 鍵自動啟動

ris="http://10.0.0.100:8888/NH/NH.jnlp"

impax="C:\impax\select\bin\impax_select.exe"

runame=019467         ;RIS的帳號 (6位數字員工代號)

iuname=019467         ;IMPAX的帳號

rpasswd=7      ;RIS密碼

ipasswd=7      ;IMPAX密碼



Run, %impax%,,,

WinWait,登入,,,,

WinActivate,ahk_class ThunderRT6FormDC,,,

control,editpaste,%iuname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,

control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,

controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,



Run, %ris%,,,

Winwait, Login,,,,

WinActivate,ahk_class SunAwtDialog,,,

winget,rpid,PID, ahk_class SunAwtDialog,,,

controlsend, ,%runame%{enter}, ahk_pid %rpid%

controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%

Return



; 自動啟動 RIS + IMPAX 並輸入帳號密碼  (R)

#r::   ; 按Win-key + r 鍵自動啟動

ris="http://10.0.0.100:8888/NH/NH.jnlp"

impax="C:\impax\select\bin\impax_select.exe"

runame=ILS         ;RIS的帳號 (6位數字員工代號)

iuname=019467         ;IMPAX的帳號

rpasswd=ILS      ;RIS密碼

ipasswd=7      ;IMPAX密碼



Run, %impax%,,,

WinWait,登入,,,,

WinActivate,ahk_class ThunderRT6FormDC,,,

control,editpaste,%iuname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,

control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,

controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,



Run, %ris%,,,

Winwait, Login,,,,

WinActivate,ahk_class SunAwtDialog,,,

winget,rpid,PID, ahk_class SunAwtDialog,,,

controlsend, ,%runame%{enter}, ahk_pid %rpid%

controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%

Return



; 按Window Key + N 啟動 N hospital intranet (logged-in)

#n::

nhosp="http://sama.cyyang.org/nhosp.htm"

Run, %nhosp%,,,

Return



; 按Window Key + L 啟動 N Hospital lab (logged-in)

#l::

nhosp="http://10.0.0.100/nhosp.htm"

Run, %nhosp%,,,

Return



; 按Window Key+ C 啟動 Case Collection Database (PHPmyAdmin)

#c::

casedb="http://10.0.0.100/phpmyadmin/"

casedb_login=

casedb_passwd=



Run, %casedb%

WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer, WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

   , javascript:void(document.login_form.pma_username.focus());

   , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_login%{Del 3}



WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer, WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

   , javascript:void(document.login_form.pma_password.focus());

   , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_passwd%{Del 10}+{Enter}



Return





; 一般



::hof::History of

::nhis::Clinical history is not available.

::l::left

::r::right

::m::mild

::bi::bilateral

::mol::more on the left side

::mor::more on the right side

::lo::lower



::nab::No definite abnormality in this study.

::ro::R/O



; OTRHO

::nfd::No evidence of fracture or dislocation.

::snl::The soft tissue is within normal limit.



; CXR and plain film



::aa::Standing abdomen shows:

::ap::Chest AP shows:

::pa::Chest PA shows:

::k::KUB shows:

::sa::supine abdomen shows:



::npa::

(

Chest PA shows:

Normal heart size and no definite lung lesion. 

)



::nk::

(

KUB shows:

Clear bilateral psoas and renal shadows. Unremarkable intestinal air. No abnormal calcification.

)



; HMC kub and lumbosacral spine

::nkls::

(

KUB and lumbosacral spine show:

Clear bilateral psoas shadows. Unremarkable intestinal air. No abnormal calcification.

Normal alignment of the lumbosacral spine. Preserved intervertebral disc spaces and vertebral height.

)



::kls::KUB and lumbosacral spine show:

::susc::疑似

::mc::輕微

::rrsc::右腎結石

::lrsc::左腎結石



::dsdd::degenerative spinal disease

::mdsd::Mild degenerative spinal disease.

::dsdc::輕微退行性脊椎病變

::dddc::輕微退行性椎間板病變

::dddd::degenerative disc disease

::n::normal

::nc::Normal. 正常. 

::lsms::Lumbar spondylosis with marginal spur formation. 

::mlsms::Mild lumbar spondylosis with mild marginal spur formation. 

::lsmsf::Lumbar spondylosis with marginal spur formation and facet joint arthrosis.

::mdcs::Mild degenerative changes of the spine. 

::spoc::脊椎滑脫症

::spo::spondylolisthesis

::fja::facet joint arthrosis

::fjal::facet joint arthrosis at lower lumbar levels

::opb::osteopenia of the bony structures. 

::nals::Normal alignment of the lumbosacral spine.

::pids::Preserved intervertebral disc spaces and vertebral height.

::comf::compression fracture

::comfs::compression fractures

::dds::decreased disc space at

::dvh::decreased vertebral height at 

::epc::endplate changes

::vap::vacuum phenomenon

::rod::radiopaque density

::rods::radiopaqye densities

::rrs::right renal shadow

::lrs::left renal shadow



::ifm::Increased fecal materials.

::iia::Increased intestinal air.

::pia::Prominent intestinal air.



::lss::Lumbosacral spine shows:

::tss::Thoracic spine shows:

::css::Cervical spine shows:



::wdu::Well-distended urinary bladder without definite focal lesion.

::ndu::The urinary bladder is not well-distended.

::nodlu::No definite lesion of the urinary bladder.



::sms::Spondylosis with marginal spurs.

::awn::The alignment is within normal limit.

::pvsn::The prevertebral soft tissue is within normal limit.



; 右股骨骨硬化性病灶

; 主動脈鈣化.

; 疑似攝護腺鈣化

; 輕微脊柱側彎.

; 手術後變化. 

; 骨盆腔傾斜. 

; 椎弓解離併脊椎滑脫. 



::uia::Unremarkable intestinal air pattern. 

::nac::No abnormal calcification. 

::cps::Clear bilateral psoas shadows. 

::cprs::Clear bilateral psoas and renal shadows. 

::phlc::靜脈石

::phle::phlebolith

::rphl::A phlebolith in the right pelvic cavity.

::lphl::A phlebolith in the left pelvic cavity. 

::phls::Phleboliths in the pelvic cavity.

::urolc::

::urol::urolithiasis

::calrr::Small calcifications superimposed on the right renal shadow, renal stones are considered.

::callr::Small calcifications superimposed on the left renal shadow, renal stones are considered.

::calbr::Small calcifications superimposed on bilateral renal shadows, renal stones are considered.



::bcon::Bilateral lung consolidation.

::bconl::Bilateral lung consolidation, more on the left side.

::bconr::Bilateral lung consolidation, more on the right side.

::bconlo::Bilateral lung consolidation, more at lower lung fields.

::bconpe::Bilateral lung consolidation and pleural effusion.

::bconpel::Bilateral lung consolidation and pleural effusion, more on the left side.

::bconper::Bilateral lung consolidation and pleural effusion, more on the right side.

::lconpe::Left lung consolidation and pleural effusion.

::rconpe::Right lung consolidation and pleural effusion.

::bconu::Bilateral lung consolidation, more at upper lung fields.

::blcon::Bilateral lower lung consolidation.

::dcon::Bilateral diffuse consolidation.

::ccp::Clear bilateral costophrenic angles.

::bcp::Blunted bilateral costophrenic angles.

::blcp::Blunted left costophrenic angle.

::brcp::Blunted right costophrenic angle.

::bpe::Bilateral pleural effusion.

::lpe::Left pleural effusion.

::rpe::Right pleural effusion.

::bln::Bilateral multiple lung nodules.

::mecl::Mild emphysematous change of both lungs.

::ecl::Emphysematous change of both lungs.

::eld::Elevated left hemidiaphragm.

::erd::Elevated right hemidiaphragm.

::ipi::Bilateral increased peribronchial infiltration.

::bpc::Bilateral peribronchial cuffing.

::llc::Bilateral low lung capacity.

::dllc::Bilateral decreased lung capacity.

::lpn::Left pneumothorax.

::rpn::Right pneumothorax.

::lpnct::Left pneumothorax with chest tube insertion.

::rpnct::Right pneumothorax with chest tube insertion.

::nfl::No definite focal lung lesion.

::nal::No definite active lung lesion.

::ndl::No definite lung lesion.

::olh::Total opacification of the left hemithorax.

::orh::Total opacification of the right hemithorax.

::iiph::Increased infiltration at bilateral perihilar regions.

::pi::patchy infiltration

::ii::increased infiltration

::fnl::fibronodular lesions

::conp::pleural effusion is considered.

::con::consolidation

::pcon::patchy consolidation

::suba::subsegmental atelectasis



::nips::Small round symmetric nodular opacities at bilateral lower lung zones, nipple shadows are suggested.

::rnip::A round nodular opacity at right lower lung zone, a nipple shadow is suggested.

::lnip::A round nodular opacity at left lower lung zone, a nipple shadow is suggested.

::nip::Nipple shadows at bilateral lower lungs. 



::impi::improved as compared with prior image.

::mspi::more severe as compared with prior image.



::plm::Prominent bilateral lung markings.

::ipv::Increased pulmonary vasculature.



::tdl::the trachea is deviated to the left side.

::tdr::the trachea is deviated to the right side.

::msl::the mediastinum is shifted to the left side.

::msr::the mediastinum is shifted to the right side.



::iprn::Bilateral interstitial thickening with reticulonodular pattern.



::fcl::fibrocalcified lesions

::io::irregular opacities

::fic::fibrotic changes



::rap::Right apical pleural thickening.

::lap::Left apical pleural thickening.

::bap::Bilateral apical pleural thickening.



::rhm::right hilum and mediastinum

::lhm::left hilum and mediastinum



::pocr::Post-operative changes with surgical clips at right hilum and mediastinum.

::pocl::Post-operative changes with surgical clips at left hilum and mediastinum.



::lapp::LAP



::ido::ill-defined opacities

::aido::ill-defined opacity

::idol::ill-defined opacities over both lungs.

::idoph::ill-defined opacities at bilateral perihilar regions.



::sube::subcutaneous emphysema

::pef::pleural effusion



::rulz::right upper lung zone

::rllz::right lower lung zone

::lulz::left upper lung zone

::lllz::left lower lung zone

::rmlz::right middle lung zone

::lmlz::left middle lung zone

::bulz::bilateral upper lung zones

::bllz::bilateral lower lung zones

::apw::AP window

::rbl::right basal lung

::lbl::left basal lung

::bbl::bilateral basal lungs



::nsa::No evidence of subphrenic free air.

::naf::No abnormal air-fluid level.





::lm::Status post left mastectomy.

::rm::Status post right mastectomy.





::cm::Cardiomegaly.

::mcm::Mild cardiomegaly.

::cmc::Cardiomegaly with calcified aorta.

::cmct::Cardiomegaly with calcified tortuous aorta.

::cmt::Cardiomegaly with tortuous aorta.

::cmmw::Cardiomegaly and mediastinal widening.

::mw::Mediastinal widening.

::nh::Normal heart size.

::nhc::Normal heart size with calcified aorta.

::nht::Normal heart size with tortuous aorta.

::nhct::Normal heart size with calcified tortuous aorta. 

::phs::Prominent bilateral hilar shadows.

::rphs::Prominent right hilar shadow.

::lphs::Prominenet left hilar shadow. 

::ephs::Enlarged bilateral hilar shadows.

::ehs::Enlarged heart shadow.

::hbo::The heart border is obscured

::rhbo::The right heart border is obscured

::lhbo::The left heart border is obscured



::rua::right upper abdomen

::lua::left upper abdomen

::rla::right lower abdomen

::lla::left lower abdomen

::ua::upper abdomen



::cps::Clear bilateral psoas shadows.

::cprs::Clear bilateral psoas and renal shadows.

::fmc::Increased amount of fecal materal in the colon.

::il::Increased intestinal air and dilatation of the bowel loops, ileus is considered.

::miau::Mild increased intestinal air but otherwise unremarkable.

::uia::Unremarkable intestinal air.

::nac::No abnormal calcification.

::ncu::No abnormal calcification along the urinary tract.

::npn::No evidence of pneumoperitoneum.

::ppc::Phlebolithes in the pelvic cavity.

::sls::Spondylosis of the lumbar spine.

::ssls::Spondylosis and scoliosis of the lumbar spine.



::ssts::Spondylosis and scoliosis of the thoracic spine. 

::sts::Spondylosis of the thoracic spine.

::dcs::Degenerative changes of the spine.

::ssss::spondylosis and scoliosis of the spine.



::mf::metallic fixation

::cs::cervical spine

::ts::thoracic spine

::ls::lumbar spine



::lrf::Previous left rib fractures.

::rrf::Previous right rib fractures.



::mscp::more severe as compared with prior image



;  Lines and tubes





::et::Placement of an endotracheal tube.

::etng::Placement of an endotracheal tube and a NG tube.

::etngrc::Placement of an endotracheal tube, a NG tube, and a right central venous catheter.

::etnglc::Placement of an endotracheal tube, a NG tube, and a left central venous catheter.

::etngfc::Placement of an endotracheal tube, a NG tube, and a femoral central venous catheter.

::etrc::Placement of an endotracheal tube and a right central venous catheter.

::etlc::Placement of an endotracheal tube and a left central venous catheter.

::tra::Placement of a tracheostomy tube.

::trang::Placement of a tracheostomy tube and a NG tube.

::trangrc::Placement of a tracheostomy tube, a NG tube, and a right central venous catheter.

::tranglc::Placement of a tracheostomy tube, a NG tube, and a left central venous catheter.

::trangfc::Placement of a tracheostomy tube, a NG tube, and a femoral central venous catheter.

::ng::Placement of a NG tube.

::ngrc::Placement of a NG tube and a right central venous catheter.

::nglc::Placement of a NG tube and a left central venous catheter.

::ngfc::Placement of a NG tube and a femoral central venous catheter.

::lc::Placement of a left central venous catheter.

::rc::Placement of a right central venous catheter.

::fc::Placement of a femoral central venous catheter.

::bc::Placement of bilateral central venous catheters. 

::ecmo::Under ECMO support.

::iabp::Status post IABP insertion.

::pc::Placement of a perm-cath.

::sgc::Placement of a Swan-Ganz catheter.

::dlc::Placement of a double lumen catheter.

::pic::Placement of a PICC.



::pigc::Placement of a pigtail catheter at



::rpa::Placement of a right Port-A catheter.

::lpa::Placement of a left Port-A catheter.

::sw::Sternal wiring.

::swts::Sternal wiring and placement of mediastinal tubes.

::swt::Sternal wiring and placement of a mediastinal tube.

::vr::Status post cardiac valve replacement with sternal wiring.

::vrt::Status post cardiac valve replacement with sternal wiring and placment of mediastinal tubes.

::cabg::Status post CABG with sternal wiring.

::cabgt::Status post CABG with sternal wiring and placement of mediastinal tubes.

::cos::Status post coronary stenting.

::ricas::Status post right carotid stenting.

::licas::Status post left carotid stenting.

::vps::Status post VP shunting.

::stp::status post



::sc::surgical clips

::dt::drain tubes

::sut::suture materials



::mcli::post-operative changes with clips in the mediastinum.



::taeua::Status post TACE with lipiodol retention at the right upper abdomen.



::f::Placement of a Foley catheter.



::bct::Insertion of bilateral chest tubes.

::rcts::Insertion of right chest tubes.

::lcts::Insertion of left chest tubes.

::rct::Insertion of a right chest tube.

::lct::Insertion of a left chest tube.

::cpm::Placement of a cardiac pacemaker.

::cpmw::Placement of cardiac pacing wire. 

::cpme::Placment of epicardial pacing wires.





::bdbj::Placement of bilateral double J catheters.

::ldbj::Placement of a left double J catheter.

::rdbj::Placement of a right double J catheter.



::orrpa::

(

Intraoperative chest AP shows:

Placement of a right Port-A catheter with its tip in SVC.

)

::orlpa::

(

Intraoperative chest AP shows:

Placement of a left Port-A catheter with its tip in SVC.

)



; OTRHO PLAIN FILM



::anky::lateral syndesmophytes and interspinous ligament ossification of the spine, ankylosing spondylitis is considered;









; Breast Mammography





::B0::BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest breast ultrasound correlation.

::B0sr::Indeterminate finding(s) of this mammography (ACR BI-RADS category 0). Suggest spot compression view of the right breast.

::B0u::Indeterminate finding(s) of this mammography (ACR BI-RADS category 0). Suggest ultrasound correlation.

::B1::Negative finding of this mammography (ACR BI-RADS category 1). Suggest annual mammogram follow up or ultrasound study if there is any clinical palpable lump.

::B2::Benign findings of this mammography (ACR BI-RADS category 2). Suggest annual mammogram follow up or ultrasound study if there is any clinical palpable lump or prior ultrasound detected abnormality.

::B2op::Benign findings of this mammography (ACR BI-RADS category 2). Suggest annual mammogram follow up and ultrasound correlation.

::B3::Probably benign findings of this mammography (ACR BI-RADS category 3). Suggest mammogram follow up in 6 months.

::B4b::Suspicious findings of this mammography (ACR BI-RADS category 4B). Suggest tissue proof.

::B4a::Suspicious findings of this mammography (ACR BI-RADS category 4A). Suggest tissue proof. 

::B4cc::Suspicious findings of this mammography (ACR BI-RADS category 4C). Suggest tissue proof. 



::B0C::性質未定之乳房攝影發現，建議乳房超音波對照，與放大攝影。

::B1C::無異常乳房攝影發現，建議每年追蹤。

::B2C::良性乳房攝影發現，建議每年追蹤。

::B3C::可能為良性乳房攝影發現，建議短期追蹤，並加超音波對照。

::B4C::疑似不正常的乳房攝影發現，建議乳房超音波對照。

::LBC::左乳

::RBC::右乳

::BBC::雙乳



::msc::Screening digital mammography of both breasts in CC and MLO views shows:



::mcomn::Digital mammography of both breasts in CC and MLO views is read without prior study available for comparision. This study shows:

::mcom::Digital mammography of both breasts in CC and MLO views is read and compared with prior study dated . This study shows: 

::mm::Digital mammography of both breasts in CC and MLO views shows:

::MD1::the breast is almost entirely fat (<25% glandular).

::MD2::there are scattered fibroglandular densities (approximately 25-50% glandular).

::MD3::the breast tissue is heterogeneously dense, which could obscure detection of small masses (approximately 51-75% glandular).

::MD4::the breast tissue is extremely dense. This may lower the sensitivity of mammography (>75% glandular).



::bcal::benign calcifications over bilateral breasts. 

::rcal::benign calcifications over right breast.

::lcal::benign calcifications over left breast. 

::MN::there is no definite mass, no suspicious microcalcification, and no architectural distortion in this study.

::MNE::there is no definite mass and no architectural distortion in this study. 



::MOP::focal parenchymal loss, architectural distortion, and skin retraction are noted at left upper central breast under the wire, compatible with post-operative changes. 





::baln::small bilateral axillary lymph nodes.

::raln::small right axillary lymph nodes.

::laln::small left axillary lymph nodes.



::lbca::History of left breast cancer status post mastectomy.

::rbca::History of right breast cancer status post mastectomy. 







::BB::bilateral breasts

::BCT::History of breast cancer s/p BCT with marking wire,

::BFBU::Benign findings of breast ultrasound.

::CAOP::no definite focal mass at ** breast. No definite lymphadenopathy at bilateral axillae, supraclavicular regions and anterior chest wall. Suggest regular follow-up.

::CORRELAT::negative ultrasound. However, suggest mammography correlation, and the final assessment should be rendered according to the highest concern among the modalities.

::DIG::(digital)

::FA::fibroadenoma 

::FCC::fibrocystic change

::FHX::family history of breast cancer (sister/mother/grandmother),

::FS::For screening. 

::HCU::For health check up.

::LB::left breast

::LNR::benign appearing node at right axilla, size , having fat hilum.

::LNL::benign appearing node at left axilla, size , having fat hilum.

::MAG::spot magnification views

::MASY::Focal asymmetry is noted at right anterior UOQ near central, suggest ultrasound or mag. views.

::MCA::There are benign scattered calcifications present bilaterally.

::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.

::MFG::There are bilateral scattered fibroglandular tissues.

::MHDE::The breast tissue is heterogeneously dense, and this may lower the sensitivity of mammography.

::MHX::History: right breast tumor s/p op. Family history of breast cancer (mother). 

::MN::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.

::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.

::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.



::MNO::Bilateral MLO and CC digital mammograms are read without prior exams available for comparison. This study shows: 



::MOP2::Focal architectural distortion, parenchymal retraction is noted at right UOQ under the wire and focal asymmetry near the surgical bed.

::MOP3::Post-op. changes at left UIQ breast with parenchymal loss, architectural deformity, skin retraction and thickening.

::MRM::History of breast cancer s/p MRM,

::MSUG::suggest breast ultrasound correlation and right mag. views.

::NP::No definite focal mass lesion. Suggest follow-up.

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







::B2ncom::

(

Digital mammography of both breasts in CC and MLO views is read without prior study available for comparision. This study shows:

1. symmetric breast with scattered or mildly dense fibroglandular tissue. 

2. some benign calcifications of the right breast. 

3. no definite deformity of breast parenchyma. Bilateral small axillary lymph nodes.



Imp: benign mammographic findings noted in this study (ACR BI-RADS category 2). Suggest annual follow up and ultrasound correlation if there is clinically palpable lump or prior US detected abnormality. 

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









; 開頭



::mrh::MRI of head without and with contrast enhancement shows:

::mrhn::MRI of head without contrast enhancement shows:

::mrn::MRI of neck without and with contrast enhancement shows:

::mrnn::MRI of neck without contrast enhancement shows:



::cthn::CT of head without contrast enhancement shows:

::cth::CT of head without and with contrast enhancement shows:

::ctn::CT of neck without and with contrast enhancement shows:

::ctab::CT of abdomen without and with contrast enhancement shows: 

::ctap::CT of abdomen and pelvis without and with contrast enhancement shows: 





::mso::magnetic suceptibility artifacts from dental prosthesis obscure image details in the oral cavity.

::ma::motion artifacts which may obscure image details.



::ans::(annotated in the summary series) 



; Chest CT





::ycc::(ILS/Dr.YCC)

::ctc::CT of chest without and with contrast enhancement shows:

::ctcn::CT of chest without contrast enhancement shows:

::ctcc::CT of the chest without and with contrast enhancement is read and compared with prior study dated . This CT study shows:

::chrct::HRCT of chest without contrast enhancement shows:



::nat::no evidence of air trapping on expiratory images.





::nlma::no abnormal enlarged lymph nodes in the mediastinum or bilateral axillary regions.

::ggo::ground glass opacity

::ggos::ground glass opacities

::nad::no definite lesion at both adrenal glands. 

::ptr::paratracheal region



::poc::post-operative changes



::ac::atherosclerotic calcification

::aca::atherosclerotic calcification of the aorta.

::acac::atherosclerotic calcification of the aorta and coronary arteries.

::mcac::mild coronary artery calcifications.

::cca::calcification of the coronary arteries.



::rhact::please correlate with the image findings and report of the head and abdomen CT studies. 

::ract::please correlate with the image findings and report of the abdomen CT study.

::rhapct::please correlate with the image findings and report of the head, abdomen, and pelvis CT studies. 

::rnapct::please correlate with the image findings and report of the neck, abdomen, and pelvis CT studies. 

::rapct::please correlate with the image findings and report of the abdomen and pelvis CT study. 

::rnact::please correlate with the image findings and report of the neck and abdomen CT studies. 

::rhct::please correlate with the image findings and report of the head CT study. 



::iact::(For the images of abdomen, please see the report of abdomen CT.)

::icct::(For the images of chest, please see the report of chest CT.) 

::incct::(For the images of neck and chest, please see the report of neck and chest CT.) 

::iapct::(For the images of abdomen and pelvis, please see the report of abdomen and pelvis CT.)

::ihct::(For the images of head, please see the report of head CT.)

::ihact::(For the images of head and abdomen, please see the report of head and abdomen CT.)

::ihnact::(For the images of head, neck, and abdomen, please see the report of head, neck, and abdomen CT.)   

::inapct::(For the images of neck, abdomen, and pelvis, please see the report of neck, abdomen, and pelvis CT.) 



::ihcct::(For the images of head and chest, please see the report of head and chest CT.) 

::incct::(For the images of neck and chest, please see the report of neck and chest CT.) 





::scps::which becomes smaller as compared with previous study.

::lcps::which becomes larger as compared with previous study.

::sscps::which is stationary as compared with previous study.

::acps::as compared with previous study.



::sds::spondylosis with degenerative marginal spurs are noted.

::ccfu::suggest clinical correlation and follow up.



::nmal::no definite mediastinal or axillary lymphadenopathy.

::nsml::non-specific small mediastinal lymph nodes.

::mln::mediastinal lymph nodes 

::lca::lung cancer



::npe::no pleural effusion.

::nmab::No evidence of metastatic lesion in the abdomen.





; Abdomen MRI



::mrab::MRI of abdomen without and with contrast enhancement shows:

::mrap::MRI of abdomen and pelvis without and with contrast enhancement shows:

::mrabn::MRI of abdomen without contrast enhancement shows: 

::mrapn::MRI of abdomen and pelvis without contrast enhancement shows: 



::hmc::

(

MRI of abdomen and pelvis for health examination in axial, coronal, and sagittal views shows:

Abdomen:

1. Liver: normal

2. Spleen: normal

3. Pancreas: normal

4. Kidneys: normal 

5. Adrenal glands: normal

6. Great vessels: normal

7. MRCP: normal

Pelvis:

1. Prostate: normal

2. Seminal vesicles: normal

3. Urinary bladder: normal



Pelvis:

1. Uterus and cervix: normal

2. Ovaries: normal

3. Urinary bladder: normal

)



::afpl::AFP: ng/ml.



::fatl::Diffusely decreased signal on out-of-phase images as compared with in-phase images, suggestive of fatty liver.



; HCC

::hccen::with global enhancement in the arterial phase and washout in the portal venous phase

::hccsien::low SI on T1WI, high SI on T2WI, global enhancement in the arterial phase and washout in the portal venous phase.

::aps::AP shunting



::cbb::Clear bilateral basal lungs.



::lcu::Liver cirrhosis with uneven hepatic surface.

::esv::Esophageal varices.

::nltr::No evidence of local tumor recurrence.

::wtr::without tumor recurrence.

::hcce::arterial enhancement and washout in portal venous phase.

::apse::arterial enhancement and becomes isodense in portal venous phase.



::spm::Splenomegaly.

::pocnr::Post-operative changes without tumor recurrence.

::nam::No evidence of abdominal metastasis.

::napm::No evidence of abdominal or pelvic metastasis.



::phpv::Patent hepatic and portal veins.

::nalap::No abdominal lymphadenopathy.

::naplap::No abdominal or pelvic lymphadenopathy.

::nas::No ascites.

::nodl::No definite lesion of the 

::sp::spleen,

::pan::pancreas,

::gb::gallbladder,

::bka::both kidneys and adrenals.

::lka::left kidney, and both adrenals.

::rka::right kidney, and both adrenals.

::bad::and both adrenals.

::lv::liver,



; 頭頸部



::bme::bilateral mastoid effusion.

::rme::right mastoid effusion.

::lme::left mastoid effusion.

::bcps::bilateral chronic paranasal sinusitis.

::mps::mild mucosal thickening of the paranasal sinuses.



::pni::the primary tumor is not identified.

::ln::lymph nodes

::lnnm::which do not meet the size criteria of malignancy.

::postrt::post-RT edematous change at the retropharynegeal space and bilateral neck interstitium as well as fatty change of the cervical spine.

::nlt::no evidence of local tumor recurrence.

::nlapc::no abnormal enlarged cervical lymphadenopathy.

::prtnr::Post-RT change without tumor recurrence.

::ntr::No evidence of tumor recurrence.

::nvb::no abnormality of the visible brain parenchyma.

::nsb::no abnormality of the skull base and visible brain parenchyma.





; 腦



::nv::normal appearance of the sulci, fissures, and ventricles.

::mbav::mild brain atrophy with prominent sulci, fissures, and ventricles.

::bav::brain atrophy with dilated sulci, fissures, and ventricles.

::nfbr::no definite focal lesion of the brain parenchyma.

::ic::intact calvarial vault.

::cpsm::clear paranasl sinuses and mastoid air cells.

::tofn::TOF MRA shows no abnormality of the major intracranial arteries.

::tofa::TOF MRA shows

::cmran::contrast-enhanced MRA shows no abnormality of the major cervicocranial arteries.

::cmraa::contrast-enhanced MRA shows

::pvwm::periventricular white matter

::leuct::confluent low density changes at bilateral periventricular white matter, leukoaraiosis is considered.

::leumr::confluent increased signal on T2WI at bilateral periventricular white matter, leukoaraiosis is considered.

::niab::No evidence of intracranial abnormality.

::ndwi::no diffusion restriction on DWI and ADC map.

::ncvsb::no definite abnormality of the calvarial vault and skull base.

::li::lacunar infarct

::bg::basal ganglion

::bgg::basal ganglia

::aci::atherosclerotic calcificaion of the intracranial arteries.







; from SJC



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





;7.  設定Window-3 Open the last ONE PACS image parallel 

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



