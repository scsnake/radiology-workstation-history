;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 全域設定區 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Hotstring EndChars ()[]{};'"\,.?!`n `t
SendMode Input  
SetWorkingDir %A_ScriptDir%
#WinActivateForce
SetTitleMatchMode,2
DetectHiddenWindows,on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

::LLLZ::left lower lung zone
::LULZ::left upper lung zone
::RLLZ::right lower lung zone
::RMLZ::right middle lung zone
::RULZ::right upper lung zone
::RUQ::right upper quadrant of abodmen
::LUQ::left upper quadrant of abodmen
::3T::placement of an endotracheal tube, a NG tube, and a central venous line.

::AA::suspect amorphous radiolucency is noted, 
::AB::of abdomen. 
::ABD::Standing abdominal film shows no definite abnormal bowel dilatation and normal bowel gas pattern.
::ABDOMEN::Please correlate with the imaging findings and report of the abdominal/pelvic CT study. 
::ABDILEUS::Standing abdominal film shows dilated bowel loops with air fluid level consistent with ileus.
::ABG::air bronchogram
::ABN::abnormal
::ABPA::allergic bronchopulmonary aspergillosis
::AD::no definite abnormality of both adrenals. 
::ADPS::no definite abnormality of the adrenals, pancreas and spleen.
::AG::radiopaque density over RUQ of abdomen, gall bladder stone is compatible. 
::AH::prominent soft tissue shadow at the posterior nasophryngx, compatible with adenoid hypertrophy. 
::AK::radiopaque density over renal shadow represent renal stone, 
::AL::increased liver span with blunting of the hepatic angle represented of hepatomegaly. 
::ALN::mottled calcified nodule(s), probable of calcified lymph node(s). 
::ANG::relative paucity of the bowel gas, 
::AO::atherosclerosis with wall calcification of the aorta, 

::AP::Supine chest AP shows 
::APC::scattered opaque density below symphysis pubis because of prostatic calcification,
::APP::chest AP shows
::AS COMP::as compared with prior study on
::ASDD::s/p ASD occluder at the usual location, 
::ASP::enlarged splenic shadow represent splenomegaly, 
::ATH::absence of the uterus, compatible with previous history of ATH,
::ATO::the aorta is tortuous,
::AVR::aortic valve replacement
::AU::opaque density over paraspinal region, suggestive of ureter stone, 
::AX::bilateral small axillary lymph nodes.
::B0::no definite abnormal bone change of this study.

::B6L::the superior segment of the LLL.
::B6R::the superior segment of the RLL.
::B10L::the posterior basal segment of the LLL.
::B10R::the posterior basal segment of the RLL.
::BCT::placement of bilateral chest tubes. 
::BEC::bronchiectasis
::BFF::relative flatten bony arcs of bilateral feet, 
::BGS::gall stone(s).
::BHF::hypoplastic femoral head,
::BHGGO::ill-defined ground-glass opacities at the bilateral perihilar region with obscured bronchovascular bundle and hilum.
::BI::bilateral
::BIA::irregular acetabular fossa, 
::BIIN::bilateral inguinal regions
::BJV::placement of bilateral jugular venous catheters.
::BK::status post operation with total knee replacement, 
::BM::Multiple sclerotic foci of the spine, compatible with bone metastases.
::BN::bilateral lung nodules. 
::BO::absence of breast shadow, compatible with previous mastectomy, 
::BP::diffusely decreased visible bone density, 
::BPL::bilateral pleural effusion.
::BPR::with periosteal reaction,
::BR::status post operation with total hip replacement,
::C0::Chest PA shows normal heart size and no definite lung lesion.
::C0JJ::Chest PA shows normal heart size and no definite lung lesion. (HHJ/Dr.JW)
::C0HH::Chest PA shows normal heart size and no definite lung lesion. (HHJ/Dr.YCC)


::C0EL::Chest PA shows normal heart size, no definite lung lesion and elevated left diaphragm.
::C0ER::Chest PA shows normal heart size, no definite lung lesion and elevated right diaphragm.
::C0OP::Chest PA shows normal heart size, no definite abnormal ung lesion and postoperative change of the mediastinum with placement of multiple sternal wires.
::C0TA::Chest PA shows normal heart size, no deifnite lung lesion and tortuous aorta.
::C1::Chest PA shows cardiomegaly, tortuous aorta and no definite abnormal lung opacity.
::C1CONSD::Chest AP shows cardiomegaly and bilateral diffuse consolidation.
::C1CONSP::Chest AP shows cardiomegaly and bilateral patchy consolidation.
::C2::Chest AP shows cardiomegaly and bilateral lung consolidation.
::CA::calcification of aorta.
::CABG0::Chest PA shows normal heart size and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CABG::Chest PA shows cardiomegaly and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.
::CAD::calcifiction of the coronary arteries, indicates CAD. 
::CC::normal heart size
::CDH::relative shallow of the acetabular roof,
::CF::Suggest clinical correlation and follow up. 
::CH::Chest PA/AP shows
::CHAP::Supine chest AP shows
::CHCT::CT of the chest without and with contrast enhancement shows:
::CHCTC::CT of the chest with contrast enhancement shows:
::CHCTN2::Paired high-resolution (thin-section) CT with full inspiration and expiration and volumetric chest CT without contrast enhancement show: 
::CHCTN::CT of the chest without contrast enhancement and HRCT show:
::CHCTP::CT of the chest without and with contrast enhancement, compared with previous CT scan on , shows:
::CHOPL::Chest PA/AP shows postoperative change of the left lung. 
::CHOPR::Chest PA/AP shows postoperative change of the right lung.
::CHPA::Chest PA shows
::CIR::cirrhotic pattern of liver; splenomegaly; esophageal varices with increased collateral vessels
::CL0::Chest lateral view shows no definite abnormality. Suggest correlation with chest PA. 
::CL::Chest lateral view shows
::CLM::Chest lateral view shows cardiomegaly and no definite abnormal opacity. Suggest correlation with chest PA.  
::CM0::Chest PA shows cardiomegaly and no definite lung lesion.
::CMI::presence of contrast medium in 
::CO::consolidation
::COM::decreased pneumotization of mastoid antrum with sclerotic change, otitis medium is compatible. 
::COMCH::CT of the chest without and with contrast enhancement is read and compared with prior study dated  . This CT study shows: 
::COMP::as compared with prior study on
::COMPL::They are more prominent or new as compared with prior study.  ;L=large
::COMPS::smaller as compared with prior study                                     ;S=small
::CONS::bilateral lung consolidation 
::CONSB::bilateral basal lung consolidation 
::CONSD::bilateral diffuse lung consolidation
::CONSL::left lung consolidation
::CONSP::bilateral patchy consolidation
::CONSR::right lung consolidation
::COPD::hyperinflation and increased volume of both lungs and flattening of diaphragms.
::CORC::Calcified atherosclerotic plaque at coronary artery. Coronary atherosclerosis is considered.
::CORREL::Please correlate with the imaging findings and report of the abdominal/pelvic CT study.
::CPAC::cardiophrenic angle
::CPAL::costophrenic angle
::CPM::placement of a cardiac pacemaker.
::CPS2::mucosal thickening of the maxillary sinuse, 
::CPS::hazziness/fluid of the paranasal sinuses, sinusitis is compatible, 
::CS::of C-spine.
::CS1::cervical spondylosis with disc space narrowing and posterior spur formation at the
::CS1M::cervical spondylosis with disc space narrowing and posterior spur formation at multiple levels. 
::CS2::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomenon and posterior spur formation at the 
::CS2M::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomena and posterior spur formation at multiple levels.
::CTAS::an accessory spleen is noted.  
::CTASS::accessory spleens are noted, n=
::CTAT::artherosclerosis representing by calcifications on the aortic wall. 
::CTATA::arteriosclerotic change with calcifed plaque at intraabdominal vessels.
::CTATH::arteriosclerotic change with calcifed plaque at intracranial vessels.
::CTBA::prominent sulci, fissure and ventricles, brain atrophy is compatible. 
::CTBS::diffsue brain swelling with diminished sulci, fissure and CSF spaces. 
::CTC::well-definded homogeneous low density shadow indicates cystic lesion is noted, 
::CTCA::paucity of the soft tissue and fatty tissue in body wall, cacaxia compatible.
::CTCC::hyperdense shadows are noted at pineal gland and choroid plexuses, indicates calcifications. 
::CTCONS::Faint opacity with ground glass opacity and some dependent subpleural consolidation of both lungs. 
::CTD::the estimated radiation dose (mSv) of this study is: 
::CTFL::generalized decreased liver density indicates fatty change of liver. 
::CTIL::generalized increased liver density and prominence of hepatic vasculature, iron overiding of liver is compatible. 
::CTLA::low density change at bil. periventricular white matter, leukoaraiosis is considered. 
::CTLAT::bilateral subpleural subsegmental atelectasis at the dependent part of bilateral basal lungs.
::CTLC::uneven hepatic surface, coarse texture, splenomegaly, indicates liver cirrhosis. 
::CTLD::low density lesion noted at 
::CTLM::multiple heterogenous low density shadows in the liver, indicates liver metastasis. 
::CTLMRM::Postoperative change consistent with left mastectomy with small air pockets and hypodense fluid collection in left chest wall and axilla.
::CTLN::enlarged (>1cm) lymphadenopahty is recognized, 
::CTM::heterogenous soft tissue density shadow indicates mass lesion is noted, 
::CTN::no definite obvious lesion or abnormality is recognized in this study. 
::CTNA::no definite ascites is found. 
::CTNC::no definite focal pulmonary nodule is noted, bilateral lungs are clear. 
::CTNICH::no definite hyperdense shadow is noted in the brain or CSF spaces, no gross ICH is recognized. 
::CTNM::no definite focal mass lesion is identified in this study. 
::CTNN::no definite enlarged (>1cm) lymphadenopathy is recognized in the visible field of this study. 
::CTOB::obesity with a lot of subcutaneous fat. 
::CTPA::atrophic change of the pancreas, compatible to aging process.
::CTPC::radiopaque shadow at the pineal gland, compatible with pineal gland calcification. 
::CTPE::bilateral basal lung field pleural effusion at the dependent part, 
::CTPEA2::minimal pleural effusion with subsegmental atelectasis in bilateral basal lungs.
::CTPEA::bilateral basal lung field pleural effusion at the dependent part with adjacent lung partial atelectasis, 
::CTPF::fatty replacement of the pancreas.
::CTRC::homogenous low density lesions in the kidney, renal cysts are considered. 
::CTRMRM::Postoperative change consistent with right mastectomy with small air pockets and hypodense fluid collection in right chest wall and axilla.
::CTSC::status post-operation with a scar in the anterior abdominal wall. 
::CTUIP::diffuse bilateral interstitial infiltration, with prominent ground glass opacity and reticulation, more localized at subpleural region and lower lung fields. There is decreased lung capacity. Mild traction bronchiolectasis is noted. Therefore, an interstitial lung disease is considered. R/o interstitial pneumonitis. 
::CVP::central venous catheter
::CVPET::placement of a central venous catheter and an endotracheal tube.
::CVPNG::placement of a nasogastric tube and a central venous line. 
::CX::cardiomegaly
::CYBK::bilateral renal cysts.
::CYBL::bilateral liver cysts.
::CYLK::left renal cysts.
::CYRK::right renal cysts.



::DB1::Dense breasts and no definite mammographic abnormality in this study (ACR BI-RADS category 1). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
::DB2::Dense breasts and benign mammographic findings in this study (ACR BI-RADS category 2). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
::DB3::Dense breasts and probably benign mammographic findings in this study (ACR BI-RADS category 3). Suggest short term follow up andand ultrasound correlation if there is clinical palpable lump or prior detected abnormality.
::DEGS::degenerative changes of spine with marginal spur at multiple levels.
::DEGSTL::degenerative changes of T-L spine with marginal spur at multiple levels. 
::DIS::distal
::DISL::dislocation
::DICO::diffuse consolidation
::DJDBK::degenerative change of both knees with marginal spur formation and joint space narrowing.
::DJDC::degenerative change of the C spine.
::DJDL::degenerative change of the L spine.
::DJDLK::degenerative change of the left knee with marginal spur formation and joint space narrowing.
::DJDRK::degenerative change of the right knee with marginal spur formation and joint space narrowing.
::DJDSP::Degenerative change of the spine with marginal spur formation.
::DJDSS::degenerative change of the spine and shoulders.
::DJDT::degenerative change of the T spine.
::DJDTL::degenerative change of the T and L spine.
::DLC::decreased lung capacity
::DLLC::decreased left lung capacity
::DRLC::decreased right lung capacity
::DSL2::grade 0-1 degenerative spondylolisthesis of the L2 on L3 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL3::grade 0-1 degenerative spondylolisthesis of the L3 on L4 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL4::grade 0-1 degenerative spondylolisthesis of the L4 on L5 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL5::grade 0-1 degenerative spondylolisthesis of the L5 on S1 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL::degenerative spondylolisthesis, 


::ECMO::placement of large bore vascular cannula, consistent with ECMO.
::EL::elevated left hemi-diaphragm.
::EM::bilateral pulmonary emphysema.
::EN::enhancement 
::EO::disproportional dilated bowel loops, suggestive of obstructive ileus,
::ER::elevated right hemi-diaphragm.
::ERCHEST::Chest PA/AP shows cardiomegaly and bilateral lower lung consolidations.
::ERCX0::Chest PA shows normal heart size and bilateral lung consolidation.
::ERCX::Chest PA shows carciomegaly and bilateral lung consolidation, predominantly at lower lung fields.
::ERCXL::Chest PA shows cardiomegaly and left lower lung consolidation.
::ERCXR::Chest PA shows cardiomegaly and right lower lung consolidation.
::ESOP::postoperative change with total esophagectomy. There is bypass grafting at the mediasitnum. Placement of multiple surgical clips at the mediastinum and upper abdomen. 
::ET::placement of an endotracheal tube.
::ETT::endotracheal tube
::ETCVP::Placement of an endotracheal tube and a central venous catheter. 
::ETNG::Placement of an endotracheal tube and a NG tube.


::FC::fibrotic change
::FCA::fibrocalcified change
::FCABU::fibrocalcified change of both upper lobes.
::FCALU::fibrocalcified change of the left upper lobe.
::FCARU::fibrocalcified change of the right upper lobe. 
::FCBU::fibrotic change of both upper lobes.
::FCM::mild fibrotic change
::FCMBU::mild fibrotic change of both upper lobes.



::G::suggest correlation with clinical manifestation.
::GB::gall bladder
::GCCT::Suggest coronary CT for further evaluation. 
::GCT::Suggest * CT for further evaluation.
::GD::suggest decubitus (>3min) abdomen with cross-table x-ray or standing (>3mm) CXR cover upper abdomen image to detect possible free air.
::GEB::suggest alimentary barium study for further workup. 
::GES::suggest alimentary scopy study for further workup. 
::GG::suggest follow up & correlated with clinical manifestration. 
::GGO::ground glass opacities
::GL::suggest lateral view for further evaluation. 
::GR::suggest MRI study for further evaluation. 
::GS::suggest further workup & correlated by sonography. 
::GT::suggest CT study for further evaluation. 
::GTA::suggest correlation with the findings and report of the abdominal CT study.
::GTT::suggest non-contrast CT for further screening. 
::GU::suggest IVP for further evaluation. 


::HET::heterogenous
::HH::(HHJ/Dr.YCC)
::HY::hydronephrosis
::HX::history


::IC::in compare to previous similar study 
::ICU0::Chest AP shows normal heart size and bilateral consolidation.
::ICU::Chest AP shows cardiomegaly and bilateral consolidation.
::ICUCUFF::Chest AP shows cardiomegaly and bilateral peribronchial cuffing.
::ICUD0::Chest AP shows normal heart size and bilateral diffuse consolidation.
::ICUD0PL::Chest AP shows normal heart size, bilateral diffuse consolidation and pleural effusion.
::ICUD::Chest AP shows cardiomegaly and bilateral diffuse consolidation.
::ICUDPL::Chest AP shows cardiomegaly, bilateral diffuse consolidation and pleural effusion.
::ICUDTRANG::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of a tracheostomy tube and a NG tube.
::ICUDTUBE::Chest AP shows cardiomegaly, bilateral diffuse consolidation and placement of an endotracheal tube, a central venous catheter and a NG tube.
::ICUPL::Chest AP shows cardiomegaly, bilateral consolidation and pleural effusion.
::ICUTRA::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy tube.
::ICUTRANG::Chest AP shows cardiomegaly, bilateral consolidation and placement of a tracheostomy and a NG tubes.
::ICUTUBE::Chest AP shows cardiomegaly, bilateral consolidation and placement of an endotracheal tube, a NG tube and central venous catheter(s).
::ICUWIRE::Chest AP shows cardiomegaly, bilateral consolidation and placement of sternal wires.
::ICV::CVP line insertion from the inguinal region, 
::IDGGO::ill-defined ground-glass opacities
::IDHO::ill-defined hazy opacity
::IDM::ill-defined margin
::IDPI::ill-defined perihilar infiltration
::II::increased infiltration 
::ILE::dilated bowel loops consistent with ileus.
::IMP::condition improved/size decreased in compare to previous similar study
::INF::inflammation 
::IP::compatible. 
::IRR::irregular
::ISD::increased soft tissue density shadow
::IST::interlobular septal thickening
::IUD::IUD is noted superimposed in the pelvic cavity. 

::JJ::(HHJ/Dr.JW)

::K0::KUB shows normal bowel gas, no definite abnormal opacity, no definite abnormal bone change.
::Kdjd:: KUB shows normal bowel gas, no definite abnormal opacity, and degenerative change of the L spine.
::KG0::KUB shows decreased bowel gas.
::KGAS::KUB shows prominent bowel gas.
::KI::KUB shows dilated bowel loops and prominent gas, consistent with ileus.
::KST::KUB shows stool impaction and no definite bowel dilatation.
::KUB::
(
KUB shows:
Bilateral clear psoas shadows. No abnormal calcification. Unremarkable intestinal air pattern. Mild spondylosis and degenerative changes with marginal spurs are noted.
)

::L0::no definite abnormal lung abnormality.
::LAP::lymphadenopathy
::LAPAX::bilateral axillary lymphadenopathy.
::LAPM::bilateral mediastinal lymphadenopathy.
::LAPMAX::bilateral mediastinal and axillary lymphadenopathy.
::LAPMH::bilateral mediastinal and hilar lymphadenopathy.
::LAPMHL::left mediastinal and hilar lymphadenopathy.
::LAPMHR::right mediastinaland hilar lymphadenopathy.
::LAPML::left mediastinal lymphadenopathy.
::LAPMR::right mediastinal lymphadenopathy.
::LAT::atelectasis
::LAX::linear or subsegmental atelectasis
::LB::increased bilateral basal lungs infiltration. 
::LBC::left basal consolidation
::LC::absence of the gall bladder with opaque clips in the hepatic hilum, compatible with laparoscopy cholecystectomy.
::LCM::lymphangitic carcinomatosis
::LCT::placement of a left chest tube.
::LCVP::placement of a left central venous catheter.
::LD::elevation of the diaphragm is noted, 
::LF::increased fibrotic change, 
::LG::diffusely linear shadows over bilateral lungs, chronic interstial lung disease is considered. 
::LH::increased pulmonary infiltration at bil peribronchial parahilar region; bronchitis is compatible. 
::LHC::left ill-defined perihilar infiltration and consolidation.
::LHGGO::ill-defined ground-glass opacities at the left perihilar region with obscured bronchovascular bundle and hilum.
::LHH::prominent increased bilateral pulmonary infiltrations at peribronchial parahilar regions; bronchopneumonia is compatible.
::LHM::left hilar mass
::LJCVP::placement of a left jugular venous catheter.
::LJV::placement of a left jugular venous catheter.
::LKB::There are some Kerley's B lines at the left lung.
::LLC::low lung capacity and abdominal distention
::LLLF::left lower lung field
::LMLF::left middle lung field
::LMRM::post operative change with left mastectomy. 
::LMRMR::post operative change with left mastectomy and placement of a right port A catheter.
::LN::nodular lesion is noted, 
::LO::low lung capacity.

::LOBECTOMYLL::postoperative change with lobectomy of the LLL and placement of surgical clips at the left hilum and mediastinum.
::LOBECTOMYLU::postoperative change with lobectomy of the LUL and placement of surgical clips at the left hilum and mediastinum.
::LOBECTOMYRL::postoperative change with lobectomy of the RLL and placement of surgical clips at the right hilum and mediastinum.
::LOBECTOMYRM::postoperative change with lobectomy of the RML and placement of surgical clips at the right hilum and mediastinum.
::LOBECTOMYRU::postoperative change with lobectomy of the RUL and placement of surgical clips at the right hilum and mediastinum.
::LOO::status post operation with multiple suture materials and metallic clips in the hilum, 
::LOWABD::low lung capacity and abdominal distention. 
::LPL::left pleural effusion.
::LPORT::placement of a left port A catheter.
::LPR::left perihilar region
::LPS::small patch shadow noted, 
::LR:: dilated bronchi, suggestive of bronchiectasis, 
::LS::of the L-spine. 
::LSS::fine interstitial pattern of the bilateral lungs; senile change is compatible. 
::LSV::placement of a left subclavian venous catheter. 
::LT::multiple pulmonary nodules of variable size, suggestive of lung metastasis. 
::LTB::fibrotic change of the bilateral upper lungs, pulmonary T.B. is considered. 
::LU::prominent pulmonary hilum is noted, 
::LULF::left upper lung field
::LX::free air collection in the pleural space suggestive of pneumothorax, 


::M::mild 
::MAF::severe motion artifact due to the involantory movement of the patient that may mask the detail finding.
::MCM::Chest PA shows mild cardiomegaly and no definite abnormal lung opacity. 
::ME::mediastinum 
::MED::bilateral small mediastinal lymph nodes.
::MED2::bilateral small nonspecific mediastinal lymph nodes
::MEDAX::bilateral small mediastinal and axillary lymph nodes.
::MEDI::mediastinal
::MEDIW::mediastinal widening
::metas::metastatsis
::MGC::much gas collection in the bowel loops,
::MGCA::much gas collection in the bowel loops at
::MGEC::much gas & fecal material collection in the bowel loops,
::MH0::no definite mediastinal or hilar lymphadenopathy.
::MI::minimal
::MID::middle
::MN::multiple bilateral lung nodules, consistent with metastases.
::MO::moderate 
::MOL:: more on the left side
::MOR:: more on the right side
::MRML::postoperative change consistent with left mastectomy.
::MRMR::postoperative change consistent with right mastectomy.
::MVR::mitral valve replacement
::MW::mediastinum widening





::N::no definite 
::NA::no definite bone lesion,the bowel gas pattern is unremarkable. 
::NAF::no definite bone lesion, much fecal material is noted in the bowel loops, suggest correlated with clinical presentation & follow up. 
::NAG::no definite bone lesion, the bowel gas pattern is unremarkable, suggest correlated with clinical presentation and follow up study if clinically indicates. 
::NAT2::the lesion is too small to be further chartacterized.
::NAT::nature ? 
::NB::no definite obvious bone lesion. 
::NBG::no definite obvious bone lesion, no definite obvious fracture. please correlated with cllinical presentation or follow up. 
::ND::no definite obvious bone lesion, the joint space and alignment are normal. 
::NF::no definite obvious bone fracture is recognized. 
::NFA::no definite free air is noted at the non-dependent portion, 
::NFB::no definite radiopaque foreign body is noted at the pharynx, upper trachea & esophagus. 
::NFLSP::no definite focal lesion in the liver, pancreas and spleen. 
::NFLSPK::no definite focal lesion in the liver, pancreas, spleen and bilateral adrenal glands & kidneys. 
::NFLSU::no definite focal lesion in the visible upper liver and spleen. 
::NFSPK::no definite focal lesion in the pancreas, spleen and bilateral adrenal glands & kidneys.
::NG::placement of a NG tube.
::NGT::NG tube
::NGCVP::Placement of a nasogastric tube and a central venous line. 
::NICH::no definite intra-cranial hemorrhage. 
::NL::no definite abnormality of bilateral lung parenchyma.
::NLL::no definite lung lesion.
::NLAP::No definite mediastinal or hilar lymphadenopathy.
::NLC::nuchial ligament calcification is noted, 
::NLN::no definite enlarged (>1cm) lymphadenopathy is noted. 
::NNBL::no definite focal nodular leison in the bilateal basal lungs. 
::NOB::no definite gross osteolytic / osteosclerotic bone lesion is recognized. 
::NOP::no definite radiopaque nodular shadow noted,
::NR::bilateral clear psoas and renal shadows are recognized. 
::NRT::no definite recurrent tumor mass is noted. 
::NS::no definite bone lesion, the disc spaces and alignment are normal, 
::NSI::No significant interval change.
::NVT::no definite viable tumor could be identified that representing as enhanced nodule, 


::OA::joint space narrowing with spurs formation, degenerative change is compatible,
::OA1::minimal osteoarthritis with subtle or tiny marginal spur formation at the 
::OA2::mild osteoarthritis with small or tiny marginal spur formation at the 
::OA3::moderate osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OA4::advanced osteoarthritis with joint space narrowing, uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OBCP::obscured bilateral CP angles and possible small bilateral basal effusion.
::OBSCB::obscured bilateral costophrenic angles. 
::OBSCL::obscured left lateral costophrenic angle. 
::OBSCR::obscured right lateral costophrenic angle. 
::OC::external cast fixation is found which may mask the details findings,
::OLCP::obscured left lateral CP angle and possible small left basal effusion.
::OO::post operative changes with 
::OOC::post operative change with clips at
::OOCS::post operative change with clips & suture materials at
::OOI::post operative change with implant at
::OOS::post operative change with suture materials, 
::OOT::post operative changes with tube(s) in the field of view with appropriate position, 
::OOTSSG::post operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration. 
::OOZ::There is blood oozing from the coaxial needle after the first fire. Hypervascular nature of the tumor is considered.
::OPLL::postoperative change of the left lung with placement of clips and suture at the left hilum and mediastinum.
::OPLU::postoperative change of the left upper abdomen with placement of clips.  
::OPRL::postoperative change of the right lung with placement of clips and suture at the right hilum and mediastinum.
::OPRU::postoperative change of the right upper abdomen with placement of clips.
::ORCP::obscured right lateral CP angle and possible small right basal effusion.
::OS::opaque shadow
::OW::post operative change with wiring at 
::OWS::post operative change with wiring at sternum, 
::OX::status post internal fixation, 



::PA::Chest PA shows 
::PC::calcified pleural peel is noted, 
::PDAC::s/p coil embolization of the PDA at the usual location, 
::PDAD::s/p device embolization of the PDA at the usual location, 
::PERI::increased bilateral peribronchial cuffing and infiltration. 
::PH::pelvic floor phlebolithes is noted,
::PHVP::the poral & hepatic veins are patent.
::PK::apical pleural is irregular thickening,
::PL::pleural effusion. 
::PP::peribronchial patch
::PPI::Peribronchial patchy infiltration
::PR::proximal 
::PRE::previous
::PRO::prominent 
::PSK::(Please refer to the uploaded key image with annotation in the Summary series) 
::PTX::pneumothorax
::PVL::increased low density in the peri-ventricular white matter, 
::PVLM::increased signal intensity in the peri-ventricular white matter, 
::PWBI::posterior wall of the bronchus intermedius
::QQ::the nature should be further determinated ?

::RADL::post-radiation lung parenchymal change is considered.
::RAT::remove the endotracheal tube, 
::RBC::right basal consolidation
::RC::remove the chest tube, 
::RCC::remove casting, 
::RCT::placement of a right chest tube.
::RCVP::placement of a right central venous catheter.
::RG::remove the NG tube,
::RHC::right ill-defined perihilar infiltration and consolidation.
::RHGGO::ill-defined ground-glass opacities at the right perihilar region with obscured bronchovascular bundle and hilum.
::RHM::right hilar mass
::RJCVP::placement of a right jugular venous catheter.
::RJV::placement of a right jugular venous catheter.
::RKB::There are some Kerley's B lines at the right lung.
::RLLF::right lower lung field
::RM::remove the mediastineal drainage tube, 
::RMLF::right middle lung field
::RMRM::postoperative change with right mastectomy.
::RMRML::postoperative change with right mastectomy and placement of a left port A catheter.
::RP::remove the CVP line, 
::RPL::right pleural effusion. 
::RPORT::placement of a right port A catheter.
::RPR::right perihilar region
::RSV::placement of a right subclavian venous catheter.
::RT::soft tissue density shadow indicates recurrrent lesion is noted,
::RULF::right upper lung field
::RX::remove fixation, 

::SA::subsegmental atelectasis
::SABD::Standing abdominal film shows normal bowel gas and no definite abnormal bone change.
::SABDI::Standing abdominal film shows dilated bowel loops with prominent gas and air fluid level, consistent with an ileus.
::SC::spine scoliosis is noted, 
::SCANL::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with L leg longer than R one about 
::SCANN::Low extremeties scanogram  with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows no definite obvious length discrepancy of the bilateral legs. 
::SCANR::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with R leg longer than L one about 
::SCI::faint cerebral gyral indentation on the skull bone,
::SCOL::scoliosis of the spine 
::SCOLT::Scoliosis of the T spine.
::SCOLTL::Scoliosis of the T and L spine.
::SCOLTLM::Mild scoliosis of the T and L spine.
::SCOLTM::Mild scoliosis of the T spine. 
::SCNN::Mild scoliosis of the spine, may due to positioning.
::SCR::superior pericardial recess
::SEM::(SE, IM)
::SFC::subpleural fibrotic change
::SG::placement of a Swan-Ganz catheter. 
::SIL::silhouette
::SIZ::* cm in greatest dimension 
::SK::spine kyphosis is noted, 
::SL::spondylolithesis is noted, 
::SN::essential clear of the bilateral paranasal sinuses without definite bone change, 
::SO::bone defect is noted over posterior part of spine represented previous lamilectomy, 
::SOP::s/p
::s/p::status post
::SP::spondylosis and degenerative changes with marginal spurs are noted, 
::SS::sationary in compare to previous similar study, 
::SSD::sationary in compare to previous similar study.
::SSG::sationary in compare to previous similar study, suggest correlated with clinical manifestration.
::STAT::stationary imaging findings as compared with prior study. 
::STS::adjacent soft tissue swelling noted,
::SU::suspect
::SUCT::Suggest CT for further evaluation.
::SUP::superimposed
::SUS::Suggest ultrasound for further evaulation.
::SVI::vascular indentation on the skull bone, 
::SW::placement of multiple sternal wires.

::TA::tortuous aorta.
::TAC::tortuous aorta with calcification. 
::TACE::post-TAE change with opaque contrast retention in the liver.
::TD::status post drainage tube placement. 
::TDL::tracheal displacement to the left
::TDR::tracheal displacement to the right
::TDU::status post placement of a duodenal feeding tube.
::TE::status post tracheostomy with airway tube insertion, 
::TECVP::Placement of a tracheostomy tube and a central venous catheter.
::TENG::Placement of tracheostomy tube and a nasogastric tube.
::TG::status post NG tube insertion, 
::TK::status post PCN catheter insertion, 
::TL::of the T-L spine. 
::TM::status post mediastineal tube insertion for drainage, 
::TN::several hypodense nodules in bilateral thyroid lobes.
::TOA::status post upper chest wall Port-A implantation, 
::TP::status post CVP line insertion, 
::TR::status post pacemaker implantation, 
::TRA::placement of a tracheostomy tube.
::TRACVP::placement of a tracheostomy tube and a central venous catheter.
::TRANG::placement of a tracheostomy tube and a NG tube.
::TU::status post double-J catheter insertion, 
::TUA::s/p umbilical arterial line insertion, 
::TUAV::s/p umbilical arterial and venous lines insertion,
::TUV::s/p umbilical vein line insertion, 
::TVP::s/p ventriculo-peritoneal (VP) shunt tube placement, 

::UB::urinary bladder
::UDC::double contour of the urinary bladder base is noted. 
::UNR::unremarkable
::UNRL::unremarkable liver, gall bladder, pancreas, spleen, kidneys and adrenal glands
::UU::smooth concaved cephalic contour of the urinary bladder, compatible with uterus indentation.
::VT::viable tumor is noted with presenting as enhanced mass at 

::WI::with

::WIRE::placement of multiple sternal wires.
::WIRETUBE::placement of multiple sternal wires, mediastinal drain, endotracheal and NG tubes.
::WT::wall thickening is noted, 

::WTE::wall thickening is noted with abnormal enhancement, 
::WTI::irregular wall thickening is noted, 
::WX::without



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 罐頭區
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



::BXL::    ; CT-guided lung biopsy  L=lung
(
CT-guided biopsy of the lung is performed in prone position with the use of a 19G coaxial guiding needle and a 20G biopsy needle:
-- Location of the lesion: left lower lobe mass (at least 5.6cm) with cavity and pleural effusion.
-- Underlying lung condition: lung mass with adjacent consolidation and left pleural effusion.(with adjacent cystic component or bullae, and airbronchogram.)
-- Total length of the needle from skin to lesion: 6.1 cm
-- Total length of the needle traversing lung: 3.4 cm
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 4 (There is blood oozing from the coaxial needle after the first fire. Hypervascular nature of the tumor is considered.)
-- Pneumothorax: nil
-- Hemothorax: nil
-- Hemorrhage: nil
-- Hemoptysis: nil
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: supine
-- There are total 4 tissue stripes, 4 imprint smears, 1 culture tubes, and 1 swab obtained for pathology and cytology studies. Suggest complete bed rest for 4 hours in supine position and follow up chest radiography 6 hours later after biopsy.

IMPRESSION:
Left lower lobe mass status post CT-guided biopsy.
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



::CHMRM0::                       ;chest MR for mediastinum
(
Purpose: History of atypical chest pain, r/o mediastinal mass lesion clinically.
Pulse sequences: EKG-gating coronal and axial T2 TrueFISP, axial T1 HASTE with/without fat suppression for morphology of mediastinum. 
MR findings:
* mild cardiomegaly. Left side aoric arch and descending aorta with normal three cephalic branches. 
* no eveidence of abnormal mass lesion is noted in mediastinum. Please correlate with clinical findings. 
* lung can't be well evaluated in MR study.

IMP:
no eveidence of mediastinal mass.  
)



::CHMRLVOT0::              ;chest MR for LVOT normal Form
(
Purpose: History of subvalvular aortic stenosis causing LVOT obstruction and LV hypertrophy s/p Morrows operation and aortoplasty. For post-op LVOT and LV function.
Pulse sequences: ECG-gating axial and sagittal T1WI dark blood HASTE and T2 TrueFISP cine. 
MR findings: 
* increased diameter of LVOT and supravalvular ascending aorta (about 2.8 cm) as compared with the previous MR (pre-operation) in 2007/09/11. The cross sectional area of the LVOT at end systole measures about 3.0 cm^2.     
* moderate aortic regurgitation and mitral regurgitation. Mild trucuspid regurgitation.
* no definite hypertrophy of the LV wall.
* LV function: To be continued
)



::CHMRDAA::
(
Purpose: aortic dissection, Stanford type B, for follow up.
Pulse sequences: ECG-gating T1W dark blood HASTE, and T2W TrueFISP.
MRI findings:
* aortic dissection from proximal descending aorta down to bil common iliac arteries. Both true lumen and false lumen are patent. There is mild partial thrombus in the false lumen. The maximal diameter of the descending aorta measures about 5.5 cm. As compared with the previous MRI study on 2007-07-04, it was 5.2 cm. Progressive enlargement of the aneurysm is impressed. The diameter of the ascending aorta measures about 4.5 cm. 
* The celiac trunk, SMA, and right renal artery arise from the true lumen. The orifice of the left renal artery seems to arise from the false lumen. Atrophy of the left kidney is noted.
* mild bilateral pleural effusions.
* The maximal diameter of the abdominal aorta measures about 4.3 cm at the level just above the celiac trunk.
IMP:
Aortic dissection, Stanford type B. Progressive enlargement of the aneurysm in the descending aorta.
)



::CHMRCAD::
(
Purpose: CAD, 3VD, ICMP, s/p CABG, AVP, MVP, TVP and SAVER. For LV function.
Pulse sequences: ECG-gating TrueFISP cine for LV function, and post-Gd IR-prepped segmented TurboFLASH for myocardial scarring.
MRI findings:
* relatively reduced sizes of LV and LA. There is no transvalvular regurgitation or stenosis.
* relatively improved contractility of the LV walls at basal and mid LV level. The LV apex is separated from the main LV cavity by a disk. Akinesia of the wall of the LV apex and a small mural thrombus are noted. 
* hyperenhancement (>50% transmurality) at the akinetic segments mentioned above. There is diffuse faint hyperenhancement of the LV myocardium. Diffuse myocardial fibrosis due to ischemic cardiomyopathy is considered.
* LV function and mass: to be continued.
)



::CHMRHCM::                   ;hypertrophic cardiomyopathy
(
Purpose: R/O hypertrophic cardiomyopathy.
Pulse sequences: ECG-gating TrueFISP cine for LV function, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* normal sizes of cardiac chamber. No definite hypertrophy of the LV wall is noted. There is mild mitral regurgitation.
* normal contractility of the LV/RV walls. There is sluggish early LV dilatation followed by atrial kick. R/O diastolic dysfunction.
* no definite hyperenhancement in the LV/RV walls.
* LV function and mass: to be continued.
)



::CHMRPA::                         ; pulmonary atresia.
(
Purpose: SOB, palpitation, Echo: R/O pulmonary HT, Eisenmenger syndrome.
Pulse sequences: ECG-gating T1W dark blood HASTE, TrueFSIP, contrast-enhanced 3D MRA, TrueFISP cine, and IR-prepped segmented TurboFLASH.
MRI findings:
* normal sizes of the cardiac chambers. Mild hypertrophy of the RV wall is noted. There is no transvalvular stenosis or regurgitation. Minimal pericardial effusion is noted. 
* Straightening of the interventricular septum at early diastole. Elevated RV diastolic pressure is considered. Normal contractility of the LV/RV walls.
* Abscence of right pulmonary artery is noted. Congenital right pulmonary artery aplasia is considered. Prominent bronchial arteries are noted supplying the right lung. Focal infiltrates are found in the periphery of right lower lobe.
* Engorged pulmonary trunk and left pulmonary artery. There are suspicious multiple stenoses at the left pulmonary arteries with post-stenotic dilatation. 
* no definite hyperenhancement in the LV/RV myocardium.
* LV function and mass: to be continued.
)



::CHMREBS::                   ;Ebstein anomaly s/p Brock procedure
(
Purpose: Ebstein anomaly s/p Brock procedure and PVP, TVP, ASD repair and right heart MAZE.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, 3D contrast enhanced MRA for pulmonary arteries imaging, TrueFISP cine for RV function and IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* mildly dilated RV and RA. Moderate pulmonary regurgitation, moderate pulmonary stenosis, and mild tricuspid regurgitation are found.
* corrected positin of the tricuspid valves. 
* normal contractility of the RV wall.
* engorged MPA.
* no definite hyperenhancement in the RV or LV myocardium.
* PR index (To be continued)
)



::CHMRAMI::                   ;for acute myocardial infarction.
(
Purpose: R/O AMI or acute myocarditis.
Pulse sequences: ECG-gating contrast enhanced MRA, TrueFISP cine for LV function, and delayed enhanced IR-prepped segmented TurboFALSH for myocardial scarring.
MRI findings:
* normal sizes of cardiac chambers. Moderate mitral regurgitation and mild aortic regurgitation and stenosis are found. There is mild pericardial effusion and bil pleural effusions.
* global hypokinesia of the LV wall. 
* scattered small patches of hyperenhancement mostly at the outerwall of the septum and anterior wall of the LV. The enhancement pattern is compatible with acute myocarditis. Advise clinical correlation.
* LV function and mass: to be continued.
)



::CHMRICM::
(
Purpose: ICM s/p CABG + MVP + SVR. HYHA2. For LV function and myocardial scarring.
Pulse sequences: ECG-gating TrueFISP cine for LV function and IR-prepped segmented TurboFLASH for myocardial scarring.
MRI findings:
* cardiomegaly with mild pericardial effusion and pleural effusion.
* global hypokinesia of the LV walls. The apical LV is separted by a patch due to SVR, and shows akinesia. There is no leakage of the patch.
* transmural hyperenhancement at the mid anterior, mid anteroseptal, mid inferior, apical anterior, apical septal, apical inferior segments. 
* LV function and mass:to be continued.
)



::CHMRVSD::
(
Purpose: VSD s/p repair. For PR fraction and RV function.
Pulse sequences: ECG-gating free breathing contrast enhanced 3D MRA, Turbo FLASH cine for RV function and navigator-echo gated IR-prepped 3D segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* mild dilatation of RV. Moderate to severe pulmonary regurgitation is found.
* normal contractility of the LV/RV walls.
* no definite hypernehancement of the LV/RV myocardium.
* PR fraction (To be continued)
* RV function (To be continued)
)



::CHMRARVD::
(
Purpose: PSVT and family history of ARVD. For follow up.
Pulse sequences: ECG-gating T1W dark blood HASTE with and without fat suppression for cardiac morphology, TrueFISP cine for RV/LV function, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* normal sizes of cardiac chambers. No definite transvalvular stenosis or regurgitation is found.
* no definite hypokinesia or focal bulging in the LV/RV walls.
* no definite hyperenhancement in the LV/RV myocardium.
The above MRI findings do not provide evidence for the diagnosis of ARVD.
* RV function (To be continued)
)



::CHMRTOF::
(
Purpose: TOF s/p total correction. For RV function, pulmonary arteries morphology, RV function and PR fraction.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, contrast enhanced 3D MRA for vascular imaging, TrueFISP cine for RV function and regional wall motion, and delayed enhanced IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* Mild dilatation of the RV and RVOT. There are mild to moderate pulmonary regurgitation and pulmonary stenosis. 
* mild hypokinesia of the RV wall. Straightening of the interventricular septum during diastole. Elevated RV diastolic pressure is considered.
* no definite segmental stenosis in the MPA or bilateral pulmonary arteries.
* focal hyperenhancement at the RVOT and basal septum, probably due to OP change.
* PR fraction (To be continued)
)



::CHMRTOF2::
(
Purpose: TOF s/p total correction. For RV function, PR fraction, pulmonary arteries morphology and RV myocardial fibrosis.
Pulse sequences: ECG-gating phase contrast cine for flow quantification, contrast enhanced 3D MRA for vascular imaging, TrueFISP cine for RV function, and IR-prepped segmented TurboFLASH for myocardial fibrosis.
MRI findings:
* dilated RV. Moderate pulmonary regurgitation and mild pulmonary stenosis are found. 
* normal contractility of the LV/RV walls. Mild straightening of the interventricular septum is noted at early diastole.
* right side aortic arch with abberant left subclavian artery. The first branch is left common carotid artery, the second branch is right innominate artery, and the third branch is ALSA.
* no definite hyperenhancement of the LV/RV myocardiu.
* PR fraction (To be continued)
)


::CHMRFAB::
(
Hx of Fabry disease.
Purpose: for delayed enhancement evaluation.
Pulse sequences: ECG-gating contrast enhanced MRA, TrueFISP cine for LV function, and delayed enhanced IR-prepped segmented TurboFALSH for myocardial scarring.
MRI findings:
* normal sizes of cardiac chambers. 
* no evidence of transvalvular regurgitation or stenosis .
* no LV hypokinesia. mild atrial kick, which may indicate mild LV diastolic dysfunction.
* diffuse enhancement of the RV wall. patchy enhancement at the inferolateral wall of LV. small linear enhancement at the septal wall.
* LV function and mass: to be continued.
)

::CHMRCOA::
(
Purpose: R/O coarctation of aorta.
Pulse sequences: ECG-gating T1W dark blood HASTE and T2W TrueFISP.
MRI findings:
* normal caliber of the aorta; ascending aorta measures about 4.1 cm, and descending aorta measures about 2.7 cm.
* no definite aneurysm or coarctation of aorta.
* no evidence of aortic dissection.
* mild fibrotic change at left lower lobe of lung.
)



::CHCTPH::                     ;chest ct for pulmonary hypertension for heart lung transplant evalutation
(
CT of the chest without and with contrast enhancement is read and compared with prior study dated 2007-2-5. This CT study shows: 
1. marked dilatation of the right heart including RV and RA, associated with hypertrophy of the myocardium. There is larger cardiac chambers and more compression of the left lung as compared with prior study. Compression of the LV and bilateral superior pulmonary veins by enlarged right heart is noted. Marked dilation of the pulmonary trunk (3.2 cm) with prominent bronchial collaterals which also supply the lung parenchyma. The ascending aorta is 2.3 cm, descending aorta 2.1 cm. Constriction of the peripheral pulmonary arterioles is noted, consistent with severe pulmonary arterial hypertension. 
2. no definite filling defect or thrombus in the dilated pulmonary arteries. 
3. increased bilateral pleural effusion and faint opacity of both lungs with ground glass attenuation and thickening of septal lines. Pulmonary venous congestion and edema is considered.
4. hepatomegaly and small periheptic ascites.MArked dilatation of the IVC and hepatic veins, possibly due to right heart failure.

IMP: severe pulmonary arterial hypertension wiht hepatic congestion and progression.
)


::CTC0::
(
Indication: screening for lung cancer or abnormality.
Low dose spiral CT (50mA, 120 kVP) without contrast enhancement and with coronal reconstruction shows:
1. no definite lung parenchymal lesion or mediastinal lymphadenopathy.
2. normal appearance of the adrenals.

IMP: no definite abnormality in the screening chest CT study.
)

::CTC1::
(
Low dose screening chest CT without contrast enhancement (120 KvP and 50 mA) shows:
1. minor lung parenchymal change with bilateral apical pleural thickening and focal fibrosis of apical subpleural region.
2. no mediastinal lymphadenopathy.
3. normal appearance of adrenals. 

IMP: minor nonspecific lung parenchymal change. Suggest follow up and clinical correlation.
非特異性肺臟實質變化於低劑量篩檢電腦斷層檢查, 建議臨床對照與追蹤.
)



::BIOP::
(
CT guided biopsy of the     was performed smoothly with a 19G coaxial guiding needle and a 20G automated cutting biopsy needle.
1. Indication of CT-guided biopsy:
2. Number of coaxial needle pass:1. Number of biopsy needle pass:4.
Please send for pathology, culture and smear cytology.
3. The patient tolerated the whole procedure well.
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
After completeing 15 minute RF treatment session, there is focal increased ground glass opacity around the lung nodule at the lateral aspect of the RUL. The gentleman stood well during and immediately after the procedure in CT room with stable vital signs.  Further evaluation with follow up chest CT is suggested for treatment response of the lesion.

Impression: 
RFA for a metastatic lung nodule in RUL. Suggest follow up chest radiographs 6 hours after the procedure.
)

