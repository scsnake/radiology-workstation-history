﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         LCH
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


::bcp::blurring of bil. CP angles
::c::CXR shows:
::cn::CXR shows: Normal heart size, no evidence of penumothorax nor active lung lesion. No evidence of fracture. No evidence of pneumoperitoneum.
::cap::Chest AP film shows:
::cpa::Chest PA film shows:
::spicu::Status post endotracheal intubation, nasogastric tube insertion and placement of
::et::s/p endotracheal intubation.
::tras::tracheostomy
::ng::s/p nasogastric tube insertion.
::pla::placement of
::rjcvp::right jugular central venous line 
::ljcvp::left jugular central venous line
::rscvp::right subclavian central venous line
::lscvp::right subclavian central venous line
::icvp::central venous line in IVC
::portl::Port-A catheter at the left upper chest with its tip in SVC
::portr::Port-A catheter at the right upper chest with its tip in SVC
::sg::S/P placement of Swan-Ganz catheter via right jugular approach  with the tip located at RPA.
::dt::drainage tube
::cht::chest tube
::medi::mediastinum
::se::subcutaneous emphysema
::con::consolidation
::bcon::diffuse bilateral lung consolidation
::cw::chest wall
::wm::widening of mediastinum.
::pe::pleural effusion
::nall::no active lung lesion
::cbcp::clear bilateral costophrenic angles.
::nh::normal heart size.
::cm::cardiomegaly.
::aa::aortic aneurysm
::bh::borderline heart size.
::eh::elevated R't hemidiaphragmr
::tor::tortuous aorta
::torc::tortuous aorta with wall calcification
::akc::aortic knot calcification
::per::perihilar
::inf::infiltration
::ate::atelectasis
::emp::emphysematous change of both lungs.
::ggo::ground-glass opacity
::ido::ill-defined opacity at
::lf::lung field
::ih::increased hazziness at the 
::abg::air-bronchogram
::dlv::decreased bilateral lung volume
::plt::pleural thickening at the bilateral apical lungs
::ivm::increased bilateral vascular markings
::ai::alveolar infiltration
::rp::reticular pattern
::lll::left lower lung zone.
::lml::left mid lung zone.
::lul::left upper lung zone.
::lal::left apical lung zone.
::rll::right lower lung zone.
::rml::right mid lung zone.
::rul::right upper lung zone.
::ral::right apical lung zone.
::cal::calcification
::nod::nodule
::erd::elevation of right hemidiaphragm
::eld::elevation of left hemidiaphragm
::prh::prominent right hilar shadow
::plh::prominent left hilar shadow
::blf::both lung fields
::bll::bilateral lower lungs
::bul::bilateral upper lungs
::blcp::blurring of left costophrenic angle; r/o left pleural effusion.
::brcp::blurring of right costophrenic angle; r/o right pleural effusion.
::bbcp::blurring of bilateral costophrenic angles; r/o bilateral pleural effusion.
::brd::blurring of right diaphragmatic border
::bld::blurring of left diaphragmatic border
::nnn::Normal heart size. No active lung lesion. Clear bilateral costophrenic angles.
::hd::hemidiaphragm
::haz::increased haziness over bil. lung fields.
::nf::No definite evidence of fracture.
::cor::suggest correlation with clinical findings.
::nal::no active lung lesion with sharp bil. CP angles.
::car::cardiomegaly with tortuous aorta.
::ccp::clear bil. CP angles.
::osp::osteopenia of the visible bony structure.
::cvp::S/P CVP line inserted via right jugular approach with the tip located at proximal SVC.
::blc::Diffuse bilateral lung consolidation with possible pleural effusion.
::2t::s/p endotracheal intubation and S/P CVP insetion.
::comp::disease progression is noted as compared with prior study.
::comd::decreased bilateral lung opacity is noted as compared with prior study.
::com::no obvious interval change as compared with prior study.
::free::no evidence of free air.
::pneu::no evidence of pneumothorax.
::Rport::S/P Port-A insertion via R't subclavian approach with tip in SVC.
::Lport::S/P Port-A insertion via L't subclavian approach with tip in SVC.
::fc::fibrocalcified change over bil. lungs.
::dlc::diffused bil. lung consolidation.
::tra::S/P tracheostomy tube insertion.
::pace::S/P pacemaker placement via left subclavian approach with the tip located in the RARV.
::llc::low lung capacity on the R't side.
::ct::suggest correlation with CT findings.
::endo::s/p endotracheal tube intubation.
::portl::s/p Port-A insertion via L't subclavian approach with tip in SVC..
::ctube::s/p chest tube placement on the L't side.
::onl::on the L't side.
::onr::on the R't side.
::cabg::post-operative change with sternal wiring and surgical clips at the bil. perihilar region and on the heart shadow.
::portr::s/p Port-A insertion via R't subclavian approach with tip in SVC..
::lm::increased bil. lung markings.
::active::no definite active lung lesion.
::dtube::s/p drainage tube placement at
::deg::degeneration change of the T-spine with marginal spurs formation.
::sp::s/p 
::3t::s/p endotracheal tube, NG, and central line placement.
::central::s/p central line(s) placement.
::str::S/P sternostomy with sternal wiring.


;KUB and abdomen

::abd::abdomen
::ruq::RUQ of abdomen
::luq::LUQ of abdomen
::cbps::clear bilateral psoas shadows
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
::dbj::s/p DBJ placement 

;location and number

::bb::bilateral
::bbl::bilaterally
::at::at the
::mu::multiple
::sev::several
::prx::proximal
::dis::distal
::lat::lateral
::med::medial
::reg::regions
::id::ill-defined

;ortho

::ofx::old fracture
::fx::fracture
::cf::compression fracture
::scotl::scoliosis of thoracolumbar spine. 
::scol::scoliosis of lumbar spine. 
::stls::spondylosis of thoracolumbar spine with marginal spur formation.
::sls::spondylosis of lumbar spine with marginal spur formation.
::lus::lumbar spine
::ths::thoracic spine
::mf::metallic fixation at the 
::ls::Lumbar spine shows: Straightened aligment. No definite evidence of fracture. No obvious spur formation. Bil. SI joints are preserved.
::shoulders::'t shoulder shows: Non-displaced fracture at the L't mid-clavicular region. No obvious dislocation nor narrowing of the AC joint. Minimal spur formation at the the subacromion region. 
::merchant::R't Merchants view shows:Mild decreased joint space more on the medial facet of patellofemoral joint with minimal spur formation and degeneration change. No definite evidence of subluxation nor fracture could be identified. Mild soft tissue swelling on the medial aspect of R't knee joint.
::knees::Bil. knee shows:Osteopenia of the visible bony structure. No definite evidence of fracture. Periosteal reaction at the bil. proximal tibia. Spur formation at the bil. interchondylar eminence. Suspicious minimal chondrocalcinosis in the femorotibial joint on the L't side. Mild marginal spur formation.
::ne::No evidence of 
::spl::Grade 1 spondylolytic spondylolisthesis of L5 on S1 with mild narrowing of the L5-S1 neural foramen.  
::soft::soft tissue swelling 
::je::joint effusion 
::pelviss::Pelvis shows: Preserved bil. hip joints and SI joints, No definite evidence of fracture. Osteopenia of the visible bony structure. 
::spur::marginal spur formation 
::hv::hallux vulgus 
::cspine::Cervical spine shows: Acceptable aligment. Spondylolysis and marginal spur formation at the multiple levels with bony fragments at the C5-6 and C6-7 levels, r/o marginal spur fracture. Increased sclerosis and mild decreased vertebral height at the C5 vertebra, r/o compression fracture, suggest correlation with clinical findings. Calcification of the nuchal ligement. r/o OPLL from C2 to C5 level. Osteopenia of the visible bony structure. No abnormal soft tissue swelling at the retropharyngeal space.
::sl::grade 1 spondylolisthesis of L5 on S1 
::iud::s/p IUD placement.
::oa::osteoarthritis change 
::kill::however, small osseous or soft tissue lesion(s) may not be detected by the plain radiography. 
::pl::minimal periprosthetic lucency 
::arthrosis::facets arthrosis at the lower lumbar spine.
::phle::Phlebolithes at the pelvic cavity.
::ankles:: 't ankle shows:Preserved joint space of tibiotalar joint. No definite evidence of fracture. Minimal soft tissue swelling at the the posterior aspect of ankle joint and plantat region, suggest correlation with clinical findings. 
::vp::s/p veretbroplasty at the upper L-spine.
::oas::mild marginal spur formation and decreased joint space on medial femorotibial joint, compatible with osteoarthritis change.
::js::joint space
::te::traction enthesophyte  
::oaknee::Bil. knee shows: Osteoarthritis change with decreased joint space of bil. femorotibial joints more on the medial aspects. Marginal spur formation at the intercondylar proscess and lateral tibia plateu. Suspicious joint effusion at the R't suprapatellar region. Osteopenia of the visible bony structure. Traction enthesopathy at bil. patella. No definite evidence of fracture.



;general

::op::post-operative change with 
::opc::post-operative change with surgical clips at
::opw::post-operative change with metallic wires at the sternum
::sc::surgical clips at the
::mw::metallic wires at the sternum
::ac::advise clinical correlation and follow-up
::lap::lymphadenopathy
::ln::lymph nodes
::us::ultrasound findings
::asc::ascites
::nda::no definite abnormality of
::mul::multiple
::sug::suggest
::sugc::suggest correlation with
::den::density
::des::densities
::sio::superimposed on
::prom::prominent
::nos::non-specific
::ae::active extravasation
::pa::pseudoaneurysm
::pdt::probably due to
::vs::varying-sized

;body

::ndaa::no definite abonrmality of gall bladder, pancreas, spleen, bilateral adrenals and both kidneys.
::nlap::no definite paraaortic lymphadenopathy.
::nlapp::no definite enlarged lymphadenopathy at the bilateral paraaortic, pelvic and inguinal regions.
::lc::uneven hepatic surface with splenomegaly, suggestive of cirrhotic pattern.
::paa::para-aortic
::ing::inguinal
::duo::duodenum
::mes::mesentry
::cel::celiac trunk
::sma::superior mesenteric artery
::bso::bilateral salpingo-oophorectomy
::hys::hysterectomy
::cho::cholecystectomy
::hemal::peripheral centripetal enhancement pattern progressing to homogeneity

;CT

::ctap::CT of abdomen and pelvis without/with contrast enhancement shows:
::ctab::CT of abdomen without/with contrast enhancement shows:
::cta-::CT of abdomen without contrast enhancement shows:
::ctda::CT of abdomen with dynamic contrast enhancement (non-enhanced, arterial and portal venous phase):

;MR

::mrap::MRI of abdomen and pelvis without/with contrast enhancement shows: 
::mrab::MRI of abdomen without/with contrast enhancement shows: 
::lt1::hypointense on T1WI
::ht1::hyperintense on T1WI
::lt2::hypointense on T2WI
::ht2::hyperintense on T2WI


; 以下為罐頭區
;

::MRA::
(
MRA of the lower abdomen, pelvis and bil. lower limbs without/with contrast enhancement shows: 
)