﻿﻿﻿;
; Edited from scripts belonging to Dr. WGL & YCC
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
#Hotstring EndChars ()[]{}:;'"\,.?!`n `t

; send out report and enter next
#s::
WinActivate, ahk_class AcucobolWClass
Send {F9}
SetWinDelay, 100
WinActivate, IMPAX 6.2.1.149 Radiologist 
Click 835,580
Click 835,730
Click 630,50 
return


F10::F10


::aa::abdominal aorta
::aaa::atherosclerosis of abdominal aorta
::abd::abdominal
::ac::are considered.
::acr::ACR BI-RADS category
::acs::accessory spleen
::abdd::abdominal distention
::adem::adenomyomatosis
::afp::AFP ng/ml ()
::afl::air-fluid levels
::ali::The alignment is intact.
::ak::(arrow, key images)
::al::alignment
::altp::although the shape is favored as a phlebolith
::ampv::Periampullary lesions can not be totally excluded by the CT or MR study.
::ang54::Angiography was performed from the right femoral approach with a 5Fr vascular sheath and a 4Fr RC1 catheter:
::ank::swelling of the ankle joint is noted
::ano::are noted
::ana::anastomosis
::anky::ankylosing spondylitis
::ant::anterior
::ao::amount of
::ap::in the arterial phase
::apl::apical lung.
::app::appearance
::aps::arterioportal shunt
::aru::amount of residual urine.
::asap::as soon as possible
::asp::aspect
::ate::atelectasis
::ath::atherosclerosis
::att::attenuation
::aw::associated with


::bai::basal indentation
::bc::BUN/Creatinine = 
::bcps::bilateral clear psoas shadows.
::bd::balloon dilatation
::bdb::status post bilateral double J catheters insertion is noted.
::bf::bone fragment
::bi::bilateral
::bk::both kidneys
::bli::both lobes of liver
::blu::both lungs
::blu::blunting
::bo::No evidence of focal bone lesions is noted.
::bon::No evidence of focal bone lesions is noted. Alignment is intact. The soft tissue injury should be correlated with clinical findings.
::bor::borderline heart size is noted.
::bp::The bile ducts and P duct are not dilated.
::bps::Bilateral psoas shadows are clear.
::bra::Bilateral renal arteries are intact.
::bro::bronchopneumonia
::brs::The bilateral renal shadows are obscured.
::bs::both sides
::bsca::bilateral sharp costophrenic angles.
::b0::no definite abnormal bone change of this study.
::b1::Dense breasts and no mammographic finding (ACR BI-RADS category 1). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::b2::Dense breasts and benign mammographic finding (ACR BI-RADS category 2). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::b3::Dense breasts and probably benign mammographic finding (ACR BI-RADS category 3). Suggest short term follow up and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.
::b6l::the superior segment of the LLL.
::b6r::the superior segment of the RLL.
::b10l::the posterior basal segment of the LLL.
::b10r::the posterior basal segment of the RLL.
::bapt::bilateral apical pleural thickening.
::baptc::bilateral apical pleural thickening with calcification.
::bbc::bilateral benign calcifications.
::bct::placement of bilateral chest tubes. 
::bec::bronchiectasis
::bi::bilateral.
::bia::irregular acetabular fossa,
::bjc::placement of bilateral jugular venous catheters (lines). 
::tbk::status post operation with total knee replacement, 
::mhn::more healing noted,
::bln::bilateral lung nodules. 
::bo::absence of breast shadow, compatible with previous mastectomy, 
::bple::bilateral pleural effusion.

::c01::normal heart size. bilateral sharps costophrenic angles. no definitive lung lesions.
::c45::C4/5
::c56::C5/6
::c67::C6/7
::cak::calcified aortic knob is noted
::cal::calcification
::cap::Chest AP film shows 
::car::cardiomegaly is noted
::cau::caudate lobe of liver
::cc::clinical correlation
::cca::about the abdominal regions, please see the abdominal CT reports.
::cch::about the head and neck regions, please see the head and neck CT reports.
::ccp::chronic calcified pancreatitis
::ccr::about the chest regions, please see the chest CT report.
::ccwj::(CCW/Dr. JW)
::ccwycc::(CCW/Dr. YCC)
::ccrh::about the head and chest regions, please see the head and chest CT reports.
::cf::clinical follow-up
::cg::calcified granuloma
::ch::clinical history
::cha::common hepatic artery
::che::chest tube
::cheng::Please consult with Dr. Cheng (PHS 3453) for possible PET-CT scan.
::cho::status post cholecystectomy is noted with surgical clips in the right upper abdomen.
::cia::common iliac artery
::cir::circumferential
::cla::clavicle
::cli::clinical findings
::cmm::contrast medium
::cn::cirrhotic nodules
::com::compatible
::comp::compression fracture
::con::consolidation
::cons::considered
::cor::correlation
::coro::coronary a.a. calcifications
::corw::correlation with
::cp::cancerous peritonitis
::cpa::costophrenic angle.
::cpa2::cardiophrenic angle.
::cps::Chest PA film shows 
::cs::calcified spots
::csit::Sitting Chest Radiograph:
::csp::cavum septum pellucidum
::cta::there are no focal lesions in the liver, spleen, pancreas, both adrenal and kidneys.
::ctabd::NECT and CECT of abdomen
::ctal::there is no evidence of paraaortic LAPs in abdomen
::ctb::there are no definite focal lesions in the basal lungs and bone window settings.
::ctbo::there are no definite focal lesions in the bone window settings.
::ctche::NECT and CECT of chest
::ctcolon::NECT and CECT of abdomen and pelvis for colon cancer with air distention:
::cthcc::hypodensity on precontrast, hyperdensity on arterial phase and rapid washout on venous phase; compatible with HCC.
::cthem::hypodensity on precontrast, peripheral dot-like enhancement on arterial phase, and progressive filling-in on venous phase; compatible with liver hemangioma.
::cthem2::isodensity on precontrast, global enhancement on arterial phase, and persistent enhancement on venous phase; compatible with liver hemangioma.
::ctl::there are no definite focal lung lesions
::ctml::there is no evidence of significant mediastinal lymphadenompathies
::ctnl::there is no evidence of significant lymadenopathies in the bilateral neck areas
::ctp::CTAP was performed with tip in the SMA orifice, 2ml/sec, delayed 30 sec, total 50 ml:
::ctpel::NECT and CECT of abdomen and pelvis for the
::ctpl::there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
::ctstomach::NECT and CECT of abdomen and pelvis with air and water distention of the stomach for evaluation:
::cvi::cavum velum interpositum
::cw::compatible with
::cxr::Normal heart size and no definite focal lung lesions are noted.


::da::deformed alignment
::db::There is dilated bowel gas but non-specific bowel gas distribution is noted.
::dec::decreased
::dem::demoral 50 mg intramuscular injection
::dep::dependent
::des::destruction
::devl::the lumbar spine is slightly deviated to
::devt::the tracheal air shadow is slightly deviated to
::dd::a diverticulum is noted at the second portion of duodenum
::def::definite
::det::details are obscured
::dia::diaphragm
::dif::should be differentiated
::dil::dilatation
::dis::disc space narrowing
::dist::distention
::dl4::at the L4/5 and L5/S1
::dl5::at the L5/S1
::dra::drainage tube
::ds::diaphragmatic shadow
::dtls::degenerative thoracolumbar spine.
::dyn::there is status post dynamic screw fixation due to intertrochanteric fracture


::ede::Increased lung markings with bilateral hilar distribution are noted, suggestive of lung edema.
::ehs::enlarged heart size.
::ele::elevated
::em::extracorporal material
::emb::embolization
::eme::Emergency
::emp::emphysematous change
::enc::encasement
::enh::enhancement
::enl::enlargement
::eps::encapsulted peritoneal sclerosis
::es::extraserosal infiltrations
::et::status post endotracheal tube insertion and the tip is in the appropriate position
::eti::The etiology should be further evaluated.
::ev::esophageal varices
::eva::evaluation
::exc::can not be excluded.
::ext::extensive


::fa::fluid accumulation
::fac::facet joint arthropathy
::fb::No evidence of radiopaque foreign body can be identified. The prevertebral soft tissue is intact.
::fc::fluid collection
::fcl::femoral central venous catheter in the inferior vena cava
::fcvp::femoral CVP line
::fd::filling defect
::fe::further evaluation
::fec::Increased fecal material in the colon is noted
::fem::femoral CVP line is noted
::ff::fluid-fluid layering
::ffl::fluid-fluid level
::fib::fibrotic change
::fin::findings
::fl::falciform ligament
::foc::focal lesion
::fol::A foley catheter insertion is noted.
::fp::fat planes
::fr::fluid retention
::fra::fragments
::fre::No evidence of subphrenic free air is noted.
::fs::fatty strandings
::fus::fusiform
::fun::Functioning or non-functioning status should be correlated with clinical findings.
::fx::fracture
::fxe::fracture ends


::gcs::greater curvature side
::gda::gastroduodenal artery
::gg::Suggest correlation with clinical manifestations.
::ggo::ground-glass opacities
::ghl::gastrohepatic ligament
::gra::grade I of spondylolisthesis
::gs::gall stones


::h::History of
::hc::hemorrhagic cyst
::hdl::hepatoduodenal ligament
::hem::hemangioma
::hemo::hemorrhagic
::het::heterogeneous
::hi1::hyperintensity
::hi2::isointensity
::hi3::hypointensity
::hs::heart shadow
::ht::hepatic tumor
::htn::hypertension
::hv::hepatic veins and portal veins are patent
::hydro::hydronephrosis
::hyper::hypervascular
::hypo::hypovascular


::ic::is considered.
::id::identified
::ii::is indicated
::ild::interstitial lung disease
::ile::increased bowel gas is noted in the abdomen, compatible with ileus.
::ilem::markedly increased bowel gas is noted in the abdomen, compatible with prominent ileus. 
::iles::slightly increased bowel gas is noted in the abdomen, compatible with mild ileus.
::inc::increased
::inci::incidentally
::incl::including
::ind::indication
::inde::indentation
::inf::infiltrations
::infv::infiltrative
::ing::inguinal area
::ins::insufficiency
::inv::involvement
::ioh::in other hospital
::ip::infectious process
::ipf::interstitial pulmonary fibrosis
::irr::irregular
::iud::Intrauterine device is noted in the pelvic cavity.
::isn::is noted


::jt::A jejunal tube is noted


::kb::Knee, both:
::ker::Increased Kerley's lines are noted and congestive heart failure is considered.
::kl::Knee, left:
::koa::knee joint space narrowing with spurs formation, osteoarthritis is compatible.
::kr::Knee, right:
::kub::The KUB shows


::l23::L2/3
::l34::L3/4
::l45::L4/5
::l51::L5/S1
::la::local anethesia 2% Xylocaine 10ml injection
::lat::lateral segment
::lbv::left brachiocephalic vein
::lc::liver cirrhosis with splenomegaly
::lcs::lesser curvature side
::ld::low density
::ldv::left decubitus view
::ldb::A left double J catheter is noted.
::ldn::low density nodules
::le::increased lung markings with bilateral hilar distribution is noted, suggestive of lung edema
::les::lesser curvature side
::leu::low density change at bilateral periventricular white matter, leukoaraiosis is considered
::lf::lung field
::lfh::low and flattened bilateral hemidiaphragms.
::lfs::lung fields
::lga::left gastric artery
::lha::left hepatic artery
::liao::Please consult with Dr. Liao Wei-Chih (PHS 1925) for the evaluation of possible IgG and IgG4 levels.
::lig::ligament
::lip::lipiodol retentions
::ljc::a left jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::lk::left kidney
::lkl::If any problems, please call 51685 (Dr. Liu, Kao-Lang) or 53442 (Dr. Chang, Chin-Chen).
::llo::several tiny low density nodules are noted in the liver and liver cysts are considered in current study.
::ll::left lobe of liver
::lll::left lower lung field.
::lm::lung markings
::lob::lobulated
::loc::no evidence of local recurrence is noted.
::lpa::Left Port-A insertion from left subclavian vein is noted with tip in the superior vena cava.
::lpaj::Left Port-A insertion from left jugular vein is noted with tip in the superior vena cava.
::lpab::Left Port-A insertion from left subclavian vein is noted with tip in the distal brachiocephalic vein.
::lps::left psoas shadow is clear.
::lrad::A radiopaque density is noted in the left pelvis; a left distal ureteral stone can not be excluded.
::lrs::The left renal shadow is not well delineated
::lrst::left renal stone
::ls::(lower sensitivity of the non-enhanced study)
::lsc::a left jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::lt::liver tumor
::lul::left upper lung
::lum::Lumbosacralization is noted on
::lun::No definite focal lung lesions are noted.
::lym::lymphangitis carcinomatosis


::ma::marked
::med::mediastinum
::met::metastases
::mha::middle hepatic artery
::mhv::middle hepatic vein
::mor::CT morphology of
::morl::CT morphology of low-grade esophageal varices is noted.
::morh::CT morphology of high-grade esophageal varices is noted; correlation with endoscopic findings is indicated
::morn::CT morphology of esophageal varices is not identified
::mrc::MRCP reveals no evidence of bile ducts or pancreatic duct dilatation; no anomalous pancreaticobiliary union.
::mrhcc::hypointensity on T1-weighted images, slight hyperintensity on T2-weighted images, and global enhancement on early arterial phase, rapid washout on delayed enhanced images; compatible with HCC.
::mrhem::hypointensity on T1-weighted images, hyperintensity on T2-weighted images, and peripheral patches enhancement on dynamic contrast-enhanced study, persistent enhancement on delayed contrast-enhanced images; compatible with liver hemangioma.
::mriw::The MRI without/with contrast administration shows:
::mriwo::The MRI without contrast administration shows:
::ms::maxillary sinus
::mss::maxillary sinuses
::mul::multiple


::n::normal
::na::there is no ascites
::nat::Nature to be determined
::nce::no contrat medium enhancement
::nda::no definite abnormality is found in this examination.
::ndll::no definite lung lesions.
::ndus::no definite urinary stones.
::ne::no evidence of
::neu::neuroforaminal narrowing is noted
::nf::no definite focal lesions
::nfa::no definite focal lesions in the abdomen
::nfp::no definite focal lesions in the pelvic cavity
::ng::nasogastric tube insertion is noted with tip in the stomach.
::nhs::normal heart size.
::nic::no interval change
::nk::Bilateral psoas shadows are clear. No evidence of radiopaque stones are noted. Nonspecific bowel gas distribution is noted.
::nl::No definite focal bone lesions are noted in the lumbar spine and the alignment is intact.
::nm::no evidence of metastatic lesions in the abdomen
::nobu::no obstruction or filling defect of bilateral urinary tract.
::nod::nodular and retracted liver contour is noted.
::non::non-specific bowel gas distribution is noted.
::nr::no evidence of recurrent tumors
::nrm::no evidence of recurrent or metastatic lesions in the abdomen
::nrr::no evidence of residual or recurrent tumor.
::ns::non-specific
::nsbgp::non-specific bowel gas pattern.
::nuc::nuchal ligament calcification is noted.


::ogd::old granulomatous disease
::ost::osteoarthritis change
::obl::obliteration
::obs::obstruction
::obsl::obstructive level
::oc::operative change
::og::old granulomatous disease
::oh::in other hospital
::oj::obstructive jaundice
::ol::obstructive level
::oo::osteoporosis
::opa::opacification
::ora::oral contrast medium
::os::osteoarthritis
::otb::increased fibrocalcified lesions are noted in the bilateral upper lung fields; old granulomatous disease is considered. 
::ove::overriding


::Pa::paraaortic areas
::pac::a pacemaker insertion is noted.
::pan::pancreatic
::par::parenchymal
::para::Paranasal sinuses are clear.
::pb::pneumobilia
::pc::pelvic cavity
::pce::pericardial effusion
::pcs::portocaval space
::pd::Status post Tenchkoff catheter replacement with tip in the
::pe::pericardial effusion
::ped::bilateral pedicles are intact.
::pegj::A 5Fr H1 insertion into the stomach first; then 300 cm guidewire was delivered and this 5Fr H1 was adjusted into the duodenum.  Therefore, the gastrojejunal tube (12Fr in 24Fr) was delivered smoothly with tip in the proximal jejunum. Prevention from tube occlusion was educated.
::pel1::basal indentation of bladder with bilateral hooked UVJ. Prostate enlargement is considered.
::per::peritoneal cavity
::peri::peripheral
::peric::pericardial effusion
::perih::perihepatic space
::pfj::patellofemoral joint
::pha::proper hepatic artery
::phl::A phlebolith is noted in the pelvis on
::phls::Phleboliths are noted in the pelvis on
::pla::pleural plaques
::ple::pleural effusions
::plm::prominent bilateral lung markings.
::pm::pneumonia
::pms::posterior marginal spur formation
::pne::no evidence of pneumonic patches in both lung fields
::po::partial obstruction
::poc::post-op change of
::pos::posterior
::pp::in the portal venous phase
::pr::Patella, right:
::pre::prostate enlargement
::pri::compared with prior
::pro::prominent
::ps::psoas shadow is not well delineated.
::pt::pneumothorax.
::pul::pulmonary
::pun::PTCD, smoothly performed, once puncture.
::pv::portal vein
::pvt::portal vein thromobses


::qua::decreased quality of the film is noted, and the details cannot be well evaluated.


::ra::radiopaque
::rad::No definite radiopaque density is noted in the urinary collecting system.
::rc::radiocarpal joint
::rea::The study was reassigned due to no report 2009/
::rrad::A radiopaque density is noted in the right pelvis; a right distal ureteral stone can not be excluded.
::res::respiratory motion artifacts make less sensitivity and specific quality.
::rd::a radiopaque density is noted at the  pelvis and the  distal ureteral stone cannot be excluded although the shape is favored as a phlebolith.
::rdb::A right double J catheter is noted.
::rha::right hepatic artery
::rhv::right hepatic vein
::ri::right
::ril::right lobe of liver
::rjc::a right jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::rk::right kidney
::rl::right lobe of liver
::rll::right lower lung field.
::rm::no evidence of recurrent or mets lesions
::rml::right middle lung
::rpa::Right Port-A insertion from right subclavian vein is noted with tip in the superior vena cava.
::rpaj::Right Port-A insertion from right jugular vein is noted with tip in the superior vena cava.
::rps::right psoas shadow is clear.
::rrs::The right renal shadow is not well delineated
::rrst::right renal stone
::rsc::a right subclavian venous approached central venous pressure line is noted with tip in the superior vena cava.
::rt::right
::ruj::radioulnar joint
::rul::right upper lung
::rv::renal vein and inferior vena cava are intact


::s02::superior lateral segment of left lobe of liver (S2)
::s03::inferior lateral segment of left lobe of liver (S3)
::s04a::superior medial segment of left lobe of liver (S4a)
::s04b::inferior medial segment of left lobe of liver (S4b)
::s05::inferior anterior aspect of right lobe of liver (S5)
::s06::inferior posterior aspect of right lobe of liver (S6)
::s07::superior posterior aspect of right lobe of liver (S7)
::s08::superior anterior aspect of right lobe of liver (S8)
::s/p::status post
::sarn::The standing abdominal radiograph shows no definitive subpleural air collection.
::sb::small bowel
::sub::subpotimal study with motion artifacts which may obscure image details.
::sbtube::Sengstaken-Blakemore tube
::sc::surgical clips
::scl::sclerotic change
::sco::scoliosis of the spine
::scot::scoliosis of the thoracic spine
::scol::scoliosis of the lumbar spine
::scub::smooth mucosal contour of urinary bladder.
::sd::the spine is deviated to
::se::subcutaneous emphysema
::sg::a Swan-Ganz catheter insertion is noted with tip at the
::sh::shadow
::sho::should be correlated with clinical findings.
::si::The soft tissue injury should be correlated with clinical findings.
::sij::sacro-iliac joint
::sl::the Shenton line is intact.
::sli::slightly
::so::suggestive of
::sp::status post 
::spl::splenomegaly
::spo::Spondylosis of the spine.
::spoc::spondylosis of the cervical spine is noted
::spol::spondylosis of the lumbar spine is noted
::spoi::spondylolisthesis
::spoy::spondylolysis
::ss::not sensitive and specific of this CT pattern
::ssa::subsegmental atelectasis
::st::soft tissue
::sta::Standing abdomen shows:
::ste::Status post operative change with sternotomy is noted
::stc::Standing CXR shows:
::std::soft tissue density
::stls::spondylosis of thoracolumbar spine.
::sto::stool impaction is compatible.
::su::suggest
::suc::suggest clinical correlation.
::sus::suspected
::sur::surrounding
::sw::superimposed with


::t/d::Total/ direct bilirubin = 
::ta::tortuous aorta.
::tca::tortuous and calcified aorta.
::tbc::tracheobronchial calcifications are noted.
::td::the trachea is deviated to
::thi::thickening
::ti::terminal ileum
::tra::status post tracheostomy
::tri::Triphase dynamic abdominal CT study (pre-, arterial- and portal venous phases) for the


::ub::urinary bladder
::ukr::status post unicompartment knee replacement (Howmedica)
::unk::unknown history in N hospital
::ur::ureteral
::usp::ulnar styloid process


::vb::vertebral body
::vp::vertebroplasty
::vs::The vascular sheathh was placed in the right femoral artery for possible further angiography; please remove it as soon as possible and prevent it from thrombosis.


::wal::abnormal thickening and enhancing wall
::wd::well-defined
::wi::widening
::wic::without internal change
::wm::white matter
::wvs::The Waters view shows
::wgl::please consult with Dr. Liu Gao-Lang (GSM 51685) for further imaging opinions.


::yfc::please consult with Dr. Chen Ya-Fang (GSM 51623) for further imaging opinions.
::yccct::CT of the chest without and with contrast enhancement shows: 1. three tiny nodules at right upper lobe (SE5 IM18, 20); the largest one is about 0.5 cm at RUL (SE5 IM20). 2. patchy consolidation and ill defined ground-glass opacities at right lower lobe. 3. bilateral small mediastinal and axillary lymph nodes. But mildly enlarged lymph nodes at right paratracheal region and right hilum are found. 4. calcification at right lobe liver. 5. no definite abnormality of the adrenals, pancreas and spleen.
