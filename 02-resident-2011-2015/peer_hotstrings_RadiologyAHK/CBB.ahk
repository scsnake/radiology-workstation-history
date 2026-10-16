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


::AADI::anterior atlantodental interval
::AARS::atlantoaxial rotatory subluxation. 
::ABF::avulsed bony fragment(s) at the 
::ABG::air-bronchogram(s) 
::ABL::aggressive bony lesion, 
::ABS::Advise correlate with isotope bone scan study, if clinically indicated.
::ABSS::asymmetrical breast shadow(s), smaller 
::AC::Advise clinical correlation. 
::ACA::atherosclerotic calcifications of the 
::ACAA::atherosclerotic change of the abdominal aorta and its bifurcation. 
::ACAA1::atherosclerotic calcifications of the abdominal aorta and visceral arteries. 
::ACF::with amorphous callus formation. 
::ACLR::s/p ACL reconstruction with presence of the femoral and tibial tunnels, and screw fixation in position.
::ACLV::an avulsed bony fragment above the anterior tibial plateau, r/o ACL avulsion. 
::ACPA::atherosclerotic calcifications of the popliteal artery and its branches. 
::ACT::Advise correlate with CT study, if clinically indicated.
::ACTG::Advise CT-guided aspiration/biopsy, if clinically indicated.
::AD::angular deformity 
::AE::abnormal effusion(s) 
::AF::Advise follow-up study. 
::AFL::air-fluid level(s) 
::AIS::Advise correlate with other imaging study, if clinically indicated. 
::AL::anterolisthesis of the 
::ALC::at the lower cervical levels. 
::ALL::at the lower lumbar levels. 
::ALS::acromion of the left scapula. 
::AME::adjacent marrow edema and hyperemia 
::AML::at multiple levels. 
::AMP::s/p amputation of the 
::AMR::Advise correlate with MRI, if clinically indicated. 
::ANR::Advise consult neuroradiologist, if clinically indicated. 
::AP::acetabular protrusion 
::APLS::s/p artificial pacemaker implantation via left subclavian approach. 
::APP0::fluid-filled appendix < 6 mm in diameter, or gas-filled appendix < 8 mm in diameter with thin wall. 
::APP1::fluid-filled appendix, about  mm in diameter, without periappendiceal abnormality. 
::APP2::fluid-filled appendix, about  mm in diameter, with enhancing wall but without periappendiceal stranding. 
::APP3::fluid-filled appendix, about  mm in diameter, with periappendiceal stranding. 
::APP4::fluid-filled appendix, about  mm in diameter, with periappendiceal fluid. 
::APP5::abscess or inflammatory mass. 
::APRS::s/p artificial pacemaker implantation via right subclavian approach. 
::APW::aortopulmonary window 
::ARR::Additional report for requesting 
::ARS::acromion of the right scapula. 
::ASO::Advise correlate with sonography, if clinically indicated.
::ASTS::adjacent soft tissue swelling. 
::ATP::anterior tibial plateau. 
::ATPE::anterior-to-posterior extension 
::ATR::anterior translation of the 
::AVFX::(previous) avulsed fracture(s) at the 
::AVR::s/p artificial valvular replacement in position. 
::B::borderline 
::B2F::bil. index fingers. 
::B3F::bil. middle fingers. 
::B4F::bil. ring fingers. 
::B5F::bil. little fingers. 
::BA::bil. ankles. 
::BAA::bil. apical areas. 
::BAB::s/p bipolar arthroplasty with postoperative changes at the bil. hip joints. 
::BAC::bil. acromioclavicular joints. 
::BAIN::bil. anterior intercondylar notches. 
::BAL::s/p bipolar arthroplasty with postoperative changes at the left hip joint. 
::BALF::bil. apical lung fields. 
::BAR::s/p bipolar arthroplasty with postoperative changes at the right hip joint. 
::BAS::bil. acromion scapulae. 
::BBA::bil. basal areas. 
::BBCP::blunting of the bil. costophrenic angles. 
::BBGR::bil. bicipital grooves. 
::BBLF::bil. basal lung fields. 
::BCB::bil. carpal bones. 
::BCC::bil. calcaneocuboid joints. 
::BCCJ::bil. calcaneocuboid joints. 
::BCMC::bil. carpometacarpal joints. 
::BCR::bil. capitellum-radial head joints. 
::BD::bowing deformity 
::BDC::bil. distal clavicles. 
::BDFE::bil. distal femoral shafts. 
::BDFI::bil. distal fibular shafts. 
::BDHC::bil. distal humeral capitellum. 
::BDHS::bil. distal humeral shafts. 
::BDHT::bil. distal humeral trochlea. 
::BDRM::bil. distal radial metaphyses. 
::BDRS::bil. distal radial shafts. 
::BDRU::bil. distal radioulnar joints. 
::BDTF::bil. distal tibiofibular syndesmosis. 
::BDTM::bil. distal tibial metaphyses. 
::BDTS::bil. distal tibial shafts. 
::BDUS::bil. distal ulnar shafts. 
::BEL::bil. elbows. 
::BEJ::bil. elbow joints. 
::BES::bil. ethmoid sinuses. 
::BF::bony fragment(s) 
::BFA::bil. facet arthroses 
::BFA1::bil. facet arthroses and hypertrophic ligamenta flava
::BFAL::bil. facet arthroses at the lower lumbar levels. 
::BFAM::bil. facet arthroses at multiple levels. 
::BFE::bil. feet. 
::BFEA::bil. femoral arteries. 
::BFEM::bil. femoral mid-shafts. 
::BFF::bil. fore-feet. 
::BFH::bil. femoral heads. 
::BFIM::bil. fibular mid-shafts. 
::BFIS::bil. femoral intertrochanteric to subtrochanteric areas. 
::BFIT::bil. femoral intertrochanteric areas. 
::BFN::bil. femoral necks. 
::BFNI::bil. femoral necks to intertrochanteric areas. 
::BFR::bony fragment(s) 
::BFS::bil. frontal sinuses. 
::BFSC::bil. femoral supracondylar areas. 
::BFSS::bil. distal femoral shafts to supracondylar areas. 
::BFST::bil. femoral subtrochanteric areas. 
::BFTJ::bil. femorotibial joints. 
::BG::bone graft(s) 
::BGFT::bil. greater femoral trochanters. 
::BGH::bil. glenohumeral joints. 
::BGHT::bil. geater humeral tubercles. 
::BH::bil. hands. 
::BHAB::s/p bipolar hemiarthroplasty with postoperative changes at the bil. hip joints. 
::BHAL::s/p bipolar hemiarthroplasty with postoperative changes at the left hip joint. 
::BHAR::s/p bipolar hemiarthroplasty with postoperative changes at the right hip joint. 
::BHC::bil. humeral capitella. 
::BHF::bil. hind-feet. 
::BHH::bil. humeral heads. 
::BHJ::bil. hip joints. 
::BHMS::bil. humeral mid-shafts. 
::BHN::bil. humeral necks. 
::BHS::borderline heart size. 
::BHSC::bil.  humeral supracondylar areas. 
::BHSS::bil. distal humeral shafts to supracondylar areas. 
::BI::bone island(s) 
::BIA::bil. inguinal area(s). 
::BILA::bil. iliac arteries. 
::BINA::bil. inguinal areas. 
::BIPA::bil. infrapatellar areas. 
::BIPH::biphalangism of the 
::BIPJ::bil. iliopubic junctions. 
::BIT::bil. Ischial tuberosities. 
::BIW::bil. iliac wings. 
::BK::bil. knees. 
::BKFP::bil. Kager's fat pads. 
::BKJ::bil. knee joints. 
::BLCP::blunting of the left costophrenic angle. 
::BLF::bil. lung fields. 
::BLFC::bil. lateral femoral condyles. 
::BLFE::bil. lower femoral shafts. 
::BLFI::bil. lower fibular shafts. 
::BLFT::bil. lateral femorotibial joints. 
::BLHS::bil. lower humeral shafts. 
::BLL::bil. lower limbs. 
::BLLF::bil. lower lung fields. 
::BLM::bil. lateral malleoli. 
::BLPF::bil. lateral patellofemoral joints. 
::BLTC::bil. lateral tibial condyles. 
::BLTD::bil. lateral talar domes. 
::BLTS::bil. lower tibial shafts. 
::BMA::bil. maxillary antra. 
::BMAC::bil. mastoid air cells. 
::BMC::bil. mid-clavicles. 
::BMCJ::bil. mid-carpal joints. 
::BMCP::bil. metacarpophalangeal joints. 
::BMEC::bil. medial clavicles. 
::BMF::bil. mid-feet. 
::BMFC::bil. medial femoral condyles. 
::BMFT::bil. medial femorotibial joints. 
::BML::bil. mid-lung zones. 
::BMLM::bil. medial and lateral malleoli. 
::BMM::bil. medial malleoli. 
::BMT::bil. mid-tarsal joints. 
::BMTC::bil. medial tibial condyles. 
::BMTD::bil. medial talar domes. 
::BMTP::bil. metatarsophalangeal joints. 
::BNF::bil. neural foramina. 
::BNFN::bil. neural foraminal narrowing. 
::BO::with bony overriding 
::BP::bil. patellae.
::BPA::bil. popliteal areas. 
::BPB::bil. patellar bases. 
::BPD::bulging-protruding disc(s) at the 
::BPF::bil. patellofemoral joints. 
::BPFE::bil. proximal femoral shafts. 
::BPFI::bil. proximal fibular shafts. 
::BPH::bil. proximal humeri. 
::BPHS::bil. proximal humeral shafts. 
::BPIN::bil. posterior intercondylar notches. 
::BPLF::bil. perihilar lung fields. 
::BPOA::bil. popliteal arteries. 
::BPRS::bil. proximal radial shafts. 
::BPRU::bil. proximal radioulnar joints. 
::BPSI::bil. prepatellar and superficial infrapatellar areas. 
::BPTF::bil. proximal tibiofibular joints. 
::BPTS::bil. proximal tibial shafts. 
::BPUS::bil. proximal ulnar shafts. 
::BRC::bil. radiocarpal joints. 
::BRCP::blunting of the right costophrenic angle. 
::BRF::bil. renal fossae. 
::BRH::bil. radial heads. 
::BRMS::bil. radial mid-shafts. 
::BRN::bil. radial necks. 
::BRS::bil. radial styloids. 
::BSAL::bil. sacral alae. 
::BSB::bil. scapular bodies. 
::BSCJ::bil. sternoclavicular joints. 
::BSG::bil. scapular glenoids. 
::BSH::bil. shoulders. 
::BSI::bil. sacroiliac joints. 
::BSIG::bil. scapular infraglenoid areas. 
::BSIP::bil. superior and inferior pubic rami. 
::BSN::bil. scapular necks. 
::BSNO::bil. scapular notches. 
::BSPP::bil. suprapatellar pouches. 
::BSTJ::bil. subtalar joints. 
::BSW::bil. scaphoid waists. 
::BT::both thighs. 
::BTH::bil. thumbs. 
::BTMF::s/p bil. transpedicle metallic fixation at the 
::BTMS::bil. tibial mid-shafts. 
::BTMT::bil. tarsometatarsal joints. 
::BTN::bil. talar necks. 
::BTNJ::bil. talonavicular joints. 
::BTT::bil. tibial tuberosities. 
::BTTJ::bil. tibiotalar joints. 
::BTU::bil. trochlea-ulnar joints. 
::BUFX::(previous) burst fracture(s) at the 
::BULF::bil. upper lung fields. 
::BUMS::bil. ulnar mid-shafts. 
::BUPS::bil. ulnar prestyloid areas. 
::BUS::bil. ulnar styloids. 
::BW::bil. wrists. 
::C::cardiomegaly with 
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
::CABG::s/p coronary artery bypass graft (CABG) surgery with retension of surgical material(s). 
::CAF::(focal) calcified annulus fibrosus 
::CAK::calcification of the aortic knob. 
::CAPD::s/p continuous ambulatory peritoneal dialysis with retension of a catheter in position. 
::CBC::communicating Baker cyst. 
::CBD::common bile duct. 
::CC::chondrocalcinosis, 
::CCT::cardiomegaly with calcification of tortuous aorta. 
::CCTM::cardiomegaly with calcification of tortuous aorta and mediastinal widening. 
::CD::s/p core decompression with postoperative changes. 
::CESP::cervical spine 
::CF::s/p casting fixation 
::CFC::(some) curvilinear fibrotic changes at the 
::CHD::common hepatic duct(s) of 
::CHF::(impending) congestive heart failure. 
::CHFX::(previous) chip fracture(s) at the 
::CHID::with compensatory hypertrophy of the adjacent disc spaces. 
::CHO::s/p cholecystectomy with retension of surgical clip(s) over the RUQ abdomen. 
::CHO1::s/p cholecystectomy with retension of surgical clip(s) in the gallbladder fossa. 
::CI::s/p chest intubation in position 
::CIFX::(previous) comminuted impacted fracture(s) at the 
::CIG::some calcified injection granulomas at the gluteal area(s) 
::CIRS::colon interposition in the right subphrenic area. 
::CLUB::varus position of the hindfoot, adduction of the forefoot and equinous deformity of the heel, suggestive of club foot, 
::CMC::carpometacarpal joint(s) 
::CME::contussion marrow edema at the 
::CME1::contussion marrow edema at the lateral femoral and tibial condyles. 
::CMFX::(previous) comminuted fracture(s) at the 
::CNF::a calcified nodular focus about the 
::CNF1::some calcified nodular foci about the 
::CNL::focal calcification(s) of the nuchal ligament. 
::COL::s/p colostomy in position at the 
::COM::chronic otitis media, 
::CP::s/p coil(s) placement in position over the aortopulmonary window. 
::CPBS::coracoid processes of bil. scapulae. 
::CPBU::coronoid processes of  bil. ulnae. 
::CPFX::(previous) compression fracture(s) and wedge deformity or decrease in height of the 
::CPLS::coracoid process of left scapula. 
::CPLU::coronoid process of left ulna. 
::CPRS::coracoid process of right scapula. 
::CPRU::coronoid process of right ulna. 
::CPST::with cortical permeation and adjacent soft tissue extension.
::CRO::subglottic narrowing of the airway with steeple sign, compatible with croup. 
::CS::cervical spondylosis with posterior spur formation at the 
::CS1::cervical spondylosis with disc space narrowing and posterior spur formation at the 
::CS1M::cervical spondylosis with disc space narrowing and posterior spur formation at multiple levels. 
::CS2::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomenon and posterior spur formation at the 
::CS2M::cervical spondylosis with disc space narrowing, intradiscal vacuum phenomena and posterior spur formation at multiple levels. 
::CSC::compression of the adjacent spinal cord. 
::CSFX::(previous) comminuted spiral fracture(s) at the 
::CSM::cervical spondylosis with posterior spur formation at multiple levels. 
::CSP::cervical spine 
::CTAB::CT scan of the abdomen without/with IV contrast enhancement shows: 
::CTAP::CT scan of the abdomen and pelvis without/with IV contrast enhancement shows: 
::CTCA::CT scan of the chest and abdomen without/with IV contrast enhancement shows: 
::CTCH::CT scan of the chest without/with IV contrast enhancement shows: 
::CTCS::CT scan of the cervical spine without IV contrast enhancement shows: 
::CTH::CT scan of the head without IV contrast enhancement shows: 
::CTLS::CT scan of the lumbar spine without IV contrast enhancement shows: 
::CTS::central canal stenosis 
::CTWB::CT scan of the whole spine without IV contrast enhancement shows: 
::CTWB1::CT scan of the whole spine without/with IV contrast enhancement shows: 
::CUFX::(previous) curvilinear fracture(s) at the 
::CV::via collateral vessel(s). 
::CVJ::costovertebral junction(s).
::CVLF::s/p CVP insertion via left femoral approach. 
::CVLJ::s/p CVP insertion via left jugular approach. 
::CVLS::s/p CVP insertion via left subclavian approach. 
::CVRF::s/p CVP insertion via right femoral approach. 
::CVRJ::s/p CVP insertion via right jugular approach. 
::CVRS::s/p CVP insertion via right subclavian approach. 
::DABL::discoid atelectasis of the adjacent basal lung field(s). 
::DACB::degenerative arthrosis of the bil. acromioclavicular joints with marginal spur formation. 
::DACL::degenerative arthrosis of the left acromioclavicular joint with marginal spur formation. 
::DACR::degenerative arthrosis of the right acromioclavicular joint with marginal spur formation. 
::DAHD::decreased acromiohumeral distance. 
::DBF::displaced bony fragment(s) 
::DBL::destructive bony lesion(s) 
::DCCS::degenerative change of the cervical spine with 
::DCDD::degenerative change of the spine with dehydrated disc(s) 
::DCFX::(previous) displaced comminuted fracture(s) at the 
::DCLS::degenerative change of the lumbar spine with 
::DCS::degenerative change of the spine 
::DCSF::degenerative change of the spine with marginal spur formation. 
::DD::dehydrated disc(s) at the 
::DDD::degenerative disk disease, 
::DDH::relative shallowing deformity of the acetabulum with mild lateral subluxation of the femoral head, suggestive of developmental dysplasia of the hip, 
::DDM::dehydrated discs at multiple levels. 
::DEFX::(previous) depressed fracture(s) at the 
::DEL::This study was delayed to report due to systemic factor. 
::DIFX::(previous) displaced fracture(s) at the 
::DIH::decrease in height of the 
::DIP::distal interphalangeal joint(s) of the 
::DIS::dislocation of the 
::DISH::, r/o diffuse idiopathic skeletal hyperostosis. 
::DISI::, r/o dorsal intercalated segment instability. 
::DJB::s/p double J catherization in the bil. collecting systems. 
::DJL::s/p double J catherization in the left collecting system. 
::DJR::s/p double J catherization in the right collecting system. 
::DLLF::s/p double-lumen catheterization via left femoral approach. 
::DLLJ::s/p double-lumen catheterization via left jugular approach. 
::DLLS::s/p double-lumen catheterization via left subclavian approach. 
::DLRF::s/p double-lumen catheterization via right femoral approach. 
::DLRJ::s/p double-lumen catheterization via right jugular approach. 
::DLRS::s/p double-lumen catheterization via right subclavian approach. 
::DMF::s/p dynamic metallic fixation 
::DN::disc space narrowing 
::DNU::but an irregular radiolucent gap at the fracture site, r/o delayed or non-union. 
::DO::disuse osteopenia of the 
::DOFX::(previous) displaced oblique fracture(s) at the 
::DOI::due to old insult. 
::DPAI::due to previous avulsed injury. 
::DPB::distal phalangeal base of the 
::DPH::distal phalanx of 
::DPI::due to previous insult. 
::DPMA::relative decreased pneumatization of the mastoid air cells 
::DPR::due to the patient's refusal 
::DRF::(previous) impacted fracture at the distal radial metaphysis with dorsal angulation of its distal bony part, intraarticular extension to the distal radioulnar and radiocarpal joints, and adjacent soft tissue swelling. 
::DRF1::(previous) impacted fracture at the distal radial metaphysis with volar angulation of its distal bony part, intraarticular extension to the distal radioulnar and radiocarpal joints, and adjacent soft tissue swelling. 
::DS::disc space(s). 
::DSB::dilated small bowel loops at the 
::DSD::degenerative spinal disease, 
::DSDD::degenerative spinal and disk disease, 
::DSFX::(previous) displaced spiral fracture(s) at the 
::DSL::degenerative spondylolisthesis, 
::DSL2::grade 0-1 degenerative spondylolisthesis of the L2 on L3 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL3::grade 0-1 degenerative spondylolisthesis of the L3 on L4 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL4::grade 0-1 degenerative spondylolisthesis of the L4 on L5 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSL5::grade 0-1 degenerative spondylolisthesis of the L5 on S1 with bil. facet arthroses at the lower lumbar levels, r/o spinal stenosis. 
::DSN::disc space narrowing at the 
::DSN5::disc space narrowing at the L5-S1 level. 
::DT::distal tuft(s) of the 
::DTCS::due to cervical spondylosis. 
::DTFX::(previous) displaced transverse fracture(s) at the 
::DUS::distal ulnar styloid. 
::EAS::uneven articular surface(s), 
::EBF::s/p external bandage fixation 
::EBH::elevation of the bil. hemidiaphragms. 
::EBL::emphysema of the both lungs. 
::EI::essential intact of the 
::ELH::elevation of the left hemidiaphragm. 
::ELN::some enlarged lymph nodes at the 
::EMF::s/p external (traction) metallic fixation 
::EP::enlarged prostate with basal indentation of the adjacent urinary bladder. 
::ERH::elevation of the right hemidiaphragm. 
::ESF::s/p external splint fixation 
::ET::s/p endotracheal intubation in position. 
::ETE::focal exostosis or traction enthesophyte formation at the medial aspect of proximal tibial metaphysis. 
::FA::facet arthroses 
::FAL::facet arthroses at the lower lumbar levels. 
::FAS::fine alignment of the spine. 
::FBD::focal bony defect(s) at the 
::FBG::"the femoral bone graft, measuring about  cm in length, from a -year-old male. 
::FC::some fibrotic changes 
::FCF::with fine callus formation 
::FCL::some fibrocalcified lesions over the 
::FCN::some fibrocalcified nodular lesions over the 
::FD::flexion deformity or position of the 
::FETE::focal exostosis or traction enthesophyte formation over the medial aspect of proximal tibial metaphysis 
::FFL::fat-fluid level(s), suggestive of lipohemoarthrosis, in the 
::FHID::with fine hydration of the intervertebral discs. 
::FIST::femoral intertrochanteric to subtrochanteric area. 
::FIT::femoral intertrochanteric area. 
::FM::some fecal materials impacted in the colon. 
::FMS::femoral mid-shaft. 
::FPMA::fine pneumatization of the mastoid air cells 
::FPPS::fine pneumatization of the paranasal sinuses 
::FR::some food residues in the stomach. 
::FS::fracture site. 
::FSHP::focal synovial herniation pit(s) at the anterolateral aspect(s) of femoral head-neck junction(s) 
::FSN::focal Schmorl's node(s) at the 
::FU::with fine union. 
::FUS::fusion of the 
::G::s/p gastrostomy in position at the 
::GDS::gas distension of the stomach. 
::GF::gallbladder fossa. 
::GFT::greater femoral trochanter. 
::GHT::greater humeral tubercle. 
::GSFX::(previous) greenstick fracture(s) at the 
::HAB::s/p hemiarthroplasty with postoperative changes at the bil. hip joints. 
::HAI::hazy alveolar infiltrations over the 
::HAL::s/p hemiarthroplasty with postoperative changes at the left hip joint. 
::HAR::s/p hemiarthroplasty with postoperative changes at the right hip joint. 
::HBH::humping of the bil. hemidiaphragms. 
::HBL::hyperinflation of the both lungs. 
::HC::hazy consolidation at the 
::HEE::hyperextension of the  elbow joint with an angle of  degree. 
::HEFT::hyperextension of the  femorotibial joint with an angle of  degree. 
::HEX::hyperextension of the 
::HF1::healing fracture(s) at the 
::HF2::healed fracture(s) at the 
::HI::hazy infiltrations at the 
::HIFP::Hoffa's infrapatellar fat pad(s). 
::HLC::hyperlordotic curve of the spine. 
::HLF::hypertrophic ligamenta flava 
::HLH::humping of the left hemidiaphragm. 
::HLL::hyperinflation of the left lung. 
::HOFX::(previous) horizontal fracture(s) at the 
::HRF::s/p Harrington rod fixation at the 
::HRH::humping of the right hemidiaphragm. 
::HRL::hyperinflation of the right lung. 
::HSF::s/p Herbert screw fixation 
::IAC::internal auditory canal(s) 
::IAE::with intraarticular extension to the 
::IAFX::(previous) intraarticular fracture(s) at the 
::IAHD::increased acromiohumeral distance. 
::IAVP::intraarticular vacuum phenomenon(a) at the 
::IBA::involvement of the biceps anchor. 
::IBF::s/p interbody bony fusion at the 
::IBMF::s/p interbody metallic fixation at the 
::IBSI::s/p interbody spacer implantation at the 
::IBT::intact bony thorax. 
::ICE::intercondylar eminence. 
::ICN::intercondylar notch.
::ID::For the angle measurement, please provide the patient's ID through the route of military certification. 
::IDC::intradiscal calcification(s) 
::IDU::impingement of the distal ulna to the adjacent 
::IDVP::intradiscal vacuum phenomenon(a) at the 
::IE::increased effusions in the 
::IEBT::intercondylar eminences of bil. tibiae. 
::IELT::intercondylar eminence of left tibia. 
::IERT::intercondylar eminence of right tibia. 
::IHD::intrahepatic duct(s) of 
::II::some interstitial infiltrations at 
::IIAC::essential intact of the internal auditory canal(s) 
::IJE::increased joint effusion(s) in the 
::IKCT::increased kyphotic curve of the thoracic spine. 
::ILB::an intraarticular loose body in the 
::ILB1::some intraarticular loose bodies in the 
::ILCC::increased lordotic curve of the cervical spine. 
::ILCL::increased lordotic curve of the lumbar spine. 
::ILF::s/p interlocking nail and screw fixation 
::ILM::Increased lung markings 
::ILMB::increased lung markings on both sides. 
::ILML::increased lung markings on left side. 
::ILMR::increased lung markings on right side. 
::ILSA::increased lumbosacral angle, suggestive of lumbosacral instability. 
::IMF::s/p intramedullary metallic fixation 
::IMFX::(previous) impacted fracture(s) at the 
::IMSF::s/p interbody metallic spacer fixation at the 
::INBF::intercondylar notches of bil. femora. 
::INFX::(previous) incomplete fracture(s) at the 
::INLF::intercondylar notch of left femur. 
::INRF::intercondylar notch of right femur. 
::IOFX::(previous) irregular oblique fracture(s) at the 
::IOSV::under the intraoperative status. 
::IPEI::interstitial and peribronchial infiltrations at the 
::IPET::interstitial and peribronchial thickening at the 
::IPF::s/p intramedullary pin fixation 
::IPIP::iliopubic junction and inferior pubic ramus. 
::IPJ::interphalangeal joint(s)
::IR::internal rotation of the 
::IR::F	due to impaired renal function 
::IRFX::(previous) irregular fracture(s) at the 
::ISF::s/p intramedullary screw fixation 
::ISIB::essential intact sacroiliac joints on both sides. 
::ISIH::essential intact sacroiliac and hip joints on both sides. 
::ISIL::essential intact sacroiliac joints on left side. 
::ISIR::essential intact sacroiliac joints on right side. 
::IST::essential intact sella turcica. 
::IUD::an intrauterine device in the pelvic cavity. 
::IVMF::s/p intravertebral metallic fixation 
::IVVP::"intravertebral vacuum phenomenon(a), r/o osteonecrosis. 
::JSN::joint space narrowing 
::JSW::joint space widening 
::KA::kyphotic angulation of the 
::KC::kyphotic curve of the spine. 
::KFP::Kager's fat pad(s). 
::KS::kyphoscoliosis of the spine. 
::KWF::s/p K wire(s) or pin(s) fixation 
::L11::	"L1-2, L2-3, L3-4, L4-5 and L5-S1 levels. 
::L12::L1-2 level. 
::L13::L1-2 and L2-3 levels. 
::L14::L1-2, L2-3 and L3-4 levels. 
::L15::"L1-2, L2-3, L3-4 and L4-5 levels. 
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
::L5T::left little toe. 
::LA::left ankle. 
::LAA::left apical area. 
::LAC::left acromioclavicular joint. 
::LAIN::left anterior intercondylar notch. 
::LALF::left apical lung field. 
::LAR::left acetabular roof. 
::LBA::left basal area. 
::LBC::leakage of some bone cement(s) at the 
::LBGR::left bicipital groove. 
::LBLF::left basal lung field. 
::LBT::left big toe. 
::LC::left calf. 
::LCB::left carpal bones. 
::LCC::left calcaneocuboid joint. 
::LCCJ::left calcaneocuboid joint. 
::LCL::at the lower cervical levels. 
::LCMC::left carpometacarpal joint. 
::LCR::	left capitellum-radial head joint. 
::LCW::left chest wall. 
::LDA::lateral downsloped acromion 
::LDC::left distal clavicle. 
::LDFE::left distal femoral shaft. 
::LDFI::left distal fibular shaft. 
::LDHC::left distal humeral capitellum. 
::LDHS::left distal humeral shaft. 
::LDHT::left distal humeral trochlea. 
::LDRM::left distal radial metaphysis. 
::LDRS::left distal radial shaft. 
::LDRU::left distal radioulnar joint. 
::LDTF::left distal tibiofibular syndesmosis. 
::LDTM::left distal tibial metaphysis. 
::LDTS::left distal tibial shaft. 
::LDUM::left distal ulnar metaphysis. 
::LDUS::left distal ulnar shaft. 
::LE::left elbow. 
::LEBF::lateral epicondyles of bil. femora. 
::LEBH::laterl epicondyles of bil. humeri. 
::LEJ::left elbow joint. 
::LELF::lateral epicondyle of left femur. 
::LELH::lateral epicondyle of left humerus. 
::LERF::lateral epicondyle of right femur. 
::LERH::lateral epicondyle of right humerus. 
::LES::left ethmoid sinus. 
::LF::left foot. 
::LFA::left forearm. 
::LFC::lateral femoral condyle. 
::LFEM::left femoral mid-shaft. 
::LFF::left fore-foot. 
::LFH::left femoral head. 
::LFIM::left fibular mid-shaft. 
::LFIN::left fibular neck. 
::LFIS::left femoral intertrochanteric to subtrochanteric area. 
::LFIT::left femoral intertrochanteric area. 
::LFN::left femoral neck. 
::LFNI::left femoral neck to intertrochanteric area. 
::LFS::left frontal sinus. 
::LFSC::left femoral supracondylar area. 
::LFSS::left distal femoral shaft to supracondylar area. 
::LFST::left femoral subtrochanteric area. 
::LFT::lesser femoral trochanter(s). 
::LFTJ::left femorotibial joint. 
::LGFT::left greater femoral trochanter. 
::LGH::left glenohumeral joint. 
::LGHT::left greater humeral tubercle. 
::LGR::left glenoid rim. 
::LH::left hand. 
::LHC::left humeral capitellum. 
::LHF::left hind-foot. 
::LHH::left humeral head. 
::LHJ::left hip joint. 
::LHMS::left humeral mid-shaft. 
::LHN::left humeral neck. 
::LHSC::left humeral supracondylar area. 
::LHSS::left distal humeral shaft to supracondylar area. 
::LHT::lesser humeral tubercle(s). 
::LIFX::(previous) linear fracture(s) at the 
::LINA::left inguinal area. 
::LIPA::left infrapatellar area. 
::LIPJ::left iliopubic junction. 
::LIPR::left inferior pubic ramus. 
::LIT::left ischial tuberosity. 
::LIW::left iliac wing. 
::LK::left knee. 
::LKFP::left Kager's fat pad. 
::LKJ::left knee joint. 
::LLA::low-lying acromion 
::LLCC::loss of normal lordotic curve of the cervical spine. 
::LLCL::loss of normal lordotic curve of the lumbar spine. 
::LLF::left lung field. 
::LLFC::left lateral femoral condyle. 
::LLFE::left lower femoral shaft. 
::LLFI::left lower fibular shaft. 
::LLFT::left lateral femorotibial joint. 
::LLHS::left lower humeral shaft. 
::LLL::left lower leg. 
::LLLF::left lower lung field. 
::LLM::left lateral malleolus. 
::LLPF::left lateral patellofemoral joint. 
::LLQ::LLQ abdomen. 
::LLT::left lower thigh. 
::LLTC::left lateral tibial condyle. 
::LLTD::left lateral talar dome. 
::LLTS::left lower tibial shaft. 
::LM::increased lung markings on both sides. 
::LMA::left maxillary antrum. 
::LMC::left mid-clavicle. 
::LMCJ::left mid-carpal joint. 
::LMCP::left metacarpophalangeal joint. 
::LMEC::left medial clavicle. 
::LMF::left mid-foot. 
::LMFC::left medial femoral condyle. 
::LMFT::left medial femorotibial joint. 
::LML::left mid-lung zone. 
::LMLM::left medial and lateral malleoli. 
::LMM::left medial malleolus. 
::LMT::left mid-tarsal joint. 
::LMTC::left medial tibial condyle. 
::LMTD::left medial talar dome. 
::LMTP::left metatarsophalangeal joint. 
::LMTS::left medial tibial spine. 
::LNF::left neural foramen. 
::LOCL::loss of normal lordotic curve of the lumbar spine. 
::LOFX::(previous) longitudinal fracture(s) at the 
::LP::left patella. 
::LPA::left popliteal area. 
::LPB::left patellar base. 
::LPF::left patellofemoral joint. 
::LPFE::left proximal femoral shaft. 
::LPFI::left proximal fibular shaft. 
::LPH::left proximal humerus. 
::LPHS::left proximal humeral shaft. 
::LPIN::left posterior intercondylar notch. 
::LPLF::left perihilar lung field. 
::LPRS::left proximal radial shaft. 
::LPRU::left proximal radioulnar joint. 
::LPS::left pubic symphysis. 
::LPSI::left prepatellar and superficial infrapatellar areas. 
::LPTF::left proximal tibiofibular joint. 
::LPTM::left proximal tibial metaphysis. 
::LPTS::left proximal tibial shaft. 
::LPUS::left proximal ulnar shaft. 
::LRC::left radiocarpal joint. 
::LRD::left radial head. 
::LRF::left renal fossa. 
::LRH::left radial head. 
::LRMS::left radial mid-shaft. 
::LRN::left radial neck. 
::LRS::left radial styloid. 
::LS::lumbar spondylosis with marginal spur formation at the 
::LS1::lumbar spondylosis with disc space narrowing and marginal spur formation at the 
::LS1L::lumbar spondylosis with disc space narrowing and marginal spur formation at the lower lumbar levels. 
::LS1M::lumbar spondylosis with disc space narrowing and marginal spur formation at multiple levels. 
::LS2::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomenon and marginal spur formation at the 
::LS2L::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at the lower lumbar levels. 
::LS2M::lumbar spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at multiple levels. 
::LSAL::left sacral ala. 
::LSB::left scapular body. 
::LSBF::lateral subluxation of the bil. femoral heads. 
::LSBP::lateral subluxation or tilt of the both patellae. 
::LSCJ::left sternoclavicular joint. 
::LSG::left scapular glenoid. 
::LSH::left shoulder. 
::LSIG::left scapular infraglenoid area. 
::LSIJ::left sacroiliac joint. 
::LSIP::left superior and inferior pubic rami. 
::LSJ::lumbosacral junction. 
::LSL::lumbar spondylosis with marginal spur formation at the lower lumbar levels. 
::LSLF::lateral subluxation of the left femoral head. 
::LSLP::lateral subluxation or tilt of the left patella. 
::LSM::lumbar spondylosis with marginal spur formation at multiple levels. 
::LSN::left scapular neck. 
::LSNO::left scapular notch. 
::LSP::lumbar spine 
::LSPK::s/p limb salvage procedure with metallic prosthesis at the distal femur and knee 
::LSPP::left suprapatellar pouch. 
::LSPR::left superior pubic ramus. 
::LSRF::lateral subluxation of the right femoral head. 
::LSRP::lateral subluxation or tilt of the right patella. 
::LSSP::lumbosacral spine  
::LSTJ::left subtalar joint. 
::LSW::left scaphoid waist. 
::LT::left thigh. 
::LTC::lateral tibial condyle. 
::LTH::left thumb. 
::LTMS::left tibial mid-shaft. 
::LTMT::left tarsometatarsal joint. 
::LTN::left talar neck. 
::LTNJ::left talonavicular joint. 
::LTP::lateral tibial plateau. 
::LTR::lateral translation of the 
::LTT::left tibial tuberosity. 
::LTTJ::left tibiotalar joint. 
::LTU::left trochlea-ulnar joint. 
::LULF::left upper lung field. 
::LUMS::left ulnar mid-shaft. 
::LUPS::left ulnar prestyloid area. 
::LUQ::left upper quadrant of abdomen 
::LUS::left ulnar styloid. 
::LUSP::lumbar spine 
::LUT::left upper thigh. 
::LV::limbus vertebra at the anterosuperior aspect(s) of 
::LW::left wrist. 
::M::s/p mastectomy 
::MA::focus (foci) of metallic artifact(s) at the 
::MAF::s/p metallic anchor fixation 
::MBM::multiple bony metastases. 
::MCF::with minimal or mild callus formation 
::MCPJ::metacarpophalangeal joint(s) 
::MDC::minimal or mild degenerative change. 
::MDPF::maximal dorsiflexion and plantar flexion of the both ankles. no definite evidence of bony or joint lesion at the both ankles. 
::MEBF::medial epicondyles of bil. femora. 
::MEBH::medial epicondyles of bil. humeri. 
::MELF::medial epicondyle of left femur. 
::MELH::medial epicondyle of left humerus. 
::MERF::medial epicondyle of right femur. 
::MERH::medial epicondyle of right humerus. 
::MESB::mild effusion(s) in the suprapatellar bursa and knee joint. 
::MF::s/p metallic fixation 
::MFC::medial femoral condyle. 
::ML::multiple levels. 
::MLSH::MRI of the left shoulder without IV contrast enhancement shows: 
::MPH::middle phalanx of 
::MRA::MRA of the pelvis and bil. lower limbs without/with IV contrast enhancement shows: 
::MRBH::MRI of the both hips without/with IV contrast enhancement shows: 
::MRCS::MRI of the cervical spine without IV contrast enhancement shows: 
::MRCS1::MRI of the cervical spine without/with IV contrast enhancement shows: 
::MRLA::MRI of the left ankle without IV contrast enhancement shows: 
::MRLA1::MRI of the left ankle without/with IV contrast enhancement shows: 
::MRLE::MRI of the left elbow without IV contrast enhancement shows: 
::MRLE1::MRI of the left elbow without/with IV contrast enhancement shows: 
::MRLF::MRI of the left foot without IV contrast enhancement shows: 
::MRLF1::MRI of the left foot without/wtih IV contrast enhancement shows: 
::MRLK::MRI of the left knee without IV contrast enhancement shows: 
::MRLK1::MRI of the left knee without/with IV contrast enhancement shows: 
::MRLS::MRI of the lumbosacral spine without IV contrast enhancement shows: 
::MRLS1::MRI of the lumbosacral spine without/with IV contrast enhancement shows: 
::MRLSH::MRI of the left shoulder without IV contrast enhancement shows: 
::MRLSH1::MRI of the left shoulder without/with IV contrast enhancement shows: 
::MRLW::MRI of the left wrist without IV contrast enhancement shows: 
::MRLW1::MRI of the left wrist without/with IV contrast enhancement shows: 
::MRPH::MRI of the pelvis and both hips without/with IV contrast enhancement shows: 
::MRRA::MRI of the right ankle without IV contrast enhancement shows: 
::MRRA1::MRI of the right ankle without/with IV contrast enhancement shows: 
::MRRE::MRI of the right elbow without IV contrast enhancement shows: 
::MRRE1::MRI of the right elbow without/with IV contrast enhancement shows: 
::MRRF::MRI of the right foot without IV contrast enhancement shows: 
::MRRF1::MRI of the right foot without/with IV contrast enhancement shows: 
::MRRK::MRI of the right knee without IV contrast enhancement shows: 
::MRRK1::MRI of the right knee without/with IV contrast enhancement shows: 
::MRRSH::MRI of the right shoulder without IV contrast enhancement shows: 
::MRRSH1::MRI of the right shoulder without/with IV contrast enhancement shows: 
::MRRW::MRI of the right wrist without IV contrast enhancement shows: 
::MRRW1::MRI of the right wrist without/with IV contrast enhancement shows: 
::MRSH::MRI of the right shoulder without IV contrast enhancement shows: 
::MRTL::MRI of the thoracolumbar spine without IV contrast enhancement shows: 
::MRTL1::MRI of the thoracolumbar spine without/with IV contrast enhancement shows: 
::MRTS::MRI of the thoracic spine without IV contrast enhancement shows: 
::MRTS1::MRI of the thoracic spine without/with IV contrast enhancement shows: 
::MRWS::MRI of the whole spine without IV contrast enhancement shows: 
::MRWS1::MRI of the whole spine without/with IV contrast enhancement shows: 
::MSA::focus (foci) of magnetic susceptibility artifact(s) at the 
::MSF::marginal spur formation 
::MT::mucosal thickening 
::MTC::medial tibial condyle. 
::MTE::mixed type endplate change(s) at the 
::MTEC::mixed-typed endplate change(s) at the 
::MTP::medial tibial plateau. 
::MTPJ::metatarsophalangeal joint(s) 
::MW::mediastinal widening. 
::NABL::non-aggressive bony lesion, 
::NAL::no active lung lesion. 
::NB::no evidence of focal bony or joint lesion. no evidence of fracture or dislocation. 
::NBJ::no evidence of focal bony or joint lesion at the 
::NBNF::narrowing of the bil. neural foramina. 
::NBR::no evidence of intracranial hemorrhage or skull fracture. 
::NCME::no evidence of contussion marrow edema at the femoral and tibial condyles. 
::ND::non-displaced 
::NDBL::no evidence of destructive bony lesion at the 
::NDC::no obvious evidence of degenerative change at the 
::NDEL::no evidence of abnormal density or enhanced lesion at the 
::NDFX::(previous) non-displaced fracture(s) at the 
::NDL::no evidence of abnormal density lesion at the 
::NDS::narrowed disc space 
::NEL::no evidence of enlarged lymphadenopathy. 
::NF::neural foramen 
::NF1::neural foramina 
::NFA::no evidence of free air. 
::NFD::no evidence of fracture or dislocation. 
::NFL::no evidence of focal lesion at the 
::NFLA::no evidence of focal lesion at the liver, gallbladder, spleen, pancreas, bil. adrenals and both kidneys. 
::NFLB::no evidence of focal lesion at the visible bony and muscular structures. 
::NFN::neural foraminal narrowing 
::NG::s/p NG intubation in position. 
::NHS::normal heart size. 
::NI::No image(s) of the  available for interpretation. 
::NIC::No obvious evidence of interval change as comparison with prior study. 
::NID::no evidence of internal derangement. 
::NIDH::no evidence of intervertebral disk herniation.
::NIDH1::no evidence of intervertebral disk herniation or neural foraminal narrowing. 
::NIKC::no evidence of increased kyphotic curve of the thoracic spine. 
::NL::nodular lesion 
::NLC::focal calcification of the nuchal ligament. 
::NLD::no obvious evidence of length discrepancy between the bil. lower limbs. 
::NLNF::narrowing of the left neural foramen. 
::NLPS::no evidence of lateral patellar subluxation 
::NMA::no evidence of marked ascites. 
::NNFB::no evidence of neural foraminal narrowing on both sides. 
::NOF::no evidence of opaque foreign body. 
::NOS::no evidence of opaque stone. 
::NOT::Notice: We has informed this information to the on-duty doctor of our emergency station at 96-04-13 AM 11:00. 
::NP::no definite radiological abnormality is noted in this study. 
::NPA::nonspecific small bowel gas pattern. no evidence of opaque stone. 
::NPA1::nonspecific small bowel gas pattern. clear renal and psoas shadows on both sides. no evidence of opaque stone. 
::NPC::normal heart size. no active lung lesion. bilateral sharp costophrenic angles.
::NPC1::normal heart size. no active lung lesion. intact bony thorax. 
::NPS::fine alignment of the spine with preserved disc spaces. 
::NPT::no evidence of pneumothorax. 
::NRNF::narrowing of the right neural foramen. 
::NSB::nonspecific small bowel gas pattern. 
::NSC::no evidence of focal lesion in the visible spinal cord. 
::NSEL::no evidence of abnormal signal or enhanced lesion at the 
::NSF::no evidence of skull fracture. 
::NSL::no evidence of abnormal signal lesion at the 
::NSLB::no evidence of spondylolysis on both sides. 
::NSLN::some nonspecific small lymph nodes at the 
::NSS::no evidence of spinal subluxation. 
::NSTL::no evidence of abnormal soft tissue lesion. 
::NT::nerve root(s) 
::NU::with non-union. 
::NUFX::(previous) non-united fracture(s) at the 
::NUVB::negative ulnar variance on both sides. 
::NUVL::negative ulnar variance on left side. 
::NUVR::negative ulnar variance on right side. 
::NVA::no evidence of specific vertebral anomaly or failure of proper segmentation. 
::NWB::non-weight-bearing segment 
::O0::normal. 
::O1::osteopenia. 
::O2::osteoporosis. 
::O3::normal on A-P view; osteopenia on LAT view. 
::O4::osteopenia on A-P view; osteoporosis on LAT view. 
::OA1::minimal osteoarthritis with subtle or tiny marginal spur formation at the 
::OA2::mild osteoarthritis with small or tiny marginal spur formation at the 
::OA3::moderate osteoarthritis with uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OA4::advanced osteoarthritis with joint space narrowing, uneven articular surfaces, subchondral sclerosis and marginal spur formation at the 
::OAHB::osteoarthritis with mild subchondral sclerosis and marginal spur formation at the IP joints of both thumbs, and some DIP and PIP joints of both hands. 
::OAHL::osteoarthritis with mild subchondral sclerosis and marginal spur formation at the IP joint of left thumb, and some DIP and PIP joints of left hand. 
::OAHR::osteoarthritis with mild subchondral sclerosis and marginal spur formation at the IP joint of right thumb, and some DIP and PIP joints of right hand. 
::OALL::ossified anterior longitudinal ligament (OALL) at the 
::OBFX::(previous) oblique fracture(s) at the 
::OBS::on both sides. 
::OD::odd deformity of the 
::OE::with overhanging edges at the 
::OI::old insult at the 
::OLFX::old fracture(s) at the 
::OLS::on left side. 
::ONFX::old nonunited fracture(s) at the 
::ONL::focal ossification(s) of the nuchal ligament. 
::OPBU::olecranon processes of bil. ulnae. 
::OPLL::ossified posterior longitudinal ligament (OPLL) at the 
::OPLU::olecranon process of left ulna. 
::OPRU::olecranon process of right ulna. 
::ORS::on right side. 
::OSP::osteopenia of the visible bony structures. 
::OST::s/p osteotomy at the 
::PADI::posterior atlantodental interval
::PAFX::pathological fracture(s), 
::PALF::s/p port-A insertion via left femoral approach. 
::PALP::passive atelectasis of the adjacent lung parenchyma. 
::PALS::s/p port-A insertion via left subclavian approach. 
::PAOD::peripheral arterial occlusive disease, bil. lower limbs, with multifocal stenosis and total occlusion. 
::PARF::s/p port-A insertion via right femoral approach. 
::PARS::s/p port-A insertion via right subclavian approach. 
::PBB::patellar bipartite on both sides. 
::PBD::posterior bulging disc(s) at the 
::PBI::some peribronchial infiltrations at the 
::PBL::patellar bipartite on left side. 
::PBPD::posterior bulging-protruding disc(s) at the 
::PBR::patellar bipartite on right side. 
::PC::posterior calcaneus. 
::PCBD::posterior concentric bulging disc(s) at the 
::PCG::preserved colon gas. 
::PCL::"s/p PCL reconstruction with presence of the femoral and tibial tunnels, and staple fixation at the proximal tibial metaphysis. "
::PCLV::an avulsed bony fragment above the posterior tibial plateau, r/o PCL avulsion. 
::PCN::s/p percutaneous nephrostomy with pig-tail insertion 
::PCSP::prostatic calcifications over the suprapubic area. 
::PD::s/p posterior decompression and laminectomy at the 
::PD1::s/p posterior decompression, and bil. transpedicle fixation and posterolateral fusion at the 
::PD2::s/p posterior decompression, bil. transpedicle fixation and posterolateral fusion, and interbody fusion at the "
::PDOI::, probably due to old insult. 
::PDPI::, probably due to previous insult. 
::PDS::preserved disk spaces. 
::PE::periarticular erosion(s) at the 
::PED::pulmonary edema. 
::PEF::prominent epidural fat, suggestive of lipomatosis, below the L5 level. 
::PEI::peribronchial infiltrations at the 
::PEOP::prominence of the external occipital protuberance. 
::PET::peribronchial thickening at the 
::PF::s/p pin fixation 
::PHL::a phlebolith in the pelvic cavity. 
::PHL1::some phleboliths in the pelvic cavity. 
::PI::some pulmonary infiltrations at the 
::PIDS::preserved intervertebral disc space(s). 
::PIFR::increased SI on T1WI and low to dark SI on STIR at the bone marrow, suggestive of postirradiation fatty replacement, of "
::PIG::s/p pig-tail catheter insertion  
::PIHC::peribronchial infiltrations and hazy consolidation at the 
::PIP::proximal interphalangeal joint(s) 
::PKRB::s/p partial knee replacement of the medial femorotibial joint with postoperative changes on both sides. 
::PKRL::s/p partial knee replacement of the medial femorotibial joint with postoperative changes on left side. 
::PKRR::s/p partial knee replacement of the medial femorotibial joint with postoperative changes on right side. 
::PLA::prominence of the left atrial appendage. 
::PLE::pleural effusion(s) or change(s) 
::PLT::(uneven) pleural thickening at the 
::PO::partial obliteration of the 
::POC::with postoperative changes. 
::POI::, probably due to old insult. 
::POLPSA::posterior labrocapsular periosteal sleeve avulsion (POLPSA). 
::POLPSA1::stripping of the posterior labrum and capsule with separation from the posterior glenoid rim, suggestive of posterior labrocapsular periosteal sleeve avulsion (POLPSA). 
::POSP::periarticular osteopenia of the 
::POT::presence of the os trigonum. 
::PPAI::, probably due to previous avulsed injury. 
::PPC::, probably due to postoperative changes. 
::PPD::posterior protruding disc(s) at the 
::PPF::, probably due to positioning factor. 
::PPH::proximal phalanx of 
::PPI::, probably due to previous insult. 
::PR::pars interarticularis 
::PRE::No significant interval change is noted as comparison with previous study on 
::PRFX::(previous) fracture(s) at the 
::PS::However, small osseous or soft tissue lesion(s) may not be detected by the plain radiography. Advise correlate with other imaging study, if clinically indicated.
::PS5::partial sacralization of the L5 
::PSF::posterior spur formation 
::PSTS::periarticular soft tissue swelling at the 
::PT::pelvic tilting. 
::PTA::posttraumatic arthritis, 
::PTB::posterior talar beak(s) 
::PTCD::s/p PTCD with pig-tail insertion via 
::PTCL::pneumothorax with (partially) collapsed lung 
::PTI::s/p pig-tail insertion in position. 
::PTP::posterior tibial plateau. 
::PTR::posterior translation of the 
::PTRC::pretracheal-retrocaval space 
::PTS::prominence of the thymic shadow. 
::PUVB::positive ulnar variance on both sides. 
::PUVL::positive ulnar variance on left side. 
::PUVR::positive ulnar variance on right side. 
::R1MC::right 1st metacarpal 
::R1MT::right 1st metatarsal 
::R2F::right index finger. 
::R2MC::right 2nd metacarpal 
::R2MT::right 2nd metatarsal 
::R2T::right 2nd toe. 
::R3F::right middle finger. 
::R3MC::right 3rd metacarpal 
::R3MT::right 3rd metatarsal 
::R3T::right 3rd toe. 
::R4F::right ring finger. 
::R4MC::right 4th metacarpal 
::R4MT::right 4th metatarsal 
::R4T::right 4th toe. 
::R5F::right little finger. 
::R5MC::right 5th metacarpal 
::R5MT::right 5th metatarsal 
::R5T::right little toe. 
::RA::right ankle. 
::RAA::right apical area. 
::RAAS::, r/o atlantoaxial subluxation. 
::RAB::retension of antibiotic beads in position. 
::RAC::right acromioclavicular joint. 
::RACL::bony fragment(s) above the anterior tibial plateau, r/o avulsion of the anterior cruciate ligament, 
::RAIN::right anterior intercondylar notch. 
::RALF::right apical lung field. 
::RAN::, r/o avascular necrosis. 
::RAN1::a geographic subchondral lesion with sclerotic margin, r/o avascular necrosis, at the 
::RAO::, r/o accessory ossicle(s). 
::RAO1::small osseous focus (foci), r/o accessory ossicle(s) or due to previous avulsed injury, over the 
::RAP::, r/o appendicolith(s). "
::RAP1::small opaque focus (foci), r/o appendicolith(s), over the RLQ abdomen. 
::RAR::right acetabular roof. 
::RAS::syndesomophyte formation with bamboo shape spine, r/o ankylosing spondylitis. 
::RASC::abdominal distension with floating of the bowel loops, r/o ascites. 
::RBA::right basal area. 
::RBC::retension of some bone cement(s) at the 
::RBG::retension of some bony graft(s) at the 
::RBGR::right bicipital groove. 
::RBIN::amorphous intramedullary radiolucent foci of serpiginous sclerotic margins, r/o bone infarcts, at the 
::RBIS::, r/o bone island(s). "
::RBL::, r/o Bankart lesion. 
::RBLF::right basal lung field. 
::RBM::, r/o bony metastases. 
::RBP::, r/o bronchiolitis or pneumonia. 
::RBR::dilated bronchial trees with peribronchial thickening, r/o bronchiectasis, at the 
::RBT::right big toe. 
::RC::right calf. 
::RCB::right carpal bones. 
::RCBI::some geographic intramedullary lesions with serpiginous sclerotic margins, r/o chronic bone infarcts, at the "
::RCC::right calcaneocuboid joint. 
::RCCJ::right calcaneocuboid joint. 
::RCD::r/o colonic diverticula. 
::RCD1::some small opaque nodular foci, r/o colonic diverticula, at the 
::RCF::, r/o compression fracture(s). 
::RCHF::, r/o congestive heart failure. 
::RCL::, r/o cyclops lesion(s). 
::RCL1::nodular lesion(s), most likely arising from the ACL stump, at the anterior intercondylar notch, r/o cyclops lesion(s). "
::RCLN::, r/o calcified lymph node(s). 
::RCM::retension of some contrast media in the 
::RCMC::right carpometacarpal joint. 
::RCO::retension of coil(s) over the 
::RCP::r/o chronic pancreatitis. 
::RCP1::some amorphous calcified foci, r/o chronic pancreatitis, over the upper abdomen.  
::RCR::right capitellum-radial head joint. 
::RCT::, r/o calcified tendinosis. 
::RCTF::calcified nodule(s) or plaque(s) about the greater femoral trochanter, r/o calcified tendinosis, 
::RCTH::calcified nodule(s) or plaque(s) about the greater humeral tubercle, r/o calcified tendinosis, 
::RCTS::Requesting CT scan. 
::RCW::right chest wall. 
::RDC::right distal clavicle. 
::RDE::r/o dural ectasia. 
::RDFE::right distal femoral shaft. 
::RDFI::right distal fibular shaft. 
::RDHC::right distal humeral capitellum. 
::RDHS::right distal humeral shaft. 
::RDHT::right distal humeral trochlea. 
::RDN::, r/o delayed or non-union. 
::RDN1::with scanty callus formation and an irregular radiolucent gap at the fracture site, r/o delayed or non-union. "
::RDNI::, r/o deep neck infection. 
::RDRM::right distal radial metaphysis. 
::RDRS::right distal radial shaft. 
::RDRU::right distal radioulnar joint. 
::RDT::retension of drainage tube(s) in position. 
::RDTF::right distal tibiofibular syndesmosis. 
::RDTM::right distal tibial metaphysis. 
::RDTS::right distal tibial shaft. 
::RDUM::right distal ulnar metaphysis. 
::RDUS::right distal ulnar shaft. 
::RE::right elbow. 
::RED::s/p reduction of the 
::REF::This study was referred to Dr. HCY on 
::REF1::This study was referred from on duty Dr.  and Dr. HCY received the study to report on 
::REJ::right elbow joint. 
::RELN::, r/o enlarged lymph node(s). 
::REM::retension of embolic materials in the hepatic tumor(s) at the RUQ abdomen. 
::RES::right ethmoid sinus. 
::RF::right foot. 
::RFA::right forearm. 
::RFB::, r/o foreign body. 
::RFBM::, r/o focal bony metastasis. 
::RFD::r/o fibrous dysplasia. 
::RFEM::right femoral mid-shaft. 
::RFF::right fore-foot. 
::RFFX::, r/o fatigue fracture(s). 
::RFH::right femoral head. 
::RFIM::right fibular mid-shaft. 
::RFIN::right fibular neck. 
::RFIS::right femoral intertrochanteric to subtrochanteric area. 
::RFIT::right femoral intertrochanteric area. 
::RFLF::sl. decreased calcaneal pitch, r/o flat foot??, 
::RFN::right femoral neck. 
::RFNI::right femoral neck to intertrochanteric area. 
::RFS::right frontal sinus. 
::RFSC::right femoral supracondylar area. 
::RFSS::right distal femoral shaft to supracondylar area. 
::RFST::right femoral subtrochanteric area. 
::RFTJ::right femorotibial joint. 
::RG::, r/o granuloma(s). "
::RG1::calcified nodule(s), r/o granuloma(s), at the 
::RGA::, r/o gouty arthritis. "
::RGFT::right greater femoral trochanter. 
::RGH::right glenohumeral joint. 
::RGHT::right greater humeral tubercle. 
::RGPI::, r/o growth plate injury. 
::RGR::right glenoid rim. 
::RGS::some calcified shadow(s) about the RUQ of abdomen, r/o gallstones.  
::RGS1::laminated opaque shadow(s), r/o gall stone(s), at the RUQ abdomen. 
::RH::right hand. 
::RHD::right radial head. 
::RHF::right hind-foot. 
::RHH::right humeral head. 
::RHJ::right hip joint. 
::RHMS::right humeral mid-shaft. 
::RHN::right humeral neck. 
::RHSC::right humeral supracondylar area. 
::RHSL::, r/o Hill-Sachs lesion. 
::RHSS::right distal humeral shaft to supracondylar area. 
::RHT::heterogeneous SI diffusely at the marrow of visible spine, sacrum and bil. pelvic bones, most likely due to hematopoietic tissue(s). "
::RI:: r/o ileus. 
::RI1::segmental dilated small bowel loops, r/o ileus, at the 
::RIA::, r/o inflammatory arthritis. 
::RID::, r/o internal derangement(s). 
::RIFX::, r/o insufficiency fracture(s). 
::RIIA::, r/o inflammatory or infectious arthritis. 
::RILB::, r/o intraarticular loose body (bodies). 
::RILD::, r/o interstitial lung disease. 
::RINA::right inguinal area. 
::RINP::, r/o infectious or neoplastic process. 
::RIP::, r/o infectious process. 
::RIPA::right infrapatellar area. 
::RIPJ::right iliopubic junction. 
::RIPR::right inferior pubic ramus. 
::RIT::right ischial tuberosity. 
::RITF::, r/o injured triangular fibrocartilage. 
::RIW::right iliac wing. 
::RK::right knee. 
::RKFP::right Kager's fat pad. 
::RKJ::right knee joint. 
::RL::retrolisthesis of the 
::RLC::, r/o lymphangitis carcinomatosis. 
::RLCA::, r/o lung cancer. 
::RLF::right lung field. 
::RLFC::right lateral femoral condyle. 
::RLFI::right lower fibular shaft. 
::RLFS::right lower femoral shaft. 
::RLFT::right lateral femorotibial joint. 
::RLHS::right lower humeral shaft. 
::RLL::right lower leg. 
::RLLF::right lower lung field. 
::RLM::right lateral malleolus. 
::RLN::, r/o lymph node(s). 
::RLP::, r/o localized paralytic ileus. 
::RLP1::mild dilated small bowel loop(s), r/o localized paralytic ileus, at the 
::RLPF::right lateral patellofemoral joint. 
::RLQ::RLQ abdomen. 
::RLT::right lower thigh. 
::RLTC::right lateral tibial condyle. 
::RLTD::right lateral talar dome. 
::RLTS:: right lower tibial shaft. 
::RMA::right maxillary antrum. 
::RMBM::", r/o multiple bony metastases. 
::RMC::right mid-clavicle. 
::RMCJ::right mid-carpal joint. 
::RMCP::right metacarpophalangeal joint. 
::RMEC::right medial clavicle. 
::RMF::right mid-foot. 
::RMFC::right medial femoral condyle. 
::RMFT::right medial femorotibial joint. 
::RMI::s/p removal of metallic instrument 
::RML::right mid-lung zone. 
::RMLM::right medial and lateral malleoli. 
::RMM::right medial malleolus. 
::RMPM::, r/o multiple pulmonary metastases. 
::RMRI::Requesting MRI. 
::RMT::right mid-tarsal joint. 
::RMTC::right medial tibial condyle. 
::RMTD::right medial talar dome. 
::RMTP::right metatarsophalangeal joint. 
::RMTS::right medial tibial spine. 
::RNF::right neural foramen. 
::RNOF::, r/o non-ossifying fibroma. 
::RNP::, r/o neoplastic process. 
::RNS::nodular shadows at bilateral lower lung fields, r/o nipple shadow(s). 
::RNSL::a nodular shadow at left lower lung field, r/o left nipple shadow.
::RNSR::a nodular shadow at right lower lung field, r/o right nipple shadow.
::ROCD::, r/o osteochondritis dissecans. 
::ROCI::, r/o osteitis condensa ilii. 
::RON::, r/o osteonecrosis. 
::ROS::, r/o Osgood-Schlatter disease. 
::ROS1::prominence and fragmentation of the tibial tuberosity with thickening of the adjacent patellar tendon and adjacent soft tissue swelling, r/o Osgood-Schlatter disease, 
::ROTB::, r/o old pulmonary tuberculosis. 
::RP::right patella. 
::RPA::right popliteal area. 
::RPAH::relative prominence of the right hilar shadow with tapid tapering of the right descending pulmonary artery, r/o pulmonary arterial hypertension. 
::RPB::right patellar base. 
::RPCL::bony fragment(s) above the posterior tibial plateau, r/o avulsion of the posterior cruciate ligament, 
::RPE::, r/o pleural effusion(s). 
::RPE1::increased lung markings with interstitial and peribronchial thickening, and Kerley's lines on both sides, r/o pulmonary edema. 
::RPF::right patellofemoral joint. 
::RPFE::right proximal femoral shaft. 
::RPFI::right proximal fibular shaft. 
::RPFX::, r/o pathological fracture(s). 
::RPH::right proximal humerus. 
::RPHO::, r/o perforated hollow organ. 
::RPHS::right proximal humeral shaft. 
::RPI::, r/o paralytic ileus. "
::RPI1::mild dilated small bowel loop(s), r/o paralytic ileus, at the 
::RPI2::dilated small and large bowel loop(s), r/o paralytic ileus, at the 
::RPIN::right posterior intercondylar notch. 
::RPL::, r/o prosthetic loosening. 
::RPLF::right perihilar lung field. 
::RPM::retropulsion of the posterior margin(s), causing 
::RPN::, r/o pneumonia. "
::RPRU::right proximal radioulnar joint. 
::RPS::right pubic symphysis. 
::RPS1::mucosal thickening, r/o paranasal sinusitis, in the 
::RPSI::right prepatellar and superficial infrapatellar areas. 
::RPSS::right proximal radial shaft. 
::RPTA::, r/o posttraumatic arthritis. 
::RPTF::right proximal tibiofibular joint. 
::RPTM::right proximal tibial metaphysis. 
::RPTS::right proximal tibial shaft. 
::RPUS::right proximal ulnar shaft. 
::RR::(Revised Report) 
::RRA::, r/o rheumatoid arthritis. 
::RRC::right radiocarpal joint. 
::RRF::right renal fossa. 
::RRH::right radial head. 
::RRL::relative retrolisthesis of the 
::RRMS::right radial mid-shaft. 
::RRN::right radial neck. 
::RRS::right radial styloid. 
::RSA::retension of suture anchor(s) over the 
::RSAL::right sacral ala. 
::RSB::right scapular body. 
::RSC::retension of surgical clip(s) over the 
::RSCJ::right sternoclavicular joint. 
::RSCL::retension surgical clips over the left mediastinum, deviation of the trachea to the left and elevation of the left hemidiaphragm. 
::RSCP::retension of surgical clip(s) over the prepatellar, and superficial suprapatellar and infrapatellar areas. 
::RSCR::retension surgical clips over the right mediastinum, deviation of the trachea to the right and elevation of the right hemidiaphragm. 
::RSD::, r/o Scheuermann disease. 
::RSF::, r/o segond fracture. 
::RSFX::, r/o stress fracture(s). 
::RSG::right scapular glenoid. 
::RSH::right shoulder. 
::RSI::, r/o shoulder impingement. 
::RSIF::, r/o sacral insufficiency fracture. 
::RSIG::right scapular infraglenoid area. 
::RSIJ::right sacroiliac joint. 
::RSIL::, r/o sacroiliitis. 
::RSIN::, r/o sinusitis. 
::RSIP::right superior and inferior pubic rami. 
::RSLD::widening of the scapholunate joint, r/o scpholunate dissociation, 
::RSM::retension of surgical material(s) over the 
::RSN::right scapular neck. 
::RSNO::right scapular notch. 
::RSOC::, r/o solitary osteochondroma. 
::RSON::, r/o spontaneous osteonecrosis. 
::RSPN::, r/o superimposed pneumonia. 
::RSPP::right suprapatellar pouch. 
::RSPR::right superior pubic ramus. 
::RSS::, r/o spinal stenosis. 
::RST::, r/o soft tissue inflammation or infection. 
::RSTC::r/o soft-tissue calcification(s). 
::RSTI::soft tissue swelling with subcutaneous fat stranding, r/o soft tissue inflammation or infection, at the 
::RSTJ::right subtalar joint. 
::RSW::right scaphoid waist. 
::RT::right thigh. 
::RTB::, r/o pulmonary tuberculosis. 
::RTC::, r/o tarsal coalition. 
::RTH::right thumb. 
::RTMS::right tibial mid-shaft. 
::RTMT::right tarsometatarsal joint. 
::RTN::right talar neck. 
::RTNJ::right talonavicular joint. 
::RTT::right tibial tuberosity. 
::RTTJ::right tibiotalar joint. 
::RTU::	right trochlea-ulnar joint. 
::RU::, r/o urolithiasis. 
::RUF::, r/o uterine fibroid. 
::RUF1::cluster(s) of amorphous calcified foci in pelvic cavity, r/o uterine fibroid(s). 
::RULF::right upper lung field. 
::RULI::, r/o ulnolunate impingement. 
::RUMS::right ulnar mid-shaft. 
::RUPS::right ulnar prestyloid area. 
::RUQ::right upper quadrant of abdomen.
::RUR::amorphous opaque shadow(s), r/o urolithiasis, at the 
::RUS::right ulnar styloid. 
::RUT::right upper thigh. 
::RW::right wrist. 
::S5::sacralization of the L5 on both sides. 
::SA::straightened alignment of the spine. 
::SAAN::partial collapse of the femoral head with subchondral radiolucent lesion and amorphous sclerotic change, suggestive of advanced avascular necrosis, 
::SAAS::, suggestive of atlantoaxial subluxation. 
::SABL::, suggestive of aggressive bony lesion, 
::SAS::, suggestive of ankylosing spondylitis. 
::SAV::, suggestive of adenoid vegetation. 
::SAV1::prominent soft tissue, suggestive of adenoid vegetation, at the nasopharyngeal area. 
::SB::sacral body. 
::SBH::scalloping of the bil. hemidiaphragms. 
::SBI::spinal bifida at the 
::SBIS::, suggestive of bone island(s). 
::SBL::, suggestive of Bankart lesion. 
::SBR::, suggestive of bronchiectasis. 
::SBR1::dilated bronchial trees with peribronchial thickening, suggestive of bronchiectasis, at the 
::SBS::spine of bil. scapulae. 
::SBV::, suggestive of block vertebra, r/o Klippel-Feil deformity.
::SC::sacrum-coccyx. 
::SCA::subcarinal area 
::SCAL::the left lower limb about  cm in length shorter than the right lower limb. 
::SCAR::the right lower limb about  cm in length shorter than the left lower limb. 
::SCBC::a loculated cyst-like lesion in the semimembranosus bursa with a well-defined neck connecting to the posterior joint capsule, suggestive of communicating Baker cyst. 
::SCCF::with scanty callus formation 
::SCF::subchondral cyst formation 
::SCFE::, r/o slipped capital femoral epiphysis. 
::SCJ::sacrococcygeal junction. 
::SCO::scoliosis of the spine. 
::SCO1::scoliosis of the spine with upper convexity to the right and lower convexity to the left. 
::SCO2::scoliosis of the spine with upper convexity to the left and lower convexity to the right. 
::SCOL::scoliosis of the spine with main convexity to the left and apical vertebra at the 
::SCOP::scoliosis of the spine, probably due to positioning factor. 
::SCOR::scoliosis of the spine with main convexity to the right and apical vertebra at the 
::SCT::, suggestive of calcified tendinosis. "
::SD::with shortened deformity. 
::SDC::scoliosis and degenerative change of the spine with dehydrated discs at multiple levels. 
::SE::subchondral erosion(s) 
::SEFS::subcutaneous edema with fat stranding and superficial fascial edema at the 
::SEP::separation of the 
::SF::s/p screw fixation. 
::SFB::, suggestive of foreign body. 
::SFBM::, suggestive of focal bony metastasis. 
::SFO::, suggestive of focal osteolysis. 
::SFO1::periprosthetic radiolucency, suggestive of focal osteolysis, at the 
::SFPT::s/p staple fixation at the proximal tibial metaphysis. 
::SFS::with subcutaneous fat stranding 
::SGC::s/p Swan-Ganz catheterization with its tip in the right pulmonary artery. 
::SHSL::, suggestive of Hill-Sachs lesion. 
::SILD::, suggestive of interstitial lung disease. 
::SIP::, suggestive of infectious process. 
::SL::spondylolysis of the pars interarticularis at the 
::SL2::grade 0-1 spondylolisthesis of the L2 on L3 
::SL3::grade 0-1 spondylolisthesis of the L3 on L4 
::SL4::grade 0-1 spondylolisthesis of the L4 on L5 
::SL5::grade 0-1 spondylolisthesis of the L5 on S1 
::SLAC::superior labrum-anterior cuff (SLAC) lesion. 
::SLAP::superior labrum anterior-to-posterior (SLAP) lesion. 
::SLH::scalloping of the left hemidiaphragm. 
::SLI::spine of left ischium. 
::SLM::, suggestive of lung metastases. 
::SLM1::nodular lesions, suggestive of lung metastases, scattered at the 
::SLS::spine of left scapula. 
::SLS:: spine of left scapula. 
::SMBM::, suggestive of multiple bony metastases. 
::SMPM::, suggestive of multiple pulmonary metastases. 
::SMT::small or tiny 
::SNBL::, suggestive of non-aggressive bony lesion, 
::SNLN::some small nonspecific lymph nodes at the 
::SNP::, suggestive of neoplastic process. 
::SO::, suggestive of 
::SOA::secondray osteoarthritis of the 
::SOCF::with some callus formation 
::SOF1::a linear opaque shadow, suggestive of foreign body, over the prespinal area of 
::SON::intravertebral vacuum phenomenon, suggestive of osteonecrosis, at the 
::SOS::suboptimal study; 
::SOT::suboptimal study; 
::SP::symphysis pubis. 
::SPAH::relative prominence of the right hilum with rapid tappering of the right descending pulmonary artery, suggestive of pulmonary arterial hypertension. "
::SPB::suprapatellar bursa(e). 
::SPC::s/p suprapubic cystostomy in position. 
::SPE::, suggestive of pulmonary edema 
::SPFI::, suggestive of patellofemoral impingement. 
::SPFX::(previous) spiral fracture(s) at the 
::SPHO::free air, suggestive of perforated hollow organ, at the bil. subphrenic areas. 
::SPL::, suggestive of prosthesis loosening. 
::SPN::, suggestive of pneumonia. 
::SPO::spondylosis of the spine with marginal spur foramtion. 
::SPS::, suggestive of paranasal sinusitis. 
::SPTA::, suggestive of posttraumatic arthritis. 
::SRH::scalloping of the right hemidiaphragm. 
::SRI::spine of right ischium. 
::SRS::spine of right scapula. 
::SS::subchondral sclerosis 
::SSAS::, suggestive of sacroiliitis, r/o ankylosing spondylitis. 
::SSB::subacromial-subdeltoid bursae. 
::SSB1::subacromial-subdeltoid bursitis. 
::SSF::subacromial spur formation 
::SSI::, suggestive of shoulder impingement. 
::SSI1::lateral downsloped acromion with subacromial spur formation and focal traction enthesophyte formation at the greater humeral tubercle, suggestive of shoulder impingement, 
::SSIF::suboptimal study due to improper field of view. 
::SSIL::, suggestive of sacroiliitis. 
::SSIP::suboptimal study due to improper positioning. 
::SSIQ::suboptimal study due to poor imaging quality. 
::SSL::spondylolytic spondylolisthesis, 
::SSL3::grade 0-1 spondylolytic spondylolisthesis of the L3 on L4 with bony defects at the L3 pars interarticularis. 
::SSL4::grade 0-1 spondylolytic spondylolisthesis of the L4 on L5 with bony defects at the L4 pars interarticularis. 
::SSL5::grade (0-)1 spondylolytic spondylolisthesis of the L5 on S1 with bony defects at the L5 pars interarticularis. 
::SSM::with serpiginous sclerotic margin(s) 
::SSMA::suboptimal study due to some motion artifacts. 
::SSON::focal subchondral depression with subchondral sclerosis at the weight-bearing segment of medial femoral condyle, suggestive of spontaneous osteonecrosis, 
::SST::supraspinatus tendon 
::SSTI::, suggestive of soft tissue infection. 
::ST::subtle or tiny 
::STC::soft tissue calcification(s) at the 
::STD::soft tissue defect. 
::STE::soft tissue edema. 
::STF::s/p staple fixation 
::STI::s/p stent implantation over the 
::STS::soft tissue swelling at the 
::STS1::soft tissue swelling with subcutaneous fat stranding at the 
::STSG::s/p split-thickness skin graft(s) implantation at the 
::STW::s/p sternotomy with wire fixation. 
::SUB::subluxation of the 
::SUDI::subluxation-dislocation of the 
::SUT::subtle or tiny 
::SVB::squaring of the vertebral bodies at the 
::SVV::"some dilated tortuous structures, suggestive of varicose veins, at the 
::T121::T12-L1 level. 
::T12E::type 1 and 2 endplate change(s) at the 
::T13E::type 1 and 3 endplate change(s) at the 
::T1E::type 1 endplate change(s) at the 
::T1EC::type 1 endplate change(s) at the 
::T23E::type 2 and 3 endplate change(s) at the 
::T2E::type 2 endplate change(s) at the 
::T2EC::type 2 endplate change(s) at the 
::T3E::type 3 endplate change(s) at the 
::T3EC::type 3 endplate change(s) at the 
::TA::tortuous aorta. 
::TAE::s/p TAE with retension of embolic materials in the hepatic tumor(s) at the RUQ abdomen. 
::TAF::(focal) torn annulus fibrosus 
::TBG::"the tibial bone graft, measuring about  cm in length, from a -year-old male. 
::TE::traction enthesophyte formation over the 
::TECB::traction enthesophyte formation over the posterior calcaneus on both sides. 
::TECL::traction enthesophyte formation over the posterior calcaneus on left side. 
::TECR::traction enthesophyte formation over the posterior calcaneus on right side. 
::TEFB::traction enthesophyte formation over the greater femoral trochanter on both sides. 
::TEFL::traction enthesophyte formation over the greater femoral trochanter on left side. 
::TEFR::traction enthesophyte formation over the greater femoral trochanter on right side. 
::TEHB::traction enthesophyte formation over the greater humeral tubercle on both sides. 
::TEHL::traction enthesophyte formation over the greater humeral tubercle on left side. 
::TEHR::traction enthesophyte formation over the greater humeral tubercle on right side. 
::TEPB::traction enthesophyte formation over the bil. patellar bases. 
::TEPL::traction enthesophyte formation over the left patellar base. 
::TEPR::traction enthesophyte formation over the right patellar base. 
::THRB::s/p total hip replacement with postoperative changes on both sides. 
::THRL::s/p total hip replacement with postoperative changes on left side. 
::THRR::s/p total hip replacement with postoperative changes on right side. 
::THSP::thoracic spine 
::TIE::tibial intercondylar eminence. 
::TKRB::s/p total knee replacement with postoperative changes on both sides. 
::TKRL::s/p total knee replacement with postoperative changes on left side. 
::TKRR::s/p total knee replacement with postoperative changes on right side. 
::TLH::tenting of the left hemidiaphragm. 
::TLJ::thoracolumbar junction 
::TLS::thoracolumbar spondylosis with marginal spur formation at multiple levels. 
::TLS1::thoracolumbar spondylosis with disc space narrowing and marginal spur formation at multiple levels. 
::TLS2::thoracolumbar spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at multiple levels. 
::TLSP::thoracolumbar spine 
::TMF::thickening of the minor fissure. 
::TMT::tarsometatarsal joint(s) 
::TNJ::talonavicular joint(s) 
::TPB::tilting of the pelvic bone. 
::TPF::s/p transpedicle metallic fixation 
::TRA::s/p tracheostomy in position. 
::TRFX::(previous) transverse fracture(s) at the 
::TRH::tenting of the right hemidiaphragm. 
::TS::thoracic spondylosis with marginal spur formation at the 
::TS1::thoracic spondylosis with disc space narrowing and marginal spur formation at the 
::TS1M::thoracic spondylosis with disc space narrowing and marginal spur formation at multiple levels. 
::TS2::thoracic spondylosis with disc space narrowing, intradiscal vacuum phenomenon and marginal spur formation at the 
::TS2M::thoracic spondylosis with disc space narrowing, intradiscal vacuum phenomena and marginal spur formation at multiple levels. 
::TSM::thoracic spondylosis with marginal spur formation at multiple levels. 
::TSP::thoracic spine  
::TTJ::tibiotalar joint(s) 
::TV::transitional vertebra at the lumbosacral junction. 
::UAS::uneven articular surface(s) 
::UC::s/p urinary catheterization in position. 
::UCA::s/p unicompartmental arthroplasty with postoperative changes at the 
::UD::ulnar deviation of 
::UHAB::s/p unipolar hemiarthroplasty with postoperative changes at the bil. hip joints. 
::UHAL::s/p unipolar hemiarthroplasty with postoperative changes at the left hip joint. 
::UHAR::s/p unipolar hemiarthroplasty with postoperative changes at the right hip joint. 
::UIS::under the intraoperative status. 
::ULI::with ulnolunate impingement. 
::UPS::ulnar prestyloid area.
::USB::unremarkable small bowel gas pattern. 
::V1B::valgus deformity of the bil. 1st metatarsophalangeal joints. 
::V1L::valgus deformity of the left 1st metatarsophalangeal joint. 
::V1R::valgus deformity of the right 1st metatarsophalangeal joint. 
::VAL::valgus deformity of the 
::VAR::varus deformity of the 
::VB::vertebral bodies 
::VBS::visible bony structures. 
::VDT::s/p ventricular drainage tube insertion 
::VEFX::(previous) vertical fracture(s) at the 
::VH::intramedullary oval lesions of intermediate to high SI on T1WI, increased SI on T2WI and abnormal enhancement on contrast-enhanced T1WI at the "
::VISI::, r/o volar intercalated segment instability. 
::VMS::visible muscular structures. 
::VP::vacuum phenomenon(a) in the 
::VPND::vacuum phenomenon(a) in the narrowed disc space(s) at the 
::VPRB::s/p vertebroplasty with retension of bone cement(s) at the 
::VPS::s/p ventriculoperitoneal shunt insertion 
::VPSI::vacuum phenomena in the bil. sacroiliac joints. 
::VS::varying-sized 
::VSBF::varying-sized bony fragments
::VSP::visible spine. 
::WB::weight-bearing segment(s) 
::WCIV::with IV contrast enhancement shows:
::WD::wedge deformity of the 
::WDTL::wedge deformity of the vertebral bodies at the thoracolumbar junction, r/o compression fractures. 
::WEB::Please check the formal report on Web 1000. 
::WET::without evidence of tear. 
::WF::s/p wire fixation at the 
::WIAC::relative widening of the internal auditory canal 
::WSIV::without IV contrast enhancement shows:
::WWIV::without/with IV contrast enhancement shows:
::MCS::mild cervical spondylosis with tiny posterior spur formation at the 
::STOK::the soft tissue is unremarkable. 
::DCSI::degenerative change at bilateral sacroiliac joints. 
::MOSP::mild osteopenia of bony structures.
::ABFS::adjacent bony fragments 
::ACCF::advise clinical correlation and follow up. 
::PROK::no evidence of loosening, migration, or fracture of the implant.
::FOF::periprosthetic radioluceny at femoral intertrochanteric to subtroachater area, suggestive of focal osteolysis.
::FO::periprosthetic radioluceny at femoral and tibial components, suggestive of focal osteolysis.
::WFA::with fine alignment. 
::ISI::essential intact of bil. sacroiliac joints. 
::FAO::fine alignment of the 
::BARS::bilateral acetabular roofs. 
::CBPS::clear bilateral psoas shadows. 
::CFS::(previous) compression fracture(s) and wedge deformity or decrease in height of the 
::BLPS::blurring of left psoas shadow. 
::BBPS::blurring of bilateral psoas shadows. 
::BRPS::blurring of right psoas shadow. 
::DTIL::degenerative type is likely.
::NDBLS::no evidence of destructive bony lesion at the spine. 
::TSI::sugg. of thecal sac indentation and possible spinal stenosis. 
::BSCA::bilateral sharp costophrenic angles.
::PTLA::pleural thickening at left apical lung. 
::PTRA::pleural thickening at right apical lung. 
::PTBA::pleural thickening at bilateral apical lungs. 
::car::cardiomegaly. 
::BBCA::blurring of bilateral costophrenic angles.
::BRCA::blurring of right costophrenic angle.
::BLCA::blurring of left costophrenic angle.
::IIBP::increased infiltrations at bilateral perihilar areas.
::PEL::left pleural effusion. 
::PER::right pleural effusion.
::PEB::bilateral pleural effusions. 
::TAC::tortuous aorta with wall calcification. 
::IO::ill-defined opacity at 
::IIBL::increased infillatration in bilateral lower lung fields. 
::DVH::decreased vertebral height at 
::PFA::(previous) fracture(s) at 
::CPA::costophrenic angle
::PBHS::prominent bilateral hilar shadows. 
::MSS::mild spondylosis of the spine. 
::CBL::consolidation at both lung fields.
::amo::amorphous
::RO::, r/o 
::IIRP::increased infiltrations at right perihilar area. 
::IILP::increased infiltrations at left perihilar area. 
::LHA::left hilar area. 
::RHA::right hilar area.
::BHA::bilateral hilar areas. 
::IBG::increased bowel gas in the abdomen. 
::SPLM::s/p left mastectomy. 
::SPRM::s/p right mastectomy. 
::MSCO::mild scoliosis of the spine. 
::CAW::calcification of the aortic wall. 
::PNR::right pneumothorax.
::PNL::left pneumothorax.
::COPD::Hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible. 
::RD::radiopaque density 
::ca::calcification(s)
::bro::bronchiectasis
::DLV::decreased lung volumes
::SEM::subcutaneous emphysema 
::CTL::s/p left chest tube in position.
::CTR::s/p right chest tube in position. 
::CTB::s/p bilateral chest tubes in position. 
::SUS::suspicious 
::STSS::soft tissue swelling with subcutaneous fat stranding 
::PCF::(previous) comminuted fracture(s) at 
::SOP::status post laminectomy, posterior decompression, bil. transpedical screws fixation, posterolateral bony fusion, and posterior instrumentation at 
::CAST::status post external cast application; the detail of bones is obliterated by artifacts of the cast. 
::DUF::s/p intramedullary metallic fixation. (previous) transverse fracture at distal ulnar styloid process with a small bony fragment at ulnar prestyloid recess. 
::SSBI::subchondral sclerosis at bil. sacroiliac joints. 
::IEF::increased effusions in the 
::IELS::mild increased effusions in the left suprapatellar bursa. 
::IERS::mild increased effusions in the right suprapatellar bursa. 
::IIEBS::mild increased effusions in the bilateral suprapatellar bursae. 
::LSBFT::mild lateral subluxation of the bil. femorotibial joints. 
::SOF::a small osseous focus in the 
::NSPL::no evidence of spondylolisthesis. 
::ES::endplate sclerosis 
::IG::multiple injection granulomas in bilateral buttock areas. 
::MLS::mild lumbar spondylosis with tiny marginal spur formation at the 
::RET::mild retrolisthesis of the 
::DDS::decreased disc space and irregular sclerotic end-plate change at 
::ED::endplate depression at 
::VSBI::vacuum phenomenon(a) and subchondral sclerosis at bil. sacroiliac joints. 
::GGO::ground glass opacities at 
::SCL::sclerotic 
::CRL::curvilinear radiolucent line in the 
::PARJ::s/p port-A insertion via right jugular approach. 
::PALJ::s/p port-A insertion via left jugular approach. 
::SW::post-op change with multiple sternal wires fixation. 
::PHI::perihliar infiltration 
::TFCC::triangular fibrocartilage complex 
::JSNR::uneven joint space narrowing at right medial femorotibial joint, causing slightly varus deformity. 
::JSNL::uneven joint space narrowing at left medial femorotibial joint, causing slightly varus deformity. 
::JSNB::uneven joint space narrowing at bilateral medial femorotibial joint, causing slightly varus deformity on both sides. 
::JSNLL::uneven joint space narrowing at left lateral femorotibial joint, causing slightly valgus deformity.
::JSNRL::uneven joint space narrowing at right lateral femorotibial joint, causing slightly valgus deformity. 
::JSNBL::uneven joint space narrowing at bilateral lateral femorotibial joints, causing slightly valgus deformity on both sides.   
::NEAS::no evidence of abnormal signal in the spinal cord. 
::MRB::MRI of the brain without IV contrast enhancement shows: 
::MRB1::MRI of the brain without/with IV contrast enhancement shows: 
::MRN::MRI of the neck without/with IV contrast enhancement shows:
::cbpss::the bilateral paranasal sinuses are clear. 
::NDRS::no definite radiopaque stones. 
::KUB::KUB:
::DC::degenerative changes at 
::PRHS::prominent right hilar shadow. 
::PLHS::prominent left hilar shadow.
::SAB::standing abdomen:
::DA::distended abdomen. 
::FI::s/p foley insertion in position. 
::SONK::spontaneous osteonecrosis of the knee. 
::IEBS::mild increased effusions in the bil. suprapatellar bursae. 
::RLB::r/o loose bodies. 
::PA::posterior aspect of 
::RHM::mild heterogenous signal in the bone marrow, r/o hematopoietic marrow. 
::BDS::bulging disc at posterior aspect of 
::BPDS::bulging-protruding disc at posterior aspect of 
::EDS::extruding disc at posterior aspect of 
::CCCS::causing central canal stenosis 
::CCS::central canal stenosis 
::NEAS::no evidence of abnormal signal in the 
::RRRS::some calcifed nodular lesion(s) in right kidney, r/o right renal stone(s).
::RLRS::some calcifed nodular lesion(s) in left kidney, r/o left renal stone(s).
::RBRS::some calcifed nodular lesion(s) in both kidneys, r/o bilateral renal stone(s).
::RLRS::some calcifed nodular lesion(s) in left kidney, r/o left renal stone(s).
::WIV::without IV contrast enhancement shows: 
::CIR::cirrhotic pattern of liver; splenomegaly; esophageal varices with increased collateral vessels 
::SOC::some callus formation 
::WASTS::with adjacent soft tissue swelling. 
::CXR::CXR:
::LN::lymph nodes. 
::cits::causing indentation of adjacent thecal sac.
::FLR::(previous) fracture(s) at left ribs. 
::FRR::(previous) fracture(s) at right ribs.
::FBR::(previous) fracture(s) at both ribs.
::DLVB::decreased lung volumes on both sides. 
::RLRS::some calcifed nodular lesion(s) in left kidney, r/o left renal stone(s).
::RCLA::right clavicle.
::LCLA::left clavicle. 
::LDJ::s/p left double J insertion.
::RDJ::s/p right double J insertion.
::BDJ::s/p bilateral double J insertion. 
::PIF::(previoius) impacted fracture(s) at 
::PDF::(previous) displaced fracture(s) at 
::CB::calcified bursitis.