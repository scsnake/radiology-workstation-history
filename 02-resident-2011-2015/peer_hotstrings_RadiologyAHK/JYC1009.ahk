﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         JYC
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

::jw::(JYC/JW)
::ycc::(JYC/YCC)
::wjl::(JYC/WJL)
::ck::for checkup.
::web1000::CT reconstruction will be performed and uploaded to web1000. Thank you for consultation.
::rr::We will evaluate the patient. Please sent chart to 東址 CT room before 4PM today to arrange the schedule.
::rr1::Please correct the PTT to normal range (2010-10-30, PTT 46.0 sec) and keep PT INR< 1.5, platelet >80K.

::por::This film is performed at POR for post-operative follow up. decreased bilateral lung volume. placement of a right Port-A catheter. suggest clinical correlation. 

::bonemeta::diffuse varying-sized nodular foci of abnormal signal and enhancement scattered at the whole spine and bilateral iliac bones; some of these lesions reveal dark signal on T1-weighted images and hyperdensities on prior CT images (2009-04-27), suggesting sclerotic metastases.
::intevalchange::no significant interval change as compared with prior study at 2009-03-03.
::cast::status post external cast application; the detail of bones is obliterated by artifacts of the cast. 
::hematopoie::heterogeneous SI diffusely at the marrow of visible spine, sacrum and bil. pelvic bones, most likely due to hematopoietic tissue(s)
::osteochondrallesion::multifocal osteochondral foci at the upper endplates of T12 and upper lumbar levels.

::cfx::(previous) compression fracture(s) and wedge deformity or decrease in height of the
::lls::lower lumbar levels
::aoar::atherosclerotic change of the abdominal aorta and its bifurcation
::onv::(previous) compression fracture(s) and wedge deformity or decrease in height of the vertebral bodies at the L1 vertebra with intravertebral vacuum phenomenon(a), r/o osteonecrosis
::kss::kyphoscoliosis of the spine
::ovb::osteopenia of the visible bony structures
::tloa::thoracolumbar spondylosis with marginal spur formation at multiple levels
::oa::osteoarthritis
::oac::osteoarthritic change
::msar::suboptimal study due to magnetic susceptibility artifact in the

::1w::T1WI
::2w::T2WI
::3D::3D reconstruction was sent to web1000. Please refer to the images. Thanks for your consultation.
::acl::anterior cruciate ligament
::aco::ascending colon
::ant::anterior
::ao::aorta
::ata::anterior tibial artery
::b::bilateral
::bd::bulging disc(s)
::bm::bone marrow
::bexd::bulging-extruding disc(s)
::bpd::bulging-protruding disc(s)
::bul::bulging
::c12::C1-2 level(s)
::c13::C1-2 and C2-3 levels
::c14::C1-2, C2-3 and C3-4 levels
::c15::C1-2, C2-3, C3-4 and C4-5 levels
::c16::C1-2, C2-3, C3-4, C4-5 and C5-6 levels
::c17::C1-2, C2-3, C3-4, C4-5, C5-6 and C6-7 levels
::c23::C2-3 level(s)
::c24::C2-3 and C3-4 levels
::c25::C2-3, C3-4 and C4-5 levels
::c26::C2-3, C3-4, C4-5 and C5-6 levels
::c27::C2-3, C3-4, C4-5, C5-6 and C6-7 levels
::c34::C3-4 level(s)
::c35::C3-4 and C4-5 levels
::c36::C3-4, C4-5 and C5-6 levels
::c37::C3-4, C4-5, C5-6 and C6-7 levels
::c45::C4-5 level(s)
::c46::C4-5 and C5-6 levels
::c47::C4-5, C5-6 and C6-7 levels
::c56::C5-6 level(s)
::c57::C5-6 and C6-7 levels
::c67::C6-7 level(s)
::c71::C7-T1 level(s)
::cbdi::concentric bulging disc(s)
::cbpd::concentric bulging-protruding disc(s)
::cfa::common femoral arteries
::cia::common iliac arteries
::co::Complain of
::col::collateral(s)
::con::concentric
::cs::cervical spine
::cts::cervicothoracic spine
::cw::compatible with
::d::disc(s)
::dco::descending colon
::dd::dehydrated disc(s)
::ddd::degenerative disc disease
::de::decreased
::deg::degenerative change of the 
::degl::degenerative change of the lumbar spine with marginal spur formation and dehydrated discs at multiple levels
::dis::distal
::dpa::dorsalis pedis artery
::dsd::degenerative spinal and disc disease
::dsn::disc space narrowing
::dspon01::grade 0-1 degenerative spondylolithesis of
::dspon12::grade 1-2 degenerative spondylolithesis of
::dspon23::grade 2-3 degenerative spondylolithesis of
::dspon34::grade 3-4 degenerative spondylolithesis of
::ec::eccentric
::ed::extruding disc(s)
::eia::external iliac arteries
::ep1::type 1 endplate change at
::ep2::type 2 endplate change at
::epd::eccentric protruding disc(s)
::epm::mixed type endplate change at
::ex::extruding
::fa::facet arthroses
::fcl::fibulat collateral ligament
::fhbc::family history of breast cancer (mother, elder younger sister, paternal maternal aunt, grandmother)
::fna::fine needle aspiration (FNA)
::fta::(focal) torn annulus fibrosus
::fx::fracture
::gb::gallbladder
::gt::a gastric tube
::hlf::hypertrophic ligamentum flava
::hsi::high signal intensity
::hx::History of
::inc::increased
::l::left
::l12::L1-2 level(s)
::l13::L1-2 and L2-3 level(s)
::l14::L1-2, L2-3, and L3-4 level(s)
::l15::L1-2, L2-3, L3-4 and L4-5 level(s)
::l11::L1-2, L2-3, L3-4, L4-5 and L5-S1level(s) 
::l23::L2-3 level(s)
::l24::L2-3 and L3-4 level(s)
::l25::L2-3, L3-4, and L4-5 level(s)
::l21::L2-3, L3-4, L4-5 and L5-S1 level(s)
::l34::L3-4 level(s)
::l35::L3-4 and L4-5 level(s)
::l31::L3-4, L4-5 and L5-S1 level(s)
::l45::L4-5 level(s)
::l41::L4-5 and L5-S1 level(s)
::l51::L5-S1 level(s)
::lat::lateral
::liga::ligament
::lm::lateral meniscus
::ln::lymph node
::lns::lymph nodes
::lor::lordotic curve
::ls::lumbar spine
::lls::lower lumbar levels
::lsi::low signal intensity
::lss::lumbosacral spine
::mcl::medial collateral ligament
::med::medial
::mm::medial meniscus
::mlm::medial and lateral menisci
::mf::multifocal
::mul::multiple

::nf::neural foramen
::nfn::neural foraminal narrowing
::nor::no evidence of focal lesion in the
::nocor::no evidence of focal lesion in the visible spinal cord
::nosij::no evidence of focal lesion in bilateral sacroiliac joint(s)
::nrc::nerve root(s) compression
::obs::on both sides
::ols::on the left side
::ors::on the right side
::opll::occification of the posterior longitudinal ligament (OPLL)
::paod::peripheral arterial occlusive disease
::pbpd::posterior bulging-protruding disc(s)
::pbd::posterior bulging disc(s)
::pcbpd::posterior concentric bulging-protruding disc(s)
::pcl::posterior cruciate ligament
::pd::protruding disc(s)
::pe::pleural effusion
::bpe::bilateral pleural effusion
::bbpe::bilateral basal pleural effusion
::rpe::right pleural effusion
::rbpe::right basal pleural effusion
::lpe::left pleural effusion
::lbpe::left basal pleural effusion
::pco::partial collapse of
::pexd::protruding-extruding disc(s)
::pla::plantar artery
::pll::posterior longitudinal ligament
::poa::popliteal artery
::pop::post-operative change
::pos::post-operative change with sutures at
::poc::post-operative change with clips at
::pocs::post-operative change with clips and sutures at
::posc::post-operative change with clips and sutures at
::pow::Post-operative change with sternal wiring
::powc::Post-operative change with sternal wiring, and clips at
::powsc::Post-operative change with sternal wiring, sutures and clips at
::post::posterior
::ppd::posterior protruding disc(s)
::pro::protruding
::pra::peroneal artery
::pta::posterior tibial artery
::pul::pulmonary
::px::proximal
::r::right
::sa::susceptibility artifact
::sci::spinal cord indentation
::sco::scoliosis
::scor::scoliosis to right
::scol::scoliosis to left
::scop::mild scoliosis may be due to positioning factor.
::sfa::superficial femoral artery
::si::signal intensity
::sig::sigmoid
::sij::sacroiliac joint(s)
::sp::status post
::ss::spinal spondylosis with spur formation
::sspon01::grade 0-1 spondylolytic spondylolithesis of
::sspon12::grade 1-2 spondylolytic spondylolithesis of
::sspon23::grade 2-3 spondylolytic spondylolithesis of
::sspon34::grade 3-4 spondylolytic spondylolithesis of
::stir::STIR images
::sq::subcutaneous
::sus::suspicious
::suc::suggest clinical correlation
::sfu::Suggest clinical correlation and follow up
::suo::suggective of
::t12::T1-2
::t23::T2-3
::t34::T3-4
::t45::T4-5
::t56::T5-6
::t67::T6-7
::t78::T7-8
::t89::T8-9
::t90::T9-10
::t01::T10-11
::t02::T11-12
::t21::T12-L1
::tco::transverse colon
::tfc::triangular fibrocartilage
::tfcc::triangular fibrocartilage complex
::tls::thoracolumbar spine
::thr::total hip replacement
::ts::thoracic spine
::tsi::adjacent thecal sac indentation
::vacuum::intradiscal vacuum phenomenon
::vb::vertebral bodies
::w::with
::wo::without
::woc::without IV contrast enhancement shows:
::wocc::without IV contrast enhancement as compared with prior CT on shows:
::wc::with IV contrast enhancement shows:
::wcc::with IV contrast enhancement as compared with prior CT on shows:
::wwc::without/with IV contrast enhancement shows:
::wwcc::without/with IV contrast enhancement as compared with prior CT on shows:


;CxR

::ap::Chest AP shows
::cl::Chest lateral view shows
::pa::Chest PA shows
::p0::Chest PA/AP shows normal heart size. no definite lung lesion.
::p00::Chest PA/AP shows normal heart size. aortic wall calcification. no definite lung lesion.
::p1::Chest PA/AP shows borderline heart size. no definite lung lesion.
::p11::Chest PA/AP shows borderline heart size. no definite lung lesion.
::p2::Chest PA/AP shows cardiomegaly. no definite lung lesion.
::p22::Chest PA/AP shows cardiomegaly. aortic wall calcification. no definite lung lesion.
::icu::Chest PA/AP shows cardiomegaly. bilateral diffuse consolidation.
::icu3::Chest AP shows cardiomegaly. bilateral diffuse consolidation. placement of an endotracheal tube, a NG tube, a central venous catheter.


::png::placement of a NG tube
::pet::placement of an endotracheal tube
::pen::placement of an endotracheal tube, a NG tube
::ptn::placement of a tracheostomy tube, a NG tube
::pnc::placement of a NG tube, a central venous catheter
::penc::placement of an endotracheal tube, a NG tube, a central venous catheter
::ptnc::placement of a tracheostomy tube, a NG tube, a central venous catheter
::ppal::placement of a left Port-A catheter
::ppar::placement of a right Port-A catheter
::picc::placement of a peripherally inserted central catheter

::pl::placement of 
::et::an endotracheal tube
::ta::a tracheostomy tube
::ng::a NG tube
::ctl::a chest tube at left side
::ctr::a chest tube at right side
::cvr::cardiac valve replacement
::cvp::a central venous catheter
::cvprj::a right jugular central venous catheter
::cvplj::a left jugular central venous catheter
::cvprn::a right neck central venous catheter
::cvpln::a left neck central venous catheter
::cvprs::a right subclavian central venous catheter
::cvpls::a left subclavian central venous catheter
::db::a double lumen catheter
::dbrj::a right jugular double lumen catheter
::dblj::a left jugular double lumen catheter
::dbrs::a right subclavian double lumen catheter
::dbls::a left subclavian double lumen catheter
::dt::a drainage tube
::dts::drainage tubes
::pal::a left Port-A catheter
::par::a right Port-A catheter
::sgz::placement of a Swan-Ganz catheter
::ecmo::ECMO
::iabp::IABP

::wire::placement of multiple sternal wires
::msr::status post right mastectomy
::msl::status post left mastectomy
::pmsr::status post right partial mastectomy
::pmsl::status post left partial mastectomy

::medi::mediastinum
::hmr::right hemidiaphragm
::hml::left hemidiaphragm
::ehmr::elevated right hemidiaphragm
::ehml::elevated left hemidiaphragm
::ohmr::obscured right hemidiaphragm
::ohml::obscured left hemidiaphragm
::htr::right hemithorax
::htl::left hemithorax
::nh::normal heart size
::bh::borderline heart size
::car::cardiomegaly
::eh::enlarged heart shadow
::tor::tortuous aorta
::torc::tortuous aorta with wall calcification
::akc::aortic knob calcification
::ac::aortic wall calcification

::cpa::costophrenic angle
::bcpa::bilateral costophrenic angles
::cpar::right lateral costophrenic angle
::cpal::left lateral costophrenic angle
::cpn::sharp bilateral lateral costophrenic angles
::cpbb::blunted bilateral lateral costophrenic angles
::cpbl::blunted left lateral costophrenic angle
::cpbr::blunted right lateral costophrenic angle
::aptb::bilateral apical pleural thickening
::aptr::right apical pleural thickening
::aptl::left apical pleural thickening
::pneut::pneumothorax
::pneup::pneumoperitoneum
::plt::bilateral apical pleural thickening

::phr::perihilar region
::rulz::right upper lung zone
::rmlz::right middle lung zone
::rllz::right lower lung zone
::lulz::left upper lung zone
::lmlz::left middle lung zone
::lllz::left lower lung zone
::bulz::bilateral upper lung zones
::bmlz::bilateral middle lung zones
::bllz::bilateral lower lung zones
::lal::left apical lung
::ral::right apical lung
::bal::bilateral apical lungs
::rbl::right basal lung
::lbl::left basal lung
::bbl::bilateral basal lungs
::bll::bilateral lower lungs
::blf::both lung fields
::bl::both lungs
::lf::lung field
::dlv::decreased bilateral lung volume
::clearl::Clear of both lungs

::abg::air-bronchogram
::afl::air-fluid level
::ate::atelectasis
::bri::bronchiectasis
::bdc::bilateral diffuse consolidation
::cos::consolidation
::fc::fibrocalcified lesions
::ha::haziness
::idpc::ill-defined patchy consolidations
::iha::increased haziness
::nall::no active lung lesion
::ndll::no definite lung lesion
::nod::nodule
::np::non-specific
::pc::patchy consolidations
::ns::nodular shadows
::ps::patchy shadows
::po::patchy opacities
::npo::nodular and patchy opacities
::npb::two small nodular shadows at bilateral lower lung zone, r/o nipples shadows.
::npr::a small nodular shadow at right lower lung zone, r/o nipple shadow.
::npl::a small nodular shadow at left lower lung zone, r/o nipple shadow.
::pmf::progressive massive fibrosis
::sbat::subsegmetal atelectasis

::copd::Hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible. 
::cinf::Chronic infiltration is noted over bilateral lungs. 


::mw::mediastinal widening
::bhs::prominent bilateral hilar shadows
::ebhs::enlarged bilateral hilar shadows
::rhs::prominent right hilar shadow
::lhs::prominent left hilar shadow
::emp::emphysematous change of both lungs
::ggo::ground-glass opacity (GGO)
::pggo::patchy ground-glass opacity (GGO)
::ido::ill-defined opacity at

::pt::pleural thickening at the bilateral apical lungs
::ptr::pleural thickening at the right apical lung
::ptl::pleural thickening at the left apical lung
::lm::increased bilateral lung markings
::ai::alveolar infiltration
::rp::reticular pattern
::sqem::subcutaneous emphysema

::brd::blurring of right diaphragmatic border
::bld::blurring of left diaphragmatic border


::dbm::diffuse sclerotic bone change of the visible bony structure consistent with bone metastases
::nuss::funnel chest status post Nuss procedure
::stat::stationary as compared with prior study

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
::urs::ureteral stone
::ile::ileus
::nds::No definite radiopaque stone in bilateral collecting system
::rss::renal stone
::rs::renal shodow
::pf::pelvic floor

;location and number

::b::bilateral
::sev::several
::px::proximal
::dis::distal
::lat::lateral
::med::medial
::sup::superior
::inf::inferior


;angio

::floppy::microguidewire (Floppy 0.014", 205cm)
::renegade::microcatheter (Renegade 130cm 2.5Fr),
::progreat::microcatheter (Progreat 110cm 2.7Fr),
::rc1::4Fr RC1
::rlg::4Fr RLG
::rh::4Fr RH
::rimm::4Fr RIM
::h1::5Fr H1
::sim2::5Fr SIM2

::celiac::celiac trunk
::cha::common hepatic artery
::pha::proper hepatic artery
::rha::right hepatic artery
::lha::left hepatic artery
::ipa::inferior phrenic artery
::ripa::right inferior phrenic artery
::sma::superior mesentary artery
::ima::inferior mesentary artery
::rga::right gastric artery
::lga::left gastric artery
::gda::gastroduodenal artery
::spda::superior pancreaticoduodenal artery
::ipda::inferior pancreaticoduodenal artery


;ortho

::ofx::old fracture
::cmfx::compression fracture
::stw::soft tissue swelling
::perilos::periprosthetic loosening

::retro::retrolisthesis
::spond::spondylolisthesis
::stra::straightening alignment

::sponly::spondylolysis of the pars interarticularis at the
::limv::limbus vertebra at the anterosuperior aspect(s) of
::isi::essential intact SI joint on both side

::osp::osteopenia of the visible bony structure
::alig::alignment
::spu::marginal spur formation
::normalnf::no obvious evidence of neural foraminal narrowing on both sides
::nanf::bilateral neural foraminal narrowing at multiple levels due to cervical spondylosis

::acj::acromioclavicular joint
::ghj::glenohumeral joint
::hj::hip joint
::hjs::hip joints
::pfj::patellofemoral joint
::kj::knee joint
::kjs::knee joints
::calb::calcaneus

::hipop::s/p hemiarthroplasty with postoperative changes at the 

::oahip::osteoarthritic change with small marginal spur formation at the 
::oasi::degenerative change of bilateral SI joints
::minioa::minimal osteoarthritis with subtle or tiny marginal spur formation at the
::oak::osteoarthritis with marginal spur formation at the

::vac::vacuum phenomenon
::sacra::L5 sacralization
::lsp::lateral subluxation or tilt of the patella
::oapa::osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the  

::te::traction enthesophyte formation
::downac::lateral downsloped acromion


::smal::However, small osseous or soft tissue lesion(s) may not be detected by the plain radiography
::pfim::focal cortical depression at the anterior aspect of right distal femoral supracondylar area, r/o patellofemoral impingement
::teis::subcortical sclerosis at the bil. Ischial tuberosities with traction enthesophyte formation.


;general

::sc::surgical clips
::lap::lymphadenopathy
::us::ultrasound findings
::asc::ascites
::nda::no definite abnormality of
::su::suggest
::suc::suggest correlation with
::suct::suggest chest CT correlation
::den::density
::des::densities
::supim::superimposed on
::prom::prominent
::fr::fracture
::frs::fractures
::dec::decreased
::nd::no definite
::ndf::no definite focal lesion 
::ndl::no definite lesion in the 
::nlap::no definite enlarged LAPs


;CT

::eme::Emergent
::ctda::CT of abdomen with dynamic contrast enhancement (non-enhanced, arterial and portal venous phase):
::cta::CT of the abdomen
::ctap::CT of the abdomen and pelvis
::ctb::CT of the brain
::ctbc::CT of the brain and chest
::ctc::CT of the chest
::ctca::CT of the chest and abdomen
::ctcp::CT of the chest, abdomen, and pelvis
::cth::CT of the head
::cthp::CT of the head, neck, chest, abdomen, and plevis
::cthn::CT of the head and neck
::ctn::CT of the neck
::ctnc::CT of the neck and chest
::ctna::CT of the neck, chest, and abdomen
::ctnp::CT of the neck, chest, abdomen, and pelvis
::ctp::CT of the pelvis
::ctlf::CT of the left foot
::ctrf::CT of the right foot
::ctbk::CT of bilateral knees
::ctban::CT of bilateral ankles
::ctpaod::CT of the lower abdomen, pelvis and bilateral lower extremities
::ctws::CT of the whole spine


;MR

::mrb::MRI of brain
::mrh::MRI of head
::mrhn::MRI of head and neck
::mra::MRI of abdomen
::mrp::MRI of pelvis
::mrap::MRI of abdomen and pelvis
::mrcs::MRI of the cervical spine
::mrcts::MRI of the cervicothoracic spine
::mrls::MRI of the lumbar spine
::mrlss::MRI of the lumbosacral spine
::mrts::MRI of the thoracic spine
::mrtls::MRI of the thoracolumbar spine
::mrws::MRI of the whole spine
::mrlw::MRI of the left wrist
::mrrw::MRI of the right wrist
::mrlk::MRI of the left knee
::mrrk::MRI of the right knee
::mrll::MRI of the left leg
::mrrl::MRI of the right leg
::tof::TOF MRA shows
::cemra::contrast enhanced MRA shows
::fl::focal lesion
::fd::filling defect
::t1::T1WI
::t2::T2WI
::flair::FLAIR
::sg::signal
::int::intensity
::enh::enhancement
::msa::magnetic suscepitibility artifact(s)

;NEURO
::bg::basal ganglion
::bgs::bilateral basal ganglia


;body

::eso::esophagus
::pan::pancreas
::ad::adrenals
::ndaa::no definite abonrmality of gall bladder, pancreas, spleen, bilateral adrenals and both kidneys.
::lc::uneven hepatic surface with splenomegaly, suggestive of cirrhotic pattern.
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


;HEART

::ar::aortic regurgitation
::mr::mitral regurgitation
::pr::pulmonary regurgitation
::tr::tricuspid regurgitation



;LUNG


::rs1::apical segment of RUL
::rs2::posterior segment of RUL
::rs3::anterior segment of RUL
::rs4::lateral segment of RML
::rs5::medial segment of RML
::rs6::superior segment of RLL
::rs7::medial basal segment of RLL
::rs8::anterior basal segment of RLL
::rs9::lateral basal segment of RLL
::rs10::posterior basal segment of RLL

::ls12::apicoposterior segment of LUL
::ls3::anterior segment of LUL
::ls4::superior lingular segment of LUL
::ls5::inferior lingular segment of LUL
::ls6::superior segment of LLL
::ls78::anteromedial basal segment of LLL
::ls9::lateral basal segment of LLL
::ls10::posterior basal segment of LLL


;BREAST


::mawjl::
(
Mammography of bilateral breasts shows:
- The breast tissue is heterogeneously dense. This may lower the sensitivity of mammography.
- The breast is extremely dense. This may lower the sensitivity of mammography.
- scattered benign appearing calcifications at both breasts. 
- no definite mass lesion.
- no focal skin thickening.
- no nipple retraction.
- no axillary lymphadenopathy.
(JYC/WJL) 
)

::b0u::BI-RADS 0, indeterminate ultrasonographic finding (need additional imaging evaluation). Suggest breast mammogram correlation.
::b1u::BI-RADS 1, no definite abnormal finding in this study. Suggest annual follow up or at the recommendation of the patient's physician.
::b2u::BI-RADS 2, benign findings. Suggest annual follow up or at the recommendation of the patient's physician.
::b3u::BI-RADS 3, probably benign finding. Suggest 6-month interval follow up.
::b4u::BI-RADS 4, suspicious lesion. Suggest tissue proof.

::b0m::BI-RADS category 0, indeterminate mammographic finding (need additional imaging evaluation). Suggest breast ultrasound or mag. spot view correlation.
::b1m::BI-RADS category 1, negative finding. Suggest annual mammogram follow up or at the recommendation of the patient's physician.
::b1mc::BI-RADS category 1, negative finding. Suggest annual mammogram follow up, or correlate with breast ultrasound if there is palpable breast lump clinically. The final assessment should be rendered according to the highest concern among the modalities.
::b2m::BI-RADS category 2, benign findings. Suggest annual mammogram follow up or ultrasound study if there is palpable lump clinically.
::b2md::BI-RADS category 2, dense breasts; benign finding. Suggest annual follow up and ultrasound correlation if palpable mass.
::b2mc::BI-RADS category  2, benign findings. Suggest annual mammogram follow up, or correlate with breast ultrasound if there is palpable breast lump clinically. The final assessment should be rendered according to the highest concern among the modalities.
::b3m::BI-RADS category 3, probably benign finding. Suggest 6-month mammogram follow up.
::b4m::BI-RADS category 4, suspicious lesion. Suggest tissue proof.
::b6m::BI-RADS category 6, known malignancy, left breast mass and left axillary LAP, suggest appropriate management.


::B0C::
  clipboard=性質未定之乳房攝影發現，建議乳房超音波對照，與放大攝影。
  Send ^v
  return
::b1c::
  clipboard=無異常乳房攝影發現，建議每年追蹤或依臨床醫師建議追蹤。若摸到腫塊，則需施行乳房超音波對照。
  Send ^v
  return
::b2c::
  clipboard=良性乳房攝影發現，建議每年追蹤或依臨床醫師建議追蹤。若摸到腫塊，則需施行乳房超音波對照。

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

::acr1::The breast is almost entirely fat.
::acr2::There are scattered fibroglandular densities.
::acr3::The breast is heterogeneously dense. This may lower the sensivity of mammography.
::acr4::The breast tissue is extremely dense, which could obscure a lesion in mammography.

::ard::architectural distortion
::ax::axilla
::axl::left axillary region
::axr::right axillary region
::axs::axillae

::bb::bilateral breasts
::bcab::There are benign scattered and regional calcifications present bilaterally
::bctr::right breast cancer s/p BCT
::bctl::left breast cancer s/p BCT
::bctm::breast cancer s/p BCT with marking wire.
::br::breast
::bca::There are benign scattered calcifications present bilaterally.
::bbca::bilateral benign calcifications

::cav::There are benign appearing vascular wall calcifications at bilateral breasts.
::ca::calcification
::cd::calcified
::cm0::without prior study for comparison
::cm1::as compared with prior 
::cmct::as compared with prior CT on
::cmmr::as compared with prior MRI on
::cmcx::as compared with prior CXR
::cmma::compared with prior mammogram study dated on

::cys::a round, anechoic lesion with distinct margin at right breast / region, sized cm, compatible with cyst.
::cysb::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, size up to cm, r/o cysts and or fibroadenomas.
::cysm::multiple small, oval, hypoechoic to anechoic lesions with distinct margin in bilateral breasts, size up to cm, r/o cysts and or fibroadenomas.
::cysl::a round, well-defined, anechoic lesion with distinct margin and posterior enhancement at left breast /, sized cm, suggestive of cyst.
::cysr::a round, well-defined, anechoic lesion with distinct margin and posterior enhancement at right breast /, sized cm, suggestive of cyst.

::fa::fibroadenoma 
::fal::an oval, parallel, hypoechoic lesion with distinct margin at left breast / region, sized cm, r/o fibroadenoma
::far::an oval, parallel, hypoechoic lesion with distinct margin at right breast / region, sized cm, r/o fibroadenoma
::fcc::fibrocystic change
::fh::family history of breast cancer (sister/mother/grandmother)
::fu::for follow-up.

::hm::History of menopause.
::hc::for health checkup
::hrt::HRT

::id::ill-defined
::wd::well-defined

::lb::left breast
::lnb::benign appearing lymph nodes with fat hilum at bilateral axillary regions.
::lnr::benign appearing lymph node with fat hilum at right axilla.
::lnl::benign appearing lymph node with fat hilum at left axilla.
::lnla::small left axillary lymph node, having fat hilum
::lnln::small lymph node at left neck region, having fat hilum
::lnra::small right axillarly lymph node, having fat hilum
::lnrn::small lymph node at right neck, having fat hilum
::nlnb::non-specific lymph nodes in the bilateral axillae
::nlnl::non-specific lymph nodes in the left axilla
::nlnr::non-specific lymph nodes in the right axilla

::mic::microcalcifications
::mm0::Bilateral CC and MLO mammogram is read without prior study for comparison
::mm1::Bilateral CC and MLO mammogram is read and compared with prior mammogram on 200--
::mop::post-operative scarring with parenchymal loss at the
::mrml::left breast cancer s/p MRM
::mrmr::right breast cancer s/p MRM
::mp::menopause

::nd::nodule
::ndf::no definite focal lesion
::ndm::no definite mass lesion
::nmm::There is no definite mass, no focal suspicious microcalcifications, and no architectural distortion in this study
::nlap::no definite lymphadenopathy at bil axillae, supraclavicular regions and anterior chest wall.
::nlna::no definite axillary lymphadenopathy
::nlnan::no definite axillary of neck lymphadenopathy
::nre::no evidence of local recurrence
::nsln::non-specific small lymph nodes at

::opsc::post-operative change with scar formation at
::opscl::post-operative scarring at left breast, which is stationary compared with prior ultrasound on
::opscr::post-operative scarring at right breast, which is stationary compared with prior ultrasound on

::rb::right breast

::uhd::heterogeneous dense fibroglandular tissue
::ud::dense fibroglandular tissue
::uif::ultrasound correlation if palpable mass.
 
::scr::for screening
::sugu::suggest breast ultrasound correlation
::sm::spot mag view

::wm::wire marked

; 以下為罐頭區
;

::