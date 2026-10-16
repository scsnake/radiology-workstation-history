﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         HYC
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

;CxR

::nlcxr::Chest PA shows normal heart size and no definite lung lesion.
::nc::normal heart size.
::cbl::essential clear bilateral lung field.
::sp::status post
::icutube::placement of endotracheal tube, NG tube, and central venous catheter.
::trach::placement of tracheostomy tube.
::endo::Placement of an endotracheal tube.
::ng::placement of a NG tube. 
::gg::placement of a gastric tube. 
::cvp::placement of a central venous catheter. 
::rjcvp::S/P right jugular CVP sertion
::ljcvp::S/P left jugular CVP sertion
::rscvp::S/P right subclavian CVP insertion
::lscvp::S/P left subclavian CVP insertion
::icvp::S/P central venous line in IVC
::portl::S/P Port-A catheter at the left upper chest with its tip in SVC
::portr::S/P Port-A catheter at the right upper chest with its tip in SVC
::swan::S/P placement of swan-ganz catheter via right jugular approach with the tip located at RPA
::iabp::There is placement of an IABP with the tip near aortic arch
::dt::drainage tube
::cht::chest tube
::mdt::mediastinal drainage tube
::ins::insertion
::cvr::cardiac valve replacement
::wire::placement of metalic sternal wires. 
::ecmo::Placement of ECMO tubing. 
::ph::prominant hilar shadow. 
::ilm::Increased lung markings, bilaterally. 
::medi::mediastinum
::hemi::hemidiaphragm
::cam::Cardiomegaly
::co::bilateral lung consolidation.
::coo::There are bilateral lung consolidation.
::nh::normal heart size.
::bh::Borderline heart size.
::ao::Tortuous aorta with calcified aortic knob.
::aoo::calcified aortic knob. 
::tor::tortuous aorta
::ath::Atherosclerosis with wall calcification of the aorta.
::ctc:: CT of chest with/without contrast is read and as compared to prior study dated. The study shows:
::ctc0:: CT of chest with/without contrast is read. The study shows:
::detl::degenerative change with marginal spur formation of the thoracolumbar spines.

::cp::costophrenic angles
::cps::Bilateral sharp costophrenic angles.
::cpb::Blunting of bilateral costophrenic angles.
::cpbl::Blurring of left CP angle, r/o pleural effusion.
::cpbr::Blurring of right CP angle, r/o pleural effusion.
::pe::pleural effusion.
::pel::left pleural effusion.
::per::right pleural effusion.
::apr::Right apical pleural thickening
::apl::Left apical pleural thickening
::elev::Elavation of right hemidiaphragm
::cpan::Chest PA film shows relatively clear of bilateral lungs, normal heart size. No definite abnormal shadow. Advise clinical correlation. 
::cpa::Chest PA film shows: 
::cap::Chest AP film shows:
::pneumot::pneumothorax
::pneumop::pneumoperitoneum
::se::subcutaneous emphysema
::rcw::right chest wall
::lcw::left chest wall

::perih::perihilar region

::lll::left lower lung
::lml::left mid lung
::lul::left upper lung
::lal::left apical lung
::rll::right lower lung
::rml::right mid lung
::rul::right upper lung
::ral::right apical lung
::blf::both lung fields
::bapl::bilateral apical lungs
::bal::bilateral basal lungs
::bll::bilateral lower lungs
::lf::lung field
::r::right
::l::left
::bil::bilateral



::lv::bilateral low lung volume.
::cl::bilateral clear lung fields
::nall::no active lung lesion
::con::consolidation
::inf::infiltration
::ate::atelectasis
::brone::bronchiectasis
::opc::opacity
::opac::opacification
::idlo::Ill-defined lung opacity noted bilaterally
::ido::ill-defined opacity
::nod::nodule
::ns::nodular shadow
::inc::increased
::de::decreased
::ha::hazziness
::abg::air-bronchogram
::fc::fibrocalcified lesions
::copd::There is hyperinflation with chronic infiltration noted over bilateral lungs, COPD is compatible. 
::cinf::Chronic infiltration is noted over bilateral lungs. 

::mw::mediastinum widening
::hs:: hilar shadow
::bhs::Enlarged bilateral hilar shadows
::rhs::prominent right hilar shadow
::lhs::prominent left hilar shadow
::emp::emphysematous change of both lungs
::ggo::ground-glass opacity
::ido::ill-defined opacity at
::sw::Post-operative change with metallic wires at sternum.

::lm::lung markings
::nlm::Bilateral symmetric lung markings
::pt::pleural thickening
::ai::alveolar infiltration
::rp::reticular pattern
::cw::chest wall

::brd::blurring of right diaphragmatic border
::bld::blurring of left diaphragmatic border
::fu::suggest clinical correlation and followup.

;KUB and abdomen

::KUB::KUB shows:
::KUBN::KUB shows bilateral clear psoas shadow, no obvious radiopaque stone. The bowel gas is normal.
::KSR::KUB shows some radiopaque spots superimposed on right renal shadow, r/o renal stones. 
::KSL::KUB shows some radiopauqe spots superimposed on left renal shadow, r/o renal stones. 
::KSB::KUB shows some radiopaque spots superimposed on bilateral renal shadows, r/o renal stones. 
::abd::abdomen
::ruq::RUQ of abdomen
::luq::LUQ of abdomen
::ps::bilateral clear psoas shadows
::unbo::unremarkable bowel loops
::npp::no pneumoperitoneum
::ro::radiopaque
::phl::phlebolith
::phls::phlebolithes
::ure::ureter
::ub::urinary bladder
::gb::gall bladder
::urs::ureteral stone
::ile::ileus
::nds::No definite radiopaque stone in bilateral collecting system
::rss::renal stone
::rs::renal shodow
::pc::pelvic cavity
::pf::pelvic floor
::phe::Phlebolithes at pelvic cavity.
::lc::contracture of liver and splenomegaly, suggestive of cirrhosis.
::lcc::surgical clips at RUQ of the abdomen, compatible with post cholecystectomy change.
::sa::Standing abdomen shows:
::san::Standing abdomen shows no obvious intra-abdominal free air, the bowel gas is normal.
::sc::Suboptimal bowel preparation which might obscure subtle lesion.
::gt::status post gastric tube insertion.


;location and number


::bb::bilateral
::bbl::bilaterally
::mu::multiple
::sev::several
::px::proximal
::dis::distal
::lat::lateral
::med::medial

;ortho

::ofx::old fracture
::cf::compression fracture
::ac::advise clinical correlation and follow up
::stw::soft tissue swelling
::perilos::periprosthetic loosening
::cast::status post external cast application; the detail of bones is obliterated by artifacts of the cast. 

::retro::retrolisthesis
::spond::spondylolisthesis
::stra::straightening alignment
::ls::L-spine
::ts::T-spine
::cs::C-spine
::dj::spondylosis and degenerative change of the spine with marginal spur formation
::sponly::spondylolysis of the pars interarticularis at the
::limv::limbus vertebra at the anterosuperior aspect(s) of
::isi::essential intact SI joint on both side
::sco::scoliosis
::os:: osteopenia of the visible bony structure
::alig::alignment
::l12::L1-2
::l23::L2-3
::l34::L3-4
::l45::L4-5
::l51::L5-S1
::sh::degenerative change of the shoulder joints. 


::normalnf::no obvious evidence of neural foraminal narrowing on both sides
::nanf::bilateral neural foraminal narrowing at multiple levels due to cervical spondylosis

::scj::sacrococcygeal junction
::acj::acromioclavicular joint
::ghj::glenohumeral joint
::hj::hip joint
::hjs::hip joints
::sij::sacroiliac joint
::sijs::sacroiliac joints
::pfj::patellofemoral joint
::kj::knee joint
::kjs::knee joints
::calb::calcaneus
::pha::phalanx

::oa::oateoarthritis
::spu::marginal spur formation
::ss::subchondral sclerosis
::dejs::decreased joint space
::te::traction enthesophyte formation

::hipop::s/p hemiarthroplasty with postoperative changes at the 

::oahip::osteoarthritic change with small marginal spur formation at the 
::oasi::degenerative change of bilateral S-I joints
::minioa::minimal osteoarthritis with subtle or tiny marginal spur formation at the
::oak::osteoarthritis with marginal spur formation at the

::vac::vacuum phenomenon
::sacra::L5 sacralization
::lsp::lateral subluxation or tilt of the patella
::oapa::osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the  


::downac::lateral downsloped acromion
::ahd::acromiohumeral distance

::nfx::no obvious evidence of fracture nor dislocation.
::smal::However, small osseous or soft tissue lesion(s) may not be detected by the plain radiography

::pfim::focal cortical depression at the anterior aspect of right distal femoral supracondylar area, r/o patellofemoral impingement

::teis::subcortical sclerosis at the bil. Ischial tuberosities with traction enthesophyte formation.


;Neuro
::si::Thickened mucosa was noted in bilateral maxillary sinuses, sinusitis should be R/O.
::sn::The paranasal sinuses are essentially clear. No abnormal bone destruction.
::sts::adjacent soft tissue swelling, r/o soft tissue inflammation or infection. 
::w::Water's view shows no obvious mucosal thickening of the paranasal sinuses. 
::mas::Well pneumatization of bilateral mastoid bone.
::masr::Decreased pneumatization of left mastoid air cells with sclerotic change, chronic mastoiditis is considered. 
::masl::Decreased pneumatization of right mastoid air cells with sclerotic change, chronic mastoiditis is considered. 


;general

::op::Post-operative change with surgical clips at
::sw::Post-operative change with metallic wires at sternum
::popsw::Post-operative change with sternal wiring and surgical clips at
::sc::surgical clips
::ac::advise clinical correlation and follow-up
::lap::lymphadenopathy
::us::ultrasound findings
::asc::ascites
::nda::no definite abnormality of
::mul::multiple
::sug::suggest
::sugc::suggest correlation with
::den::density
::des::densities
::supim::superimposed on
::prom::prominent
::fr::fracture
::frs::fractures
::dec::decreased
::os::opaque shadow
::sup::superimposed
::infe::inferior
::supe::superior
::st::stationary as compared to previous study, suggest correlated with clinical manifestation.
::suggest::Suggest correlation with the image findings and report of abdomen and pelvic CT study.
 
;body

::ndaa::no definite abonrmality of gall bladder, pancreas, spleen, bilateral adrenals and both kidneys.
::lc::uneven hepatic surface with splenomegaly, suggestive of cirrhotic pattern.
::tael::Radiopaque densities superimposed over upper abdomen; compatible with previous TAE effect with lipiodol accumulation


;CT

::ctap::CT of abdomen and pelvis without/with contrast enhancement shows:
::ctda::CT of abdomen with dynamic contrast enhancement (non-enhanced, arterial and portal venous phase):
::ctcwi::Chest CT without/with contrast enhancement shows:
::ctcwo::Chest CT without contrast enhancement shows:
::ctco::**Please correlation with the imaging finding and report of
::recon::s/p recent injection of contrast medium with enhancement of the GB, bilateral urinary tracts and urinary bladder

::nlb::there are no definite focal lesions in the basal lungs and bone window settings


;MR

::mrcap::MRI of abdomen and pelvis without/with contrast enhancement shows:
::mrca::MRI of abdomen without/with contrast enhancement shows:
::mrab::MRI of abdomen without contrast enhancement shows:
::nfl::no definite evidence of focal lesion in the 
::nlap::no definite enlarged LAPs
::ncirr::no definite evidence of liver cirrhosis. no splenomegaly. the portal vein is patent
::ebph::Enlarged prostate with widening of the central zone; compatible with BPH
::pans::pancreas
::bad::both adrenals
::bk::both kidneys
::rk::right kidney
::lk::left kidney
::spl::spleen
::seg::segment
::hydro::hydronephrosis
::splm::splenomegaly
::cir::liver cirrhosis
::wdub::well-distended urinary bladder
::fl::focal lesion
::fd::filling defect
::t1::T1
::t2::T2
::sg::signal
::int::intensity
::enh::enhancement


; 以下為罐頭區
;

::