﻿﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Revised from WYH
;


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Hotstring EndChars ()[]{}:;'"\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;
; 快速鍵設定區
;;;;;;;;;;;;;;;;;;;;;;;
; 自動啟動 RIS + IMPAX 並輸入帳號密碼  (v)
#v::   ; 按Win-key + v 鍵自動啟動
ris="http://10.0.0.100:8888/NH/NH.jnlp"
impax="C:\impax\select\bin\impax_select.exe"
runame=017585         ;RIS的帳號 (6位數字員工代號)
iuname=017585         ;IMPAX的帳號
rpasswd=017585      ;RIS密碼
ipasswd=6      ;IMPAX密碼

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


; 一般

::hof::History of
::nhis::Clinical history is not available.
::m::mild
::bi::bilateral
::mol::more on the left side
::mor::more on the right side
::temp:: (however, this report is not yet confirmed by the attending radiologist.)


::nc1::
(
Chest PA shows:
Normal heart size and no definite lung lesion. 
)

::nk::
(
KUB shows:
Clear bilateral psoas and renal shadows. Unremarkable intestinal air. No abnormal calcification.
)



::3t::Placement of a central venous catheter, an endotracheal tube and a NG tube
::3tl::Placement of a left central venous catheter, an endotracheal tube and a NG tube 
::3tr::Placement of a right central venous catheter, an endotracheal tube and a NG tube 

::a1::KUB shows
::a2::Standing abdomen shows
::ab::abdomen
::abd::abdominal
::abg::air-bronchogram
::ac::advise clinical correlation and follow-up
::adr::adrenal gland
::adrs::adrenal glands
::afl::air-fluid level
::aflr::air-fluid layering
::ahd::acromiohumeral distance
::akc::aortic knob calcification
::alth::anterolithesis
::ate::atelectasis
::ath::atherosclerosis with wall calcification of the aorta
::athb::atherosclerosis with wall calcification of the major cerebral arteries


::b::bilateral
::b6l::superior segment of LLL
::b6r::superior segment of RLL
::bal::bilateral apical lungs
::bbl::bilateral basal lungs
::bdlc::bilateral diffuse lung consolidation
::bec::bronchiectasis
::bg::basal ganglion
::bh::borderline heart size
::blc::bilateral lung consolidation
::bli::bilateral lung infiltrations
::bll::bilateral lower lungs
::bln::blunted
::blr::blurring
::bme::bone marrow edema
::boec::bronchiolectasis 
::bratr::brain atrophy with mild dilated sulci, fissures, cisterns, and ventricles
::bul::bilateral upper lungs    


::c1::Chest PA shows
::c2::Chest AP shows
::ca::calcification
::cabg::post CABG change with clips superimposed on heart and sternal wiring
::cals::microcalcifications
::cao::calcified aorta
::cak::calcified aortic knob
::cate::an amorphous calcified nodule(s) or plaque(s) about the greater humeral tubercle, r/o calcified tendinosis
::cfx::(previous) compression fracture
::cfx1::compression fracture(s) with wedge deformity
::cfx2::(previous) compression fracture(s) and wedge deformity or decrease in height of the
::cht::placement of chest tube
::chtl::placement of left chest tube
::chtr::placement of right chest tube
::chts::placement of chest tubes
::chty::cholecystectomy
::cl::surgical clips
::cm::cardiomegaly
::cmfx::(previous) comminuted fracture
::con::consolidation
::cora::Please correlate with the imaging findings and report of the abdominal CT study
::corap::Please correlate with the imaging findings and report of the abdominal and pelvic CT study
::corb::Please correlate with the imaging findings and report of the brain CT study
::corc::Please correlate with the imaging findings and report of the chest CT study
::cpa::costophrenic angle
::cpar::right costophrenic angle
::cpal::left costophrenic angle
::cpas::costophrenic angles
::cpm::status post cardiac pacemaker implantation
::cpw::placement of cardiac pacing wire
::crty::craniectomy
::cs::cervical spine
::cspo::cervical spondylosis with marginal spur formation at multiple levels
::cts::cervicothoracic spine
::cvc::status post central line insertion
::cvcr::placement of a right central venous catheter
::cvcrf::status post central line insertion from right femoral vein
::cvcrj::status post central line insertion from right jugular vein
::cvcrs::status post central line insertion from right subclavian vein
::cvcl::placement of a left central venous catheter
::cvclf::status post central line insertion from left femoral vein
::cvclj::status post central line insertion from left jugular vein
::cvcls::status post central line insertion from left subclavian vein
::cw::as compared with prior study on 2011/
::cwct::as compared with prior CT scan on 201
::cwmr::as compared with prior MR study on 201


::dbg::diminished bowel gas
::dbjb::placement of bilateral DBJ catheter
::dbjl::placement of left DBJ catheter
::dbjr::placement of right DBJ catheter
::dc::decreased
::dcfx::(previous) displaced, comminuted fracture
::ddh1::shallowing deformity of the acetabulum with mild lateral subluxation of the femoral head
::dfx::(previous) displaced fracture 
::dg::degenerative change
::dgs::degenerative change of the spine
::dl::placement of a double lumen catheter
::dlcl::decreased left lung capacity
::dlcr::decreased right lung capacity
::dn::density
::dns::densities
::dt::placement of drainage tube at
::dts::placement of drainage tubes at

::e::enhancement
::e1::enhancement on contrast-enhanced T1WI
::eac::external auditory canal
::ecl::essentially clear bilateral lungs
::ecmo::placement of large bore catheter, possibly ECMO in use
::emf::emphysematous change
::emfb::emphysematous change of both lungs
::emp::empyema
::et::status post endotracheal tube insertion
::etng::status post endotracheal tube and NG tube insertion
::etngtr::status post endotracheal tube, NG tube insertion and tracheostomy


::fal::fair alignment of the
::falc::fair alignment of the cervical spine
::fall::fair alignment of the lumbar spine 
::falt::fair alignment of the thoracic spine
::fc::fibrotic change
::fca::fibrocalcified lesions
::fd::filling defect
::ffl::fluid-fluid level
::fx::fracture
::fxs::fractures

::gb::gall bladder
::ggo::ground-glass opacity
::ggos::ground-glass opacities
::gst::gall stone
::gty::gastrectomy

::hh::hepatic hilum
::hi1::high signal on T1WI
::hi2::high signal on T2WI
::hlf::hypertrophic ligamentum flavum
::hm::homogeneous
::hmd::hemidiaphragm
::hmt::hemithorax
::hs::hilar shadow
::hsb::prominent bilateral hilar shadows
::hsl::prominent left hilar shadow
::hsr::prominent right hilar shadow
::hss::hilar shadows
::ht::heterogenous
::htbm::heterogeneous SI diffusely at the marrow of visible spine, sacrum and bil. pelvic bones, most likely due to hematopoietic tissue(s)
::hty::hepatectomy
::hx::History of 
::hz::haziness

::iac::internal auditory canal
::ic::increased
::icu1::cardiomegaly and bilateral lung consolidation
::icv::intact cranial vault
::id::ill-defined
::ido::ill-defined opacity at
::idos::ill-defined opacities at 
::ifr::status post internal (metallic) fixation and removal of the implant
::ifx::(previous) impacted fracture
::ilst::interlobular septal thickening
::inf::infiltration
::infs::infiltrations
::ist::interstitial
::istt::interstitial thickening
::iud::placement of intrauterine device
::ivd::intervertebral disc

::k::kidney
::kub::KUB shows:

::l::left
::lap::lymphadenopathy
::lat::lateral
::lda::lateral downsloped acromion
::lka::confluent low density change at bilateral periventricular white matter, consistent with leukoaraiosis
::llq::LLQ of the abdomen
::lm::lung markings
::lmty::laminectomy
::ln::lymph node
::lns::lymph nodes
::lo1::low signal on T1WI
::lo2::low signal on T2WI
::ls::lumbar spine
::lspo::lumbar spondylosis with marginal spur formation at multiple levels
::luq::LUQ of the abdomen

::med::mediastinum
::mfx::metallic fixation
::msa::magnetic susceptibility artifacts
::mst:: No definite bony lesion in the mastoid bone. Well pneumatization of bilateral mastoid bone. 
::mstd::decreased pneumatization of bil. mastoid with sclerotic change, chronic mastoiditis is considered.
::mty::mastectomy
::mw::mediastinum widening
::mx::maxillary
::mxs::maxillary sinsus
::mxss::maxillary sinuses

::n3::prevascular
::n4::paratracheal
::n5::aortopulmonary window
::n6::para-aortic
::n7::subcarinal
::n8::paraesophageal
::n10::hilar
::n11::interlobar

::na::no definite abnormality of the
::nab::no obvious abnormality of the liver, gall bladder, pancreas, both kidneys and adrenal glands
::nadr::normal appearance of bilateral adrenal glands
::naex::no definite active extravasation of contrast medium indicating as bleeder
::napp::normal appearance of the appendix
::nb1::no evidence of destructive bony lesion at the visible bony structures
::nb2::no evidence of focal bony or joint lesion
::nb3::no evidence of fracture or dislocation
::nb4::no evidence of focal bony or joint lesion; no evidence of fracture or dislocation
::nb5::no obvious fracture line is identified. no evidence of joint subluxation or dislocation
::nbb::intact cranial vault and skull base
::nd::nodule
::nexp::there is no evidence of airtrapping on expiration
::nfl::no definite focal lesion at the
::nfm::no definite focal mass lesion at the
::nfn::neural foramen narrowing
::nfx::no obvious bony fracture
::ng::status post gastric tube insertion
::ngtr::placement of NG tube and tracheostomy tube  
::nh::normal heart size
::nhie::preserved gray-white matter differentiation without significant evidence of HIE; but early HIE cannot be excluded
::nich::no definite intracranial hemorrhage

::nl::no definite lung lesion
::nl1::no definite abnormal lung opacity
::nl2::no definite abnormal lung nodule or opacity
::nlap::no definite lymphadenopathy at the
::nln::no enlarged lymph nodes at 
::nme::negative mass effect
::nmlap::no mediastinal or hilar lymphadenopathy
::nobu::No obstructive uropathy
::nrec::no evidence of local recurrence
::nros::no definite radiopaque density is noted in the urinary collecting system
::ns::nodular shadow
::nsbg::non-specific bowel gas distribution
::nsfa::no definite subphrenic free air
::nsln::non-specific small lymph nodes at the
::nslnc::non-specific small lymph nodes at the mediastinum
::nslup::minor nonspecific lung parenchymal change
::nst::no definite radiopaque stone in bilateral collecting system
::nsfcv::normal size of sulci, fissures, cisterns, and ventricles
::ntol::nearly total opacification of the left hemithorax
::ntor::nearly total opacification of the right hemithorax
::nty::nephrectomy

::o1::However, small osseous or soft tissue lesion(s) may not be detected by the plain radiography. Advise correlate with other imaging study, if clinically indicated.
::oa::osteoarthritis
::oa1::osteoarthritis with subtle or tiny marginal spur formation at
::oa2::osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the
::oac::osteoarthritic change
::oipl::old insult with parenchymal loss at 
::ok::osteosclerotic
::ol::osteolytic
::omt::osteomucosal thickening
::op::post-operative change
::opa::opacity
::opas::opacities
::opcl::post-operative change with surgical clip at
::opcls::post-operative change with surgical clips at
::opclsw::post-operative change with surgical clips at and metallic wires at sternum
::opsc::post-operative change with scar formation at
::opsm::post-operative change with suture material at
::opsp::s/p posterior decompression, and bil. transpedicle fixation and posterolateral fusion at the L1-5 level, and s/p interbody metallic fixation at the L2-L3-4 level with retension of drainage tube(s) in position
::opsw::post-operative change with metallic wires at sternum
::opvr::post-operative change with valvular replacement and metallic wires at sternum
::osp::osteopenia of the visible bony structures


::pal::placement of a left port-A catheter
::palj::placement of port-A catheter at left upper chest from left internal jugular vein
::pals::placement of port-A catheter at left upper chest from left subclavian vein
::par::placement of a right port-A catheter
::parj::placement of port-A catheter at right upper chest from right internal jugular vein
::pars::placement of port-A catheter at right upper chest from right subclavian vein
::pbg::prominent bowel gas
::pbt::peribronchial thickening
::pc::pelvic cavity
::pemf::pulmonary emphysema
::peg::placement of gastrostomy tube
::pesplanus::small calcaneal inclination angle (calcaneal pitch), suggestive of pes planus
::pfe::perifocal edema
::pfx::(previous) fracture
::pfxs::(previous) fractures
::phl::phlebolith
::phls::phleboliths in the pelvic cavity
::pig::placement of pigtail catheter

::ple::pleural effusion
::pler::right pleural effusion
::plel::left pleural effusion
::plp::pleural plaque
::plt::pleural thickening
::pnp::pneumoperitoneum
::pnt::pneumothorax
::posi::probably due to positioning factor
::pren::prostate enlargement
::prf::peripheral
::prg::presence of rectal gas
::prh::perihilar region
::prhi::perihilar infiltration
::prs::paraspinal
::prv::paravertebral
::psw::pelvic side wall


::r::right
::rcy::renal cyst
::rcyl::left renal cyst
::rcyr::right renal cyst
::rcysl::left renal cysts
::rcysr::right renal cysts

::rd::radiodense
::rl::radiolucent
::rlq::RLQ of the abdomen
::rlth::retrolithesis
::ro::radiopaque
::rst::renal stone
::ruq::RUQ of the abdomen

::sasd::subaromial-subdeltoid bursae
::sasf::subacromial spur formation
::sbo::small bowel obstruction
::sc::subcutaneous
::scano::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with R leg longer than L one about 5mm, suggest correlated with clinical manifestration. 
::sce::subcutaneous emphysema
::scf::supraclavicular fossa
::sin0::the paranasal sinuses are essentially clear
::sks::subchondral sclerosis
::sos::suboptimal study
::sosm::suboptimal study due to signigicant motion artifact 
::sosp::suboptimal study due to improper positioning
::sp::status post
::sph::suprahilar region
::spi::superimposed
::spon::spondylosis and degenerative change of the spine with marginal spur formation
::ssg::subsegmental
::ssx::subsegmental atelectasis
::stat::stationary as compared to previous similar study, suggest correlated with clinical manifestation
::std::soft tissue density
::sts::soft tissue swelling 

::sug::suggest
::sugc::suggest correlation with
::sugcc::suggest correlated with clinical manifestation
::sugcf::suggest clinical correlation and follow-up
::sugcfi::suggest clinical correlation and follow-up images if clinically indicated
::sugff::suggest clinical correlation and follow-up formal report
::sugmm::suggest correlate with mammography
::sugu::suggest clinical and ultrasonography correlation
::swg::placement of swan-ganz catheter via right jugular approach with its tip at RPA
::symb::symmetric sulci, fissures, cisterns and ventricles


::tae::Multiple coarse radiopaque nodular densities superimposed on liver, post TAE change
::taf::(focal) torn annulus fibrosus
::tao::tortuous aorta
::tbec::traction bronchiectasis
::tcao::tortuous and calcified aorta
::tenkh::placement of Tenckhoff catheter with its tip at lower abdomen
::tent::(However, this report is not yet confirmed by the attending radiologist.)
::tpsf::transpedicular screw fixation
::tr::placement of tracheostomy tube 
::tras::Status post tracheostomy
::trdl::tracheal deviation to the left
::trdr::tracheal deviation to the right
::tren::traction ensethophyte
::ts::thoracic spine
::tls::thoracolumbar spine
::tlspo::thoracolumbar spondylosis with marginal spur formation at multiple levels

::ubg::unremarkable bowel gas pattern

::vpsl::placement of left VP shunt
::vpsr::placement of right VP shunt

::wd::well-defined
::wsd::wedge shaped deformity

::jw::(YDH/Dr.JW)
::ycc::(YDH/Dr.YCC)



::ctap0::CT of the abdomen and pelvis without IV contrast enhancement shows:
::ctap1::CT of the abdomen and pelvis with IV contrast enhancement shows:
::ctap01::CT of the abdomen and pelvis without and with IV contrast enhancement shows:
::cta0::CT of the abdomen without IV contrast enhancement shows:
::cta1::CT of the abdomen with IV contrast enhancement shows:
::cta01::CT of the abdomen without and with IV contrast enhancement shows:
::ctb0::CT of the brain without IV contrast enhancement shows:
::ctb01::CT of the brain without and with IV contrast enhancement shows:
::ctbc01::CT of the brain and chest without and with IV contrast enhancement shows:
::ctbca01::CT of the brain, chest and abdomen without and with IV contrast enhancement shows: 
::ctbcap01::CT of the brain, chest, abdomen and pelvis without and with IV contrast enhancement shows: 
::ctc0::CT of the chest without IV contrast enhancement shows:
::ctc1::CT of the chest with IV contrast enhancement shows:
::ctc01::CT of the chest without and with IV contrast enhancement shows:
::ctca0::CT of the chest and abdomen without IV contrast enhancement shows:
::ctca1::CT of the chest and abdomen with IV contrast enhancement shows:
::ctca01::CT of the chest and abdomen without and with IV contrast enhancement shows:
::ctcap0::CT of the chest, abdomen and pelvis without IV contrast enhancement shows:
::ctcap1::CT of the chest, abdomen and pelvis with IV contrast enhancement shows:
::ctcap01::CT of the chest, abdomen and pelvis without and with IV contrast enhancement shows:
::cth0::CT of the head without IV contrast enhancement shows:
::cth01::CT of the head without and with IV contrast enhancement shows:
::ctext01::CT of bilateral lower extremities without and with IV contrast enhancement shows:


::mra0::MRI of the abdomen without IV contrast enhancement shows: 
::mra01::MRI of the abdomen without and with IV contrast enhancement shows:
::mrap01::MRI of the abdomen and pelvis without and with IV contrast enhancement shows: 
::mrb0::MRI of the brain without IV contrast enhancement shows: 
::mrb01::MRI of the brain without and with IV contrast enhancement shows: 
::mrcs0::MRI of the cervical spine without IV contrast enhancement shows:
::mrkl0::MRI of the left knee without IV contrast enhancement shows:
::mrkl01::MRI of the left knee without/with IV contrast enhancement shows:
::mrkr0::MRI of the right knee without IV contrast enhancement shows:
::mrkr01::MRI of the right knee without/with IV contrast enhancement shows:
::mrls0::MRI of the lumbar spine without IV contrast enhancement shows:
::mrn01::MR of the neck without and with IV contrast enhancement shows:
::mrp0::MRI of the pelvis without IV contrast enhancement shows: 
::mrp01::MRI of the pelvis without/with IV contrast enhancement shows:
::mrshl0::MRI of the left shoulder without IV contrast enhancement shows:
::mrshr0::MRI of the right shoulder without IV contrast enhancement shows:
::mrts0::MRI of the thoracic spine without IV contrast enhancement shows:
::mrts01::MRI of the thoracic spine without/with IV contrast enhancement shows: 
::mrtls0::MRI of the thoracolumbar spine without IV contrast enhancement shows:
::mrws::MRI of whole spine without/with IV contrast enhancement shows:



;CxR


::lal::left apical lung
::lbl::left basal lung
::lll::left lower lung
::lf::lung field
::lml::left middle lung
::lul::left upper lung
::ral::right apical lung
::rbl::right basal lung
::rll::right lower lung
::rml::right middle lung
::rul::right upper lung
::lv::Decreased bilateral lung volume
::copd::Hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible. 



;KUB and abdomen


::bl::bladder
::bltri::bladder trigone
::rep::renal pelvis
::rs::renal shadow
::rst::renal stone
::ub::urinary bladder
::ur::ureter
::ust::ureteral stone



::hydc::hydrocalyx
::hydn::hydronephrosis
::hydp::hydropelvis
::hydu::hydroureter
::hydun::hydroureteronephrosis
::pf::pelvic floor



::st::stone

::bcs::bilateral clear psoas shadows









;Ortho


::enthe::mild traction enthesophyte formation over the
::jsn::joint space narrowing
::sts::soft tissue swelling
::asts::adjacent soft tissue swelling
::perilos::periprosthetic loosening
::msf::marginal spur formation
::psf::posterior spur formation
::tsi::adjacent thecal sac indentation
::ccs::central canal stenosis
::acl::anterior cruciate ligament
::pcl::posterior cruciate ligament
::mcl::medial collaterla ligament
::fcl::fibular collateral ligament

::bnfn::bilateral neural foramina narrowing
::msart::magnetic susceptibility artifact(s) at


::retro::retrolisthesis
::slth::spondylolisthesis
::stra::straightening alignment



::sponly::spondylolysis of the pars interarticularis at the
::limv::limbus vertebra at the anterosuperior aspect(s) of
::isi::essential intact SI joint on both side
::sco::scoliosis


::c23::C2-3
::c24::C2-4
::c25::C2-5
::c26::C2-6
::c34::C3-4
::c35::C3-5
::c36::C3-6
::c37::C3-7
::c45::C4-5
::c46::C4-6
::c47::C4-7
::c41::C4-T1
::c56::C5-6
::c57::C5-7
::c51::C5-T1
::c67::C6-7
::c61::C6-T1
::c71::C7-T1
::l12::L1-2
::l13::L1-3
::l14::L1-4
::l23::L2-3
::l24::L2-4
::l25::L2-5
::l34::L3-4
::l35::L3-5
::l31::L3-S1
::l45::L4-5
::l41::L4-S1
::l51::L5-S1

::r1f::right thumb
::r2f::right index finger
::r3f::right middle finger
::r4f::right ring finger
::r5f::right little finger
::l1f::left thumb
::l2f::left index finger
::l3f::left middle finger
::l4f::left ring finger
::l5f::left little finger

::r1t::right big toe
::r2t::right 2nd toe
::r3t::right 3rd toe
::r4t::right 4th toe
::r5t::right little toe
::l1t::left big toe
::l2t::left 2nd toe
::l3t::left 3rd toe
::l4t::left 4th toe
::l5t::left little toe


::normalnf::no obvious evidence of neural foraminal narrowing on both sides


::acj::acromioclavicular joint
::ghj::glenohumeral joint
::hj::hip joint
::hjb::bilateral hip joints
::kj::knee joint
::kjb::bilateral knee joints
::pfj::patellofemoral joint
::pfjb::bilateral patellofemoral joints
::sij::sacroiliac joint
::sijb::bilateral sacroiliac joints
::scj::sacrococcygeal junction


::hipop::s/p hemiarthroplasty with postoperative changes at the 

::oahip::osteoarthritic change with small marginal spur formation at the 
::oasi::degenerative change of bilateral S-I joints
::mioa::mild osteoarthritis with subtle or tiny marginal spur formation at the


::vac::vacuum phenomenon
::sacra::L5 sacralization
::lsp::lateral subluxation or tilt of the patella
::oapa::osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the  






::pfim::focal cortical depression at the anterior aspect of right distal femoral supracondylar area, r/o patellofemoral impingement

::teis::subcortical sclerosis at the bil. Ischial tuberosities with traction enthesophyte formation.










;body

::ndaa::no definite abonrmality of gall bladder, pancreas, spleen, bilateral adrenals and both kidneys.
::lc::uneven hepatic surface with splenomegaly, suggestive of cirrhotic pattern.

;CT


::ctda::CT of abdomen with dynamic contrast enhancement (non-enhanced, arterial and portal venous phase):

;MR


::nlap::no definite enlarged LAPs
::ncirr::no definite evidence of liver cirrhosis. no splenomegaly. the portal vein is patent
::ebph::Enlarged prostate with widening of the central zone; compatible with BPH
::pans::pancreas
::bad::both adrenals
::bk::both kidneys

::spl::spleen
::seg::segment
::splm::splenomegaly
::cir::liver cirrhosis
::wdub::well-distended urinary bladder
::fl::focal lesion
::t1::T1
::t2::T2
::sg::signal
::int::intensity





::asc::ascites

::sbd::should be differentiated.




; 以下為罐頭區
;


::BXA::
(
CT guided biopsy of the left renal tumor is performed in prone position with the use of 19G coaxial guiding needle and 20 G automatic biopsy needle. 
-- Indication of biopsy: R/O RCC.
-- Size and location of the lesion: a renal tumor (about 5.7 cm) at the lower pole of the left kidney.
-- Totallength of the needle from skin to lesion: 3.3 cm
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 2
-- Hemorrhage: There was blood oozing from the coaxial needle since the first time we removed the stylet from the coaxial needle. Thus we injected some gelfoam particles from the coaxial needle into the biopsy tract after the biopsy.
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: supine or left decubitus.
-- There are total 2 tissue stripes and 4 imprint smears obtained for pathology and cytology studies. 
Suggest keep him complete bed rest for 4 hours in supine position, follow up his vital signs and possible complication (such as hematoma) closely.

Impression:
Left lower pole renal mass status post CT-guided biopsy. R/O RCC.
)


::BXAWGL::
(
History of endometrial cancer stabe Ib status post staging surgery, status post radiotherapy; recent CT showed para-aortic lymph nodes, R/O metastatic LAP.

NECT for the CT-guided biopsy of the left para-aortic lymph node:
1. the patient is in prone position.
2. the CT gantry is 0 degree.
3. 10cc, 2% xylocaine administration.
4. a 19G coaxial needle insertion via the left paraspinal approach through paraspinal muscles.
5. adjust the coaxial needle in the paraspinal muscles and a 20 biopsy gun was used.
6. 3 tissue cords, 2.0 cm, in different direction were taken and 3 cytology prints. 
7. minimal woozing from the coaxial needle; post-procedure CT scan show no definite hematoma.

Suggest close f/u the vital signs and possibility of complications (local hematoma).

left para-aortic lymph node, status post CT guided biopsy.
)



::bxl::   ;CT-guided lung biopsy
(
CT guided biopsy of the lung is performed in supine position with the use of a 19G coaxial guiding needle and a 20G semiautomatic biopsy needle.
-- Size and location of the lesion: 2.5*1.7 cm spiculated tumor at right upper lobe
-- Underlying lung condition: multiple lung nodules scattered at right lung
-- total length of the needle from skin to lesion: 5.9 cm
-- total length of the needle traversing lung: 0.3 cm
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 2
-- Pneumothorax: minimal
-- Hemorrhage: minimal
-- Hemothorax: nil
-- Hemoptysis: nil
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: prone
-- There are total 2 tissue stripes and 4 imprint smears obtained for pathology and cytology studies. Suggest complete bed rest for 4 hours in supine position and follow up chest radiography 6 hours later after biopsy.

Right upper lobe lung tumor status post CT guided biopsy. 
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


::BXPCL::
(
Abdomen CT without enhancement is performed for CT guide biopsy:
1.indication: Right renal tumor, r/o renal cell carcinoma, with renal vein invasion, lymphadenopathy, and suspicious lung metastasis. For CT guide biopsy of the right renal tumor.
2.Procedure:
 1).patient in the prone position.
 2).puncture site: right posterior lateral abdominal wall, under CT guidance.
 3).sterilize, draping, andlocal anesthesia at puncture site.
 4).19G 6cm coaxial needle from puncture site with tip in right renal tumor.
 5).20G 11cm automatic biopsy needle, inserted through the coaxial needle, thrust 2cm distal to the tip of coaxial needle, to take biopsy.
 6).3 fragments of tissue stripes and 4 slides of smear was obtained, please sent for pathology and cytology.
 7).remove the coaxial and automatic biopsy needles.
 8).sterilize and dressing the skin wound for biopsy.
 9).post-biopsy CT showed minimal hemorrhage.
3.the patient tolerate the procedure well without any complaint.
4.please bed rest and keep supine position for 4 hours.

Impression: 
a metastatic lung nodule in RUL s/p CT guided biopsy. Suggest follow up chest radiographs 6 hours after the procedure.
)



::CTAB::
(
CT of head and neck without/with contrast enhancement show:
1. Normal size of sulci, fissures, cisterns, and ventricles.
2. No abnormal attenuation of cerebrum, cerebellum, brain stem, and basal ganglion.
3. No definite abnormal enhancing lesion.
4. Intact cranial vault and skull base.

Reconstructed CT angiography shows:
1. Patent bilateral vertebral arteries. 
2. Small bilateral posterior communicating arteries.
CTP shows symmetric CBF and CBV. No definite MTT increase noted. 
)



::CTBca::
(
CT of brain without and with contrast enhancement shows:
1. Normal size of sulci, fissures, cisterns, and ventricles.
2. No obvious abnormal density or pathological enhancement detected at the brain, brainstem and cerebellum.
3. No obvious osteolytic or osteosclerotic lesions detected at the cranial vault.
4. No obvious organic lesions detected at the nasopharynx and paranasal sinus.
5. No obvious findings in orbits. 
6. The major vascular structures are enhancing well without obvious abnormality.

No obvious brain or cranial vault metastasis. 
)



::dbjpcl::
(
Percutaneous ureteroplasty was performed:
1.Indication: HIV infection. S-colon cancer S/P sigmoid colectomy. Persistent left hydronephrosis, suspected ureter stricture related, S/P Left PCN Insertion on 2009/7/30. For antegrade DBJ placement.
2.Antegrade pyelography showed total obstruction at left lower ureter, resulting in proximal hydroureter and hydronephrosis. S/P left PCN.
3.Percutaneous ureteroplasty was performed:
 1).placement of 8Fr long sheath from left renal pelvis to left ureter.
 2).navigating 0.035" guidewire through obstructed left lower ureter into U.B.
 3).PTA with 5mmx4cm balloon catheter(XT, Bard) to dilate the obstructed ureter, until full expansion of the balloon.
 4).DBJ with 7Fr 26cm catheter(Inlay optoma, Bard), from left renal pelvis to U.B.
 5).smooth internal urine drainage through the DBJ into U.B.
4.PCN with 8Fr pigtail catheter, with distal end looping in left renal pelvis. 
)


::dr::
(
Indication: 
Position: supine.
Anesthesia: local anesthesia with 10ml of 2% Xylocaine.
Procedure: a 8Fr 15cm pigtail catheter was inserted percutaneously under CT-guidance with tip in the abscess.
Specimen: yellowish sticky semisolid substance 10ml for culture.
Complication: nil immediately after this procedure.

Post-procedure care:
> persue result of studies.
> keep external drainage of the pigtail catheter.
)


::DRPCL::
(
Abdomen CT without enhancement was performed for CT guided abscess aspiration and showed
1.indication: End-stage renal disease status post renal transplantation (2009-06-18) with graft kidney at right iliac fossa, with small amount fluid collection with small air pockets at peri-graft renal region, R/O abscess. For CT guided aspiration.
2.patient in the supine position.
3.puncture site: right lower quadrant abdomen wall, under CT guide.
4.procedure:
 1).localize, sterilize, draping, and local anesthesia at puncture site.
 2).a 18G Chiba needle from puncture site with tip in right peri-graft kidney fluid collection.
 3).about 16cc yellowish mild turbid watery material were aspirated for culture, R/O infectious urinoma.
 4).remove the Chiba needle.
 5)sterilize and dressing the puncture site.
5.Post-procedure immediate CT scans showed no definite intraperitoneal hematoma or pneumoperitoneum or other complication. The fluid collection was collapsed with some tiny air pockets there.
6.the patient tolerated the procedure well without definite complaints.

Impression:
Peri-graft kidney fluid collection at right iliac fossa s/p CT-guided aspiration, R/O infectious urinoma.
)


::DRWGL::
( 
History of 

Indication: atrophic change of the left kidney with a small lobulated abscess; for drainage.
CT guided aspiration of the left perirenal abscess is performed in prone position with the use of 18G Chiba needle.
-- Indication and location: a 2.7x1.9x5.1cm irregular-shaped abscess is noted at left posterior perirenal space on the CT images (2009/06/20, BH chart number: N052657).
-- Totallength of the needle from skin to lesion: 7.4 cm
-- Hemorrhage: no
-- Vital signs after procedure: stable
-- There are total 12 ml of sticky greenish abscess tangled with some bloody content obtained for culture. No residual cystic component is noted at the post-procedure CT images.
-- Suggest complete bed rest for 4 hours in supine position.
Impression:Left perirenal abscess status post CT-guided aspiration.
)



::MRLSSPL::
(
MRI of the lumbosacral spine without IV contrast enhancement shows:
1. mild scoliosis and degenerative change of the lumbar spine with decreased disc spaces and dehydrated discs at multiple levels, more at L4-5 level.
2. grade 0-1 spondylolytic spondylolisthesis of the L4 on L5 with bony defect(s) at the bil. L4 pars interarticularis and posterior bulging-protruding disc(s) at the L4-5 level, causing mild central canal stenosis and relative narrowing of its bil. neural foramina; type 1 endplate change(s) and focal osteochondral lesion at the L4 lower endplate with susp. avulsion of the adjacent posterior longitudinal ligament (PLL). 
3. posterior bulging-protruding disc(s) at the L5-S1 level without obvious thecal sac indentation. 
4. no evidence of focal lesion in the visible spinal cord. 

mild degenerative scoliosis, lumbar spine; grade 0-1 spondylolytic spondylolisthesis, L4 on L5, and HIVD, L4-5 level, with spinal stenosis; r/o avulsed PLL, L4 lower endplate; slight HIVD, L5-S1 level. (GE27983/14-1)
)



::PCNA::
(
Abdomen CT without enhancement was performed for CT guide PCN and showed
1.indication: Right staghorn stone and right ureteral stricture, for drainage. S/P ESWL on 2009/7/27, urinoma at right retroperitoneum S/P pigtail catheter drainage. Remaining right renal stone with hydronephrosis, for PCN.
2.patient in the prone position.
3.puncture site: right lateral abdomen wall, under CT guide.
4.procedure:
 1).localize, sterilize, draping, and local anesthesia at puncture site.
 2).a 22G Chiba needle from puncture site with tip in the right renal pelvis.
 3).then a 8Fr 15cm pigtail catheter from the puncture site with tip looping in the right renal pelvis.
 4).remove the Chiba needle.
 5).about 50cc clear urine was aspirated, please sent for culture.
 6).the pigtail catheter was fixed at abdomen wall for external drainage.
 7)sterilize and dressing the puncture site.
5.Post-procedure immediate CT scans showed no definite intraperitoneal hematoma or pneumoperitoneum or other complication.
6.the patient tolerated the procedure well without definite complaints.
)


::PTAPCL::
(
PTA was performed:
1.indication: HCC rupture s/p left hepatic lobectomy, with recurrence s/p cadaveric liver transplantation on 2008/5/6 at China. S/P C/T. obstructive jaundice S/P PTCD on 2009/6/2. S/P PTA on 2009/7/14, 2009/7/16, 2009/8/18 and 2009/8/20. for series PTA.
2.Cholangiogram showed hepatic hilar and CBD anastomotic site mild re-stenosis, resulting in isolation and mild dilatation of bil IHDs, the CBD and duodenum were opacified. S/P PTCD with 8Fr pigtail catheter from left IHD to distal CBD.
3.PTA was performed with 8mmx4cm balloon catheter(XT, Bard) to dilate the stenotic site, until full expansion of the balloon. 
4.PTCD was performed with 8Fr pigtail catheter, from left IHD to distal CBD, with smooth internal and external bile drainage.
5.Please keep external drainage of the PTCD catheter.
6.Next PTA is arranged on 2009/9/16 AM on call.
)


::RFAA::
(
Abdomen CT without enhancement for CT guide biopsy and RFA for HCC.
1.indication: HCC(4cm) at S#8 of liver, S/P TAE(I) on 2008/6/23. S/P RFA(I) on 2008/6/27. Recurrent HCC S/P TAE(II) on 2009/6/5. Four recurrent HCCs at S#8(3.6cm), and at S#6(1.4cm, 1.8cm, 1.5cm), S/P TAE(III) on 2009/7/28. For Post-TAE CT guide RFA(II).
2.patient in the supine position.
3.Demerol 50mg i.m. and local anesthesia with xylocaine immediately before the RFA. another 25mg Demerol i.m. during RFA becasue of severe abdomen pain.
4.puncture site: right anterior lateral abdomen wall.
5.CT guide localization was performed, for the tumor(3.6cm) at S#8 of liver, with 22G Chiba needle, from puncture site, to inferior margin of the tumor.
6.CT guide RFA was performed with Cooltip needle (ACT-1530), paralleling the localization needle, under CT guide, for the tumor(3.6cm) at S#8 of liver, at three directions, four points, times:
 1).the 1st RFA, for the posterior inferior portion of the tumor, with needle tip near left lateral margin of the tumor, with baseline impedence 80ohm, impedence range during RFA 74~82ohm, power 128~132Watt, RFA time 12min, ending temperature 46 0C. pulse 0 time.
 
7.Post-RFA CT showed nearly total tumor necrosis with hyperdensity and small air pockets in the tumor treated by RFA, no definite intrahepatic or intraperitoneal hematoma, no definite pneumothorax, suggest F/U Abdomen CT one month later. 
8.Please bed rest for 4 hours.

Impression:
1.Post-TAE CT guide RFA(II), for the recurrent HCC(3.6cm) at S#8 of liver, was performed smoothyl today.
)


::RFAL::
(
History: external ear adenoid carcinoma s/p tumor excision 12 years ago; lung metastases with wedge resection of RUL, RLL, LUL in 2003 and LUL in 2005, LUL wedge resection and RLL lobectomy in 2008.
CT-guided RF ablation for RUL nodule is performed smoothly in supine position with the use of a 17G single electrode 2.0 cm exposure needle (Cool-Tip).
-- Location: 1.2 cm nodule at RUL.
-- Emphysema: yes
-- Total length of the needle traversing lung: 3 cm. 
-- first-session RFA (internal control): baseline impedence 136 ohm, impedence range during RFA 120~180 ohm, power maximum 79 watt, duration for 12 mins, ending temperature 43 degree C. 
-- second-session RFA (manual): baseline impedence 125 ohm, impedence range during RFA 115~220 ohm, duration for 3 mins, ending temperature 46 degree C. 
-- Total 15 minute RF therapy is given.
-- Pneumothorax:  no
-- Hemorrhage: mild, peritumoral and along the tract
-- Hemoptysis: no
-- Medication: Demeral 50mg in 0.9% saline 50mL IV drip slowly for pain control
-- Recommanded position after RFA: supine bed rest for 4 hours.
After completeing 15 minute RF treatment session, there is focal increased ground glass opacity around the lung nodule at the lateral aspect of the RUL. The gentleman stood well during and immediately after the procedure in CT room with stable vital signs.  Further evaluation with follow up chest CT is suggested for treatment response of the lesion. (TYY/YCC) 

Impression: 
RFA for a metastatic lung nodule in RUL. Suggest follow up chest radiographs 6 hours after the procedure.
)


::RFAWGL::
(
History of HCC s/p left lobectomy on 2003/1/6; suspect recurrent tumor at anterior S8 along surgical margin on prior CT and MRI.

US-guided and non-contrast CT-guided RFA was performed smoothly as procedures described as below:
1. Patient in the supine position.
2. Demerol 50mg was administrated iv drip and local anesthesia with xylocaine 2% 10ml was also given before procedure.
3. The 21G chiba needle was inserted by ultrasound guidance and two Cooltip RFA needles were inserted along the chiba needle; 5ml of pure alcohol was injected from the chiba needle.
4. The first RFA was performed for the anterior S3 tumor, with Cooltip RFA needles (SWCT15303), impedence range during RFA 57~89 ohm and 61-98 ohm, power 163-63 watt and 149-44 watt, time 10 min, ending temperature 68 and 63 degreeC.
5. The second course RFA was performed for the lateral portion of the S8 tumor, with the same RFA needle pulled backward, impedence range during RFA 70~93 ohm, power 106-84 watt, time 10 min, ending temperature 75 degree Celsius.
6. The second RFA for S2 tumor was not performed in this time due to the tolerance of the patient. Pain was obvious in this time due to the capsule and part of anterior abdominal wall involvement. 
6. Pain was obvious but bearable under the analgesia in use; no immediate complication noted on post-procedure CT scan. 
7. Suggest follow-up liver function.

Please note: after needle sterilization, the next RFA for the S2 tumor will be arranged in next Monday morning if the patient can be admitted on Sunday.

Impression:
recurrent HCC at anterior S8 of liver, s/p RFA(I).
)



::taehcc::
(
History of HBCV; Hepatocellular carcinoma status post left lobectomy, status post TAE
Angiographies of celiac trunk, common hepatic and right posterior segmental hepatic artery were smoothly performed from the right femoral approach using a 4Fr RC1, which show:
1. corkscrew-appearance of the hepatic arterial branches is present suggestive of cirrhosis.  
2. multiple nodular hypervascular stains in bilateral hepatic lobes with irregular neovascularity and global enhancement, compatible with HCCs.
3. portal veins are patent.
TACE was smoothly performed using the RC1(4Fr, Cook Inc.) plus a 2.7Fr microcatheter (Progreat; Terumo) with its tip at the S6-7 segmental artery with 20mL of emulsion (Adriamycin 40mg, Lipiodol 10cc) and Gelfoam fine particle 1 pack till the stasis of blood flow. No specific complaints immediately after this TAE.
2% xylocaine, 4 ml, was delivered for the discomfort and pain control before and after the TAE.
Suggest follow up liver function and re-arrange another TACE session 2 months later.

recurrent HCC in bilateral lobes, s/p TACE in right posterior segment
)
