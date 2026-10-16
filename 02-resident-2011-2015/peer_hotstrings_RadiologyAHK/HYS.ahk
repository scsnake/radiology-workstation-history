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
::acc::accessory spleen
::ai::The alignment is intact.
::alt::although the shape is favored as a phlebolith
::ank::swelling of the ankle joint is noted
::ano::are noted
::ana::anastomosis
::ant::anterior
::app::appearance
::anky::ankylosing spondylitis
::ate::atelectasis
::ath::atherosclerosis
::aw::associated with
::bdb::status post bilateral double J catheters insertion is noted.
::bf::bone fragment
::bil::bilateral
::bk::both kidneys
::bl::both lungs
::bo::No evidence of focal bone lesions is noted.
::bon::No evidence of focal bone lesions is noted. Alignment is intact. The soft tissue injury should be correlated with clinical findings.
::bor::borderline heart size is noted.
::bps::Bilateral psoas shadows are clear.
::bra::Bilateral renal arteries are intact.
::bro::bronchopneumonia
::brs::The bilateral renal shadows are obscured.
::bs::both sides
::c45::C4-5, 
::c56::C5-6, 
::c67::C6-7, 
::cak::calcified aortic knob is noted.
::cal::calcification
::car::cardiomegaly is noted.
::cc::clinical correlation
::ccp::chronic calcified pancreatitis
::cf::clinical follow-up
::ch::clinical history
::cha::common hepatic artery
::che::chest tube
::cheng::Please consult with Dr. Cheng (PHS 3453) for possible PET-CT scan.
::cho::status post cholecystectomy is noted with surgical clips in the right upper abdomen.
::cir::circumferential
::cla::clavicle
::cli::clinical findings
::com::compatible
::comp::compression fracture
::con::consolidation
::cons::considered
::cor::correlation
::coro::coronary a.a. calcifications
::corw::correlation with
::cp::cancerous peritonitis
::cpa::costophrenic angle
::cs::calcified spots
::csit::Sitting Chest Radiograph:
::csp::cavum septum pellucidum
::ctabd::NECT and CECT of abdomen
::ctal::there is no evidence of paraaortic LAPs in abdomen
::ctb::there are no definite focal lesions in the basal lungs and bone window settings.
::ctche::NECT and CECT of chest
::cthcc::hypodensity on precontrast, hyperdensity on arterial phase and rapid washout on venous phase; compatible with HCC.
::cthem::hypodensity on precontrast, peripheral dot-like enhancement on arterial phase, and progressive filling-in on venous phase; compatible with liver hemangioma.
::ctl::there are no definite focal lung lesions
::ctml::there is no evidence of significant mediastinal lymphadenompathies
::ctnl::there is no evidence of significant lymadenopathies in the bilateral neck areas
::ctpl::there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
::ctp::CTAP was performed with tip in the SMA orifice, 2ml/sec, delayed 30 sec, total 50 ml:
::cvi::cavum velum interpositum
::cw::compatible with
::cxr::Normal heart size and no definite focal lung lesions are noted.
::da::deformed alignment
::dec::decreased
::dep::dependent
::des::destruction
::dev::the spine is deviated to
::dd::a diverticulum is noted at the second portion of duodenum
::def::definite
::det::details are obscured
::dia::elevated diaphragmatic shadow
::dil::dilatation
::dis::disc space narrowing
::dist::distention
::dl4::at the L4/5 and L5/S1
::dl5::at the L5/S1
::dra::drainage tube
::ds::diaphragmatic shadow
::dyn::there is status post dynamic screw fixation due to intertrochanteric fracture
::ede::Increased lung markings with bilateral hilar distribution are noted, suggestive of lung edema.
::ele::elevated
::eme::emergency
::emp::emphysematous change
::enc::encasement
::enh::enhancement
::enl::enlargement
::eps::encapsulted peritoneal sclerosis
::et::status post endotracheal tube insertion and the tip is in the appropriate position
::eti::The etiology should be further evaluated.
::ev::esophageal varices
::eva::evaluation
::exc::can not be excluded.
::ext::extensive
::fac::facet joint arthropathy
::fb::No evidence of radiopaque foreign body can be identified. The prevertebral soft tissue is intact.
::fc::fluid collection
::fcl::femoral central venous catheter in the inferior vena cava
::fcvp::femoral CVP line
::fe::further evaluation
::fec::Increased fecal material in the colon is noted
::fib::fibrotic change
::fin::findings
::fl::focal lesion
::fol::A foley catheter insertion is noted.
::fp::fat planes
::fra::fragments
::fre::no evidence of subphrenic free air is noted.
::fs::fatty strandings
::fun::Functioning or non-functioning status should be correlated with clinical findings.
::fx::fracture
::fxe::fracture ends
::gckd::glomerulonephrotic cystic kidney disease
::gda::gastroduodenal artery
::gg::Suggest correlation with clinical manifestations.
::ggo::ground-glass opacities
::ghl::gastrohepatic ligament
::gra::grade I of spondylolisthesis
::gs::gall stone
::h::history of
::hdl::hepatoduodenal ligament
::hem::hemangioma
::het::heterogeneous
::hv::hepatic veins and portal veins are patent
::hydro::hydronephrosis
::hyper::hypervascular
::hypo::hypovascular
::hea::heart shadow
::id::identified
::ild::interstitial lung disease
::ile::increased bowel gas is noted in the abdomen, compatible with ileus.
::ilem::markedly increased bowel gas is noted in the abdomen, compatible with prominent ileus. 
::iles::slightly increased bowel gas is noted in the abdomen, compatible with mild ileus.
::inc::increased
::inci::incidentally
::incl::including
::ind::indicated
::inde::indentation
::inf::infiltrations
::ing::inguinal area
::ins::insufficiency
::inv::involvement
::irr::irregular
::iud::Intrauterine device is noted in the pelvic cavity.
::isn::is noted
::jt::A jejunal tube is noted
::kb::Knee, both:
::ker::Increased Kerley's lines are noted and congestive heart failure is considered.
::kl::Knee, left:
::koa::knee joint space narrowing with spurs formation, osteoarthritis is compatible.
::kr::Knee, right:
::kub::KUB shows:
::l23::L2-3,
::l34::L3-4,
::l45::L4-5,
::l51::L5-S1,
::lat::lateral
::lbv::left brachiocephalic vein
::lc::liver cirrhosis with splenomegaly
::le::increased lung markings with bilateral hilar distribution is noted, suggestive of lung edema
::leu::low density change at bilateral periventricular white matter, leukoaraiosis is considered
::ldb::A left double J catheter is noted.
::lf::lung field
::lga::left gastric artery
::lha::left hepatic artery
::liao::Please consult with Dr. Liao Wei-Chih (PHS 1925) for the evaluation of possible IgG and IgG4 levels.
::lig::ligament
::lip::lipiodol retentions
::ljc::a left jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::lk::left kidney
::lll::left lower lung
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
::lul::left upper lung
::lum::Lumbosacralization is noted on
::lun::No definite focal lung lesions are noted.
::lym::lymphangitis carcinomatosis
::ma::marked
::med::mediastinum
::met::metastases
::mor::CT morphology of
::morl::CT morphology of low-grade esophageal varices is noted.
::morh::CT morphology of high-grade esophageal varices is noted; correlation with endoscopic findings is indicated
::morn::CT morphology of esophageal varices is not identified
::mrc::MRCP reveals no evidence of bile ducts or pancreatic duct dilatation; no anomalous pancreaticobiliary union.
::mrhcc::hypointensity on T1-weighed images, slight hyperintensity on T2-weighted images, and global enhancement on early arterial phase, rapid washout on delayed enhanced images; compatible with HCC.
::mrhem::hypointensity on T1-weighted images, hyperintensity on T2-weighed images, and peripheral patches enhancement on dynamic contrast-enhanced study, persistent enhancement on delayed contrast-enhanced images; compatible with liver hemangioma.
::mul::multiple
::n::normal
::nce::no contrat medium enhancement
::ne::no evidence of
::neu::neuroforaminal narrowing is noted
::nf::no definite focal lesions.
::ng::nasogastric tube insertion is noted with tip in the stomach.
::nh::normal heart size
::nic::no interval change
::nk::Bilateral psoas shadows are clear. No evidence of radiopaque stones are noted. Nonspecific bowel gas distribution is noted.
::nl::No definite focal bone lesions are noted in the lumbar spine and the alignment is intact.
::nod::nodular and retracted liver contour is noted
::non::non-specific bowel gas distribution is noted.
::nrm::no evidence of recurrent or metastatic lesions
::nrr::no evidence of residual or recurrent tumor.
::ns::non-specific
::nuc::nuchal ligament calcification is noted.
::ogd::old granulomatous disease
::ost::osteoarthritis change
::obl::obliteration
::obs::obstruction
::oc::operative change
::ol::obstructive level
::oo::osteoporosis
::opa::opacification
::ora::oral contrast medium
::os::osteoarthritis
::otb::increased fibrocalcified lesions are noted in the bilateral upper lung fiedls; old granulomatous disease is considered. 
::ove::overriding
::Pa::paraaortic areas
::pac::A pacemaker is noted.
::pan::pancreatic
::par::parenchymal
::para::Paranasal sinuses are clear.
::pb::Patella, both:
::pc::pelvic cavity
::pce::pericardial effusion
::pcs::portocaval space
::pd::Status post Tenchkoff catheter replacement with tip in the
::ped::bilateral pedicles are intact.
::peri::pheripheral
::pfj::patellofemoral joint
::pha::proper hepatic artery
::phl::A phlebolith is noted in the pelvis cavity.
::phls::Phleboliths are noted in the pelvis cavity.
::pl::Patella, left:
::pla::pleural plaques
::ple::pleural effusions
::pm::pneumonia
::pms::posterior marginal spur formation
::pne::no evidence of pneumonic patches in both lung fields
::po::partial obstruction
::pos::posterior
::pp::in the portal venous phase
::pr::Patella, right:
::pri::compared with prior
::pro::prominent
::ps::psoas shadow is not well delineated.
::pt::pneumothorax
::pvt::portal vein thromobses
::qua::decreased quality of the film is noted, and the details cannot be well evaluated.
::ra::radiopaque
::rad::No definite radiopaque density is noted in the urinary collecting system.
::rrad::A radiopaque density is noted in the right pelvis; a right distal ureteral stone can not be excluded.
::res::respiratory motion artifacts make less sensitivity and specific quality.
::rd::a radiopaque density is noted at the  pelvis and the  distal ureteral stone cannot be excluded although the shape is favored as a phlebolith.
::rdb::A right double J catheter is noted.
::rha::right hepatic artery
::ri::right
::rjc::a right jugular venous approached central venous pressure line is noted with tip in the superior vena cava.
::rk::right kidney
::rll::right lower lung
::rm::no evidence of recurrent or mets lesions
::rml::right middle lung
::rpa::Right Port-A insertion from right subclavian vein is noted with tip in the superior vena cava.
::rpaj::::rpa::Right Port-A insertion from right jugular vein is noted with tip in the superior vena cava.
::rps::right psoas shadow is clear.
::rrs::The right renal shadow is not well delineated
::rrst::right renal stone
::rsc::a right subclavian venous approached central venous pressure line is noted with tip in the superior vena cava.
::rul::right upper lung
::rv::renal vein and inferior vena cava are intact
::s2::superior lateral segment of left lobe of liver (S2)
::s3::inferior lateral segment of left lobe of liver (S3)
::s4a::superior medial segment of left lobe of liver (S4a)
::s4b::inferior medial segment of left lobe of liver (S4b)
::s5::inferior anterior aspect of right lobe of liver (S5)
::s6::inferior posterior aspect of right lobe of liver (S6)
::s7::superior posterior aspect of right lobe of liver (S7)
::s8::superior anterior aspect of right lobe of liver (S8)
::s/p::status post
::sb::small bowel
::sbtube::Sengstaken-Blakemore tube
::scot::scoliosis of the thoracic spine
::scol::scoliosis of the lumbar spine
::se::subcutaneous emphysema
::sh::shadow
::sho::should be correlated with clinical findings.
::sli::slightly
::sm::small
::spl::splenomegaly
::st::soft tissue
::sta::Standing abdomen shows:
::stc::Standing CXR shows:
::std::soft tissue density
::sto::stool impaction is compatible.
::suc::Supine CXR shows:
::sus::suspected
::sur::surrounding
::sw::superimposed with
::t/d::Total/ direct bilirubin = 
::ta::torturous aorta
::thi::thickening
::ti::terminal ileum
::tra::status post tracheostomy
::ub::urinary bladder
::unk::unknown history in N hospital
::ur::ureteral
::vb::vertebral body
::vp::vertebroplasty
::ctabd::CT of abdomen and pelvis without/with contrast enhancement shows:
::ctda::CT of abdomen with dynamic contrast enhancement (non-enhanced, arterial and portal venous phase):
::tri::Triphasic CT of abdomen without/with contrast enhancement shows:
::hccn::A 2.5 cm nodule with enhancement in hepatic artery phase and washout in portal venous phase is noted at S#5-6, compatible with HCC. 
::apsh::A wedge shape lesion is noted at the peripheral aspect of S#5-6, compatible with AP shunting.
::dil::dilatation
::obs::obstruction
::pro::prominent
::uro::No obstructive uropathy. No urinary stone.
::cw::compatible with
::cc::please clinical correlation
::siz::the size is smaller compared with the previous study on 2008-08-08.
::ru::amount residual urine.
::pe::pleural effusion
::sptae::Status post TAE with lipiodol retention at right upper abdomen.
::bi::basal indentation
::proe::compatible with prostate enlargement.
::rks::A radiopaque spot superimposed on the right kidney shadow, suspicious a right renal stone.
::upj::ureteropelvic junction
::uvj::ureterovescicle junction
::rp::renal pelvis
::nh::Normal heart size. Tortuous aorta. 
::cx::CXR shows:
::bil::bilateral
::abche::About the chest region, please refer to the chest report.
::sub::Suboptimal bowel preparation.
::bi::basal indentation
::sus::suspicious 
::l12::L1/2, 
::skull2::1. No definite abnormal focal bony change. 2. The sella is intact. 3.No definite change in the vascular groove and the sutures.
::sin::No definite abnormal bony change. The bilateral maxillary sinus is cloudy and with thick mucosa and it is compatible to sinusitis.
::mas::No definite bony change in the mastoid bone. The pneumatization was within normal limit.
::stenver::IAC study showed normal sized and shaped bilateral internal auditory canal. No definite focal bony change.

::spo::spondylosis of the spine is noted.
::spoc::spondylosis of the cervical spine is noted.
::spol::spondylosis of the lumbar spine is noted.
::sco::scoliosis of the spine with convexity to the right. 
::penia::osteopenia of the visible bone.
::msco::scoliosis of the spine, probably due to positioning factor.
::ali::the alignment of the bony structure is intact.
::nar::joint space narrrowing is noted at the medial tibiofemoral joint.
::fac::facet joint arthropathy at multiple lumbar spine.
::spis::spinal stenosis
::spu::thoracolumbar spondylosis with disc space narrowing and marginal spur formation at multiple levels
::pros::periprosthetic radiolucency, suggestive of focal osteolysis, at 
::enth::traction enthesophyte formation over the bil. patellar bases
::latpat::lateral subluxation or tilt of the both patellae.
::tkr::s/p total knee replacement with postoperative changes on right side and with adjacent soft tissue swelling. 
::thr::s/p total hip replacement with postoperative changes on right side. focal screw fracture at the right acetabular roof.
::oajoi::mild osteoarthritis with joint space narrowing, uneven articular surfaces, marginal spur formation at
::osi::partial obliteration of the right sacroiliac joint with subchondral sclerosis. 
::par::bony defects at the L5 pars interarticularis.
::vac::vacuum phenomena at  joints. 
::fus::bil. posterior(-lateral) bony fusion at the T12-L5 level
::comfr::(previous) compression fracture(s) and wedge deformity or decrease in height of the L2 vertebra
::npbon::no definite fracture line or abnormal soft tissue density. no joint space narrowing or spur formation. 
::varic::some dilated tortuous structures, suggestive of varicose veins, at the medial aspect of right knee and proximal lower leg.
::cem::s/p retension of some bone cement(s)
::supra::increased joint effusion(s) in the left suprapatellar pouch. 
::1a::focal geographic subcortical osteolytic lesion with thin sclerotic margin at the
::spl::s/p external splint fixation 
::legfr::old fracture(s) at the left distal tibial shaft s/p interlocking nail and screw fixation formation. old fractwith fine callus ure(s) at the left lower fibular shaft s/p metallic fixation with fine callus formation.
::vp::s/p vertebroplasty with retension of some bone cement(s). 
::lspo::lumbar spondylosis with marginal osteophyte formation and facet joint arthroses. 
::dsi::degenerative change of bilateral sacroiliac joints.
::hipoa::advanced osteoarthritis with joint space narrowing, uneven articular surfaces, subchondral sclerosis and cyst formation, and marginal spur formation at the weight-bearing segment(s) of left hip joint.
::hipddh::relative shallowing deformity of the acetabulum with lateral subluxation of the femoral head epiphysis
::hipenth::focal traction enthesophyte formation over the greater femoral trochanter on both sides. 
::tkr::osteopenic change of visible bones. status post total knee arthroplasty at both knee joints with fine alignment and soft tissue swelling at anterior aspects. advise clinical correlation. 
::npsi::bilateral essential intact sacroiliac joints. 
::suprap::increased soft tissue density at the bilateral suprapatellar spaces.
::oapat::osteoarthritic change of the bilateral patellofemoral joints. 

::spiMR::MRI of L-S spine with/without contrast administration shows: 
::lis::grade 0-1 degenerative spondylolisthesis of the L4 on L5 
::ret::retrolisthesis of the L4 on L5 
::hipfluid::mild increased effusion(s) and synovial enhancement in the bil. hip joints with mild subchondral marrow edema/hyperemia. 
::spimeta::varying-sized patcy lesions of abnormal signal and enhancement with osteoblastic foci of low to dark SI on T1WI and heterogeneous enhancement on contrast-enhanced T1WI diffusely at the visible spine, sacrum, bil. pelvic bones and both proximal femora; focal cortical permeation at the left aspect of L3 vertebra with paraspinal soft-tissue extension, causing relative edema and mild hyperemia of the left psoas muscle.
::spisco::Scoliosis, mild increased lordotic curve and degenerative change of the lumbar spine with vacuum phenomenon(a) in the narrowed disc space(s) at the L4-5 and L5-S1 levels, and dehydrated disc(s) at the lower lumbar levels. 
::spibulg::posterior concentric bulging disc at the L3-4 level, causing mild thecal sac indentation. 
::spipro::protruding disc at L4-5 level with bilateral facet arthroses and hypertrophic ligamenta flava, causing adjacent central canal stenosis. Focal torn annulus fibrosus at left foraminal zone of the L4-5 disc.
::spispur::posterior spur formation at the L4-5 level, causing mild thecal sac indentation and narrowing of its bil. neural foramina. 
::spifacet::, with bilateral facet arthroses and hypertrophic ligamenta flava, causing central canal stenosis and narrowing of its bilateral neural foramina.
::npcord::no evidence of intrathecal lesion. no focal SI change in the visible spinal cord.
::spideg::degenerative change of the cervical and lumbar spine with marginal spur formation and dehydrated disc(s) at multiple levels, and vacuum phenomenon at L4-5 and L5-S1 level(s).
::npspi::no focal abnormal signal is noted in the bone.
::hipmeta::focal expansile geograhic intramedullary lesion, about 7x3x3 cm in size, of abnormal signal and enhancement at the right acetabulum to supraacetabular iliac bone and iliopubic junction with cortical permeation, susp. pathological fracture(s) and adjacent muscular edema/hyperemia. 
::spisub::(previous) subchondral fracture(s) and amorphous marrow edema/hyperemia at the T8, T9, T10 and T11 upper endplates with unremarkable paraspinal area(s). 
::shmr::MRI of the left shoulder without IV contrast administration shows: 
::shdeg::degenerative arthrosis of the left acromioclavicular joint with uneven articular surface(s) and marginal spur formation; lateral downsloped acromion with small subacromial spur formation and focal tiny traction enthesophyte formation over the greater humeral tubercle on left side. 
::shtear::mild uneven increased SI at the bursal side of supraspinatus tendon with abnormal effusion and synovial proliferation in the subacromial bursa. 
::bicepeffu::increased effusion(s) in the biceps (long head) tendon sheath. 
::nplab::intact glenoid labra and biceps-labral complex without evidence of tear. 
::degdisc::dehydrated discs at lumbar spine with intervertebral discs narrowing and vaccum phenomenom at L3/4, L4/5 and L5/S1.
::npspi::no focal SI change in the visible bone. 
::hill::focal bony defect at the posterolateral aspect of right humeral head, r/o Hill-Sachs lesion.
::shnar::diffuse joint space narrowing at the right glenohumeral joint with uneven articular surface(s), subchondral erosion(s) and periarticular soft tissue swelling, r/o inflammatory or infectious arthritis.
::lor::loss of lordotic curvature at lumbar spine.
::slap::suspicious linear tear at the anteroinferior labrum of right scapular glenoid.
::bic::intact biceps tendon and biceps-labral complex without evidence of tear.
::hipmet::expansile geographic intramedullary lesion(s) of abnormal signal and heterogeneous enahncement at the right acetabulum and supraacetabular iliac bone, iliopubic and ilioischial junctions, and ischial bone(s) with multifocal cortical destruction, soft tissue extension and susp.  involvement of or extension to the articular surface(s) of right acetabulum, causing compression and edema/hyperemia of the adjacent muscular structure(s), and mild increased effusion(s) and synovial enhancement in the right hip joint. 
::slap4::suspicious displaced labral tear at the superior labrum of right scapular glenoid with anterior-to-posterior extension and with involvement of or extension to the biceps anchor; mild swelling and increased SI at the biceps (long head) tendon.
::comfrx::anterior wedge deformity and decreased height of the L3 vertebrae body with area of non-enhancement and minimal paraspinal and epidural soft tissue reaction at L3-4 level; increased effusion in the bilateral L3-4 facet joints; retropulsed posterior cortex of L3 vertebra, causing thecal sac compression and central canal stenosis at L2-3 level.
::ccs::central canal stenosis
::its::indentation of the thecal sac.
::psf::posterior spur formation
::buck::longitudinal tear(s) at the lateral meniscus with a mesially displaced fragment as truncated meniscus, fragment notch, double PCL sign
::avn::a geographic subchondral lesion of intermediate to low SI on T1WI and mixed SI on T2WI with serpiginous sclerotic margin and peripheral marrow edema at the right femoral head; subtle partial collpase with susp, subchondral fracture(s) at the right femoral head; relative increased effusion(s) and synovial proliferation in the right hip joint with small or tiny marginal spur formation. 
::pate::focal uneven articlar cartilage defect at the medial facet of right patella with underlying subchondal bone exposure and mild marrow edema; focal uneven articular swelling and thinning at the anterior aspect of right medial femoral condyle with amorphous subchondral marrow edema. 
::si::signal intensity
::leu::non-specific tiny hyperintensity dots at the bilateral periventricular white matter.
::how::However, small osseous or soft tissue lesion(s) may not be detected by the plain radiography. Advise correlate with other imaging study, if clinically indicated. 
::npwrist::no evidence of focal bony or joint lesion. no evidence of fracture or dislocation.
::val::mild valgus deformity of the bil. 1st metatarsophalangeal joints. 
::biph::biphalangism of the bil. little toes. 
::opfoot1::s/p corrective osteotomy at the right 1st metatarsal neck s/p intramedullary pin fixation with bony displacement and adjacent soft tissue swelling.
::opfoot2::s/p osteotomy at the bilateral 1st metatarsal bones with removal of metallic instrument, with minimal or mild callus formation and with adjacent soft tissue swelling; relative bony displacement and angular deformity of the right 1st metatarsal neck. Advise follow-up study. 
::anksyn::increased effusion and synovial enhancement in the anterior recess and posterior recess of the left tibiotalar joint.
::neckrt::post-RT edematous change in the retropharynegeal space and bil. neck interstitium as well as fatty change in the C spine.
::flatfoot::decreased calcaneal pitch, r/o flat foot. medial rotation of the talar head(s) on both sides. 
::radialfrx::(previous) impacted fracture at the left distal radial metaphysis with dorsal angulation of its distal bony part, and intraarticular extension to the distal radioulnar and radiocarpal joints s/p metallic fixation and s/p casting fixation with retension of some bony graft(s) and with adjacent soft tissue swelling.
::sts::adjacent soft tissue swelling
::oaknee::mild osteoarthritis with small or tiny marginal spur formation at the bil. knee joints. mild traction enthesophyte formation over the bil. patellar bases. no evidence of fracture or dislocation. 
::Bak::a 1.5x 0.8x2 cm cystic lesion at the medial aspect of right popliteal fossa, between semitendinous and medial head of gastrocnemius muscles.
::acl::anterior cruciate ligament
::pcl::posteior cruciate ligament
::sim::shoulder impingement
::dsd::degenerative spinal and disc disease
::acj::acromioclavical joint
::ns::status post interlocking nail and screw fixation
::shou1::
(
MRI of the left shoulder without IV contrast enhancement shows:
1. low-lying left acromian with tiny subacromial spur formation.
2. subcortical cyst formation at the posterolateral aspect of the left humeral head; traction enthesophyte formation over the greater tubercle of the left humerus.
3. minimal osteoarthritis with subtle or tiny marginal spur formation and increased effusion in the left glenohumeral joint.
4. thickened left suprapinatus tendon with intermediate SI on T1WI and uneven increased SI on T2WI.
minimal osteoarthritis, left glenohumeral joint; tendinopathy, left suprapinatus tendon. (G27717/1-1)
)
::shou2::
(
MRI of the left shoulder without IV contrast enhancement shows:
1. slight lateral downsloped acromion with small subacromial spur formation and focal tiny traction enthesophyte formation over the greater humeral tubercle on left side. 
2. mild osteoarthritis with small marginal spur formation and decreased effusion in the left glenohumeral joint.
3. focal uneven high signal intensity at the bursal side of supraspinatus tendon, near the insertion site, r/o partial-thickness tear, left suprapinatus tendon.
4. focal small subcortical erosion(s) at the left humeral head. 
5. relative edema of the rotator cuff interval with partial obliteration of the coracohumeral and superior glenohumeral ligaments. 
6. intact biceps tendon and biceps-labral complex without evidence of tear. 
impingement syndrome, left shoulder; r/o bursal-sided partial-thickness tear, suprapinatus tendon; mild osteoarthritis, left glenohumeral joint; r/o injured rotator interval.
)
::arthro::
(
Arthrography of right shoulder shows:
1. slightly low-lying acromion.
2. no evidence of tear at articular site of supraspinatous tendon.
3. intact of the labrum of scapular glenoid.
4. no evidence of adhesive capsulitis.
no evidence of tear at articular site of supraspinatous tendon.
)
::elbow1::
(
MRI of the right elbow without contrast enhancement shows:
> abnormal hyperintensity on T2-weighted images at humeral insertion of the common flexor tendon, anterior to the medial humeral condyle, with focal effusion at medial aspect of the medial humeral epicondyle.
> focal swelling with mild hyperintensity on T2-weighted images of the ulnar nerve at level of the humeral supracondylar level.
> no evidence of abnormal SI at the visible bony structures. 
R/o tear of the common flexor tendon. R/o ulnar neuritis, humeral supracondylar level.
)
::ankle1::
(
MRI of the right ankle without/with IV contrast enhancement shows: 
1. blurring and thickening of the right anterior talofibular ligament and right calcaneofibular ligament; intact right posterior talofibular ligament.
2. increased effusion in the right tibiotalar and subtalar joints.
3. an ovoid nodule, of dark SI on all pulse sequences, at the anterosuperior apect of the right talar dome.
injured right anterior talofibular and calcaneofibular ligaments; posttraumatic synovitis, right tibiotalar and subtalar joints; focal enostosis, right talar dome. (G27670/7)
)
::PAOD1::
(
MRA of the pelvis and bil. lower limbs without/with IV contrast enhancement shows: 
1. fine opacification of the aortic bifurcation, and bil. common iliac, external iliac, common femoral, superficial femoral and popliteal arteries. 
2. multifocal mild stenosis at the right fibular and posterior tibial arteries with patency of the right plantar arteries; multifocal severe stenosis and total occlusion of the right anterior tibial arteries with faint recanalization of the right dorsalis pedis artery. 
3. multifocal mild stenosis at the left fiblular artery; multifocal mild to moderate stenosis at the left posterior tibial artery with patency of the left plantar arteries; multifocal severe stenosis and total occlusion of the left anterior tibial arteries with fine recanalization of the left dorsalis pedis artery. 
peripheral arterial occlusive disease, bil. lower limbs, with multifocal stenosis and total occlusion, bil. lower legs. (S83498/16-1)
)
::myelo::
(
Myelography of lumbar spine was performed smoothly via L2-3 puncture with injection of 3ml Omnipaque contrast medium, which shows:
1. s/p posterior decompression, transpedicle screw fixation and posterior instrumentation at L4 to L5 levels.
2. scoliosis and mild lumbar spondylosis with marginal spur formation.
3. mild straightening of the lumbar spine with mild retrolisthesis at L3-4.
4. indentation of the thecal sac at L3-4 level with blurring of the left L3 nerve root sheath.
Lumbar scoliosis and spondylosis. Suspected L3-4 HIVD with left L3 nerve root compression. Advise correlation with myelo-CT images.
)
::TMJ::
(
MRI of the bilateral TM joints without contrast enhancement shows:
Right TMJ:
1. Normal position, signal, and contour of the meniscus.
2. no increased effusion in joint space; no hypoplasia or flattening of the mandibular condyle.
3. Dynamic images shows no limitation of the motion of right mandibular condyle.
Left TMJ:
1. The body and post horn of the meniscus are emaciated. 
2. deformed configuration with surface flattening of the left mandibular condyle. small osteophytes are noted at the anterior surface. arthritic change is compatible.
3. Dynamic images shows severe limitation of the motion of left mandibular condyle.
arthritic change and severe motion limitation of the left TMJ. (S83832/TMJ)
1.Deformed configuration of the  bilateral mandibular condyle. The surface is sl. flattening. Small osteophytes are noted at the anterior surface. Arthritic change is compatible. 2.The menisci show irregular contour and signal . The anterior horn of both sides are preserved. The body and post horn are emaciated. This finding could be due to the arthritic change.
)
::angio1::
(
Angiographies of celiac, common hepatic, right hepatic arteries were performed via right transfemoral approach and show:
> cirrhotic change of the liver with cork-screw change of intrahepatic vessels.
> a small hypervascular tumor, about 1.2 cm in size, at S6 of right hepatic lobe.
> scattered tiny and small hypervasuclar stains at both lobes, A-P shunts are more likely.
> patent bilateral portal veins with hepatopetal flow.
)
::spi1::
(
mild osteopenia of the visible bony structures. mild scoliosis of the spine, probably due to positioning factor. increased lordotic curve of the lumbar spine. thoracolumbar spondylosis with marginal spur formation at multiple levels. grade (0-)1 degenerative spondylolisthesis of the L4 on L5 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. mild vacuum phenomena in the bil. sacroiliac joints. 
)
::patfrc::
(
(previous) irregular fracture(s) at the left patella with intraarticular extension to the left patellofemoral joint s/p metallic fixation and s/p external splint fixation with scanty callus formation and with adjacent soft tissue swelling. 
)
::brainMR::
(
MRI of head without  contrast enhancement shows
1. no abnormal bright up on DWI.
2. no abnormal focal SI change in the brain parenchyma.
3. symmetrical sulci, fissures and ventricles. 
4. TOF MRA of circle of Willis appears normal.
5. the cranial vault and skull base appear normal.
 No obvious intracranial abnormality
)
::brainCT::
(
Brain CT without/with contrast enhancement shows:
1. neither abnormal focal density change nor abnormal enhancement in the brain parenchyma.
2. symmetrical sulci, fissures and ventricles3. intact cranial vault.
Neck CT without/with contrast enhancement shows:
1. no obvious mass lesion noted.
2. no abnormal LAPs at neck.
3. the parotid, submandibular glands and nasopharynx appear normal.
4. clear paranasal sinuses and mastoid aircells.
No evidence of brain or skull mets.
No obvious neck mass or LAPs
)
::avmtae::
(
History of right F-T-P AVM with ICH. for TAE.
TAE indication: right F-T-P AVM.
Procedure: 
1. Under general anesthesia. 
2. Sterillization of bilateral inguinal area. Set 6Fr sheath via right transfemoral approach. A
3. Access 5Fr guiding catheter and take angiography. Angiography of right ICA, ECA and left VA shows the AVM gets blood supply from both right ICA, PCA and branches of ECA (middle deep temporal artery). 
4. TAE with microcatheter (marathon) tip at branches of right MCA and PCA. Onyx was injected via the microcatheter under fluoro-guidance.
5. Post-TAE angiography shows decreased size of AVM, about 50% of AVM is embolized.The procedure was stopped because the hemandynamic change and worry about the possibility of normal autoregulation breaththrough if we embolized too much in such large AVM. Send to ICU for further care.
Suggest: Bedrest for 8 hours, sandbag compression of puncture site for 4 hours.
)
::cta::
(
CT of brain without IV contrast shows:
1. no abnormal density in the brain parenchyma.
2. symmetric sulci and ventricles.
3. intact cranial vault.

CTA shows:
1. a 5 mm aneurysm with narrow neck, pointing superiomedially, is noted at the proximal supraclinoidal internal carotid artery.
2. no evidence of lesion at other great vessels. 

CTP shows:
1. symmetric blood perfusion at brain. 
)
::angio2::
(
Angiography of bilateral common carotid arteries and bilateral vertebral arteries are performed via right transfemoral approach by using a 5 Fr H1 catheter, and it shows:
1. Early bifurcation of bilateral MCA. Early branching of right anterior temporal artery from distal ICA.
2. A bilobule aneurysm at right MCA bifurcation, the larger sac is about 6mm and pointing anteriorly, the smaller sac is about 4mm.
3. Prominent right Pcom infundibulum.
4. No other aneurysm noted.
5. Patent dural sinuses.
Right MCA bifurcation aneurysm.
)
::biopsy1::
(
Pelvic CT without enhancement is performed for CT guide biopsy:
1.Indication: osteolytic lesion, bilateral iliac bone, for tissue proof.
2.Procedure:
 1).patient in the prone position.
 2).puncture site: posterior aspect of right buttock, under CT guidance
 3).sterilize, draping, and local anesthesia at puncture site.
 4).17G 6cm coaxial needle from puncture site with tip against post margin
 of the soft tissue lesion.
 5).18G 11cm biopsy needle, inserted through the coaxial needle, thrust
 2cm distal to the tip of coaxial needle, to take biopsy of the soft tissue lesion.
 6).1 fragment of tissue stripe (2cm in length) and 3 slides of smear were obtained from the lesion, please sent for pathology and cytology.
 7).remove the coaxial and automatic biopsy needles.
 8).sterilize and dressing the skin wound for biopsy.
 9).post-biopsy CT showed minimal air pockets at biopsy site without definite 
complication.
3.The patient tolerate the procedure well without any complaint.
4.Suggest bed rest and keep supine position for at least 4 hours.
Osteolytic lesion, right iliac bone; status post CT-guided biopsy.
)
::prerfa1::
(
Angiographies of celiac, hepatic proper and left hepatic arteries were performed via right transfemoral approach and shows:
> a hypervascular tumor stain at S2, compatible with tumor recurrence. there is no evidence of other hypervascular tumor.
> patent portal veins with hepatopetal flow.
Pre-RFA TAE was performed with lipiodol 5ml and Gelfoam fine particles via 2.7 Fr Progreat catheter (tip at left hepatic artery) till the S2 tumor stain appeared.
Post-TAE non-contrast CT scan shows well retention of the lipiodol in the hypervascular part of the tumor.
HCC recurrence at S2. s/p Pre-RFA TAE.
the subsequent RFA is scheduled on 8/13(W5) PM.
)
::prerfa1::
(
MRI of the left knee without/with IV contrast enhancement shows:1. s/p reconstruction of the anterior cruciate ligament (ACL) with patellar tendon graft, and presence of the femoral and tibial tunnels, and some focus (foci) of magnetic susceptibility artifact(s) at the left knee. 
2. intraarticular opening of the tibial tunnel partially anterior to the projected slope of intercondylar roof, r/o roof impingement.
3. no definite abnormal contour nor SI of the ACL graft with mild buckling of the PCL.
4. an infiltrative nodular focus of low SI on T2WI and mild enhancement on post-contrast T1WI at the  anterior aspect of intercondylar notch.
5. postoperative change at the patellar tendon insertion of tibial tuberosity.6. mild increased effusion with synovial proliferation in the suprapatellar bursa.
7. The lateral meniscus is intact. Truncation of the anterior horn and emiciation of the posterior horn of the medial meniscus. 
8. The MCL and LCL are intact.
9. A focus (foci) of magnetic susceptibility artifact(s) at the left patellofemoral joint, causing focal indentation of the articular cartilage of left patella. 
Suboptimal study; s/p ACL reconstruction, left, with postoperative changes; r/o roof impingement of ACL graft; r/o cyclops formation, anterior intercondylar ntoch; medial meniscal tear or s/p meniscectomy. (/6-2)
)
::wrist1::
(
MRI of right wrist without IV contrast shows:
1. a fracture line with adjacent bone marrow edema is noted at the hook of hamate on axial T2-weighted fat-sat images.
2. no increased effusion in the carpal tunnel. no thickening of the flexor retinaculum. no abnormal signal intensity of the ulnar or median nerve.
3. no increased effusion in the distal radioulnar joint, radio-carpal joint or the prestyloid recess of the wrist joint.
4. intact triangular fibrocartilage without signal intensity change.
fracture, hook of hamate. 
)
::cellu::
(
MRI of the left knee, lower leg, ankle and foot without/with IV contrast enhancement shows: 
1. suboptimal study due to some motion artifacts. 
2. cutaneous thickening and subcutaneous edmea/hyperemia with fat stranding and superficial fascial edema/hyperemia diffusely at the left knee, lower leg, ankle and dorsum foot; deep fascial edema/hyperemia between the medial and lateral heads of gastrocnemius muscle, and betweem the soleus and flexor hallucis longus muscles at the left calf with amorphous edema/hyperemia of the adjacent gastrocnemius and soleus muscles. 
3. mild effusion(s) in the left knee and ankle joint(s). 
4. no evidence of abnormal signal or enhanced lesion at the visible bony structures. 
advanced cellulitis and fasciitis, left knee, lower leg, ankle and dorsum foot; r/o necrotizing fasciitis, left calf, with gastrocnemius and soleus muscle(s) inflammation. (/@@17)
)
::brainct2::
(
Brain CT without IV contrast enhancement shows:
1. no abnormal focal density change in the brain parenchyma.
2. symmetrical sulci, fissures and ventricles.
3. intact cranial vault.
no evidence of intracranial hemorrhage.
)