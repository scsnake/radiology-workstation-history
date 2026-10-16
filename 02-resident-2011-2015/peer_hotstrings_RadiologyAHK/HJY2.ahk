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


F10::F10


::aa::abdominal aorta
::ac::acromioclavicular joint
::aca::anterior cerebral artery
::acic::atherosclerotic calcification of the intracranial vessels.
::al::alignment
::acl::anterior cruciate ligment
::am::amorphous
::an::anterolisthesis at
::art::Atherosclerosis with wall calcification of the aorta
::ate::atelectasis
::AVFX::(previous) avulsed fracture(s) at the 
::bapt::bilateral apical pleural thickening
::bde::degenerative change of the spine with marginal osteophytes formation
::bi::bilateral
::bos::Mild osteopenia of the visible bony structures.
::BPB::bil. patellar bases. 
::bpe::bilateral pleural effusion
::bpd::bulging-protruding disc(s) at the 
::BPF::bil. patellofemoral joints. 
::bps::bilateral psoas shadows are clear.
::brs::The bilateral renal shadows are obscured.
::BSI::bil. sacroiliac joints. 
::BTMF::s/p bil. transpedicle metallic fixation at the 
::BUFX::(previous) burst fracture(s) at the 
::burr::Burr hole at left frontal region
::C21::C2-3, C3-4, C4-5, C5-6, C6-7 and C7-T1 levels. 
::C23::C2-3 level. 
::C24::C2-3 and C3-4 levels. 
::C25::C2-3, C3-4 and C4-5 levels. 
::C26::C2-3, C3-4, C4-5 and C5-6 levels. 
::C27::C2-3, C3-4, C4-5, C5-6 and C6-7 levels. 
::C31::C3-4, C4-5, C5-6, C6-7 and C7-T1 levels. 
::C34::C3-4 level. 
::C35::C3-4 and C4-5 levels. 
::C36::C3-4, C4-5 and C5-6 levels. 
::C37::C3-4, C4-5, C5-6 and C6-7 levels. 
::C41::C4-5, C5-6, C6-7 and C7-T1 levels. 
::C45::C4-5 level. 
::C46::C4-5 and C5-6 levels. 
::C47::C4-5, C5-6 and C6-7 levels. 
::C51::C5-6, C6-7 and C7-T1 levels. 
::C56::C5-6 level. 
::C57::C5-6 and C6-7 levels. 
::C61::C6-7 and C7-T1 levels. 
::C67::C6-7 level. 
::C71::C7-T1 level. 
::C0::Chest PA shows normal heart size and no definite lung lesion.
::C0ER::Chest PA shows normal heart size, no definite lung lesion and elevated right diaphragm.
::C0EL::Chest PA shows normal heart size, no definite lung lesion and elevated left diaphragm.
::C0OP::Chest PA shows normal heart size, no definite abnormal ung lesion and postoperative change of the mediastinum with placement of multiple sternal wires.
::C0TA::Chest PA shows normal heart size, no deifnite lung lesion and tortuous aorta.
::C1::Chest PA shows cardiomegaly, tortuous aorta and no definite abnormal lung opacity.
::CA::calcification of aorta.
::CABG0::Chest PA shows normal heart size and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CABG::Chest PA shows cardiomegaly and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CAD::calcifiction of the coronary arteries, indicates CAD. 
::ch::Chest PA/AP shows
::chopl::Chest PA/AP shows postoperative change of the left lung. 
::chopr::Chest PA/AP shows postoperative change of the right lung.
::CHM::Chest PA (AP) shows cardiomegaly and no definite lung lesion.
::ChCT::CT of the chest without and with contrast enhancement shows:
::DACB::degenerative arthrosis of the bil. acromioclavicular joints with marginal spur formation. 
::DACL::degenerative arthrosis of the left acromioclavicular joint with marginal spur formation. 
::DACR::degenerative arthrosis of the right acromioclavicular joint with marginal spur formation. 
::DAHD::decreased acromiohumeral distance. 
::cak::calcified aortic knob is noted.
::cao::calcification of aortic wall and bilateral iliac arteries
::CF::s/p casting fixation 
::CHFX::(previous) chip fracture(s) at the 
::CIFX::(previous) comminuted impacted fracture(s) at the 
::cla::clavicle
::cm::cardiomegaly
::CMFX::(previous) comminuted fracture(s) at the 
::con::consolidation
::cp::costophrenic angle
::cpa::Chest PA film shows
::CPFX::(previous) compression fracture(s) and wedge deformity or decrease in height of the 
::CS::cervical spondylosis with posterior spur formation at the 
::CS1::cervical spondylosis with disc space narrowing and posterior spur formation at the 
::CS1M::cervical spondylosis with disc space narrowing and posterior spur formation at multiple levels. 
::CS2::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomenon and posterior spur formation at the 
::CS2M::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomena and posterior spur formation at multiple levels. 
::CSFX::(previous) comminuted spiral fracture(s) at the 
::csp::Cervical spine AP and lateral view shows:
::cta::
(
CT scan of the head without contrast enhancement shows:

Reconstruction CT angiography shows:
)
::ctal::there is no evidence of paraaortic LAPs in abdomen
::cthcc::hypodensity on precontrast, hyperdensity on arterial phase and rapid washout on venous phase; compatible with HCC.
::cthem::hypodensity on precontrast, peripheral dot-like enhancement on arterial phase, and progressive filling-in on venous phase; compatible with liver hemangioma.
::ctl::there are no definite focal lung lesions
::ctml::there is no evidence of significant mediastinal lymphadenompathies
::ctnl::there is no evidence of significant lymadenopathies in the bilateral neck areas
::ctpl::there is no evidence of paraaortic LAPs in pelvic cavity and bilateral inguingal areas.
::CUFX::(previous) curvilinear fracture(s) at the 
::cw::compatible with
::cxr::Normal heart size and no definite focal lung lesion are noted.
::dbj::s/p placement of double J catheher on
::DMF::s/p dynamic metallic fixation 
::DSL::degenerative spondylolisthesis, 
::emphy::emphysematous change
::fib::fibrotic change at
::g0::Grade 0-1
::gg::Suggest correlation with clinical manifestations.
::hemid::hemidiaphragm
::hjy::(HJY/YCC)
::iac::Stenver's view showed normal size of bilateral internal auditory canals. 
::iac2::IAC study showed normal sized and shaped bilateral internal auditory canal
::IAVP::intraarticular vacuum phenomenon(a) at the 
::IBF::s/p interbody bony fusion at the
::ibi::Increased bilateral vascular lung markings with perivascular infiltrations.
::IC::in compare to previous similar study
::ICU::Chest AP shows cardiomegaly and bilateral consolidation.
::ICU0::Chest AP shows normal heart size and bilateral consolidation.
::ICUCUFF::Chest AP shows cardiomegaly and bilateral peribronchial cuffing.
::ICUCUFF0::Chest AP shows normal heart size and bilateral peribronchial cuffing.
::ICUD::Chest AP shows cardiomegaly and bilateral diffuse consolidation.
::ICUD0::Chest AP shows normal heart size and bilateral diffuse consolidation.
::ICUDPL::Chest AP shows cardiomegaly, bilateral diffuse consolidation and pleural effusion.
::ICUD0PL::Chest AP shows normal heart size, bilateral diffuse consolidation and pleural effusion.
::ICUDTRANG::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of a tracheostomy tube and a NG tube.
::ICUDTUBE::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of an endotracheal tube, a central venous catheter and a NG tube.
::ICUPL::Chest AP shows cardiomegaly, bilateral consolidation and pleural effusion.
::ICUTRA::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy tube.
::ICUTRANG::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy and a NG tubes.
::ICUTUBE::Chest AP shows cardiomegaly, bilateral consolidation and placement of an endotracheal tube, a NG tube and central venous catheter(s).
::ICUWIRE::Chest AP shows cardiomegaly, bilateral consolidation and placement of sternal wires.
::IUD::IUD is noted superimposed in the pelvic cavity. 
::ihp::ill-defined hazy opacity
::IJE::increased joint effusion(s) in the 
::ILCC::increased lordotic curve of the cervical spine. 
::ILCL::increased lordotic curve of the lumbar spine. 
::ipo::ill-defined patchy opacity
::IUD::an intrauterine device in the pelvic cavity. 
::ivd::intervertebral disc space
::KUB::KUB shows 
::L11::L1-2, L2-3, L3-4, L4-5 and L5-S1 levels. 
::L12::L1-2 level. 
::L13::L1-2 and L2-3 levels. 
::L14::L1-2, L2-3 and L3-4 levels. 
::L15::L1-2, L2-3, L3-4 and L4-5 levels. 
::L1MC::left 1st metacarpal 
::L1MT::left 1st metatarsal 
::L1O2::L1 on L2 
::L21::L2-3, L3-4, L4-5 and L5-S1 levels. 
::L23::L2-3 level. 
::L24::L2-3 and L3-4 levels. 
::L25::L2-3, L3-4 and L4-5 levels. 
::L2F::left index finger. 
::L2MC::left 2nd metacarpal 
::L2MT::left 2nd metatarsal 
::L2O3::L2 on L3 
::L2T::left 2nd toe. 
::L31::L3-4, L4-5 and L5-S1 levels. 
::L34::L3-4 level. 
::L35::L3-4 and L4-5 levels. 
::L3F::left middle finger. 
::L3MC::left 3rd metacarpal 
::L3MT::left 3rd metatarsal 
::L3O4::L3 on L4 
::L3T::left 3rd toe. 
::L41::L4-5 and L5-S1 levels. 
::L45::L4-5 level. 
::L4F::left ring finger. 
::L4MC::left 4th metacarpal 
::L4MT::left 4th metatarsal 
::L4O5::L4 on L5 
::L4T::left 4th toe. 
::L51::L5-S1 level. 
::L5F::left little finger. 
::L5MC::left 5th metacarpal 
::L5MT::left 5th metatarsal 
::L5O1::L5 on S1 
::lPB::left patellar base. 
::LDA::lateral downsloped acromion 
::le::left
::LGH::left glenohumeral joint. 
::lk::left knee
::lla::left lung apex
::lll::left lower lung field
::lm::There is postoperative change of the left breast consistent with mastectomy.
::lml::left middle lung field
::LMRM::postoperative change with left mastectomy.
::lpa::placement of a left port A catheter
::lps::left psoas shadow is clear.
::lpe::left pleural effusion
::lrs::The left renal shadow is not well delineated
::lSI::left sacroiliac joints. 
::LSM::lumbar spondylosis with marginal spur formation at multiple levels. 
::lsp::Lumbar spine AP and lateral view shows:
::lul::left upper lung field
::mca::middle cerebral artery
::media::mediastinum
::meta::metastasis
::mf::s/p metallic fixation 
::mini::minimal
::ms::multiple focus (foci) of magnetic susceptibility artifact(s) at
::mul::multiple
::nb::no definite bone lesion
::nb1::There is no evidence of destructive bone lesion.
::nb2::no evidence of focal bony or joint lesion. no evidence of fracture or dislocation. 
::nbg::normal bowel gas pattern with some fecal material
::nbl::Normal bony alignment without focal bony lesion.
::ndisc::The disc spaces are normal.
::nf::neural foramina
::nfd::no evidence of fracture or dislocation. 
::ng::nasogastric tube insertion is noted with tip in the stomach.
::ng::Status post nasogastric tube insertion.
::nh::normal heart size
::NIC::No obvious evidence of interval change as comparison with prior study. 
::nk::Bilateral psoas shadows are clear. No evidence of radiopaque stones are noted. Nonspecific bowel gas distribution is noted.
::nl::no definite lung lesion
::nl1::Essentially clear both lung fields
::nm::Well pneumatization of bilateral mastoid bone. 
::nps::clear bilateral paranasal sinuses
::nuc::nuchal ligament calcification is noted.
::nus::no definite radiopaque density is noted in the urinary collecting system.
::OA1::minimal osteoarthritis with subtle or tiny marginal spur formation at the 
::OA2::mild osteoarthritis with small or tiny marginal spur formation at the 
::OA3::moderate osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OA4::advanced osteoarthritis with joint space narrowing, uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::obs::obscured
::op::postoperative change
::opll::ossified posterior longitudinal ligament (OPLL) at the
::os::osteopenia of the visible bony structures
::pac::s/p pacemaker implantation
::pca::posterior cerebral artery
::pcl::posterior cruciate ligment
::phl::phlebolith
::phls::Phleboliths are noted in the pelvis on
::ps::psoas shadow is not well delineated
::ra::radiopaque lesion
::raf::Fibrotic change noted at right lung apex.
::rPB::right patellar base. 
::RCTF::calcified nodule(s) or plaque(s) about the greater femoral trochanter, r/o calcified tendinosis, 
::RCTH::calcified nodule(s) or plaque(s) about the greater humeral tubercle, r/o calcified tendinosis, 
::re::retrolisthesis at 
::rGH::right glenohumeral joint. 
::ri::right
::RID::r/o internal derangement(s). 
::rk::right knee
::rla::right lung apex
::rll::right lower lung field
::rm::There is postoperative change of the right breast consistent with mastectomy.
::rml::right middle lung field
::RMRM::postoperative change with right mastectomy.
::rpa::placement of a right port A catheter
::rpe::right pleural effusion
::rps::right psoas shadow is clear.
::rrs::The right renal shadow is not well delineated
::ROCD::r/o osteochondritis dissecans. 
::rSI::right sacroiliac joints. 
::rul::right upper lung field
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
::scattered:: scattered
::sco::scoliosis of the spine
::scol::scoliosis of the lumbar spine
::SCOP::scoliosis of the spine, probably due to positioning factor. 
::scot::scoliosis of the thoracic spine
::sf::s/p screw fixation. 
::SFO1::periprosthetic radiolucency, suggestive of focal osteolysis, at the 
::sh::shadow
::si::signal intensity
::sm:: surgical material
::sp::spondylolytic spondylolisthesis
::SPB::suprapatellar bursa(e). 
::ssf::subacromial spur formation 
::stra::straightening
::STS::soft tissue swelling at the 
::sup::superimpose
::t1::T1-weighted image
::t2::T2-weighted image
::ta::torturous aorta with calcification.
::TE::traction enthesophyte formation over the 
::THRB::s/p total hip replacement with postoperative changes on both sides. 
::THRL::s/p total hip replacement with postoperative changes on left side. 
::THRR::s/p total hip replacement with postoperative changes on right side. 
::THSP::thoracic spine 
::TIE::tibial intercondylar eminence. 
::TKRB::s/p total knee replacement with postoperative changes on both sides. 
::TKRL::s/p total knee replacement with postoperative changes on left side. 
::TKRR::s/p total knee replacement with postoperative changes on right side. 
::TRA::s/p tracheostomy in position. 
::VP::vacuum phenomenon(a) in the 
::WB::weight-bearing site 
::un::unremarkable.
