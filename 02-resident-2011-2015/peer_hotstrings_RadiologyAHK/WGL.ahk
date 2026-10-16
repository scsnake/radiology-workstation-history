﻿﻿;
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


#IfWinActive ahk_class WindowsForms10.Window.8.app.0.2bf8098
RAlt::
  SendEvent {Blind}{LButton down}
  KeyWait Ralt
  SendEvent {Blind}{LButton up}
return
MButton::
  SendInput, {Right}
return

#ifWinActive

F10::F10

::[::( )
::62299::Thanks for your consultation and please call 62299/ or 62301 (CT room) if any problems. 
::62608::Thanks for your consultation and please call 62608/ or 62612 (angio-room) if any problems. 
::aa::abdominal aorta
::aaa::atherosclerosis of abdominal aorta
::abd::abdominal
::ac::distended GB is noted with wall thickening and enhancing, increased fatty strandings around the GB, and hyperemia change of the surrounding liver parenchyma. Acute cholecystitis is compatible. 
::acc::accessory spleen
::ad::alignment deformity is noted.
::acutecholecystitis::distended GB is noted with increased surrounding fatty strandings; hyperemia of the surrounding liver parenchyma is also noted; the pattern is favored as acute cholecystitis. 
::ade::adenomyomatosis
::af::AFP ng/ml (2014
::afl::air-fluid levels
::ag::adrenal gland
::ags::adrenal glands
::ai::The alignment is intact.
::ak::(arrow, key images)
::al::alignment
::alt::AFP  ng/ml; T-bil 4.11 mg/dL; AST 50 U/ml; ALT 32 U/ml (2014/
::ampv::Periampullary lesions can not be totally excluded by the CT or MR study.
::ana::anastomosis
::anc::ANC (acute necrotic collection)
::ang::Angiography was smoothly performed from the right femoral approach with a 5Fr vascular sheath and a 4Fr RC1:
::ank::swelling of the ankle joint is noted
::anky::Syndesomophyte formation with bamboo-shaped spine and ankylosis of bilateral sacroiliac joints, suspected ankylosing spondylitis.
::ankylosing::sydesmophyte at T-L spine with square-shaped vertebrae and ankylosing of the facet joints, suspected ankylosing spondylitis
::ano::are noted
::ant::anterior
::ao::amount of
::aoa::atherosclerosis of the aorta
::ap::air pocket
::apfc::APFC (acute peripancreatic fluid collection)
::aph::in the arterial phase
::apn::acute pyelonephritis
::app::focal inflammatory process is noted at the RLQ with dilated appendix, wall enhancement and increased perifocal fatty strandings; no appendicoliths; acute appendicitis is compatible
::appe::appearance
::aps::arterioportal shunt
::apsliver::a small irregular nodule is noted at the , only identified in the arterial phase; a small arterioportal shunt is considered.
::apy::antegrade pyelography
::asap::as soon as possible
::asp::aspect
::ast::AFP  ng/ml; T-bil 4.11 mg/dL; AST 50 U/ml; ALT 32 U/ml (2014/ 
::ate::atelectasis
::ath::atherosclerosis
::att::attenuation
::avs::such as NP-59 and adrenal venous sampling.
::aw::associated with
::ba::relatively increased density of the basilar artery
::bc::Bartholin cyst
::bcv::brachiocephalic vein
::bd::balloon dilatation
::bdb::status post bilateral double J catheters insertion is noted.
::bf::bone fragment
::bg::The button-type gastrostomy tube (24Fr, 1.7cm, 2.4cm, 3.4cm and 4.4cm; BARD) was inserted smoothly.
::bh::biliary hamartoma (von Meyenburg complex)
::bi::bilateral
::bk::both kidneys
::bli::both lobes of liver
::blu::both lungs
::blu::blunting
::bo::No evidence of focal bone lesions is noted.
::bon::No evidence of focal bone lesions is noted. Alignment is intact. The soft tissue injury should be correlated with clinical findings.
::bor::borderline heart size is noted.
::bosniak 1::Bosniak category 1 of renal cystic neosplasm is considered.
::bp::The bile ducts and P duct are not dilated.
::bphc::攝護腺肥大. 五十歲以上男性有1/2的檢查者有這項發現, 請與您的醫師確認追蹤以及治療方式.
::bps::Bilateral psoas shadows are clear.
::bra::Bilateral renal arteries are intact.
::brains::a brain stimulation implanted in the
::bro::bronchopneumonia
::brs::The bilateral renal shadows are obscured.
::bs::both sides
::bti::biliary tract infection
::c34::C3/4
::c45::C4/5
::c56::C5/6
::c67::C6/7
::c456::C4/5 and C5/6
::c567::C5/6 and C6/7
::ca125::CA-125 = 183.1 U/ml (2013/04/29)
::ca199::CA19-9 60.4 U/ml (2014/0
::cak::calcified aortic knob is noted
::cal::calcification
::car::cardiomegaly is noted
::carv::carvenous transformation
::cau::caudate lobe of liver
::cavumi::cavum velum interpositum
::cavump::cavum septum pellucidum
::cc::clinical correlation
::cce::(about the extremity regions, please see the extremity CT report)
::cch::about the head and neck regions, please see the head and neck CT reports.
::ccp::chronic calcifying pancreatitis
::cchange::consciousness change
::ccr::(about the chest regions, please see the chest CT report)
::ccrh::(about the head and chest regions, please see the head and chest CT reports)
::cea::CEA ng/ml (2014/0
::cf::clinical follow-up
::cfi::clinical findings
::cg::calcified granuloma
::ch::clinical history
::cha::common hepatic artery
::che::chest tube insertion
::ches::chest tubes insertion
::cheng:: Please consult with Dr. Cheng (cellular phone 53453) for possible FLT- and PET-CT scan.
::cheng2::Please consult with Dr. Cheng (cellular phone 53453) for possible GET (gastric emptying time study; injection of the exam drug from the red port).  
::cho::status post cholecystectomy is noted with surgical clips in the right upper abdomen.
::chol::cholangiocarcinoma
::cia::common iliac artery
::cie::left common iliac vein compression syndrome (May-Thurner)
::cir::circumferential
::cla::clavicle
::cli::clinical findings
::cm::contrast medium
::cme::contrast medium extravasation
::cn::cirrhotic nodules
::com::compatible
::comp::compression fracture
::comp11::mild compression fracture (grade 1 wedge fracture)
::comp12::moderate compression fracture (grade 2 wedge fracture)
::comp13::severe compression fracture (grade 3 wedge fracture)
::comp21::mild compression fracture (grade 1 biconcave fracture)
::comp22::moderate compression fracture (grade 2 biconcave fracture)
::comp23::severe compression fracture (grade 3 biconcave fracture)
::comp31::mild compression fracture (grade 1 crush fracture)
::comp32::moderate compression fracture (grade 2 crush fracture)
::comp33::severe compression fracture (grade 3 crush fracture)
::con::consolidation
::cons::considered
::cor::correlation
::coro::coronary a.a. calcifications
::corw::correlation with
::cos::coronary artery stent
::cp::cancerous peritonitis
::cpa::costophrenic angle
::cpa2::cardiophrenic angle
::cps::thickenened mucoperiosteum of bilateral maxillary sinuses with decreased antral volumes, compatible with chronic sinusitis; loss of aeriation of bilateral mastoid air cells, chronic mastoiditis is considered.
::cr::capsular retraction
::cs::calcified spot
::css::calcified spots
::csit::Sitting Chest Radiograph:
::csp::cavum septum pellucidum
::cst::The local staging is favored as cT
::cta::there are no focal lesions in the liver, spleen, pancreas, both adrenal and kidneys
::ctal::there is no evidence of paraaortic LAPs in abdomen
::ctapl::there is no evidence of paraaortic LAPs in abdomen; there is no evidence of LAPs in pelvic cavity and bilateral inguinal areas.
::ctb::there are no definite focal lesions in the basal lungs and bone window settings.
::ctbb::there are no definite focal lesions in the bone window settings.
::ctbo::there are no definite focal lesions in the bone window settings.
::ctbph::BPH or prostate cancer should be correlated with clinical findings due to CT not sensitive to differentiate the both.
::ctcholecystitis::distended GB with wall thickening and enhancement are noted; with surrounding liver parenchymal enhancement; with increased fatty strandings between the hepatic flexure of colon and the 2nd portion of the duodenum; acute cholecystitis is considered. 
::ctcolon::NECT and CECT of abdomen and pelvis for colon cancer with air distention:
::ctgb::The pattern can not exclude acute cholecystitis but CT diagnosis of acute cholecystitis is less sensitive and less specific than ultrasonography. The surrounding fat planes are still clear. 
::cthcc::hypodensity on precontrast, hyperdensity on arterial phase and rapid washout on venous phase; compatible with typical HCC.
::cthem::hypodensity on precontrast, peripheral dot-like enhancement on arterial phase, and progressive filling-in on venous phase; compatible with liver hemangioma.
::cthem2::isodensity on precontrast, global enhancement on arterial phase, and persistent enhancement on venous phase; compatible with liver hemangioma.
::ctl::there are no definite focal lung lesions
::ctml::there is no evidence of significant mediastinal lymphadenompathies
::ctnl::there is no evidence of significant lymadenopathies in the bilateral neck areas
::ctp::CTAP was performed with tip in the SMA orifice, 2ml/sec, delayed 30 sec, total 50 ml:
::ctpl::there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
::ctss::(Non-enhanced CT study is not sensitive and specific for the detection of focal lesions in the abdominal organs)
::ctstomach::NECT and CECT of abdomen and pelvis with air and water distention of the stomach for evaluation:
::cuc::If any problems, please call U-Chin Chen (52402).
::cvi::presence of the 7th ventricle (cavum velum interpositum, normal variant)
::cvr::cardiac valve replacement
::cw::compatible with
::cxr::Normal heart size and no definite focal lung lesions are noted.
::cz::central zone
::da::deformed alignment
::db::There is dilated bowel gas but non-specific bowel gas distribution is noted.
::dbs::status post deep brain stimulation
::dd::duodenal diverticulum is noted at the second portion of duodenum
::dbj1::status post a double J catheter indwelling is noted on
::dbj2::status post double J catheter indwellings are noted on both sides
::dds::diffuse disc space narrowing
::deb::prominent precipitates and debris
::dec::decreased
::decu::decubitus film
::def::definite
::dem::demoral 50 mg intramuscular injection
::dep::dependent
::des::destruction
::det::details are obscured
::devl::the lumbar spine is slightly deviated to
::devt::the tracheal air shadow is slightly deviated to
::di::diffusely increased
::dia::diaphragm
::dif::should be differentiated
::dil::dilatation
::dis::disc space narrowing
::disl::dislodgement
::dist::distention
::dl4::at the L4/5 and L5/S1
::dl5::at the L5/S1
::dra::drainage tube
::ds::diaphragmatic shadow
::dt::drainage tube
::dts::drainage tubes
::dtvn::a 15Fr, 15cm DTVN drainage tube (Cook)
::dyn::there is status post dynamic screw fixation due to intertrochanteric fracture
::dzl::If any problems, please call 51685 (Dr. Liu, Kao-Lang) or 51291 (Dr. Lee, Din-Zwau).
::ec::endplate change
::ede::Increased lung markings with bilateral hilar distribution are noted, suggestive of lung edema.
::ekc::Emergency KUB shows: Non-specific bowel gas distribution is noted.  No evidence of focal bone lesions is noted.  Suggest correlation with clinical manifestations. 
::eka::Emergency KUB shows: Non-specific bowel gas distribution is noted.  No evidence of focal bone lesions is noted.  Bilateral psoas shadows are clear.  No definite radiopaque density is noted in the urinary collecting system.  Suggest correlation with clinical manifestations. 
::ele::elevated
::em::extracorporal material
::emb::embolization
::embozene::Embozene particles (400 micrometer, CeloNova Bioscience)
::eme::Emergency
::emek::Emergency KUB shows:
::emes::Emergency Standing abdomen shows: No evidence of subphrenic free air is noted. 
::emp::emphysematous change
::en::enterostomy
::enc::encasement
::enh::enhancement
::enl::enlargement
::ent::status post enterostomy
::ep::emphysematous pyelonephritis
::eps::encapsulted peritoneal sclerosis
::es::extraserosal infiltrations
::et::Status post endotracheal tube insertion and the tip is in the appropriate position
::eti::The etiology should be further evaluated.
::ev::esophageal varices
::eva::evaluation
::exc::can not be excluded.
::ext::extensive
::eyepb::phthisis bulbi
::eyelens::post-phacoemusification
::f::Findings:
::fa::fluid accumulation
::fac::facet joint arthropathy
::fb::No evidence of radiopaque foreign body can be identified. The prevertebral soft tissue is intact.
::fc::fluid collection
::fcl::femoral central venous catheter in the inferior vena cava
::fct::fat-containing tumor
::fcvp::femoral CVP line
::fd::filling defect
::fe::further evaluation
::fec::Increased fecal material retention in the colon is noted
::fem::femoral CVP line is noted
::fen::Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection
::ff::fluid-fluid layering
::ffl::fluid-fluid level
::fib::fibrotic change
::fin::findings
::fixs::posterior internal fixation with rods and screws
::fl::falciform ligament
::fliver::Heterogeneous decreased signal of the liver on out-of-phase images as compared with in-phase images, suggestive of fatty liver
::fm::fecal material
::foc::focal lesion
::fol::A foley catheter insertion is noted.
::fp::fat planes
::fr::fluid retention
::fra::fragments
::fre::No evidence of subphrenic free air is noted.
::fs::fatty strandings
::fth::focal transient hyper-attenutation
::fus::fusiform
::fun::Functioning or non-functioning status should be correlated with clinical findings, such as hypertension
::fx::fracture
::fxra::distal radial head fracture associated with ulnar styloid process fracture is noted; the fracture end extends to the radiocarpal joint; slightly dorsal angulation is noted.
::fxe::fracture ends
::g4::(grade 4)
::ga::focal type of the gall bladder adenomyomatosis
::gba::a focal type of the GB adenomyomatosis is noted
::gcs::greater curvature side
::gda::gastroduodenal artery
::gel::Gelfoam fine particle was injected for hemostasis
::get::Suggest possible gastric empty time study (nuclear medicine) and followed OPD, GI, Dr. 
::gg::Suggest correlation with clinical manifestations.
::ggb::Gamna-Gandy bodies
::ggo::ground-glass opacities
::ghl::gastrohepatic ligament
::gp::unremarkable bowel gas pattern
::gra::grade I of spondylolisthesis
::gs::gall stones
::gt::granulation tissue
::gu::gynecological ultrasound correlation
::h::History of
::hc::hemorrhagic cyst
::hdl::hepatoduodenal ligament
::hecxr::無異常; 胸腔x光不建議用來篩檢肺癌, 若要肺癌篩檢請自費加作低劑量電腦斷層
::hem::hemangioma
::hemo::hemorrhagic
::hep::hepatic cysts are considered temporally in current study; suggest clinical follow-up.
::het::heterogeneous
::hf::hepatic flexure
::hh::hepatic hilum
::hhc::If any problems, please call 53177 (Dr. Huang, Hsu-Cheng). 
::hht::HHT (hereditary hemorrhagic telangiectasia), Osler-Weber-Rendu syndrome,
::hi::head injury
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
::i::Indication: for
::iac::interaortocaval area
::ic::is considered.
::icv::ileocecal valve
::id::identified
::ifu::Indication: for FU study
::ii::is indicated
::ild::interstitial lung disease
::ile::Increased bowel gas and fluid retention are noted in the abdomen, compatible with ileus.
::ilem::Markedly increased bowel gas is noted in the abdomen, compatible with prominent ileus. 
::iles::Slightly increased bowel gas is noted in the abdomen, compatible with mild ileus.
::im::intramedullary nail fixation
::inc::increased
::inci::incidentally
::incl::including
::ind::indentation
::inf::infiltrations
::infv::infiltrative
::ing::inguinal area
::ins::insufficiency
::int::intussusception
::inv::involvement
::ioh::in other hospital
::ip::infectious process
::ipf::interstitial pulmonary fibrosis
::ipi::status post intrathecal pump implantation
::ipp::inflammatory process
::irr::irregular
::isf::is found
::isi::is identified
::isn::is noted
::its::in this study
::iud::Intrauterine device is noted in the pelvic cavity.
::j::joint
::jc::a 4Fr J-curve catheter (Terumo)
::je::jejunostomy
::js::joint space
::jsn::joint space narrowing
::jt::The yellow port is for feeding; the red port is for decompression. Please give the ointments for wound care and peristalsis stimulating drug.
::jy::jejunostomy
::kaml::renal angiomyolipoma
::kb::Knee, both:
::ker::Increased Kerley's lines are noted and congestive heart failure is considered.
::kl::KUB and L-spine show:
::kl2::L-spine shows: 
::koa::knee joint space narrowing with spurs formation, osteoarthritis is compatible.
::kr::Knee, right:
::kub::KUB shows:
::l23::L2/3
::l34::L3/4
::l45::L4/5
::l51::L5/S1
::l451::L4/5 and L5/S1
::la::local anethesia 2% Xylocaine 10ml injection
::lat::lateral segment
::lbv::left brachiocephalic vein
::lc::liver cirrhosis with splenomegaly
::lcs::lesser curvature side
::lcyst::a small low density nodule in the liver; liver cyst is considered in current status
::lcysts::multiple small low density nodules are noted in the liver; liver cysts are considered in current status
::ld::low density
::ldv::left decubitus view
::ldn::low density nodules
::le::increased lung markings with bilateral hilar distribution are noted, suggestive of lung edema
::les::lesser curvature side
::leu::ill-defined low density change at bilateral periventricular white matter, leukoaraiosis is considered
::lf::lung field
::lfs::lung fields
::lga::left gastric artery
::lha::left hepatic artery
::lhv::left hepatic vein
::li::lacunar infarct
::liao::Please consult with Dr. Liao Wei-Chih (PHS 1925) for the evaluation of possible IgG and IgG4 levels.
::lig::ligament
::lil::TAE for lipiodol localization
::lip::lipiodol retentions
::lis::lacunar infarctions
::ljc::Status post a left jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::ljcb::Status post a left jugular venous approached central venous pressure line is noted with tip in the left brachiocephalic vein.
::lk::left kidney
::lkl::If any problems, please call 51685 (Dr. Liu, Kao-Lang).
::ll::left lobe of liver
::lll::left lower lung
::lm::lung markings
::lo::the larger one is
::lob::lobulated
::loc::no evidence of local residual tumor is noted
::lp::locking pigtail
::lpa::Left Port-A insertion from left subclavian vein is noted with tip in the superior vena cava.
::lpaj::Left Port-A insertion from left jugular vein is noted with tip in the superior vena cava.
::lpab::Left Port-A insertion from left subclavian vein is noted with tip in the distal brachiocephalic vein.
::lps::left psoas shadow is clear.
::lrad::A radiopaque density is noted in the left pelvis; a left distal ureteral stone can not be excluded.
::lrs::The left renal shadow is not well delineated
::lrst::left renal stone
::ls::left side
::lsc::a left subclavian venous approached central venous pressure line is noted with tip in the superior vena cava.
::lss::(lower sensitivity of the non-enhanced study)
::lstv::lumbosacral transitional vertebrae (LSTV): Castellvi classification IIa
::lt::liver tumor
::ltae::TAE for lipiodol localization
::ltc::Please consultation with Dr. Lee, Tsung-Chun (phone: 51867) for further evaluation.
::lul::left upper lung
::lum::Lumbosacralization (Bertolotti syndrome) is noted on
::lun::No definite focal lung lesions are noted.
::lus::lumbar spine
::lyh::If any problems, please call 53439 (Dr. Lin, Yen-Heng). 
::lym::lymphangitis carcinomatosis
::ma::Suggest gentle and manual aspiration of the pigtail with 10-ml syrinage; if no drained amount, please followed imagnig study to evaluate the abscess condition. 
::max::maxillary sinus
::max2::maxillary sinuses
::mc::metacarpal bone
::mcbd::status post a metallic common bile duct stent
::md::maximal diameter
::mea:: the size is not measuable
::med::mediastinum
::met::metastases
::mha::middle hepatic artery
::mhv::middle hepatic vein
::missfb::the foreign body could be missed, which is mixed with calcification of the laryngeal cartilages
::mk::markedly
::ml::mass lesion
::mmph::multifocal micronodular pneumocyte hyperplasia (MMPH)
::mo::more obvious
::mor::CT morphology of
::morl::CT morphology of low-grade submucosal esophageal varices is noted.
::morh::CT morphology of high-grade submucosal esophageal varices is noted; correlation with endoscopic findings is indicated
::morn::CT morphology of submucosal esophageal varices is not identified
::mrc::MRCP reveals no evidence of bile ducts or pancreatic duct dilatation; no anomalous pancreaticobiliary union.
::mrchange::normal CEA, CA19-9, ANA, IgG and IgG4
::mrcn::cirrhotic nodules in both lobes of liver, mixed with regenerative nodules and dysplastic nodules, presenting as hyperintensity on T1W, hypointensity on T2W, and no enhancement.
::mrdn::with increased hyperintensity on T1W, isointensity to hypointensity on T2W and no definite enhancement after contrast medium injection; dysplasia nodules are favored.
::mrfnh::slight hypointensity on T1-weighted images, slight hyperintensity on T2-weighted images, and global enhancement on early arterial phase, near isointensity on delayed enhanced images; compatible with FNH.
::mrhcc::hypointensity on T1-weighted images, slight hyperintensity on T2-weighted images, and global enhancement on early arterial phase, rapid washout on delayed enhanced images; compatible with HCC.
::mrhem::hypointensity on T1-weighted images, hyperintensity on T2-weighted images, and peripheral patches enhancement on dynamic contrast-enhanced study, persistent enhancement on delayed contrast-enhanced images; compatible with liver hemangioma.
::mrprostate::with hypointensity on T2W, hyperintensity on DWI, hypointensity on ADC and early enhancement in early dynamic study; the prostate cancer is compatible
::mrwu::(MR cardiac perfusion was performed but the MR renal perfusion was not carried out in this machine)
::ms::medial segment
::msf::marginal spur formation
::mss::maxillary sinuses
::mt::metatarsal bone
::mu::myoma uteri
::mul::multiple
::n::normal
::na::there is no ascites
::nat::Nature to be determined
::nb::no definite destructive bone lesion or joint dislocation; however, small osseous lesion, occult fracture, or soft tissue lesion may not be detected on plain film radiograph; recommend clinical correlation
::nc::normal CEA, CA19-9, CA-125, TSH, free T4, RA factor, ANA, Anti-DNA (EIA), ant-SS-A, anti-SS-B, IgG, IgG4, Anti-Thyroglobulin Ab (TA), anti-TPO Ab (AMA)
::nce::no contrat medium enhancement
::ne::no evidence of
::nect::non-enhanced computed tomography of chest
::net::NET (neuroendocrine tumor)
::neu::neuroforaminal narrowing
::nextrfa::The next RFA for the tumor at the S3 of left lateral segment will be arranged on 2011/09/06 p.m. on call; please arrange admission on 09/05 or 09/06 a.m. with NPO. If admission is not available, please call us for arrangement; (CT room 62299; 62301). 
::nf::no definite focal lesions
::nfa::no definite focal lesions in the abdomen
::nfp::no definite focal lesions in the pelvic cavity
::ng::Nasogastric tube insertion is noted with tip in the stomach.
::nh::normal heart size
::nic::no interval change
::nihrfa::The NIH-paid RFA needle will be applied and the reply will be back within two weeks; please arrange the RFA two weeks later.
::nk::Bilateral psoas shadows are clear. No evidence of radiopaque stone is noted. Non-specific bowel gas distribution is noted.
::nkc::No evidence of subphrenic free air is noted. Nonspecific bowel gas distribution is noted.  No evidence of focal bone lesions is noted.
::nl::No definite focal bone lesions are noted in the lumbar spine and the alignment is intact.
::nm::no evidence of metastatic lesions in the abdomen
::nn::nodular lesion
::nns::nodular lesions
::nod::nodular and contracted liver contour is noted
::non::non-specific bowel gas distribution is noted.
::non1::the condition should be correlated with the clinical picture in order that any additional investigatinos may be carried out without delay.
::nos::no solid or enhanced part is noted.
::notae::The imaging pattern hints the limited effect of embolization and increased or aggravated liver cirrhosis if embolization; clinical follow-up or local treatment is more favored in choice. Liver transplantation is a candidate.
::nr::no evidence of recurrent tumors
::nrm::no evidence of recurrent or metastatic lesions in the abdomen
::nrr::no evidence of residual or recurrent tumor.
::ns::non-specific
::nse::no solid or enhanced parts
::nsta::No evidence of focal bone lesions is noted.  Non-specific bowel gas distribution is noted. Suggest correlation with clinical manifestations. 
::nti::N/G tube insertion will be arranged today as soon as possible. Thanks for your consultation and please call 62608/ or 62612 (angio-room) if any problems.
::nuc::nuchal ligament calcification is noted.
::obl::obliteration
::obs::obstruction
::obsl::obstructive level
::oc::operative change
::og::old granulomatous disease
::ogd::old granulomatous disease
::oh::in other hospital
::oj::obstructive jaundice
::ol::obstructive level
::oll::only lipiodol localization
::om::obstructive mass
::oo::osteopenia
::opa::opacification
::opcolon::operative change of the colon; no evidence of local recurrence is noted; non-specific bowel gas distribution is noted.
::opgyn::status post operative change of the gynecological organs; no evidence of local recurrence is noted.
::opkidney::operative change of the kidney; no evidence of local recurrence is noted; 
::opstomach::operative change of the stomach; no evidence of local recurrence is noted; non-specific bowel gas distribution is noted.
::ora::oral contrast medium
::os::osteoarthritis
::osf::osteophyte formation
::osteo::osteopoikilosis
::otb::increased fibrocalcified lesions are noted in the bilateral upper lung fields; old granulomatous disease is considered. 
::ou::obstructive uropathy
::ov::overriding
::paa::porcelian abdominal aorta
::pa::paraaortic areas
::pac::a pacemaker insertion is noted.
::pacs::Medical images from outside Hospital for shared information has been successfully uploaded into the PACS (Picture Archieving and Communication System) server for reference purpose. Please check the attached original formal report of the source Hospital. If a second opinion of these images is required, please send a formal consultation to the Department of Medical Imaging with a mention of "Request a Second Opinions".
::pan::pancreatic
::par::parenchymal
::para::Paranasal sinuses are clear.
::paraev::paraesophageal varices are noted.
::pb::pneumobilia
::pbg::prominent bowel gas is noted; non-specific bowel gas distribution is considered
::pc::pelvic cavity
::pcbd::status post a plastic common bile duct stent
::pce::pericardial effusion
::pcs::portocaval space
::pd::Status post Tenchkoff catheter replacement with tip in the
::pe::pericardial effusion
::ped::bilateral pedicles are intact.
::peg::PEG will be performed on W2 morning; please midnight NPO or NPO > 8hrs. Please evaluate the appropriate antibiotics for the patient by using Cefa (1 g) or using Augmentin (2 vials) (please check possible allergy of penicillin) before procedure if no underlying antibiotics usage. Also, plea keep antibiotics for 3 days after the procedures. Thanks for your consultation and please call 51685 (Liu, Kao-Lang) if any problems.  
::pegj::Decreased peristalsis of the stomach is noted; prominent colon gas, indicating ileus. A 5Fr H1 insertion into the stomach first; then 150 cm guidewire was delivered and this 5Fr H1 was adjusted into the duodenum.  Therefore, the gastrojejunal tube (12Fr in 24Fr) was delivered smoothly with tip in the proximal jejunum. Prevention from tube occlusion was educated. Please give peristalsis-stimulating drugs (such as Motilin or Mopride; 1# tid); Local wound care ointment (such as Bacitracin Neomycin Ointment; Zinc oxide ointment).
::pelvimetry::The pelvimetry:The measurement of obstetric conjugate, anatomic conjugate, diagonal conjugate, pelvic outlet and bispinous diameter should be correlated with clinical findings. No evidence of focal bone lesions.
::per::peritoneal cavity
::perfusionstudy::If the patient's history is compatible with renal artery stenosis related renal hypertension and the patient has the indication for renal artery stent, a study for MR renal perfusion can be performed for this patient; If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
::peri::peripheral
::peric::pericardial effusion
::perih::perihepatic space
::pev::paraesophageal varcies are noetd
::pfj::patellofemoral joint
::ph::phlebolith
::pha::proper hepatic artery
::phl::A phlebolith is noted in the pelvis on
::phls::Phleboliths are noted in the pelvis on
::pi::pneumatosis intestinalis
::pif::pulmonary interstitial fibrosis
::pj syndrome::Peutz-Jeghers syndrome
::pla::pleural plaques
::placenta::Under local anesthesia with 2% 10ml xylocaine for bilateral inguinal areas, 8Fr check-flow sheaths were inserted into bilateral femoral arteries and then 6Fr balloon catheters were introduced through each check-flow sheath into appropriate location of unilaterally bilateral common iliac arteries.  Maximal amount of 2ml Normal Saline (suggested amount is 1.5ml) could be administered through the balloon port of the balloon catheter to inflate the balloon if clinically indicated.  Please remove these two catheters and sheaths as soon as possible with the balloon deflated.  Further compression of the puncture wounds with sandbag for 6 hours and complete bed rest for 12 hours after removal of the intra-arterial devices is necessary for post-angiography care.  Be aware of potential complication such as local hematoma.
::ple::pleural effusions
::pm::pneumonia
::pmf::peripheral mass-forming type of cholangiocarcinoma
::pms::posterior marginal spur formation
::pne::no evidence of pneumonic patches in both lung fields
::pn::status post percutaneous nephrostomy on
::pns::status post percutaneous nephrostomy on both sides
::po::partial obstruction
::pop::popliteal artery
::pops::popliteal arteries
::pos::posterior
::pp::in the portal venous phase
::premr::(the specific liver contrast medium should be specially arranged; please call MR room 52540 or Dr. Liu, Kao-Lang 51685). 
::prev::prevertebral soft tissue density
::pri::compared with prior
::primo:: Primovist MR study may be considered in next followed study (liver specific MR contrast medium; specially arranged; please call MR room 62540 for arrangement; or Dr. Liu, Kao-Lang 51685 or Dr. Chang, Chin-Chen 53315).
::primomr::(the primovist contrast medium should be especially arranged, please call MR room 62540 for arrangement; if any problems, please call Dr. Liu, Kao-Lang 51685, or Dr. Chang, Chin-Chen 55520).
::pro::prominent
::progreat::a 2.7Fr microcatheter (Progreat; Terumo)
::ps::psoas shadow is not well delineated.
::psc::phlebosclerotic colitis
::pt::pneumothorax
::pul::pulmonary
::pun::PTCD, smoothly performed, once puncture.
::pv::portal vein
::pvt::portal vein thromobses
::pz::peripheral zone
::qua::decreased quality of the film is noted, and the details cannot be well evaluated.
::r::right
::ra::radiopaque
::rad::No definite radiopaque density is noted in the urinary collecting system.
::rc::腎臟有單純水泡變化.此種變化是良性的,通常不需要追蹤檢查.隨著年紀的增加,這種單純的水泡也會有數量上以及大小上的增加. 國外的統計上有一半以上的五十歲之檢查者有此項發現.
::rcj::radiocarpal joint
::rcs::renal cysts
::rd::radiopaque density
::rea::The study was reassigned on 2014/09/18
::rear::The study was assigned due to request films on 2013/0
::reg::regenerative nodules
::rem::remarkable
::rene::a 2.5Fr microcatheter (Renegade; Boston Scientific)
::res::(respiratory motion artifacts make less sensitivity and specific quality)
::rf::requested films
::rha::right hepatic artery
::rhv::right hepatic vein
::ril::right lobe of liver
::rjc::a right jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::rk::right kidney
::rl::right lobe of liver
::rll::right lower lung
::rlq1::increased fatty infiltration (grade: mild) in the RLQ with marked appendical wall thickening without obvious intraluminal air.  The wall of cecum and the terminal ileum are intact.  No appendicolith is noted.  There are no evidence of signs of rupture of the acute appendicitis.
::rm::no evidence of recurrent or mets lesions
::rml::right middle lung
::rn::radiopaque nodule
::rpa::right Port-A insertion from right subclavian vein is noted with tip in the superior vena cava.
::rpaj::right Port-A insertion from right jugular vein is noted with tip in the superior vena cava.
::rps::right psoas shadow is clear.
::rpy::retrograde pyelography
::rrs::the right renal shadow is not well delineated
::rs::right side
::rsc::a right subclavian venous approached central venous pressure line is noted with tip in the superior vena cava.
::rss::radiopaque nodules are superimposed with renal shadow, suggestive of
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
::sa::non-specific small LNs in the abdomen; (the short axis is less than 15 mm)
::sa1::Study: monophasic abdominal CT, without contrast enhancement
::sa2::Study: 2 phases of abdominal CT, without and with contrast enhancement
::sa3::Study: 3 phases of abdominal CT, without and with (arterial and portal venous phases) contrast enhancement
::sa4::Study: 4 phases of abdominal CT, without and with (arterial and portal venous and delayed phases) contrast enhancement
::sb::small bowel
::sbe::The small bowel embolization is still a risky issue and the long-term follow-up evidence is still scant. Possible short term and long term of complications (perforation, stenosis etc) should be followed and alerted.
::sbtube::Sengstaken-Blakemore tube
::sc::surgical clips
::sc1::Study: monophasic chest CT, without contrast enhancement
::sc2::Study: biphasic chest CT, without and with contrast enhancement
::scl::sclerotic change
::sco::scoliosis of the spine
::scot::scoliosis of the thoracic spine
::scol::scoliosis of the lumbar spine
::sdt::surgical drainage tubes
::se::subcutaneous emphysema
::seml::subepithelial mass lesion
::sf::splenic flexure
::sfol::suprapubic foley catheter insertion
::sg::a Swan-Ganz catheter insertion is noted with tip at the
::sh::shadow
::sho::should be correlated with clinical findings.
::si::The soft tissue injury should be correlated with clinical findings.
::sic::Sitting CXR shows:
::sij::sacro-iliac joint
::sl::the Shenton line is intact.
::sl10::1.7Fr microcatheter (SL-10; Boston Scientific)
::sli::slightly
::sln::A small nodule (< 1cm) is identified at , only identified in the arterial phase, not identified in the portal venous phase. Small HCCs or small arterioportal shunts are possible.  Due to severe liver cirrhosis with diffuse cirrhotic nodules, clinical follow-up is favored. Further evaluation or management is not recommended. 
::smc::spinal meningeal cysts
::so::suggestive of
::solu::solu-cotef (Hydrocortisone Sodium Succinate; 100mg)
::sp1::Study: abdominal and pelvis CT, without contrast enhancement
::sp2::Study: 2 phases of abdominal and pelvis CT, without and with contrast enhancement
::sp3::Study: 3 phases of abdominal and pelvis CT, without and with (arterial and venous phases) contrast enhancement
::sp4::Study: 4 phases of abdominal and pelvis CT, without and with (arterial, nephrogenic and delayed phases) contrast enhancement
::spl::splenomegaly
::spo::spondylosis of the spine is noted
::spoc::spondylosis of the cervical spine is noted
::spol::spondylosis of the lumbar spine is noted
::spoi::spondylolisthesis
::spoy::spondylolysis
::spu::Study: 3 phases of abdominal and pelvis CT, without and with (nephrogenic and delayed excretory phases) contrast enhancement
::ss::not sensitive and specific for this findings
::st::soft tissue
::sta::Standing abdomen shows:
::ste::Status post operative change with sternotomy is noted
::stc::Standing CXR shows:
::std::soft tissue density
::stenosisofima::suspected stenosis of the celiac axis and IMA with dilated arc of Buhler, arc of Riolan, and marignal artery of Drummond.
::sto::stool impaction is compatible.
::sts::soft tissue swelling
::su::suggest
::sub::subpotimal study with motion artifacts which may obscure image details.
::subch::subchondral sclerosis
::suc::Supine CXR shows:
::sus::suspected
::sur::surrounding
::sv::seminal vesicle
::sw::superimposed with
::t/d::Total/ direct bilirubin = 
::ta::torturous aorta
::tbc::tracheobronchial calcifications are noted.
::td::the trachea is deviated to
::te::teaching_
::tha::Thanks for your consultation and please call 51685 (Liu, Kao-Lang) if any problems.
::thad::THAD (transient hepatic attenuation differences)
::thi::thickening
::ti::terminal ileum
::tli::several tiny low density nodules are noted in the liver and liver cysts are considered in current study.
::tnmrectum::Rectal cancer: distal rectum.  ---T: T3, abnormal thickening and enhancing wall with increased fatty strandings in the perirectal space.  ---N: N1c, small LNs in the perirectal space; there is no evidence of paraaortic LAPs in abdomen; there is no evidence of LAPs in pelvic cavity and bilateral inguinal areas.  ---M: M0, multiple liver cysts; no definite mets; but slightly increased fatty strandings in the omentum should be followed.  ---The local staging is favored as cT3N1cM0.
::tnmkidney::Renal cancer: right kidney.  ---T: T1b, right kidney; a well-defined renal mass 46.3 mm is noted at the right kidney without definite fat density or calcifications; the tumor is solid but heterogeneous enhancement; the pattern should exclude the RCC (such as chromophobe type) first; the differential diagnosis includes the fat-paucity of renal angiomyolipoma. Accorrding the imaging pattern, partial or total nephrectomy is first considered even though the AML is differentiated.  ---N: N0, no regional LNs.  ---M: M0, no definite distant metastases.  ---The local staging is favored as cT3N1cM0.  
::tnmstomach::---T: T3, abnormal thickening and enhancing wall with increased fatty strandings; ---N: N2, small LNs (3-6) in the regional areas and lesser omentum;---M: M0, no definite metastases in the abdomen; ---The local staging is favored as cT3N2M0. 
::tra::Status post tracheostomy
::tri::Triphase dynamic abdominal CT study (pre-, arterial- and portal venous phases) for the
::tsai::Please inform us for renal perfusion study: pre- and post-transplant for donor if the patient is admitted; If any problems, please call 51685 (Dr. Liu, Kao-Lang).
::tsc::tuberous sclerosis complex
::tstc::too small to be characterized
::tstd::The size of cysts is too small to be differentiated. Clinical follow-up or correlation is indicated.
::ty::typical
::tz::transitional zone
::ub::urinary bladder
::uc::uterine cavity
::ug::ultrasound guidance
::ukr::status post unicompartment knee replacement (Howmedica)
::unc::uncinate process
::unk::unknown (unavailable) history in N hospital
::ur::ureteral
::usg::freehand and real-time ultrasound-guided
::usf::ulnar styloid process fracture
::usp::ulnar styloid process
::uti::urinary tract infection
::vb::vertebral body
::vbh::vertebral body height
::vc::voiding cystourethrography
::vh::vertebral body height
::vp::vertebroplasty
::vps::ventriculo-peritoneal shunt
::vr::valvular replacement
::vs::The vascular sheathh was placed in the right femoral artery for possible further angiography; please remove it as soon as possible and prevent it from thrombosis.
::w::with
::wal::abnormal thickening and enhancing wall
::wc::please give the wound care ointments, such as Bacitracin-Neomycin ointmwnt "Shiteh" and Zinc Oxide ointment.
::wd::well-defined
::wi::widening
::wic::without internal change
::wm::white matter
::ws::wedge-shaped deformity
::wyw::Suggest consultation with Dr. Wu Yen-Wyne (phone: 51388) for possible FDG and FLT PET-CT for cholangiocarcinoma study.
::ycd::If any problems, please call Jian-De Ye (51291).
::yfc::For the screening of the possible cerebral aneurysms, please consultation with Dr. Chen, Ya-Fang (phone: 51623) for further evaluation.

::ab::
(
After biopsy/ RFA
Severe hemorrhage 0.35-1.7%
Observation 4 hours
Vital signs 15 min/ for 1 hour
Vital signs 30 min/ for 2 hour
Vital signs 1 hour
48 hours內不要提重物或肚子太用力。
若有問題，please call Liu, Kao-Lang (51685).
)
::bb::
(
Before biopsy/ RFA
停用Aspirin and plavix/ 7-10 days前；
停用Warfarin/ 5-7 days前；
停用Heparin/ 6-12 hours
)
::biliarystent::
(
History of colon cancer, adenocarcinoma, s/p operation, pT3N2bM1b with peritoneal carcinomatosis, s/p chemotherapy; obstructive jaundice Total/ direct bilirubin = 7.78/ 3.7 mg/dl (2014/12/05); status post left PTCD 2014/12/09.

Anethesia:
Fentanyl 0.1 mg IV push slowly with local 2% Xylocaine 10ml injection;
Dormicum 3.75 mg intravenous before balloon dilatation;

For biliary stenting.
1. Cholangography showed the CBD and duodenum were not opacified; compatible with CBD obstruction.
2. The previous 6Fr pigtail was exchanged with an 8Fr vascular sheath. However, fresh blood sprouted from the tract; hepatic artery bleeding could not be excluded due to the fresh color. 
3. Then a 4Fr Cobra catheter and 0.035-in guidewire manipulation was smoothly and successfully performed with catheterization of the CBD and duodenum. The flow of duodenum was intact.
4. Obstructive level was about 60 mm.
5. After balloon dilatation (7mm x 80mm Rival BARD; 10mm x 40mm; Advance, Cook), a covered biliary stent (10mm x 80mm; Nitis, Korea) was inserted.
6. The sheath was removed; then an 8Fr pigtail was inserted to keep the tract.
Please external clamp of the pigtail for observation if no hemobilia.
If any problems, please call 51685 (Dr. Liu, Kao-Lang).
CBD obstruction status post biliary stent, covered.
)
::biopsylap::
(
For the CT-guided biopsy of the right paraaortic LAP:
1. the patient is in prone position on the CT table.
2. Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection
3. a 17G coaxial needle insertion via the right posterior abdominal wall.
4. adjust the coaxial needle in the tumor and an 18 biopsy gun was used.
5. three tissue cords, 2.2 cm, in different direction were taken and 3 cytology prints.
6. the tract was embolized with gelfoam fine particle; no immediate complications after the procedure.
Suggest close f/u the vital signs and possibility of complications (local hematoma).
If any problems, please call 51685 (Dr. Liu, Kao-Lang).

status post plugged LAP biopsy. 
)
::biopsykidney::
(
History of Large B cell neurolymphomatosis with central nervous system involvement, status post R-HDMTX (VI); status post triple intrathecal therapy(IV); status post consolidation R-ESHAP (II); status post autologous peripheral stem cell harvest on 2014/3/11, 3/12, status post autologous peripheral blood stem cell transplantation (CD34+= 8.5 x10^6/kgBW, D0=2014/5/6), in complete remission status.

For the US- or CT-guided biopsy of the left renal tumor:
1. the patient is in prone position on the CT table.
2. Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection
3. a 17G coaxial needle insertion via the left posterior abdominal wall.
4. adjust the coaxial needle in the kidney tumor and an 18 biopsy gun was used.
5. three tissue cords, 2.2 cm, in different direction were taken and 3 cytology prints.
6. the tract was embolized with gelfoam fine particle; no immediate complications after the procedure.
Suggest close f/u the vital signs and possibility of complications (local hematoma).
If any problems, please call 51685 (Dr. Liu, Kao-Lang).
status post plugged kidney biopsy. 
)
::biopsyliver::
(
History of  

For the US- or CT-guided biopsy of the liver dome tumor:
1. the patient is in supine position on the CT/ angioroom table.  
2. Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection 
3. a 17G coaxial needle insertion via the right lateral chest/ abdominal wall.
4. adjust the coaxial needle in the liver tumor and an 18 biopsy gun was used.
5. three tissue cords, 2.2 cm, in different direction were taken and 3 cytology prints. 
6. the tract was embolized with gelfoam fine particle; no immediate complications after the procedure.
Suggest close f/u the vital signs and possibility of complications (local hematoma).
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 

status post plugged liver biopsy.
)
::cryo::
(
History of right renal cystic tumor (4.4 cm).

Cryotherapy was done as followings:
1. Pre-contrast CT is done in prone position for visualize the renal tumor.
2. After skin disinfection, local anesthesia and draping, the biopsy to the renal tumor is done with a 17G coaxial needle inserton and about 15ml of fluid was aspirated for cytotoloy; then an 18G biopsy needle was used. 3 tissue stripes and 3 imprint smears are taken for exam. 
3. Cryosystem: Galil Medical, IceRod 1.47mm 17-gauge needle * 3 (-20C: 27 mm * 50 mm, sample). The cryosystem is inserted to the renal tumor parallel to the coaxial needle after local anesthesia and fentanyl 0.05mg IV.
4. Double freeze-thaw cycle was performed: 
 1) 10 minutes of freezing, 6 minutes of passive thawing, 3 minutes of active thawing.
 2) 10 minutes of freezing, 6 minutes of passive thawing, 3 minutes of active thawing.
5. The range of iceball is verified by CT at the end of every freezing session during the freeze-thaw cycles. The target lesions are confirmed within the hypodence iceball coverage. 
6. Post-procedure CT showed adequate hypodensed area covering the renal tumor. The patient had tolerated the procedure well.
7. Suggest monitor vital signs and follow up contrast-enhanced CT one month after this treatment.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::dbjinlayleft::
(
Indication: status post left PCN by urologist; for left DBJ.
The patient was in prone position.
Fentanyl 100 ug IV push slowly with local 2% Xylocaine 10ml injection.
The left PCN was exchanged with an 8Fr vascular sheath insertion to the left renal pelvis. 
Under the fluoroscopy, the antegrade pyelography showed total obstruction of the contrast medium at the left upper ureter (L3/4 level); 
The distal ureter and urinary bladder could not be catheterized with a 4Fr cobra catheter and a 0.035-inch guidewires manipulation and a 2.7Fr microcatheter (Progreat; Terumo) was applied and the distal ureter was catheterized; a 7Fr 22 cm DBJ (InLay; BARD; 3-6 months) was inserted smoothly after balloon dilatation (6mmx150mm; Rival, BARD). 
The vascular sheath was removed, and replaced with an 8Fr 25 cm pigtail; 
 
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::dbjinlayright::
(
Indication: for right DBJ.
The patient was in left lateral position.
Fentanyl 50/100 ug IV push slowly with local 2% Xylocaine 10ml injection.
The right PCN was exchanged with an 8Fr vascular sheath insertion to the right renal pelvis. 
Under the fluoroscopy, the antegrade pyelography showed total obstruction of the contrast medium at the right distal ureter (L5/S1 level); 
The distal ureter and urinary bladder could not be catheterized with a 4Fr cobra catheter and a 0.035-inch guidewires manipulation and a 2.7Fr microcatheter (Progreat; Terumo) was applied and the distal ureter was catheterized; a 7Fr 22 cm DBJ (InLay; BARD; 3-6 months) was inserted smoothly after balloon dilatation (6mmx150mm; Rival, BARD). 
The vascular sheath was removed, and replaced with an 8Fr 25 cm pigtail; 
 
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::dbjtumorstentleft::
(
History of left ovarian cancer and endometrioid adenocarcinoma, with intestine invasion, stage IV, status post total hysterectomy, bilateral salpingo-oophorectomy, pelvic lymph node dissection and Hartmann procedure, status post adhesionolysis and colostomy revision, status post systemic chemotherapy with Phyxol and Carboplatin (VI). Presacral soft tissue and right ureteral stone causing right side hydronephrosis found on CT (2013/07/08). S/p right ureteral catheter placement; s/p PCN 2014/11/11.

Indication: for left DBJ.
The patient was in prone position.
Fentanyl 50/100 ug IV push slowly with local 2% Xylocaine 10ml injection.
The left PCN was exchanged with an 8Fr vascular sheath insertion to the left renal pelvis.
Under the fluoroscopy, the antegrade pyelography showed total obstruction of the contrast medium at the left distal ureter (L5/S1 and distal ureter to UVJ level);
The distal ureter and urinary bladder could be catheterized with a 4Fr cobra catheter and a 0.035-inch guidewires manipulation; a 7Fr 22 cm tumor stent DBJ (BARD; 12 months) was inserted smoothly after balloon dilatation (6mmx150mm; Rival, BARD).
The vascular sheath was removed, and replaced with an 8Fr 25 cm pigtail;

If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::dbjtumorstentright::
(
History of left ovarian cancer and endometrioid adenocarcinoma, with intestine invasion, stage IV, status post total hysterectomy, bilateral salpingo-oophorectomy, pelvic lymph node dissection and Hartmann procedure, status post adhesionolysis and colostomy revision, status post systemic chemotherapy with Phyxol and Carboplatin (VI). Presacral soft tissue and right ureteral stone causing right side hydronephrosis found on CT (2013/07/08). S/p right ureteral catheter placement; s/p PCN 2014/11/11.

Indication:  for right DBJ.
The patient was in left lateral position.
Fentanyl 100 ug IV push slowly with local 2% Xylocaine 10ml injection.
The right PCN was exchanged with an 8Fr vascular sheath insertion to the right renal pelvis.
Under the fluoroscopy, the antegrade pyelography showed total obstruction of the contrast medium at the right distal ureter (L5/S1 and distal ureter to UVJ level);
The distal ureter and urinary bladder could be catheterized with a 4Fr cobra catheter and a 0.035-inch guidewires manipulation; a 7Fr 22 cm tumor stent DBJ (BARD; 12 months) was inserted smoothly after balloon dilatation (6mmx150mm; Rival, BARD).
The vascular sheath was removed, and replaced with an 8Fr 25 cm pigtail;

If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::diaphragm fluoroscopy::
(
Diaphragm fluoroscopy (Sniff test) is done smoothly, which shows:
-- symmetrical diaphragmatic movement of both hemidiaphragms at rest, except during/after coughing and when taking deep breathe.
-- After a few times of deep breathing, the patient presents with asymmetric diaphragm movement, with relatively fixed left hemidiaphragm but rapid small movements of the right diaphragm; 
)
::drainageabscess::
(
NECT for the US-guided and CT-guided drainage of the 
1. the patient is prone position in the CT table.
2. Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection 
3. Description of procedure and findings:
- Informed consent was obtained. The patient was prepped and draped in the usual sterile fashion with monitoring of vital signs.  Sonography and non-contrast CT disclosed low density reigon at the posterior right lobe. A 6-Fr 25cm pigtail was then inserted sonography guidance, with the end loop positioned in center of the abscess. Dark brown turbid bile was aspirated and injected into the drainage bag. The drainage catheter was secured to the skin with a suture and the exit site was covered with a dry sterile dressing.
- The patient tolerated the procedure well, with no immediate complications, and was returned to the ward in good condition.
4. suggest gentle and manual aspiration of the pigtail with 10-ml syrinage; no irrigation; if no drained amount, please followed imagnig study to evaluate the abscess condition.

No obvious discomfort was complained after the procedure.
Post-procedure vital signs: stable.
Please be careful of the possible complications (internal bleeding etc.), even though the procedures were very smoothly performed.
Further evaluation or any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::hemr::
(
History of Cancer Screening.
Study: MRCP and MR study of abdomen and pelvis.
Machine: Siemens, Verio 
Contrast medium: without iv contrast medium.

Findings:
1. Liver: normal.
2. Spleen: normal.
3. Pancreas: normal.
4. MRCP: no evidence of bile ducts or pancreatic duct dilatation; no anomalous pancreaticobiliary union. 
5. Kidneys: normal; (non-enhanced MR study is not sensitive and specific for detection of the small renal/ ureteral stones without hydronephrosis; or the small ureteral tumor without hydronephrosis)
6. Adrenals: normal.
Pelvis-
7. Urinary bladder: normal.
8. Prostate & seminal vesicles: normal (occult prostate cancer can not be well detected in this screening study)
8. Uterus, cervix, adnexa: normal. (stage Ia or CIS of cervical lesions can not be defected in this screening study)
)
::gasr::
(
Indication: for tube replacement 
A new 24Fr gastrostomy tube was replaced smoothly. 
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::mrb::
(
Study: MRCP; MRA; MR study of abdomen
Machine: Siemens, Biograph MP
Contrast medium: without and with iv contrast medium.
Indication: for
Findings:
1. 
)
::mrenterography::
(
History of Crohn disease

Study: MR enterography; MRA; MR study of abdomen
Machine: Siemens, Verio V40412
Contrast medium: without and with iv contrast medium.
Indication: for evaluation 
Findings:
1. inflammatory process is prominent at the terminal ileum with abnormal thickening and enhancing wall; Crohn disease is compatible. Surrounding mesenteric fat deposition is not increased. No evidence of fistula formation. No regional abscess.  No obvious regional LNs. 
2. MRCP reveals no evidence of bile ducts or pancreatic duct dilatation; no anomalous pancreaticobiliary union. 
3. bilateral femoral heads are intact; 
4. there is no evidence of paraaortic LAPs in abdomen; there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
5. there is no ascites
6. there are no focal lesions in the liver, spleen, pancreas, both adrenal and kidneys
7. no definite focal lesions in the pelvic cavity 
)
::mrg::
(
Study: MRA; MR study of abdomen.
Machine: GE, signa excite 
Contrast medium: without and with iv contrast medium.
Indication:
Findings:
1. 
)
::mrh::
(
Study: MRCP; MRA; MR study of abdomen.
Machine: GE, signa HDx 
Contrast medium: without and with iv contrast medium.
Indication: for 
Findings:
1. 
)
::mrs::
(
Study: MRCP; MRA; MR study of abdomen
Machine: Siemens, Sonata S
Contrast medium: without and with iv contrast medium.
Indication: for 
Findings:
1. 
)
::mrt::
(
Study: MRCP; MRA; MR study of abdomen
Machine: Siemens, Tim 
Contrast medium: without and with iv contrast medium.
Indication: for 
Findings:
1. 
)
::mrv::
(
Study: MRCP; MRA; MR study of abdomen 
Machine: Siemens, Verio V
Contrast medium: without and with iv contrast medium.
Indication: for 
Findings:
1. 
)
::ng2::
(
Indication: for difficult N/G tube insertion
Fluoroscopic nasogastric tube was smoothly performed:
1. a 300 cm, 0.035 guidewire within the 5Fr H1 was inserted into the stomach smoothly.
2. the 16Fr silicone NG tube was exchanged into the stomach.

Suggest exchange N/G tube 2 months later.
Please call 51685 (Dr. Liu, Kao-Lang) if any problems.

difficult N/G insertion, smoothly performed. 
)
::nj14::
(
History of Esophageal cancer, squamous cell carcinoma, 35-40cm below incisors, cT3N0M0, status post port-A insertion and laparoscopic jejunostomy, neoadjuvant chemoradiation and minimally invasive Ivor Lewis esophagectomy, T3N0M0, IIa.

Indication: for N/J tube insertion.
Fluoroscopic nasojejunal tube was smoothly performed:
1. no N/G tube was noted.
2. a 300 cm, 0.035 guidewire was inserted via a 5Fr 125-cm H1 was inserted smoothly into the gastric tubing.
3. the anastomosis was not opacified by the contrast medium; the anastomosis was easily catheterized by the H1; then the 300 guidewire was delivered to the jejunum.
4. the 14Fr N/J tube (Tiger, Cook) was inserted into the proximal jejunum; the duodenum and jejunum were smoothly opacified with intact peristalsis.

Suggest exchange the N/J tube 2 months later.
The drug powder should feed 2-3 times separately.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::nj2::
(
Indication: for N/J tube insertion. 
Fluoroscopic nasojejunal tube was smoothly performed:
1. the N/G tube was noted in the stomach for decompression. 
2. a 300 cm, 0.035 guidewire was inserted via a 5Fr 100-cm H1 was inserted smoothly into the stomach.
3. the duodenal bulb was not opacified by the contrast medium; the duodenal bulb was easily/ difficultly catheterized by the H1; then the 300 guidewire was delivered to the jejunum.
4. the 16Fr N/G tube was inserted into the proximal jejunum; the duodenum and jejunum were smoothly opacified with intact peristalsis.

Suggest exchange the N/J tube 2 months later.
The drug powder should feed 2-3 times separately.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::pcnl::
(
The patient was in prone position.
Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection 

For the left PCN:
PCN was smoothly performed via left posterior approach under freehand and real-time ultrasound-guided with an 18G Chiba needle; then with Seldinger technique under fluoroscopy, an 8 Fr 4 sideholes 25cm pigtail catheter was inserted through the lower pole with catheter looping in the left renal pelvis.
No gross hematuria is noted after the procedures.
Left UPJ stones are noted. 
Pus-like urine is noted. 

If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::pcnr::
(
History of cervical cancer status post left PCN.

Indication: for right hydronephrosis
The patient was in left lateral position.
Fentanyl 50 ug IV push slowly with local 2% Xylocaine 10ml injection

For the right PCN:
PCN was smoothly performed via right posterior approach under freehand and real-time ultrasound-guided with an 18G Chiba needle; then with Seldinger technique under fluoroscopy, an 8 Fr 4 sideholes 25cm pigtail catheter was inserted through the middle pole with catheter looping in the right renal pelvis.
No gross hematuria is noted after the procedures.

Pus-like urine is noted.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::perianalfistula::
(
History of abscess

Study: MRA; MR study of pelvis
Machine: Siemens, Verio V40405
Contrast medium: without and with iv contrast medium.
Indication: for evaluation 
Findings:
1. perianal fistula is noted on left side; the tract orifice at the 6 o'clock direction from the posterior anal region, upward extension to distal left perirectal space, through the elevator ani muscle at 3 o'clock direction, two two tracts to the left buttock region, with an orifice to the skin.
2. a small reactive LN in the left inguinal area; there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
3. there is no ascites
4. no definite focal lesions in the pelvic cavity except the fistula. 
)
::ptcdl::
(
History of hilar cholangiocarcinoma; obstructive jaundice = 8.31/ 5.74 mg/dL (2014/09/15).

Anethesia:
Fentanyl 50 ug IV push slowly;
Local 2% Xylocaine 10ml injection.

For the left PTCD:
PTCD was smoothly performed via left approach under ultrasound and fluoroscopic guidance with an 18G chiba needle insertion; then an 8 Fr 25 cm 4 sideholes pigtail catheter through left IHD insertion and with catheter looping in left IHD.  Cholangiography showed obstruction at the hilar area. The bowels are not well opacified. The bowels are not opacified. The CBD and GB were slightly opacified.

For the right PTCD:
PTCD was smoothly performed via right approach under ultrasound and fluoroscopic guidance with an 18G chiba needle insertion; then an 8 Fr 25 cm 4 sideholes pigtail catheter through right IHD insertion and with catheter looping in right IHDs.  Cholangiography showed obstruction at the hilar area. 
No obvious discomfort was complained after the procedure.
Post-procedure vital signs: stable.

Please be careful of the possible complications (internal bleeding etc.), even though the procedures were very smoothly performed.
Further evaluation or any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::ptccd::
(
History of gallstones with acute cholecystitis, recurrent.

Indication: gall stones with cholecystitis
Method: percutaneous transhepatic cholecystostomy.
Anaethesia: Fentanyl 50 ug IV push slowly
Procedure: Under supine position, sonographic evaluation and localization were performed. After skin preparation, local anasthesia 10ml of 2% xylocaine was given under sonographic guidance. Then an 8Fr pigtail catheter was inserted into the gall bladder smoothly. Definite pus was drained fluently. Please close observe possible complications. 

Complication: Nil immediately after the procedure.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::rectumdilatation::
(
History of rectal cancer s/p LAR. 

Indication: for balloon dilatation of the stenosis
Balloon dilatation of the colorectal anastomosis:
1. Contrast injection through the anus shows stenosis at the colorectal anastomosis. 
2. Insert a KMP and a H1 catheter, with a 0.035" guidewire over the stenotic site; the rectum distal was dialated; therefore, an 8Fr 15cm vascular sheath and a 9Fr 23cm vascular sheath were inserted to keep the route.
3. Balloon dilatation with a 16mm x 4cm PTA balloon (Atlas); two segment; 

Non-enhanced computed tomography of abdomen and pelvis showed focal stenosis at the anastomosis area; no evidence of contrast medium leakage. 
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::rfabigtip::
(
History of ESRD; pacemaker; Appendix, carcinoid tumor, s/p right hemicolectomy on 2010/01/23; traditional serrated adenoma, rectum, suspect rectal cancer, status post endoscopic mucosal resection (EMR) on 2013/8/6; Left ureter high grade papillary urothelial carcinoma, cT1N0M0, status post hand-assisted laparoscopic left nephroureterectomy, status post cystoscopy follow-up on 2013/3/13; Hepatocellular carcinoma, s/p atypical hepatectomy S7, S8 on 2010/01/23; CT 2014/03/14 showed liver cirrhosis with 2 HCCs; Total/ direct bilirubin = 1.37/ 0.16; AST 31 U/ml; ALT 24 U/ml (2014/04/24); TACE (1) 2014/04/24 for right hepatic artery; 

-Treatment: RFA of HCC x2 at S3 (17.4mm), S6 (18.9mm).
-Anesthesia: Midazolam (total dose 8.75mg) and fentanyl (total dose 0.125mg) were administered intravenously before and during the procedure. Local anesthesia with lidocaine 200 mg was given before the procedure.
-Position: supine position
-Procedure:
1. under the guidance of ultrasound and non-contrast CT, the RFA electrode
(Bip-Tip radiofrequency electrode, 15cm30mm; RadioMedical Co.)
>RFA (1) was performed at the S3 tumor with impedence range 70-120 ohm, power 60-120 Watt, RFA time 12min, ending temperature 70'C, pause 10 times; starting time of cool down at 4:30.
>RFA (2) was performed at the S6 tumor with impedence range 60-100 ohm, power 60-160 Watt, RFA time 12min, ending temperature 70'C, pause 6 times; starting time of cool down at 6:32.
2. post-prodcedure images showed no obvious intra- or extra-hepatic hematoma. The post-procedural after the ablation showed low density changes and bubbles at the ablation area.
3. Please bed rest for 4 hours and follow up serum ALT and T-bill.
4. right pleural effusions are noted; 
5. Suggest followed triphase CT scan one month later. If any problems, please call 51685 (Dr. Liu, Kao-Lang).   
)
::rfacooltip::
(
History of rectal cancer with liver metastases; 

-Treatment: RFA of liver metastases at S7 (28.1mm), S5 (14.3mm) and S6 (11.2mm).
-Anesthesia: Midazolam (total dose 7.5mg) and fentanyl (total dose 0.2mg) were administered intravenously before and during the procedure. Local anesthesia with lidocaine 200 mg was given before the procedure.
-Position: supine position
-Procedure:
1. under the guidance of ultrasound and non-contrast CT, the RFA electrode 
(Cool-Tip radiofrequency electrode, 20cm30mm; COVIDIEN Co.)
>RFA was performed at the S7 tumor with impedence range 70-93 ohm, power 91-127 Watt, RFA time 12min, ending temperature 75'C, pause 8 times.
>RFA was performed at the S7 tumor with impedence range 71-90 ohm, power 77-98 Watt, RFA time 12min, ending temperature 73'C, pause 8 times.
>RFA was performed at the S5 tumor with impedence range 71-96 ohm, power 91-125 Watt, RFA time 12min, ending temperature 72'C, pause 13 times.
>RFA was performed at the S6 tumor with impedence range 70-96 ohm, power 77-106 Watt, RFA time 12min, ending temperature 66'C, pause 11times.
2. post-prodcedure images showed no obvious intra- or extra-hepatic hematoma. The post-procedural after the ablation showed low density changes and bubbles at the ablation area.
3. Please bed rest for 4 hours and follow up serum ALT and T-bill.
4. Suggest further RFA for the other tumors 2 weeks later, within one month. 
)
::sclero::
(
Procedure name: Sclerotherapy
Indication: refractory symptomatic hepatic cyst with obstructive jaundice
Medication: Fentanyl 0.05 mg IV push slowly 
Procedure:
1. Contrast injection confirmed that the fluid cavity had no obvious connection to other space.
2. Picibanil 5KE in 25 ml N/S was injected into cystic cavity. 
3. The patient was kept in supine position for 10 minutes, and turned to prone position for the other 10 minutes.
4. The injected fluid was aspirated. 
5. The patient tolerated the procedures well without immediate complications.
)
::stagingprostate::
(
Prostate cancer staging: 
--- Tumor location: bilateral involving both central gland and peripheral zone, more on the right side.
--- Diameter of the biggest tumor: 3.9cm 
--- Tumor invasion: Tumor invades seminal vesicle. T3b 
--- Regional nodal metastasis:  no lymphadenopathy. N0
--- Distant metastasis: a 1.5cm enhancing lesion at S2 body with central dark signal, suspect osteoblastic metastasis. The tumor is not identified on bone scan, the DD include hemangioma, suggest clinical correlation for this bone lesion. M1b
)
::stentbiliary::
(
History of 

--- Indication: Common bile duct obstruction, for biliary stenting.
--- Instrument: 8Fr introducing catheter, 4Fr Cobra-2 catheter, 0.035 inch 150 cm and 0.035 inch 300 cm guidewires (Terumo).
--- Stent: BARD fluency plus 9F 0.035 in 80 mm x 10 mm peripheral vascular stent.
--- Pigtail catheter: 8 Fr 25 cm (Inter-V).
--- Balloon dilatation catheter: Advance 35LP 5 Fr 80 cm 0.035 in 7 mm x 8 cm and 10 mm x 4 cm.
--- Analgesics: Fentanyl 0.05 mg/0.05 mg mg iv stat.  Domicum 2.5 mg/ iv stat.
--- Cholangiogram and duodeno-jejunography: 
1. Severe stenosis is shown at the proximal common bile duct.
2. Intact peristasis of the duodenum and proximal jejunum.
--- Procedure: 
1. Patient in supine position.
2. We navigate the Cobra-2 catheter with the guidewire into the duodenum.
3. Dilatation of the proximal common bile duct was performed with 7 mm and 10 mm balloon catheters respectively.
4. The stent was placed successfully in the common bile duct, then we inserted the pigtail catheter with the tip into the common bile duct.
5. Post-stenting cholangiogram showed marked improvement of the stenosis and fluent flow in the stent.

Suggestion: The PTCD revision is arranged on this Friday (a.m.) on call.
If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::taegibleeding::
(
History of bloody stool and suspected GI bleeding; CT angiography showing duodenal bleeding.
Indication: An active bleeding at the second to the third portion of duodenum on CT. 
Puncture site: right transfemoral approach.
Equipments: 5Fr vascular sheath, 5Fr RLG, 5Fr RC1, 4Fr RC1, 2.7Fr Progreat, 2.4Fr Renegade*II, Floppy. 

Angiographic findings:
1. Angiography of celiac artery, superior mesentric artery and gastroduodenal artery was performed. Stenosis of celiac orifice was noted.
2. Active contrast extravasation from duodenal was noted during GDA injection.
3. Guiding catheter was placed at GDA and Renegade was navigated to the inferior pancreaticoduodenal artery. Embolization was performed with 50% NCBA (n-butyl cyanoacrylate). 
4. However, active contrast extravasation was still noted. 
5. Embolization of gastroduodenal artery with microcoil (8mm/4mm, Tornado) and 50% NCBA (n-butyl cyanoacrylate) was performed. 
6. Angiography of SMA showed active contrast extravasation from IPDA.
7. Guiding catheter was placed at SMA and Progreat was navigated to the IPDA. Embolization was performed with 50% NCBA (n-butyl cyanoacrylate). 
8. Post-embolization angiography of SMA and common hepatic artery showed no evidence of contrast extravasation. 

Suggestion: 
1. Please remove femoral sheath within 48 hours.
2. Beware of possible complication of bowel ischemia; 
Please Note: the dual supplies of the duodenum were embolized (from gastroduodenal artery and from SMA); the possible pancreatitis should be alerted; the bowel ischemia, perforation may be delayed wihtin one week.  Surgical intervention is still indicated if persistent bleeding or bowel ischemia/ perforation. 
)
::taehcc::
(
--- Indication: for TAE (1)
--- Puncture site: right transfemoral approach by ultrasound guidance.
--- A 5Fr vascular sheath insertion.
--- A 5Fr RC1 catheter (Cook) and a 0.035-in 150cm guidewire (Terumo) 

--- Angiography findings:
1. a small tumor stain is noted at the S4b supplied by the middle hepatic artery and compatible with CT finding.
2. main portal vein patent. 

--- Indication for microcatheter: superselective embolization of the tumors in the medial segment supplied by middle hepatic artery, from the replaced common hepatic artery from SMA. 
--- Procedures of TAE (1) was performed
1. The tip of this 5Fr RC1 at the common hepatic artery.
2. Plus with a 2.7Fr microcatheter (Progreat; Terumo) and the tip at the internal torturous branch of the middle hepatic artery; 
3. the tumor was embolized with 10 ml of mixture (40mg adriamycin, 10ml lipiodol) and Gelfoam fine particle. 
4. No immediate abdominal discomfort.

--- Suggestion: 
1. the CT guided RFA will be arranged on W5 a.m. on call.
--- If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)
::taehccj::
(
History of HBV; HCC. AFP 5.05 ng/ml (2014/08/25).

--- Indication: for TACE (1)
--- Puncture site: right transfemoral approach by ultrasound guidance.
--- A 5Fr vascular sheath insertion.
--- A 4Fr J catheter (Terumo) and a 0.035-in 150cm guidewire (Terumo)

--- Angiography findings:
1. a huge hypervascular tumor stain is noted in the right lobe of liver; multiple smaller tumors are noted in both lobes of liver; most tumors are supplied by the right hepatic artery; compatible with CT finding. (multiple pulmonary metastases).
2. main portal vein patent.

--- Indication for microcatheter: none.
--- Procedures of TACE (1) was performed
1. The tip of this 4Fr J at the inferior right hepatic artery.
2. the tumors were embolized with 10 ml of mixture (40mg adriamycin, 5ml lipiodol, mixed in 10ml), Lipiodol 10ml and Gelfoam fine particle.
3. No immediate abdominal discomfort.

--- Suggestion:
1. next session of TACE depends on patient's condition.
Please check liver functions.
--- If any problems, please call 51685 (Dr. Liu, Kao-Lang).
)
::taehccrc1::
(
History of NBNC; AFP 37.67 ng/ml (2010/04/23); a huge HCC status post right lobectomy; CT 2012/03/20 showing a recurrent HCC at the S2; status post TACE (1) 2012/04/17 with complete effect and no viable tumor.  New recurrent HCCs in the S4b and S1; status post TACE (2) 2013/01/09; multiple (n=10) recurrent HCCs, status post TACE (3) 2013/09/10. AFP <2 ng/ml (2014/09/04); T-bil 0.55 mg/dL; AST 25 U/ml; ALT 15 U/ml (2014/09/09).

--- Indication: for TACE (4)
--- Puncture site: right transfemoral approach by ultrasound guidance.
--- A 5Fr vascular sheath insertion.
--- A 5Fr RC1 catheter (Cook) and a 0.035-in 150cm guidewire (Terumo)

--- Angiography findings:
1. a viable tumor stain is noted at the high S4a, supplied by the medial branch of the left hepatic artery; suspicious small tumor stains in the left lateral segment; compatible with CT finding. The tumors are markedly decreased, compared with prior TACE (3) (2013/09/10).
2. main portal vein patent.

--- Indication for microcatheter: superselective embolization of the tumors in the distal lateral segment; and the tumor in the high S4a; 
--- Procedures of TACE (4) was performed
1. The tip of this 5Fr RC1 at the common hepatic artery.
2. Plus with a 2.7Fr microcatheter (Progreat; Terumo) and the tip at the internal torturous branch of the medial branch of the left hepatic artery; and the branch of the left lateral segment.
3. the tumors were embolized with 5 ml of mixture (40mg adriamycin, 5ml lipiodol in total mixture of 10ml), Lipiodol 1ml and Gelfoam fine particle.
4. No immediate abdominal discomfort.

--- Suggestion:
1. check liver functions and clinical follow-up 
2. possible RFA for the viable tumor at the S4a.
--- If any problems, please call 51685 (Dr. Liu, Kao-Lang). 
)