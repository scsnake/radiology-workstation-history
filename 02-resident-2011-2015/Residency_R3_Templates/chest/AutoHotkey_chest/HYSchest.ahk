﻿;

; AutoHotkey Version: 1.x

; Language:       English

; Platform:       Win9x/NT

; Author:         A.N.Other <myemail@nowhere.com>

;

; Script Function:

;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)

;



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



; write & send out report and enter next

#w::

WinActivate, ahk_class AcucobolWClass

Send {F9}

SetWinDelay, 100

WinActivate, IMPAX 6.2.1.149 Radiologist 

Click 709,971

Click 715,1121

Click 50,41

Click 73,369

Send X320

return



; find study and copy serial number

#f::

Send {ENTER}

Click 72,371

Send ^c

Sleep, 1000

Click 38,500

Click 2

Sleep, 200

WinActivate, ahk_class AcucobolWClass

Send ^v

Send {ENTER}

return



;**********************************

;Y分院



;IPAX: 003924

;PW:003924



;大同



;ID:03924

;PW:5586



;*********************************



; Note: From now on whenever you run AutoHotkey directly, this script

; will be loaded.  So feel free to customize it to suit your needs.



; Please read the QUICK-START TUTORIAL near the top of the help file.

; It explains how to perform common automation tasks such as sending

; keystrokes and mouse clicks.  It also explains more about hotkeys.





::AB::of abdomen. 

::ABD::Standing abdominal film shows no definite abnormal bowel dilatation and normal bowel gas pattern.

::ABDILEUS::Standing abdominal film shows dilated bowel loops with air fluid level consistent with ileus.

::ABN::abnormal

::ACR::ACR BI-RADS category

::AD::no definite abnormality of both adrenals. 

::ADPS::no definite abnormality of the adrenals, pancreas and spleen.

::ART::Artherosclerotic change with mural calcification of the aorta.

::ATX::atelectasis. 





::BAPT::bilateral apical pleural thickening

::BAPTCA::bilateral apical pleural thickening with calcification

::LAPT::left apical pleural thickening

::LAPTCA::left apical pleural thickening with calcification

::RAPT::right apical pleural thickening

::RAPTCA::right apical pleural thickening with calcification

::APTCA::apical pleural thickening and calcification.



::As comp::as compared with prior study at

::AX::bilateral small axillary lymph nodes.

 

::B0::no definite abnormal bone change of this study.

::B1::Dense breasts and no mammographic finding (ACR BI-RADS category 1). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.

::B2::Dense breasts and benign mammographic finding (ACR BI-RADS category 2). Suggest follow up annually and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.

::B3::Dense breasts and probably benign mammographic finding (ACR BI-RADS category 3). Suggest short term follow up and breast ultrasound correlation if there is clinical palpable lump or prior ultrasound detected abnormality.

::B6L::the superior segment of the LLL.

::B6R::the superior segment of the RLL.

::B10L::the posterior basal segment of the LLL.

::B10R::the posterior basal segment of the RLL.

::BAP::bilateral apical pleural thickening.

::BAPCA::bilateral apical pleural thickening with calcification.

::BCA::bilateral benign calcifications.

::BCT::placement of bilateral chest tubes. 

::BEC::bronchiectasis

::BI::bilateral

::BIA::irregular acetabular fossa,

::BJV::placement of bilateral jugular venous catheters (lines). 

::BK::status post operation with total knee replacement, 

::BMH::more healing noted,

::BN::bilateral lung nodules. 

::BO::absence of breast shadow, compatible with previous mastectomy, 

::BPL::bilateral pleural effusion.



::Cx::Chest PA shows

::Cz::Chest AP shows

::C0::Chest PA shows normal heart size and no definite lung lesion.

::C0ER::Chest PA shows normal heart size, no definite lung lesion and elevated right diaphragm.

::C0EL::Chest PA shows normal heart size, no definite lung lesion and elevated left diaphragm.

::C0OP::Chest PA shows normal heart size, no definite abnormal ung lesion and postoperative change of the mediastinum with placement of multiple sternal wires.

::C0TA::Chest PA shows normal heart size, no deifnite lung lesion and tortuous aorta.

::C1::Chest PA shows cardiomegaly, tortuous aorta and no definite abnormal lung opacity.

::CA::calcification of aortic wall.

::CABG0::Chest PA shows normal heart size and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.

::CABG::Chest PA shows cardiomegaly and postoperative change consistent with CABG with placement of multiple sternal wires and mediastinal clips.

::CAD::calcifiction of the coronary arteries, indicates CAD. 

::ch::Chest PA/AP shows

::chopl::Chest PA/AP shows postoperative change of the left lung. 

::chopr::Chest PA/AP shows postoperative change of the right lung.

::CHM::Chest PA (AP) shows cardiomegaly and no definite lung lesion.

::ChCT::CT of the chest without and with contrast enhancement shows:



::ChCTbrr::

(

CT of the chest without and with contrast enhancement shows:

1. postoperative change with right mastectomy and placement of a left port A catheter. 

)



::ChCTbrl::

(

CT of the chest without and with contrast enhancement shows:

1. postoperative change with left mastectomy and placement of a right port A catheter. 

)

::ChCTcw::CT of the chest without and with contrast enhancement is read and compared with prior study dated 2010-12-24. This CT study shows: 

::ChCTN::CT of the chest without contrast enhancement and HRCT show:

::ChCTC::CT of the chest with contrast enhancement shows:

::CDH::relative shallow of the acetabular roof,

::CF::Suggest clinical correlation and follow up. 

::CL::Chest lateral view shows

::CL0::Chest lateral view shows no definite abnormality. Suggest correlation with chest PA. 

::CLM::Chest lateral view shows cardiomegaly and no definite abnormal opacity. Suggest correlation with chest PA.



::CMABD::Chest AP shows cardiomegaly, marked abdominal distention and lower lung capacity. Suggest clinical correlation.  

::CMBPL::Chest PA shows cardiomegaly and bilateral pleural effusion.

::CMLPL::Chest PA shows cardiomegaly and left pleural effusion.

::CMRPL::Chest PA shows cardiomegaly and right pleural effusion.

::CMCABG::Chest film (PA /AP) shows cardiomegay and postoperative change with placement of sternal wires and multiple clips at the mediastinum, compatible with CABG.

::CMCPM::Chest PA shows cardiomegaly, no definite lung lesion and placement of cardiac pacemaker.

::CMEM::Chest PA/AP shows cardiomegaly and bilateral pulmonary emphysema.



::COM::decreased pneumotization of mastoid antrum with sclerotic change, otitis medium is compatible. 

::CMOP::Chest PA (AP) shows cardiomegaly and postoperative change.

::CMWIRE::Chest PA/AP shows cardiomegaly and postoperative change with placement multiple sternal wires.

::comp::as compared with prior study at

::compare chest::CT of the chest without and with contrast enhancement is read and compared with prior study dated  . This CT study shows: 

::consd::bilateral diffuse lung consolidation.

::consp::bilateral patchy consolidation.

::consr::right lung consolidation.

::consl::left lung consolidation.

::COPD::hyperinflation and increased volume of both lungs and flattening of diaphragms.

::CORREL::Please correlate with the imaging findings and report of the abdominal/pelvic CT study.

::CPAC::cardiophrenic angle

::CPAL::costophrenic angle

::CPM::placement of a cardiac pacemaker.

::CPS::hazziness/fluid of the paranasal sinuses, sinusitis is compatible, 

::CPS2::mucosal thickening of the maxillary sinuse, 

::CS::of C-spine.

::CTAS::an accessory spleen is noted.  

::CTASS::accessory spleens are noted, n=

::CTAT::artherosclerosis representing by calcifications on the aortic wall. 

::CTATA::arteriosclerotic change with calcifed plaque at intraabdominal vessels.

::CTATH::arteriosclerotic change with calcifed plaque at intracranial vessels.

::CTBA::prominent sulci, fissure and ventricles, brain atrophy is compatible. 

::CTBS::diffsue brain swelling with diminished sulci, fissure and CSF spaces. 

::CTC::well-definded homogenous low density shadow indicates cystic lesion is noted, 

::CTCA::paucity of the soft tissue and fatty tissue in body wall, cacaxia compatible.

::CTCC::hyperdense shadows are noted at pineal gland and choroid plexuses, indicates calcifications. 

::CTD::the estimated radiation dose (mSv) of this study is: 

::CTFL::generalized decreased liver density indicates fatty change of liver. 

::CTIL::generalized increased liver density and prominence of hepatic vasculature, iron overiding of liver is compatible. 

::CTLA::low density change at bil. periventricular white matter, leukoaraiosis is considered. 

::CTLC::uneven hepatic surface, coarse texture, splenomegaly, indicates liver cirrhosis. 

::CTLD::low density lesion noted at 

::CTLM::multiple heterogenous low density shadows in the liver, indicates liver metastasis. 

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

::CTPF::fatty replacement of the pancreas.

::CTPC::radiopaque shadow at the pineal gland, compatible with pineal gland calcification. 

::CTPE::bilateral basal lung field pleural effusion at the dependent part, 

::CTPEA::bilateral basal lung field pleural effusion at the dependent part with adjacent lung partial atelectasis, 

::CTRC::homogenous low density lesions in the kidney, renal cysts are considered. 

::CTSC::status post-operation with a scar in the anterior abdominal wall. 

::CVPNG::placement of central venous catheter(s) and a NG tube.

::CVPET::placement of central venous catheter(s) and an endotracheal tube.

::Cm::cardiomegaly.

::cybk::bilateral renal cysts.

::cybl::bilateral liver cysts.

::cylk::left renal cysts.

::cyrk::right renal cysts.



::DIS::distal

::DISL::dislocation

::DJDBK::degenerative change of both knees with marginal spur formation and joint space narrowing.

::DJDlK::degenerative change of the left knee with marginal spur formation and joint space narrowing.

::DJDRK::degenerative change of the right knee with marginal spur formation and joint space narrowing.

::DJDC::degenerative change of the C spine.

::DJDT::degenerative change of the T spine.

::DJDTL::degenerative change of the T and L spine.

::DJDTLM::mild degenerative change of the T and L spine.

::DJDTLS::degenerative change and scoliosis of the T and L spine. 

::DJDL::degenerative change of the L spine.

::DJDSS::degenerative change of the spine and shoulders.

::DRB::deformed right ribs.

::DLB::deformed left ribs.

::DBB::deformed bilateral ribs.

::DS::the stomach is distended,

::db1::Dense breasts and no definite mammographic abnormality in this study (ACR BI-RADS category 1). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.

::db2::Dense breasts and benign mammographic findings in this study (ACR BI-RADS category 2). Suggest annual follow up and ultrasound correlation if there is clinical palpable lump or prior detected abnormality.

::db3::Dense breasts and probably benign mammographic findings in this study (ACR BI-RADS category 3). Suggest short term follow up andand ultrasound correlation if there is clinical palpable lump or prior detected abnormality.

  



::ECMO::placement of large bore vascular cannula, consistent with ECMO.

::EE::the bowel gas pattern is unremarkable. 

::EF::much fecal material is noted in the bowel. 

::EFA::much fecal material is noted in the bowel at

::EM::bilateral pulmonary emphysema.

::EMFC::bilateral pulmonary emphysema with superimposed fibrotic change and ill defined patches.

::EN::enhancement 

::EO::disproportional dilated bowel loops, suggestive of obstructive ileus,

::ER::elevated right diaphragm.

::ERCX::Chest PA shows carciomegaly and bilateral lung consolidation, predominantly at lower lung fields.

::ERCX0::Chest PA shows normal heart size and bilateral lung consolidation.

::ERCXR::Chest PA shows cardiomegaly and right lower lung consolidation.

::ERCXL::Chest PA shows cardiomegaly and left lower lung consolidation.

::ERCHEST::Chest PA/AP shows cardiomegaly and bilateral lower lung consolidations.

::ERCHEST0::Chest PA/AP shows normal heart size and consolidation of bilateral lower lung fields.

::EL::elevated left diaphragm.

::esop::postoperative change with total esophagectomy. There is bypass grafting at the mediasitnum. Placement of multiple surgical clips at the mediastinum and upper abdomen. 

::et::placement of an endotracheal tube.

::etcvp::placement of an endotracheal tube and a central venous catheter. 

::etng::placement of an endotracheal tube and a NG tube.



::FB::fibrotic band(s)

::FC::fibrotic change

::FCRMLU::fibrotic change of the RML and inferior lingular segment of the LUL.

::FCM::mild fibrotic change

::FCMBU::mild fibrotic change of both upper lobes.

::FCBU::fibrotic change of both upper lobes.

::FCA::fibrocalcified change

::FCABU::fibrocalcified change of both upper lobes.

::FCALU::fibrocalcified change of the left upper lobe.

::FCARU::fibrocalcified change of the right upper lobe. 

::FX::fracture

::CFX::compression fracture



::GB::gall bladder

::ggo::ground glass opacity (GGO)

::BGS::gall stone(s).



::HET::heterogenous

::HETERODNB2::

(

Digital mammograms of both breasts in CC and MLO views are read without available prior mammograms for comparison. This study shows: 

1. heterogeneously dense fibroglandular tissue of both breasts which may decrease the sensitivity of this study. 

2. 



IMP: benign findings of this mammography, ACR BI-RADS category 2. Suggest annual mammogram follow up or ultrasound study if there is any clinical palpable lump or prior ultrasound detected abnormality.

)

::hyd::hydronephrosis





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



::K0::KUB shows normal bowel gas, no definite abnormal opacity, no definite abnormal bone change.

::Kdjd:: KUB shows normal bowel gas, no definite abnormal opacity, and degenerative change of the L spine.

::Kgas0::KUB shows decreased bowel gas.

::KGAS::KUB shows prominent bowel gas.

::KI::KUB shows dilated bowel loops and prominent gas, consistent with ileus.

::KST::KUB shows stool impaction and no definite bowel dilatation.



::L0::no definite abnormal lung abnormality.

::Lax::linear or subsegmental atelectasis

::LAPAX::bilateral axillary lymphadenopathy.

::LAPM::bilateral mediastinal lymphadenopathy.

::LAPMAX::bilateral mediastinal and axillary lymphadenopathy.

::LAPMH::bilateral mediastinal and hilar lymphadenopathy.

::LAPML::left mediastinal lymphadenopathy.

::LAPMHL::left mediastinal and hilar lymphadenopathy.

::LAPMR::right mediastinal lymphadenopathy.

::LAPMHR::right mediastinaland hilar lymphadenopathy.

::LAT::atelectasis

::LB::increased bilateral basal lungs infiltration. 

::LC::absence of the gall bladder with opaque clips in the hepatic hilum, compatible with laparoscopy cholecystectomy.

::LD::elevation of the diaphragm is noted, 

::LF::increased fibrotic change, 

::LG::diffusely linear shadows over bilateral lungs, chronic interstial lung disease is considered. 

::LH::increased pulmonary infiltration at bil peribronchial parahilar region; bronchitis is compatible. 

::bronchopneu::prominent increased bilateral pulmonary infiltrations at peribronchial parahilar regions; bronchopneumonia is compatible.

::Ling::inferior lingular segment of the left upper lobe.

::LJV::placement of a left jugular venous catheter.

::LMRM::postoperative change with left mastectomy. 

::LMRMR::postoperative change with left mastectomy and placement of a right port A catheter.

::LOBECTOMYRU::postoperative change with lobectomy of the RUL and placement of surgical clips at the right hilum and mediastinum.

::LOBECTOMYRM::postoperative change with lobectomy of the RML and placement of surgical clips at the right hilum and mediastinum.

::LOBECTOMYRL::postoperative change with lobectomy of the RLL and placement of surgical clips at the right hilum and mediastinum.

::LOBECTOMYLU::postoperative change with lobectomy of the LUL and placement of surgical clips at the light hilum and mediastinum.

::LOBECTOMYLL::postoperative change with lobectomy of the LLL and placement of surgical clips at the left hilum and mediastinum.

::LO::low lung capacity.

::LOWABD::low lung capacity and abdominal distention. 

::LPL::left pleural effusion.

::LPORT::placement of a left port A catheter.

::LCT::placement of a left chest tube.

::LCVP::placement of a left central venous catheter.

::LSV::placement of a left subclavian venous catheter. 





::mcm::Chest PA shows mild cardiomegaly and no definite abnormal lung opacity.

::MCX::mild cardiomegaly. 

::ME::mediastinum 

::MED::bilateral small mediastinal lymph nodes.

::MEDAX::bilateral small mediastinal and axillary lymph nodes.

::MH0::no definite mediastinal or hilar lymphadenopathy.

::MN::multiple bilateral lung nodules, consistent with metastases.

::MOL::, more on left side.

::MOR::, more on right side.

::MRMR::postoperative change consistent with right mastectomy.

::MRML::postoperative change consistent with left mastectomy.



::NC::normal heart size.

::NG::placement of a NG tube.

::NF::no definite obvious bone fracture is recognized. 

::NICH::no definite intracranial hemorrhage. 



::OA::joint space narrowing with spur formation, compatible with degenerative change.

::OBSCL::obscured left lateral costophrenic angle. 

::OBSCR::obscured right lateral costophrenic angle. 

::OBSCB::obscured bilateral costophrenic angles. 

::OP::postoperative change 

::oprl::postoperative change of the right lung with placement of clips and suture at the right hilum and mediastinum.

::opru::postoperative change of the right upper abdomen with placement of clips.

::opll::postoperative change of the left lung with placement of clips and suture at the left hilum and mediastinum.

::oplu::postoperative change of the left upper abdomen with placement of clips.  

::opsp::postoperative change of the spine with placement of metallic transpedicle fixation.



::PL::pleural effusion.

::peri::increased bilateral peribronchial cuffing and infiltration. 

::PHVP::the poral & hepatic veins are patent.

::PK::apical pleural is irregular thickening, 

::PR::proximal 

::PRE::previous

::PTX::pneumothorax



::PSK::(Please refer to the uploaded key image with annotation in the Summary series) 

::PVL::increased low density in the peri-ventricular white matter, 

::PVLM::increased signal intensity in the peri-ventricular white matter, 



::RADL::post-radiation lung parenchymal change is considered.

::RAT::remove the endotracheal tube, 

::RC::remove the chest tube, 

::RCC::remove casting, 

::RJV::placement of a right jugular venous catheter.

::rport::placement of a right port A catheter.

::rct::placement of a right chest tube.

::rcvp::placement of a right central venous catheter.



::BRB::deformity of bilateral rib(s).

::RBR::deformity of right rib(s).

::LBR::deformity of left rib(s).



::RPL::right pleural effusion. 

::RMRM::postoperative change with right mastectomy.

::RMRML::postoperative change with right mastectomy and placement of a left port A catheter.

::RSV::placement of a right subclavian venous catheter.



::SABD::Standing abdominal film shows normal bowel gas and no definite abnormal bone change.

::SABDI::Standing abdominal film shows dilated bowel loops with prominent gas and air fluid level, consistent with an ileus.

::SABD0::Standing abdominal film shows decreased bowel gas and no definite abnormal bone change.

::SCOL::scoliosis of the spine 

::SCANL::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with L leg longer than R one about 

::SCANN::Low extremeties scanogram  with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows no definite obvious length discrepancy of the bilateral legs. 

::SCANR::Lower extremeties scanogram with measurement from the femoral head epiphyses surface to lower tibia epiphyses shows: discrepancy of the bilateral legs with R leg longer than L one about 

::scolt::Scoliosis of the T spine.

::scoltl::Scoliosis of the T and L spine.

::scoltlm::Mild scoliosis of the T and L spine.

::scoltm::Mild scoliosis of the T spine.



::screening::

(

Indication: screening for lung cancer or abnormality.

Low dose spiral CT (50mA, 120 kVP) without contrast enhancement and with coronal reconstruction shows:

1) no definite lung parenchymal lesion or mediastinal lymphadenopathy.

2) normal appearance of the adrenals.



IMP: no definite abnormality in the screening chest CT study.

)

 

::SG::placement of a Swan-Ganz catheter. 

::stat::stationary imaging findings as compared with prior study.

::SUB::bilateral subcutaneous emphysema.

::rsub::right subcutaneous emphysema.

::lsub::left subcutaneous emphysema. 

::SUCT::Suggest CT for further evaluation.

::SUS::Suggest ultrasound for further evaulation.



::TA::tortuous aorta.

::TAC::tortuous aorta with calcification. 

::TACE::post-TAE change with opaque contrast retention in the liver.

::TM::status post mediastineal tube insertion for drainage, 

::TOA::status post upper chest wall Port-A implantation, 

::TRA::placement of a tracheostomy tube.

::TRANG::placement of a tracheostomy tube and a NG tube.

::TRACVP::placement of a tracheostomy tube and a central venous catheter.

::TRATUBE::placement of a tracheostomy tube, a NG tube and a central venous catheter. 

::TUBEE::placement of an endotracheal tube, a NG tube and a central venous catheter. 



::UB::urinary bladder

::UDC::double contour of the urinary bladder base is noted. 

::UU::smooth concaved cephalic contour of the urinary bladder, compatible with uterus indentation.



::VP::placement of a ventriculo-peritoneal (VP) shunt tube from the neck to the abdomen. 



::WIRE::placement of multiple sternal wires.

::wiretube::placement of multiple sternal wires, mediastinal drain, endotracheal and NG tubes.

::WX::without

::WT::wall thickening is noted, 

::WTE::wall thickening is noted with abnormal enhancement, 

::WTI::irregular wall thickening is noted, 



::hj::(HYS/JW)

::hy::(HYS/YCC)

::poa::placement of a Port-A catheter, 

::cvp::placement of a central venous catheter,

::slc::small bilateral lung capaci

::swan::S/P placement of swan-ganz catheter via right jugular approach with the tip located at RPA.

::cvr::Chest AP shows placement of an endotracheal tube, and a NG tube. placement of a left central venous catheter. repalced cardiac valve. placement of metalic sternal wires and surgical clips, placement of bilateral chest tubes and mediastinal drainage tube. Cardiomegaly and calcified aortic knob. increased hazy ground-glass opacity at bilateral lungs. Blunting of bilateral costophrenic angles. spondylosis and degenerative change of the spine with marginal spur formation. 

::mw::mediastinum widening

::subma::relatively poor breathholding and some motion artifact. 

::thy::multiple hypodense nodules (some with calcification) at bilateral thyroid gland. Suggest correlation with thyroid ultrasound.

::ath::atherosclerosis and calcification at the aorta and coronary arteries.

::chctln::no evidence of enlarged lymph node at mediastinum and bilateral axillary region.

::sugg::suggest clinical correlation and follow-up.

::sa::subsegmental atelectasis

::sla::subsegmental linear atelectasis

::nfibc::non-specific fibrotic change at bilateral lung.

::fcl::fibrocalcified lesion at, the possibility of old granulomatous infection or TB infection is considered.

::pscl::placement of surgical clips at the left hilum and mediastinum.

::pscr::placement of surgical clips at the right hilum and mediastinum.

::bronc::mild dilatation of the bronchial tree and thickening of bronchial wall.

::bpefc::bilateral pulmonary emphysema with superimposed fibrotic change.

::pneu::pneumonia is considered first if there is appropriate clinical setting.

::pht::mildly dilated pulmonary trunk (3.2 cm). The diameter of ascending aorta is about 3.6cm, descending aorta 2.5 cm.

::nonl::mild fibrotic change and subsegmental atelectasis of bilateral lower lungs.

::nln::small nonspecific tiny nodules at LUL and LLL.

::nmln::small nonspecific mediastinal lymph nodes.

::refa::please correlate with the imaging findings and report of the abdominal CT study.

::refna::please correlate with the imaging findings and report of the neck and abdominal CT study.

::refh::please correlate with the imaging findings and report of the brain CT study.

::dggo::Diffuse ground-glass opacity at bilateral lungs, r/o PJP, CMV, other viral or atypical pneumonia. advise clinical correlation and follow up. 

::spoth::spondylosis of the thoracic spine with marginal spur formation. 

::npag::no evidence of adrenal gland lesion.

::rlvef::impaired LV function: please read the details on PACS system.

::fcf::mild fibrotic change at the RML and lingular segment of the LUL as well as bilateral apical upper lobes. 

::swmc::postoperative change with sternal wiring and mediastinal clips.



::ctpm::postoperative change of the right breast with partial mastectomy. There is mild deformity, skin thickening and nipple retraction accompanied with parenchymal loss at lateral aspect of the right breast.

::ntn::numerous tiny nodules at both lungs in random distribution. Metastases is considered.

::lrt::fibrotic change and subsegmental atelectasis at medial aspect of LUL and RUL, r/o radiation lung change.

::bmeta::multiple vertebral bodies with bone destruction or sclerotic change at the C and T spine, compatible with bone metastases, stationary.

::ls::interlobular septal thickening and bronchial wall thickening are also noted at the right lower lobe. lymphatic spreading is likely. 

::ps::irregular and nodular thickening of bilateral pleural and fissues with multiple pleural-based nodules. Pleural tumor seeding is considered.

::extlap::extensive bilateral supraclavicular, hilar, and mediastinal lymphadenopathy (prevascular, paratracheal, subaortic, paraaortic, subcarinal, and paraesophageal nodes), associated with encasement and narrowing of trachea and central bronchi, suspected invasion to distal trachea and proximal right main bronchus, encasement of bilateral central PAs, and obliteration of SVC and bilateral brachiocephalic veins.

::inters::diffuse interstitial reticulations, fibrosis at bilateral lungs, with superimposed consolidation and hazy ground-glass opacity at bilateral lungs, more at the right upper lung and the left lower lung.

::nhs::normal heart size.



::LLLZ::left lower lung zone

::LULZ::left upper lung zone

::RLLZ::right lower lung zone

::RMLZ::right middle lung zone

::RULZ::right upper lung zone

::RUQ::right upper quadrant of abodmen

::LUQ::left upper quadrant of abodmen

::3T::placement of an endotracheal tube, a NG tube, and a central venous line.

::pcbl::patchy consolidations at bilateral lung fields.

::dcbl::diffuse consolidations at bilateral lung fields.

::cbl::consolidations at bilateral lung fields.

::bpo::increased bilateral perihilar opacities.

::blcpa::blunting of left costophrenic angle.

::brcpa::blunting of right costophrenic angle.

::bbcpa::blunting of bilateral costophrenic angle.



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

::leu::non-specific tiny hyperintensity dots at the bilateral periventricular white matter.



::spo::spondylosis of the spine is noted.

::spoc::spondylosis of the cervical spine is noted.

::spol::spondylosis of the lumbar spine is noted.

::sco::scoliosis of the spine with convexity to the right. 

::penia::osteopenia of the visible bone.

::psco::scoliosis of the spine, probably due to positioning factor.

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

::sir::partial obliteration of the right sacroiliac joint with subchondral sclerosis. 

::sil::partial obliteration of the right sacroiliac joint with subchondral sclerosis. 

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

::spi1::mild osteopenia of the visible bony structures. mild scoliosis of the spine, probably due to positioning factor. increased lordotic curve of the lumbar spine. thoracolumbar spondylosis with marginal spur formation at multiple levels. grade (0-)1 degenerative spondylolisthesis of the L4 on L5 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. mild vacuum phenomena in the bil. sacroiliac joints. 

::patfrc::(previous) irregular fracture(s) at the left patella with intraarticular extension to the left patellofemoral joint s/p metallic fixation and s/p external splint fixation with scanty callus formation and with adjacent soft tissue swelling. 

::pcbl::patchy consolidations at bilateral lung fields.

::dcbl::diffuse consolidations at bilateral lung fields.

::iibl::increaed infiltrations at bilateral lower lung fields.

::iirl::increaed infiltrations at right lower lung field.

::iill::increaed infiltrations at left lower lung field.

::hspi::prominent bilateral hilar shadows with increased perihilar infiltration. 

::poa::placement of a Port-A catheter,

::nao::no abnormal lung opacity.

::surc::surgical clips

::tfcn::tiny fibrocalcified nodules at bilateral lung fields.

::bbcp::blunting of bilateral costophrenic angles.

::blcp::blunting of left costophrenic angle.

::brcp::blunting of right costophrenic angle.

::dbg::distended bowel gas. 

::scn::surgical clips at left lower neck.

::r::right

::l::left

::bil::bilateral 

::erhd::elevation of right hemidiaphragm.

::elhd::elevation of left hemidiaphragm.

::bpo::increased bilateral perihilar opacities.

::seim::(SE:2, IM:17)

::pcp::placement of a cardiac pacemaker. 





;1. 打完報告按Ctrl-Alt-Q關閉RIS與退出autohotkey:

^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.

IfWinExist ahk_class com.pohai.client.application.MainFrame

{

 WinActivate ahk_class com.pohai.client.application.MainFrame

 SendPlay !{F4}

}

ExitApp

 



 

;2. 設定Ctrl-Alt-E 叫出Notepad編輯autohotkey:

^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.

Edit

return

 







;3. 設定Ctrl-Alt-R reload script

^!r:: ; Assign Ctrl-Alt-R as a hotkey to restart the script.

Reload

Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.

MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?

IfMsgBox, Yes, Edit

return













 ;5. 設定Window-1 = Open the last ONE report

#1::

Click 857,552

Click 2

return



 ;6.  設定Window-2 = Open the last ONE report and Copy it

#2::

Click 857,552

Click 2

Sleep 100

Click 170,400

Click 2

return





;7.  設定Window-3 = Open the last ONE PACS image parallel 

; ( 1238,42 ) at report room-3 ( 1095,42 ) at room-1 & Ped-2 ( 1088,42 ) at CT & room-4

#3::

Click 857,552

Click right

Sleep 200

Click right 1012,635

Sleep 200

WinActivate, ahk_class #32770

Sleep 100

Click 1095,42 

Sleep 300

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 200

Click 26,579

return





;  設定Window-4 = open the images parallel...

#4::

WinActivate, ahk_class #32770

Sleep 100

Click 1095,42 

Sleep 500

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 100

Click 26,579

return









;7-2.   設定Window-O = add "suggest correlated with clinical manifestration." then send report and  Open the last ONE PACS image parallel

#O::

Send suggest correlated with clinical manifestration. 

Click 637, 1481

Sleep 5000

winActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 300

Click 857,552

Sleep 100

Click right

Sleep 80

Click right 1012,635

Sleep 80

WinActivate, ahk_class #32770

Sleep 300

Click 1095,42 

Sleep 300

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 200

Click 26,579

return





;7-3.  設定 Window-I = add "sationary in compare to previous similar study, suggest correlated with clinical manifestration." then send send report and Open the last ONE PACS image parallel

#I::

Send sationary in compare to previous similar study, suggest correlated with clinical manifestration. 

Click 637, 1481

Sleep 5000

winActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 300

Click 857,552

Sleep 100

Click right

Sleep 80

Click right 1012,635

Sleep 80

WinActivate, ahk_class #32770

Sleep 300

Click 1095,42 

Sleep 300

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 200

Click 26,579

return



;7-4.  設定 Window-K =  add "status post-operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration." than send report and Open the last ONE PACS image parallel

#K::

Send status post-operative changes with tube(s) in the field of view with appropriate position, sationary in compare to previous similar study, suggest correlated with clinical manifestration. 

Click 637, 1481

Sleep 3000

winActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 100

Click 857,552

Sleep 100

Click right

Sleep 80

Click right 1012,635

Sleep 80

WinActivate, ahk_class #32770

Sleep 300

Click 1095,42 

Sleep 300

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 100

Click 26,579

return



;8. 設定Window-A = Open the last TWO report

#A::

Click 944,578

Click 2

return



;9.  設定Window-S = Open the last TWO report and Copy it

#S::

Click 944,578

Click 2

Sleep 100

Click 170,400

Click 2

return





;10.  設定Window-D = Open the last TWO PACS image parallel

#D::

Click 944,578

Click right

Sleep 200

Click right 1012,670

Sleep 200

WinActivate, ahk_class #32770

Sleep 100

Click 1095,42 

Sleep 200

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 200

Click 26,579

return







; 設定Window-M = move cursor to IMAX and split image parallel for Whole -spine

#M::

WinActivate, ahk_class #32770

Sleep 200

Click 250,228

Sleep 100

Click 300, 1000

Sleep 100

Click 300, 1000

return





; 設定Window-N = move cursor back to RIS

#N::

WinActivate, ahk_class com.pohai.client.application.MainFrame

Sleep 100

Click 300, 800

return





; 設定Window-B = move cursor to IMAX only

#B::

WinActivate, ahk_class #32770

Sleep 100

Click 300, 1000

Sleep 100

Click 300, 1000

return









