﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Hsin-ming, Chen <physician@hospital.example.com>
;


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Hotstring EndChars ()[]{}:;'"\,.?!`n `t
;#IfWinActive ahk_class com.pohai.client.application.MainFrame    ;Make it active only in RIS
;#IfWinActive #32770  ;IMPAX                                      ;Make it active only in IMPAX

^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

::00::Nonspecific small mediastinal lymph nodes. 
::11::Calcified LNs at mediastinum.
::6m::Suggest short-term follow up. 
::aa::Unremarkable liver, GB, pancreas, spleen, bilateral adrenal glands and kidneys.
::AB::Mild increased peribronchial cuffings at bilateral perihilar region, R/O bronchiolitis. 
::abc::aneurysmal bone cyst
::AC::are considered. 
::acc::adrenal cortical carcinoma
::acl::anterior cruciate ligament
::AD::Bilateral adrenal glands are normal in size.
::AF::No obvious air-fluid levels. 
::AIR::No evidence of intraabdominal free air. 
::amr::MRI of abdomen without/with Gd-DTPA shows:{enter}>
::ao::Atherosclerosis with wall calcification of the aorta.
::aocad::Atherosclerosis with wall calcification of the aorta and coronary arteries.
::apmr::MRI of abdomen and pelvis without/with Gd-DTPA shows:{enter}>
::ATE::atelectasis 
::B::at both sides.
::ba::Brain cortical atrophy with prominent sulci, fissures and dilated ventricles.
::ba1::Mild brain atrophy with slightly prominent sulci, fissures and dilated ventricles.
::bbcp::Blunted bilateral CP angles.
::BC::Borderline heart size. 
::BCP::Blurring of bilateral CP angles. 
::bf::bullous formation
::BI::A small round nodule, R/O bone island or lung nodule, superimposed over 
::bil::bilateral 
::bil::bilateral 
::bk::bilateral kidneys
::BL::bilateral lungs. 
::BLCP::Blunted left CP angle. 
::BLL::bilateral lower lung zones. 
::BNI::Small nodular shadows at bilateral lower lung fields, compatible with bilateral nipple shadows. 
::BP::Diffusely decreased visible bone density, suggestive of osteoporosis. 
::BRCP::Bluncted right CP angle.
::bron::bronchiectasis
::bst::bladder stone
::BUL::bilateral upper lungs. 
::bwt::bowel wall thickening
::BYT::Bilateral apical pleural thickening. 
::BYTC::Bilateral apical pleural thickening and calcifications. 
::C0::Chest AP/PA shows: normal heart size and no definite focal lung lesion. 
::C1::Chest PA shows: {Enter}
::C2::Chest PA/AP shows: {Enter} 
::CA::Diffusely interstital thickening and numerous small nodules, R/O lymphangitic carcinomatosis at both lungs. 
::CABG::S/p CABG with sternal wiring and clips retention at mediastinum. 
::CAD::Calcified atherosclerotic plaque noted at coronary artery. Coronary atherosclerosis is considered.
::cal::calcifications
::calcs::microcalcifications
::cc::clinical conditions
::cct::* Sections through upper abdomen reveal
::cd::Crohn disease
::cf::compression fracture
::CF::Compression fracture
::CH::S/p chest tube insertion. 
::CHB::S/p bilateral chest tubes insertion. 
::CHL::S/p left chest tube insertion.
::CHR::S/p right chest tube insertion. 
::CM::Cardiomegaly. 
::CMF::Cumminuted fracture 
::cmr::MRI of chest without/with Gd-DTPA shows:{enter}>
::CO::Suggest compare with previous films or series films.  
::COMP::compared with previous study, no significant interval change is noted. 
::CON::consolidations 
::COPD::Hyperinflation with chronic infiltration over bilateral lungs, COPD is compatible. 	
::CP::Bilateral sharp CP angles. 
::CPA::CP angle
::csf::Symmetric sulci, fissures and ventricles.
::ct::CT without and with contrast enhancement shows: {Enter}*
::ct0::Noncontrast CT shows: {Enter}*
::ct3::CT without and with dynamic contrast enhancement shows: {Enter}*
::ctlc::liver cirrhosis with uneven hepatic surface, splenomegaly, ascites, esophageal varices and splenorenal shunt.
::CVL::S/p central venous line insertion. 
::CVP::S/p CVP insertion. 
::cw::compatible with
::cxr::Chest PA shows:
::DBJ::S/p DBJ catheter insertion
::DG::Spondylosis with degenerative marginal spurs formation. 
::dh::The breast tissue is heterogeneously dense, and this may lower the sensitivity of mammography.
::DLL::Decreased left lung volume. 
::DRL::Decreased right lung volume. 
::DV::decreased vertebral body height
::E::Extensive 
::EC::Enlarged cardiac shadow. 
::ED::There are bil. prominent reticulations, Kerley B lines and peribornchial cuffings. Pulmonary edema is considered. 
::EF::pleural effusion. 
::EG::S/p ET tube and NG tube insertion. 
::EGV::S/p ET-tube, NG and CVP insertion. 
::EGVS::S/p ET-tube, NG, CVP and Swan-Ganz catheter insertion. 
::EHA::Enlarged bilateral hilar shadows and prominent pulmonoary conus. 
::EL::Focal dilated bowel loops, suggestive of focal ileus at 
::ELH::Elevation of left hemidiaphragm. 
::EM::Pulmonary emphysema. 
::EM1::emphysematous changes
::ERH::Elevation of right hemidiaphragm. 
:C:Es::S/p esophagectomy with clips at mediastinum. 
::ES1::S/p esophagectomy and reconstruction with clips at mediastinum. 
::ET::S/p ET tube insertion. 
::EU::Dilated bowel loops, suggestive of ileus. 
::ev::esophageal varices
::fad::focal asymmetric density
::FAI::Report delay due to PACS system factors. 
::FC::Fibrocalcified changes 
::FI::Fibrotic changes
::fin::fibroinfiltrative patches
::FM::Much fecal material in the colon. 
::FN::Fibronodular lesions
::FU::Suggest follow up.
::fx::fracture
::GB::Metallic clips at RUQ of abdomen, previous cholecystectomy is considered.
::GBS::Radiopaque nodules superimposed over RUQ abdomen; R/O GB stones.
::GC::Suggest clinical correlation. 
::GF::Suggest further evaluation. 
::GG::Suggest correlate with clinical manifestation and follow up. 
::GGI::ground glass infiltrations 
::GGO::ground glass opacities 
::GL::Suggest correlation with lateral view. 
::glo::global enhancement in HA phase and rapid washout in PV phase 
::gm::suggest spot magnification CC and MLO views for further evaluation.
::GOIL::Increased soft tissue density at left paratracheal region with displacement of the trachea to right side. R/O goiter. 
::GOIR::Increased soft tissue density at right paratracheal region with displacement of the trachea to left side. R/O goiter. 
::GR::Suggest repeat study. 
::GS::S/p gastrostomy at upper abdomen. 
::gst::gall stone
::GT::Suggest correlation with CT study. 
::GU::Suggest ultrasound correlation. 
::gv::gastric varices
::GV::S/p NG tube and CVP insertion. 
::HA::Prominent bilateral hilar shadows. 
::HC::Multiple metallic clips at RUQ of abdomen, previous partial hepatectomy is considered. 
::HD::hemidiaphragm. 
::HE::Prominent hilar shadow 
::HI::Increased infiltrations at bilateral perihilar areas.
::hl::hypervascular lesion
::hlb::History: bilateral breast lumps, marked with BB markers.
::hll::History: a left breast lump, marked with a BB marker.
::hlr::History: a right breast lump, marked with a BB marker.
::hrct::Noncontrast chest CT and HRCT show:{Enter}*
::HS::No evidence of destructive bone lesion.
::hx::Clinical history
::I::Increased 
::IABP::S/p IABP insertion with tip at the level of proximal descending aorta. 
::ib::increased bowel gas 
::IC::is considered. 
::ICP::is compatible. 
::ICU::Cardiomegaly.  Bilateral lung consolidations. 
::icv::illeocecal valve
::ID::ill-defined 
::IH::Increased hazziness 
::II::Increased infiltration at 
::IL::Increased and dilated small bowel loops; ileus is considered. 
::IM::Calcified density superimposed over shoulder area; R/O supraspinatous calcified tendinitis
::IO::Intra-op. film shows: {Enter}
::IOR::This study was performed in the operating room for evaluation of catheter placement. No evidence of malpositioning of the catheter is noted. 
::IR:: ----- tentative report ----- 
::IUD::IUD superimposed over the pelvic cavity. 
::K::KUB shows: {Enter} 
::KN::Normal alignment. Mild marginal osteophytes formation is noted. 
::KUB::Supine KUB shows: {Enter} Bilateral clear psoas and renal shadows. Nonspecific bowel gas. No definite radiopaque stone. 
::kub::Supine KUB shows:{enter}>
::L::at left side. 
::LA::linear atelectasis
::lacu::Lacunar infarcts at the bilateral centrum semiovale, basal ganglion, brain stem.
::lam::lymphangioleiomyomatosis
::lap::lymph adenopathies
::lap::lymphadenopathy
::laps::lymphadenopathies
::LC::Bilateral lung consolidations. 
::lc::liver cyst
::LCP::Blurring of left CP angle. 
::LE::Increased bilateral vascular lung markings with perivascular infiltrations.
::leuko::Decreased density at bilateral periventricular white matter; leukoaraiosis is considered.
::LG::Diffusely linear shadows over bilateral lungs, chronic interstitial lung disease is considered. 
::lk::left kidney
::LL::The lung parenchyma are symmetrical in density with normal pulmonary markings and no masses evident. There is no pleural thickening and the costophrenic angles are sharp. 
::lll::left lower lung 
::lll::left lower lung zone.
::llll::LLL
::LM::Increased bilateral lung markings. 
::LMA::The left breast shadow is not visible, compatible with left mastectomy. 
::lmca::left scattered benign calcifications;
::lml::left middle lung zone.
::ln::lymph nodes
::ln0::no enlarged lymphadenopathy
::LNI::A small nodular shadow at left lower lung field, compatible with nipple shadow. 
::LP::ill-defined patchy lesions, suggestive of pneumonia. 
::LPA::S/p left port-A placement. 
::LT::left 
::lul::left upper lung 
::lul::left upper lung zone.
::lull::LUL
::lumpb::History: S/p bilateral lumpectomies, wires marked.
::lumpl::History: S/p left lumpectomy, wire marked.
::lumpr::History: S/p right lumpectomy, wire marked.
::LV::Low lung volume. 
::LY::Left apical pleural thickening. 
::M::mediastinum
::MA::Motion artifacts obscure the image details. 
::magn::Magnified mammography (Date:  ) of the     breast on CC and MLO views shows: {Enter}* 
::mca::bilateral benign scattered calcifications;
::MD::Mediastinum widening. 
::MDG::Mild degenerative changes of the spines with minimal spurs formation. 
::ME::Multiple nodules of variable size, suggestive of metastasis 
::META::metastasis 
::mn::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
::mot::motion artifacts degrade the image quality.
::MT::S/p mediastinal drainage tube insertion.
::mul::multiple
::N::Normal heart size. 
::NA::The bowel gas pattern is unremarkable. No abnormal calcific density in the region of the kidney or ureter is noted. 
::NAL::Normal bony alignment. 
::NB::Nonspecific bowel gas pattern.
::NC::Bilateral clear lung fields with bilateral sharp CP angles.  Normal heart size. 
::ND::No definite focal lung lesion. 
::NF::No evidence of bony fracture/ fracture line. 
::nfa::no subdiaphragmatic free air 
::NG::S/p NG tube insertion. 
::nhs::normal heart size 
::NL::Bilateral clear lung fileds and bilateral sharp CP angles. 
::NLC::Nuchal ligament calcification is noted. 
::NP::No definite focal bone lesion. 
::NS::No definite radiopaque stone. 
::NT::No significant lesion at 
::OA::Joint space narrowing with spurs formation, osteoarthritis is compatible. 
::OC::External casting is found. 
::OFR::Old fracture 
::ol::are read and compared with old films:
::OP::Post-op. change with metallic fixation at 
::OPC::Postoperative change with metallic clips at 
::OPCS::Postoperative change with metallic clips and suture materials at 
::OPCW::Postoperative change with sternal wiring and metallic clips at mediastinum. 
::OPL::Post-op. changes with decreased lung volume, elevation of hemidiaphragm, mediastinal shift and surgical materials retention at 
::opm::post-op. changes at * breast with clips retention, architectural deformity, skin retraction and thickening, stationary as compared with prior study in *. Benign post-op. changes are considered.
::OPS::Postoperative change with suture materials at 
::OPW::Postoperative change with sternal wiring. 
::ORF::Multiple old rib fractures
::os::osteoporosis
::P::patchy opacity
::PA::S/P port-A catheter insertion. 
::PACE::S/p pacemaker implantation.
::pal::Suggest ultrasound correlation if palpable lump.
::par::paraaortic region
::paraao::paraaortic
::parat::paratracheal
::PC::patchy consolidations 
::PD::Chronic infiltrations over bilateral lungs. 
::PE::Increased infiltration at bil. perihilar region. R/O pulmonary edema. 
::PH::bilateral perihilar areas. 
::pi::patchy infiltrations
::pi::pneumatosis intestinalis
::picc::S/p PICC insertion. 
::PIG::S/p pigtail catheter insertion 
::pl::Phlebolithes in the pelvic cavity.
::pm::psoas muscle
::ptx::pneumothorax
::PO::Post-op. changes at 
::PRET::pretracheal
::PRS::Clear bilateral psoas and renal shadows. 
::PS::Clear bilateral psoas shadows. 
::ps::psoas shadow
::PT::pleural thickening 
::PUL::pulmonary
::pvr::paravertebral region
::R::at right side. 
::rc::renal cyst
::RCP::Blurring of right CP angle. 
::RD::radiopaque density
::RE::reticulations
::REF::R/O pleural effusion. 
::RH::with tip at right heart level. 
::RI::R/O ileus. 
::rk::right kidney
::rll::right lower lung
::rll::right lower lung zone.
::rlll::RLL
::RMA::The right breast shadow is not visible, compatible with right mastectomy. 
::rmca::right scattered benign calcifications;
::rml::right middle lung
::rml::right middle lung zone.
::rmll::RML
::RNI::A small nodular shadow at right lower lung field, compatible with nipple shadow. 
::RO::R/O 
::RPA::S/p right port-A placement.
::RS::Clear bilateral renal shadows. 
::rs::renal shadow
::rst::renal stone
::RT::right 
::rul::right upper lung
::rul::right upper lung zone.
::rull::RUL
::ruq::RUQ abdomen.
::RY::Right apical pleural thickening. 
::s/p::status post
::sbo::small bowel obstruction
::SC::Scoliosis. 
::SD::Degenerative changes of shoulder joint. 
::SE::subcutaneous emphysema 
::SF::soft tissue swelling 
::SG::S/p Swan-Ganz catheter insertion. 
::SI::superimposed over 
::sij::sacroiliac joint
::SIT::Chest PA in sitting position shows: {Enter} 
::SKU::No definite bone lesion or fracture is recognized. No increased soft tissue density. 
::SL::slightly
::SM::Small lung volume, probable due to insufficient inspiration or distended abdomen. 
::SP::s/p 
::spl::splenomegaly
::ST::Coronary stent superimposed over the heart shadow. 
::STA::Standing abdomen shows:{Enter}No evidence of pneumoperitoneum. Nonspecific bowel gas. No obvious air-fluid levels. Bilateral clear psoas and renal shadows. 
::sts::soft tissue swelling
::SU::Supine CXR shows:{Enter} 
::SUB::Suboptimal study due to rotation of patient position. 
::SUB1::Suboptimal study due to overpenetration. 
::SUB2::Suboptimal study due to improper image processing. 
::subc::subcarina
::subp::subpleural
::sup::superimposed on
::Susp::suspicious
::t1h::T1 hyperintensity
::t1l::T1 hypointensity
::t2h::T2 hyperintensity
::t2l::T2 hypointensity
::TA::Tortuous aorta. 
::TAC::Tortuous aorta with calcification. 
::TAE::Radiopaque densities superimposed over RUQ abdomen; compatible with previous TAE effect with lipiodol accumulation. 
::TB::Fibronodular changes at bilateral upper lungs, R/O TB. 
::TRA::S/P tracheostomy. 
::us::ultrasonography
::ust::ureteral stone
::VA::valve replacement.
::vb::vertebral body
::VC::vascular calcifications.
::vcic::Vascular calcifications at intracranial vessels.
::VP::S/p VP shunt. 
::VPS::A tubular structure is found from lower neck to upper abdomen, probably due to VP shunt placement. 
::WA::was read and compared with previous study on 2007-. This study 
::WM::Widening mediastinum. 
::rha::right hepatic artery