﻿﻿; Imaging methods, protocol 
getExamDesc()
{
  SetTitleMatchMode 2
  DetectHiddenText, On
  WinGetText, WinText, , T0
  FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  if FoundPos = 0 
  {
    WinGetText, WinText, , t01
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  if FoundPos = 0
  {
    WinGetText, WinText, , TH1
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  if FoundPos = 0
  {
    WinGetText, WinText, , T1
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  if FoundPos = 0
  {
    WinGetText, WinText, , T2
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }

  Date := RegExReplace(Date, "上午(.*)", "$1 am")
  Date := RegExReplace(Date, "下午(.*)", "$1 pm")
  return %Date%
}

ReportHeader(mod = "")
{
  date := getExamDesc()
  SendInput, [Exam]`n
  SendInput, Date: %date%`n
  SendInput, Modality: %mod%`n`n
  SendInput, [Image Findings]`n
}


^i::
  SetTitleMatchMode 2
  DetectHiddenText, On
  WinGetText, WinText, , T01
  FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  if FoundPos = 0
  {
    WinGetText, WinText, , t01
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  if FoundPos = 0
  {
    WinGetText, WinText, , TH1
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  if FoundPos = 0
  {
    WinGetText, WinText, , T00
    FoundPos := RegExMatch(WinText, "(\d*/\d*/\d*).*", Date)
  }
  MsgBox, %WinText%
  return

::cta0::Abdomen CT without contrast enhancement shows: 
::cta1::Abdomen CT with contrast enhancement shows: 
::cta2::Abdomen CT without/with contrast enhancement shows: 
::ctb0::Brain CT without contrast enhancement shows: 
::ctb1::Brain CT with contrast enhancement shows: 
::ctb2::Brain CT without/with contrast enhancement shows: 
::ctc0::Chest CT without contrast enhancement shows: 
::ctc1::Chest CT with contrast enhancement shows: 
::ctc2::Chest CT without/with contrast enhancement shows: 
::ctp0::Pelvis CT without contrast enhancement shows: 
::ctp1::Pelvis CT with contrast enhancement shows: 
::ctp2::Pelvis CT without/with contrast enhancement shows: 
::ctap0::Abdomen & Pelvis CT without contrast enhancement shows: 
::ctap1::Abdomen & Pelvis CT with contrast enhancement shows: 
::ctap2::Abdomen & Pelvis CT without/with contrast enhancement shows: 
::ctcap0::Chest, Abdomen & Pelvis CT without contrast enhancement shows: 
::ctcap1::Chest, Abdomen & Pelvis CT with contrast enhancement shows: 
::ctcap2::Chest, Abdomen & Pelvis CT without/with contrast enhancement shows: 
::mra0::Abdomen MRI without contrast enhancement shows: 
::mra1::Abdomen MRI with contrast enhancement shows: 
::mra2::Abdomen MRI without/with contrast enhancement shows: 
::mrp0::Pelvis MRI without contrast enhancement shows: 
::mrp1::Pelvis MRI with contrast enhancement shows: 
::mrp2::Pelvis MRI without/with contrast enhancement shows: 
::mrap0::Abdomen & Pelvis MRI without contrast enhancement shows: 
::mrap1::Abdomen & Pelvis MRI with contrast enhancement shows: 
::mrap2::Abdomen & Pelvis MRI without/with contrast enhancement shows: 
::mrb0::Brain MRI without contrast enhancement shows: 
::mrb1::Brain MRI with contrast enhancement shows: 
::mrb2::Brain MRI without/with contrast enhancement shows: 
::mrlsp::MRI of lumbar spine without contrast enhancement shows: 
::mrlsp2::MRI of lumbar spine without/with contrast enhancement shows: 
::mrtsp::MRI of thoracic spine without contrast enhancement shows: 
::mrtsp2::MRI of thoracic spine without/with contrast enhancement shows: 
::mrcsp::MRI of cervical spine without contrast enhancement shows: 
::mrcsp2::MRI of cervical spine without/with contrast enhancement shows: 


:c1:ct0::CT of   without contrast enhancement shows:{left 37}
:c1:ct1::CT of   with contrast enhancement shows:{left 34}
:c1:ct2::CT of   without/with contrast enhancement shows:{left 46}
:c1:mr0::MRI of   without contrast enhancement shows:{left 37}
:c1:mr1::MRI of   with contrast enhancement shows:{left 34}
:c1:mr2::MRI of   without/with contrast enhancement shows:{left 46}
:c1:cth0::Head CT without contrast enhancement shows:
:c1:cth1::Head CT with contrast enhancement shows:
:c1:cth2::Head CT without/with contrast enhancement shows:
:c1:mrh0::Head MRI without contrast enhancement shows:
:c1:mrh1::Head MRI with contrast enhancement shows:
:c1:mrh2::Head MRI without/with contrast enhancement shows:
:c1:ctn0::Neck CT without contrast enhancement shows:
:c1:ctn1::Neck CT with contrast enhancement shows:
:c1:ctn2::Neck CT without/with contrast enhancement shows:
:c1:mrn0::Neck MRI without contrast enhancement shows:
:c1:mrn1::Neck MRI with contrast enhancement shows:
:c1:mrn2::Neck MRI without/with contrast enhancement shows:
:c1:cthn0::Head & Neck CT without contrast enhancement shows:
:c1:cthn1::Head & Neck CT with contrast enhancement shows:
:c1:cthn2::Head & Neck CT without/with contrast enhancement shows:
:c1:mrhn0::Head & Neck MRI without contrast enhancement shows:
:c1:mrhn1::Head & Neck MRI with contrast enhancement shows:
:c1:mrhn2::Head & Neck MRI without/with contrast enhancement shows:
:c1:ctc0::Chest CT without contrast enhancement shows:
:c1:ctc1::Chest CT with contrast enhancement shows:
:c1:ctc2::Chest CT without/with contrast enhancement shows:
;:c1:cta0::Abdomen CT without contrast enhancement
;:c1:cta1::Abdomen CT with contrast enhancement
;:c1:cta2::Abdomen CT without/with contrast enhancement
;:c1:mra0::Abdomen MRI without contrast enhancement
;:c1:mra1::Abdomen MRI with contrast enhancement
;:c1:mra2::Abdomen MRI without/with contrast enhancement
;:c1:ctp0::Pelvis CT without contrast enhancement
;:c1:ctp1::Pelvis CT with contrast enhancement
;:c1:ctp2::Pelvis CT without/with contrast enhancement
;:c1:mrp0::Pelvis MRI without contrast enhancement
;:c1:mrp1::Pelvis MRI with contrast enhancement
;:c1:mrp2::Pelvis MRI without/with contrast enhancement
;:c1:ctap0::Abdomen & Pelvis CT without contrast enhancement
;:c1:ctap1::Abdomen & Pelvis CT with contrast enhancement
;:c1:ctap2::Abdomen & Pelvis CT without/with contrast enhancement
;:c1:mrap0::Abdomen & Pelvis MRI without contrast enhancement
;:c1:mrap1::Abdomen & Pelvis MRI with contrast enhancement
;:c1:mrap2::Abdomen & Pelvis MRI without/with contrast enhancement
;:c1:ctca0::Chest and abdomen CT without contrast enhancement
;:c1:ctca1::Chest and abdomen CT with contrast enhancement
;:c1:ctca2::Chest and abdomen CT without/with contrast enhancement
:c1:ctcap0::Chest, abdomen and pelvis CT without contrast enhancement
:c1:ctcap1::Chest, abdomen and pelvis CT with contrast enhancement
:c1:ctcap2::Chest, abdomen and pelvis CT without/with contrast enhancement
:c1:mrcsp::MRI of cervical spine without contrast enhancement shows:
:c1:mrcsp2::MRI of cervical spine without/with contrast enhancement shows:
:c1:mrlsp::MRI of lumbar spine without contrast enhancement shows:
:c1:mrlsp2::MRI of lumbar spine without/with contrast enhancement shows:
:c1:mrtsp::MRI of thoracic spine without contrast enhancement shows:
:c1:mrtsp2::MRI of thoracic spine without/with contrast enhancement shows:
:c1:k::KUB shows
;:c1:ak::Abdomen/KUB shows
::bce::without and with contrast enhancement shows
::cce::with contrast enhancement shows
::wce::without contrast enhancement shows
::&::and
:c:NECT::NECT
:c:CECT::CECT
::nect::nonenhanced CT
::cect::enhanced CT
;::hn::head/neck
::hn::hydronephrosis
::hnn::head and neck

; hemorrhage
:c:ICH::ICH
:c:EDH::EDH
:c:SDE::SDE
:c:SDH::SDH
:c:SAH::SAH
:c:IVH::IVH
;::ich::intracerebral hematoma
::ich::parenchymal hematoma
::edh::epidural hematoma
::sde::subdural effusion
::sdh::subdural hematoma
::sah::subarachnoid hemorrhage
::ivh::intraventricular hematoma
::h0::{HOME}- no obvious intracranial hemorrhage, midline shift, or mass effect.
::hema::hematoma
::heman::hemangioma
::hm::hemangioma
::hms::hemangiomas
::hemo::hemorrhage
::gw0::{HOME}- preserved normal gray-white differentiation.
::gwd::gray-white differentiation
::gw::gray-white
::gwm::gray-white matter

; organs
::ao::aorta
::aor::aortic
::l::left
::r::right
::lsi::left-sided
::rsi::right-sided
::ll::left lung
::rl::right lung
::lg::lung
::llo::left lobe
::rlo::right lobe
::llf::left lung field
::rlf::right lung field
::blf::bilateral lung fields
::llb::left lung base
::rlb::right lung base
::blb::bilateral lung bases
::lb::lung base
::lbs::lung bases
::lbl::left basal lung
::rbl::right basal lung
::bbl::both basal lungs
::lk::left kidney
::rk::right kidney
::ki::kidney
::kd::kidney
::lku::upper pole of left kidney
::lkm::interpolar left kidney
::lkl::lower pole of left kidney
::rku::upper pole of right kidney
::rkm::interpolar right kidney
::rkl::lower pole of right kidney
::lr::left renal
::rr::right renal
::kp::renal pelvis
::lrp::left renal pelvis
::rrp::right renal pelvis
::lkp::left renal pelvis
::rkp::right renal pelvis
::bkp::bilateral renal pelvis
::brp::bilateral renal pelvis
::bk::both kidneys
::lkn::left knee
::rkn::right knee
::bkn::both knees
::lu::left ureter
::ru::right ureter
::ldu::left distal ureter
::lpu::left proximal ureter
::rdu::right distal ureter
::rpu::right proximal ureter
::bu::both ureters
::bl::both lungs
::blo::both lobes
::rt::right thalamus
::lt::left thalamus
::bt::both thalami
::rh::right hemithorax
::lh::left hemithorax
::hth::hemithorax
::bth::bilateral hemithorax
::lth::left hemithorax
::rth::right hemithorax
::brth::right basal hemirhotrax
::blth::left basal hemirhotrax
::ht::hemithorax
::pv::portal vein
::pvs::portal veins
::ppv::patent portal veins
::pve::periventricular
::pvp::portal venous phase
::pvw::portal venous phase washout
::rua::right upper abdomen
::ruq::right upper quadrant
:c:RUL::RUL
:c:RML::RML
:c:RLL::RLL
:c:LUL::LUL
:c:LLL::LLL
::rul::right upper lobe
::rml::right middle lobe
::rll::right lower lobe
::lul::left upper lobe
::lll::left lower lobe
::lml::lingular lobe
::bml::lingular and right middle lobe
::bll::bilateral lower lobes
::bul::bilateral upper lobes.
::rulz::right upper lung zone 
::lulz::left upper lung zone 
;::rmlz::right middle lung zone
::lmlz::left middle lung zone 
::rllz::right lower lung zone 
::lllz::left lower lung zone
::lln::left lower neck
::rln::right lower neck

::ha::hepatic artery
::hv::hepatic vein
:c:IHD::IHD
:c:IHDs::IHDs
:c:CBD::CBD
::ihd::intrahepatic duct
::ihds::intrahepatic ducts
::cbd::common bile duct
::cbds::common bile duct stone
::chd::common hepatic duct
::lv::liver
::lvd::liver dome
::rlv::right lobe liver
::llv::left lobe liver
::blv::both hepatic lobes
;::lv::lateral ventricle
;::rlv::right lateral ventricle
;::llv::left lateral ventricle
::llv::low lung volumes
::4v::4th ventricle
::3v::3rd ventricle
::blv::both lateral ventricles
::icap::internal capsule
::ecap::external capsule
::scap::striatocapsular
::tcap::thalamocapsular
::scaps::bilateral striatocapsular areas
::occ::occipital
::socc::suboccipital
::par::parietal
::pan::pancreatic
::pans::pancreas
::ps::pancreas
::pro::prostate
::pfc::Tiny punctate calcification foci in pelvic floor, R/O prostate calcification.
::fro::frontal
::tem::temporal
::stem::subtemporal
::frotem::frototemporal
::fropar::frontoparietal
::ton::tonsillar
:c:ACL::ACL
:c:PCL::PCL
:c:LCL::LCL
:c:MCL::MCL
:c:FCL::FCL
:c:VA::VA
:c:BA::BA
:c:PCA::PCA
:c:ACA::ACA
:c:MCA::MCA
:c:ACOM::ACOM
:c:PCOM::PCOM
:c:CCA::CCA
:c:ICA::ICA
:c:ECA::ECA
:c:SCA::SCA
:c:PICA::PICA
:c:AICA::AICA
::acl::anterior cruciate ligament
::pcl::posterior cruciate ligament
::lcl::lateral collateral ligament
::mcl::medial collateral ligament
::fcl::fibular collateral ligament
::va::vertebral artery
::ba::basilar artery
::pca::posterior cerebral artery
::aca::anterior cerebral artery
::mca::middle cerebral artery
::acom::anterior communicating artery
::pcom::posterior communicating artery
::cca::common carotid artery
::ica::internal carotid artery
::eca::external carotid artery
::sca::superior cerebellar artery
::pica::posterior inferior cerebellar artery
::aica::anterior inferior cerebellar artery
::ijc::internal jugular chain
::ij::internal jugular
::ijv::internal jugular vein
::ejv::external jugular vein
::cia::common iliac artery
::eia::external iliac artery
::iia::internal iliac artery
::civ::common iliac vein
::eiv::external iliac vein
::iiv::internal iliac vein
::cic::common iliac chain
::eic::external iliac chain
::iic::internal iliac chain
::ila::iliac artery
::ilb::iliab bone
::ilv::iliac vein
::ilc::iliac chain
::fea::femoral artery
::scm::sternocleidomastoid
:c:SCM::SCM
::cc::corpus callosum
:c:SMA::SMA
:c:SMV::SMV
:c:IMA::IMA
:c:IMV::IMV
::sma::superior mesenteric artery
::smv::superior mesenteric vein
::smvv::superior mesenteric vessels
::ima::inferior mesenteric artery
::imv::inferior mesenteric vein
::cr::corona radiata
::cs::centrum semiovale
::gp::globus pallidus
::gps::globi pallidi
::len::lentiform
::nu::nucleus
::nus::nuclei
::lum::lumbar
;::sac::sacral
::cer::cervical
::tho::thoracic
::tha::thalamus
::thi::thalami
:c:GB::GB
::gb::gallbladder
::gbp::gallbladder polyp
::gbps::gallbladder polyps
::gbf::gallbladder fundus
::gbn::gallbladder neck
::gbb::gallbladder body
::gbs::gallbladder sludge
::gst::gallstone
::gsts::gallstones
::ub::urinary bladder
::ub0::{HOME}- Distended urinary bladder with smooth walls.
::ub1::{HOME}- Inadequately distended urinary bladder with thickened walls.
::thy::thyroid
::jv::jugular vein
:c:IVC::IVC
:c:SVC::SVC
::ivc::inferior vena cava
::svc::superior vena cava
::i1::cervical internal carotid artery segment
::i2::petrous internal carotid artery segment
::i3::lacerum internal carotid artery segment
::i4::cavernous internal carotid artery segment
::i5::clinoid internal carotid artery segment
::i6::ophthalmic internal carotid artery segment
::i7::communicating internal carotid artery segment
::v1::extraosseous vertebral artery segment
::v2::foraminal vertebral artery segment
::v3::extraspinal vertebral artery segment
::v4::intradural vertebral artery segment
::a1::horizontal anterior cerebral artery segment
::a2::vertical anterior cerebral artery segment
::a3::pericallosal artery segment
::m1::horizontal middle cerebral artery segment
::m2::insular middle cerebral artery segment
::m3::opercular middle cerebral artery segment
::m4::cortial middle cerebral artery segment
::p1::precommunicating posterior cerebral artery segment
::p2::ambient posterior cerebral artery segment
::p3::quadrigerminal posterior cerebral artery segment
::p4::cortical posterior cerebral artery segment
::l12::L1-2
::l23::L2-3
::l34::L3-4
::l45::L4-5
::l51::L5-S1
::c12::C1-2
::c23::C2-3
::c34::C3-4
::c45::C4-5
::c56::C5-6
::c67::C6-7
::c71::C7-T1
::t121::T12-L1
::c1::C1
::c2::C2
::c3::C3
::c4::C4
::c5::C5
::c6::C6
::c7::C7
::t1::T1
::t2::T2
::t3::T3
::t4::T4
::t5::T5
::t6::T6
::t7::T7
::t8::T8
::t9::T9
::t10::T10
::t11::T11
::t12::T12
::l1::L1
::l2::L2
::l3::L3
::l4::L4
::l5::L5
::s1::S1
::s2::S2
::s3::S3
::s4::S4
::s4a::S4a
::s4b::S4b
::s5::S5
::s6::S6
::s7::S7
::s8::S8
::s23::S2/3
::s24::S2/4
::s34::S3/4
::s45::S4/5
::s48::S4/8
::s56::S5/6
::s67::S6/7
::s78::S7/8
::s58::S5/8
::g1::grade 1
::g2::grade 2
::g3::grade 3
::g4::grade 4
::g5::grade 5
::ac::ascending colon
::tc::transverse colon
::dc::descending colon
::1f::thumb
::2f::index finger
::3f::middle finger
::4f::ring finger
::5f::little finger
::dph::distal phalanx
::mph::middle phalanx
::pph::proximal phalanx
:c:SSS::SSS
::sss::superior sagittal sinus
::iss::is shown
::iss::inferior sagittal sinus
::csp::cervical spine
::lcsp::lower cervical spine
::lsp::lumbar spine
::llsp::lower lumbar spine
::tsp::thoracic spine
::tlsp::thoracolumbar spine
::tlj::thoracolumbar junction
::lssp::lumbosacral spine
::ssp::sacral spine
::npx::nasopharynx
::opx::oropharynx
::hpx::hypopharynx
::phx::pharynx
::lax::larynx
::lal::laryngeal
::npl::nasopharyngeal
::opl::oropharyngeal
;::hpl::hypopharyngeal
::rpl::retropharyngeal
::rpx::retropharynx
;::pp::parapharyngeal
::pp::placement
::ppl::parapharyngeal
::pms::pharyngeal mucosal space
::npms::nasopharyngeal mucosal space
::opms::oropharyngeal mucosal space
::hpms::hypopharyngeal mucosal space
::eth::ethmoid
::max::maxillary
::maxi::maxillary
::sph::sphenoid
::mas::mastoid
::pha::pharynx
:c:LAR::LAR
::lar::lower anterior resection
::au::auditory
::oss::ossicles
::os::ossicle
::spl::splenic
::spn::spleen
::acf::anterior cranial fossa
::mcf::middle cranial fossa
::pcf::posterior cranial fossa

::cn1::olfactory nerve
::cn2::optic nerve
::cn3::oculomotor nerve
::cn4::trochlear nerve
::cn5::trigeminal nerve
::cn51::ophthalmic nerve
::cn52::maxillary nerve
::cn53::mandibular nerve
::cn6::abducens nerve
::cn7::facial nerve
::cn8::vestibulocochlear nerve
::cn9::glossopharyngeal nrve
::cn10::vagus nerve
::cnx::vagus nerve
::cn11::accessory nerve
::cn12::hypoglossal nerve


; geometry
::ltr::local tumor recurrence
::ltr::left-to-right
::rtl::right-to-left
::ant::anterior
::lat::lateral
::med::medial
::pos::posterior
::sup::superior
::inf::inferior
::ax::axial
::cor::coronary
::cor::coronal
::ilat::ipsilateral
::clat::contralateral
::sag::sagittal
::psag::parasagittal
::psg::parasagittal
::alat::anterolateral
::amed::anteromedial
::asup::anterosuperior
::plat::posterolateral
::pmed::posteromedial
::psup::posterosuperior
;::ainf::anteroinferior
::pinf::posteroinferior

::1/3::proximal-third
::2/3::mid-third
::3/3::distal-third
::1st::first
::1mary::primary
::2nd::second
::2ndary::secondary
::2to::secondary to
::3rd::third
::4th::fourth
::5th::fifth
::6th::sixth
::7th::seventh
::8th::eighth
::9th::ninth
::10th::tenth
::11th::eleventh
::12th::twelfth


; vessels
::rha::right hepatic artery
::lha::left hepatic artery
::ipa::inferior phrenic artery
::pha::proper hepatic artery
::cha::common hepatic artery
::gda::gastroduodenal artery
::gea::gastroepiploic artery
::pda::pancreaticoduodenal artery
::ipda::inferior pancreaticoduodenal artery
::spda::superior pancreaticoduodenal artery


; disease
::pd::progressive disease
::dp::drain placement
::dp::disease progression
::dpro::disease progression
;::sd::stable disease
;::pr::partial response
::cr::complete remission

::aa::arteries
::aal::arterial
:c:AAA::AAA
::aaa::abdominal aortic aneurysm
::abs::abscess
::acj::acromioclavicular joint
::acs::accessory spleen
::sn::spleen
::ad::adrenal
::ads::adrenals
::adr::adrenal
::adn::adnexa
::al::alignment
::ali::alignment
::ane::aneurysm
::aneu::aneurysm
::anu::aneurysm
;::app::appearance
::app::arterial and portal venous phases
::ar::artery
::arr::arteries
::arp::arterial phase
::aas::arteries
:c:V::V
::v::vein
::vv::veins
::ab::abdomen
::abl::left abdomen
::abr::right abdomen
::abb::bilateral abdomen
::abc::air bronchogram
::abc::central abdomen
::abd::abdominal
;::a0::{HOME}- Imaged liver, gallbladder, spleen, pancreas and adrenals within normal limit.
::a0::{HOME}- Unremarkable imaged liver, spleen, pancreas, gallbladder and adrenals.
::a00::
SendInput, {HOME}
(
- Liver: Normal. `
- Gallbladder and biliary system: Normal. `
- Spleen: Normal. `
- Pancreas: Normal. `
- Kidneys: No evidence of obstructive uropathy. `
- Adrenal glands: Normal. `
- GI tract: No evidence of bowel obstruction. `
- Peritoneum/retroperitoneum: Normal. `
- Others: Normal. `
)

;- Unremarkable imaged liver, spleen, pancreas, gallbladder and adrenals.
;- No evidence of obstructive uropathy.
;- No definite abnormally enlarged lymphadenopathy.
;- No ascites.

return
::a00l::
SendInput, {HOME}
(
- Unremarkable imaged spleen, pancreas, gallbladder and adrenals.
- No evidence of obstructive uropathy.
- No definite abnormally enlarged lymphadenopathy.
- No ascites.
)
return
::a00ls::
SendInput, {HOME}
(
- Unremarkable imaged pancreas, gallbladder and adrenals.
- No evidence of obstructive uropathy.
- No definite abnormally enlarged lymphadenopathy.
- No ascites.
)
return
::ap00::
SendInput, {HOME}
(
- Liver: Normal. `
- Gallbladder and biliary system: Normal. `
- Spleen: Normal. `
- Pancreas: Normal. `
- Kidneys: No evidence of obstructive uropathy. `
- Adrenal glands: Normal. `
- GI tract: No evidence of bowel obstruction. `
- Peritoneum/retroperitoneum: Normal. `
- Pelvic structures: Normal. `
- Others: Normal. `
)
;- Unremarkable imaged liver, spleen, pancreas, gallbladder and adrenals.
;- No evidence of obstructive uropathy.
;- No definite abnormally enlarged lymphadenopathy.
;- No ascites.
;- No free fluid or abnormally enlarged lymph nodes in the pelvis.
return

::p00::
SendInput, {HOME}
(
- Visualized urinary system: No evidence of obstructive uropathy. `
- GI tract: No evidence of bowel obstruction. `
- Peritoneum/retroperitoneum: Normal. `
- Pelvic structures: Normal. `
- Others: Normal. `
)
return

::a0l::{HOME}- Unremarkable imaged spleen, pancreas, gallbladder and adrenals.
::a0ls::{HOME}- Unremarkable imaged pancreas, gallbladder and adrenals.
::a0s::{HOME}- Unremarkable imaged liver, pancreas, gallbladder and adrenals.
::a0p::{HOME}- Unremarkable imaged liver, spleen, gallbladder and adrenals.
::a0g::{HOME}- Unremarkable imaged liver, spleen, pancreas and adrenals.
::a0a::{HOME}- Unremarkable imaged liver, spleen, pancreas and gallbladder.
::as0::{HOME}- No ascites.
::bi0::{HOME}- No obvious dilatation of biliary system.
::acn::air-containing
::adv::advanced
::adm::adenomyomatosis
::adh::adhesion
::ak::aortic knob
:c:AML::AML
::aml::angiomyolipoma
::ana::anastomosis
::anl::AP and lateral
::pnl::PA and lateral
::aoc::an atherosclerotic partially calcified aorta
::aod::aortic dissection
::aot::tortuous aorta
::aota::atherosclerotic change of the tortuous aorta
::aotc::a tortuous atherosclerotic partially calcified aorta
;::aps::air-fluid levels with bubbly appearing secretions as "foam on the water" appearacnce, consistent with acute rhinosinusitis.
::aps::arterioportal shunt
::apss::arterioportal shunts
::ara::arachnoid
::art::artifact
::aic::atherosclerotic calcification change of intracranial vessels
::ath::atherosclerotic change
::asc::ascending
::asi::ascites
;::asis::anterosuperior iliac spine
::aso::airspace opacity
::asoo::airspace opacities
::asy::asymmetry
::asym::asymmetric
:c:AVM::AVM
::avm::arteriovenous malformation
:c:AVF::AVF
:c:dAVF::dAVF
::avf::arteriovenous fistula
::davf::dural arteriovenous fistula
::sy::symmetry
::sym::symmetric

; herniation
::her::herniation
::hern::herniation
::th::transtentorial herniation
::sfh::subfalcine herniation
::vh::ventral herniation
::dth::descending transtentorial herniation


:c1:ap0::Chest AP shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear
::bapt::Bilateral apical pleural thickening.
::lapt::Apical pleural thickening on the left.
::rapt::Apical pleural thickening on the right.
::apt::apical pleural thickening

::str::straightened curve
;::str::straightening of the normal lordotic curve
; with no ligamentous instability or malalignment of the vertebrae. 

; infarct
::ainf::parenchymal hypodensity with loss of gray-white matter distinction, gyral swelling and sulcal effacement
::sinf::wedge-shaped area of decreased attenuation involving gray/white matter
::oinf::focal, well-delineated low-attenuation areas with prominent adjacent sulci and enlarged ipsilateral ventricle
::ain::acute infarction
::sin::subacute infarction
::cin::chronic infarction

::abn::abnormal
::abnn::abnormality
::abny::abnormally
::acc::accumulation
::ace::acetabulum
::ach::atrophic change
::adc::ADC
::ade::adequate
::adely::adequately
::adj::adjacent
::adr::adrenal
::aef::aryepiglottic fold
::af0::{HOME}- no obvious free air or fluid.
::afl::air-fluid level
::afls::air-fluid levels
::alv::alveolar
::avl::alveolar
::avi::alveolar infiltrate
::am::amount
::amo::amorphous
::ank::ankylosing
::ano::another
::anp::abdominal and pelvic
::aop::abdominal or pelvic
::aov::Ampulla of Vater
::apl::appendiceal
::apn::acute pyelonephritis
::apx::appendix
::apy::Antegrade pyelography shows 
::asa::as stated above
::asdo::ASD occluder
::ash::air-space shadows
::asis::atelectasis
::asp::aspect
::ass::associated
::asvd::atherosclerotic vascular disease
::ate::atelectasis
::atep::subpleural atelectasis
::atis::appendicitis
::att::attenuation
::av::anteverted
::avd::{HOME}- Focal low attenuation adjacent to the falciform ligament in left lobe liver during portal venous phase, R/O perfusion abnormalities related to aberrant venous drainage with poor portal venous inflow.
::avn::avascular necrosis
::aw::abdominal wall
::axi::axillary

::bate::basal atelectasis
::epn::emphysematous pyelonephritis
::fa0::{HOME}- no obvious free air or fluid.
::ffl::fluid-fluid level
::ffls::fluid-fluid levels
::iad::inadequate
::inade::inadequate
::papl::periappendiceal
::pate::subpleural atelectasis
::rv::retroverted
::sam::small amount
::sasis::subsegmental atelectasis
::xpn::xanthogranulomatous pyelonephritis
:c:APN::APN
:c:AVN::AVN
:c:EPN::EPN

::favn::
SendInput serpiginous line of low signal surrounding an area of fatty marrow in the femoral head
MsgBox Ficat scale`nstage 0: no evidence of AVN`nstage 1: early disease only detectable on MRI`nstage 2: sclerotic and cystic changes in the femoral head`nstage 3: areas of flattening of the femoral head`nstage 4: collapse of the femoral head and changes in the joint architecture
return



::b::bilateral
::b::brain
::b0::bone structures are anatomic in alignment. No obvious fracture or dislocation
::b1::Billroth I anastomosis
::b2::Billroth II anastomosis
::baa::{HOME}- Enlarged ventricles and widened cortical sulci.
::ba1::{HOME}- Mild cortical atrophy with opening of sulci (GCA 1).
::ba2::{HOME}- Moderate cortical atrophy with volume loss of gyri (GCA 2).
::ba3::{HOME}- Severe cortical atrophy with 'knife blade' appearance of gyri (GCA 3).
::baalct::{HOME}- Enlarged ventricles and widened cortical sulci.`n- focal/confluent periventricular hypodensities.
::bamlct::{HOME}- Mildly enlarged ventricles and widened cortical sulci.`n- focal/confluent periventricular hypodensities.
::bam::{HOME}- Mildly enlarged ventricles and widened cortical sulci.
::ba::basilar artery
::baker::{HOME}- A cystic lesion with communicating channel between the semimebranosus muscle and the medial head of the gastrocnemius muscle, suggesting Baker's cyst.
::bat::brain atrophy
::bb::broad-based
::bbb::blood-brain barrier
::bc::Bilateral costophrenic angle blunting.
::bcr::Right costophrenic angle blunting.
::bcl::Left costophrenic angle blunting.
::rbc::Right costophrenic angle blunting.
::lbc::Left costophrenic angle blunting.

::cb::Bilateral costophrenic angle blurring.
::cbr::Right costophrenic angle blurring.
::cbl::Left costophrenic angle blurring.
::rcb::Right costophrenic angle blurring.
::lcb::Left costophrenic angle blurring.

::bc::brain contussion
::hbc::hemorrhagic brain contussion
::bcp::blunt costophrenic angle
::bcpb::blunt costophrenic angles bilaterally
::bcpl::blunt costophrenic angle on the left
::bcpr::blunt costophrenic angle on the right
::coa::costophrenic angle
::cdr::costodiaphragmatic recess
; ::bd::circumferential disc bulging with encroachment upon the central spinal canal without spinal cord impingement
::bd::disc bulging
::bis::bone island
::bi::biliary
::pbi::pneumobilia
::bpd::disc bulging-protruding
::bdas::asymmetrical bulging annulus
::bds::symmetrical bulging annulus
;::bdfa::severe central canal stenosis due to diffuse disc bulging, hypertrophic facet arthropathy and ligamentous thickening combining to compress the thecal sac.
::bdfa::disc bulging and facet arthropathy
::bf::disc bulging and facet arthropathy
::bdlf::disc bulging and ligamentous thickening
::falf::facet arthropathy and ligamentous thickening
::bdfalf::disc bulging, facet arthropathy and ligamentous thickening
::bgp::bowel gas pattern
::ibg::increased bowel gas
::bfl::disc bulging, facet arthropathy and ligamentous thickening
::bet::between
::bif::bifurcation
::ble::brain lesion
::bles::brain lesions
::blr::blurring
::blt::blunting
::broncho::bronchoscopy
::sc1::mild canal stenosis
::sc2::moderate canal stenosis
::sc3::severe canal stenosis
::scs1::mild canal stenosis
::scs2::moderate canal stenosis
::scs3::severe canal stenosis
::sfs::canal/foraminal stenosis
::lfs::lateral canal/foraminal stenosis
::sfs1::mild canal/foraminal stenosis
::sfs2::moderate canal/foraminal stenosis
::sfs3::severe canal/foraminal stenosis
::ccs::central canal stenosis
::lcs::lateral canal stenosis
::lcfs::lateral canal and foraminal stenosis
::bezoarct::a mass with a mottled appearance of multiple air bubbles, fluid, and debris scattered throughout
::ben::benign
::bg::bowel gas
::sbg::small bowel gas
::bg::basal ganglion
::bgg::basal ganglia 
::bgh::{HOME}- hyperintense SI over bilateral basal ganglia on T1WI, suggesting possible chronic hepatic insufficiency. Possible chronic hepatic insufficiency.
::bh::borderline heart size
::bh::burr hole
::bhs::burr holes
::bhz::borderline heart size 
::hz::heart size
::bha::beam hardening artifact
;::bhc::borderline heart size with wall calcification of the aorta	
::bht::borderline heart size with tortuous aorta 
::bhtc::borderline heart size with wall calcification of the tortuous aorta 
::bil::bilateral 
::bily::bilaterally
::bllz::bilateral lower lung zones
::blz::bilateral lower lung zones
::bbz::bilateral basal lung zones
::bk0::{HOME}- No evidence of obstructive uropathy.
::bk1::{HOME}- No evidence of obstructive uropathy. Bilateral renal cysts.
::bk1r::{HOME}- No evidence of obstructive uropathy. Right renal cysts.
::bk1l::{HOME}- No evidence of obstructive uropathy. Left renal cysts.
::bk2::{HOME}- No evidence of obstructive uropathy. Bilateral renal stones.
::bk2r::{HOME}- No evidence of obstructive uropathy. Right renal stones.
::bk2l::{HOME}- No evidence of obstructive uropathy. Left renal stones.
::bk3::{HOME}- No evidence of obstructive uropathy. Bilateral renal stones and cysts.
::bk3r::{HOME}- No evidence of obstructive uropathy. Right renal stones and cysts.
::bk3l::{HOME}- No evidence of obstructive uropathy. Left renal stones and cysts.
::bm0::{HOME}- no definite abnormal marrow signal change in imaged bone structures.
::bm::bone marrow
::bme::bone marrow edema
::bmets::bone metastasis
::bmets::osteolytic destructive bone lesions
::bmts::bone metastasis
::bmz::bilateral middle lung zones
::bn::brain
::bp::brain parenchyma
::bpl::brain parenchymal
::BPH::BPH
::bph::enlarged prostate
::bsis::bronchiectasis
::bs::brain stem
::bst::bone structures
::bsw::brain swelling
::bso::bilateral salpingo-oophorectomy
::rso::right salpingo-oophorectomy
::lso::left salpingo-oophorectomy
::bti::biliary tract infection
::so::salpingo-oophorectomy
::hys::hysterectomy
;::mas::mastectomy
::bulz::bilateral upper lung zones
::bw::bladder wall
::bx::biopsy


::c::with
::c/s::Cesarean section
;::c0::normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear
::e0::{HOME}- no definite abnormal density change in brain parenchyma.`n- preserved normal gray-white differentiation.
::co0::{HOME}- no definite abnormal signal intensity change in imaged cord.
::cath::catheter
::cau::caudate
::dcath::drainage catheter
::ca::cancer
::cal::calcification
::cald::calcified
::cals::calcifications
::vcal::vascular calcification
::car::cartilage
::cart::cartilage
::cav::cavity
::cavy::cavitary
::pcav::pelvic cavity
::acav::abdominal cavity
::cavi::cavitation
::cavs::cavities
::cbe::cerebellar
:c:CBF::CBF
:c:CBV::CBV
:c:MTT::MTT
::cbf::cerebral blood flow
::cbv::cerebral blood volume
::mtt::mean transit time
::cbral::cerebral
::cbr::cerebral
::cds::cul-de-sac
::ce::contrast enhancement
::cel::celiac
::ie::increased enhancement
::cemra::CE-MRA study
::cen::central
::cfx::compression fracture
::dfx::displaced fracture
::ofx::old fracture
::ndfx::non-displaced fracture
::nfx::non-displaced fracture
::cg::causing
::ci::following contrast administration
::ccom::cord compression
::vcom::ventricular compression
::com::compression
:c:COM::COM
::cf::femoral catheter
::lcf::left femoral catheter
::rcf::right femoral catheter
::cfs::colonofibroscopy
::chw::chest wall
::chr::chronic
::chole::cholecystectomy
::chec::cholecystectomy
::cir::circumferential
::cirr::cirrhotic
::cis::cistern
::cl::surgical material placement
::cl::clip placement
::cli::surgical clips
::cll::clear left lung
::crl::clear right lung
::cla::clavicle
::clo::with the largest one
::clu::cluster
::clus::clusters
::clud::clustered
::clv::clavicle
::clf::left femoral catheter
::clj::left jugular catheter
::cls::left subclavian catheter 
::cam::cardiomegaly
::cmc::enlarged heart shadow with an atherosclerotic partially calcified aorta	
::cmg::cardiomegaly
::cmj::corticomedullary junction
::cmt::enlarged heart shadow with tortuous aorta
::cmtc::enlarged heart shadow with a tortuous atherosclerotic partially calcified aorta
::cme::contrast medium
::cnod::calcified nodule
::cnd::calcified nodule
::cnods::calcified nodules
::cnds::calcified nodules
::cn::cirrhotic nodule
::cns::cirrhotic nodules
::cnct::faint low attenuation in both arterial and portal venous phase
::co::correlation
;::col::collection
::col::collapse
::cold::collapsed
::cln::collection
::clns::collections
::clp::collapse
::clpd::collapsed
::colles::Dorsally angulated fracture of distal radial metaphysis, consistent with Colles' fracture. `
::collel::dorsally angulated fracture of left distal radial metaphysis
::coller::dorsally angulated fracture of right distal radial metaphysis
::smith::Ventrally angulated fracture of distal radial metaphysis, consistent with Smith's fracture. `
::comm::comminuted
::comp::as compared to the prior similar study dated
::compct::as compared to the prior CT study
::cct::as compared to the prior CT study
::compmr::as compared to the prior MR study
::cmr::as compared to the prior MR study
;::cm::contrast medium
::con::consolidation
::lcon::lung consolidation
::cons::consolidation
::conb::consolidation at bilateral lungs
;::cond::diffuse consolidation at both lungs
::cond::lung consolidation in dependent regions
::slc::subpleural areas of lung consolidation
::conf::configuration
::cong::conglomerate
::conh::perihilar consolidation 
::conl::left lung consolidation 
::conv::convexity
;::conp::patchy consolidations at both lungs
;::conpe::bilateral lung consolidation and bilateral pleural effusion
;::conpecm::bilateral lung consolidation, pleural effusion and enlarged heart shadow
;::conpecmc::bilateral lung consolidation, pleural effusion and enlarged heart shadow with wall calcification of the aorta
;::conpecmtc::bilateral lung consolidation, pleural effusion and enlarged heart shadow with wall calcification of the tortuous aorta
;::conpl::patchy consolidations at left lung
;::conpr::patchy consolidations at right lung
::conr::right lung consolidation
::conl::light lung consolidation
::hcon::hemorrhagic contusion
::hcont::hemorrhagic contusion
::cont::contusion
::cors::coarse
::cos::colostomy
::cord0::{HOME}- no definite abnormal signal intensity change in imaged cord.
:c:CPA::CPA
:c:CPAs::CPAs
::cp::catheter placement
::ccp::central catheter placement
::cpa::cerebellopontine angle
::cpas::cerebellopontine angles
::cpb::blurring of bilateral costophrenic angles 
::cpl::blurring of left costophrenic angle	
::cpm::{HOME}- central pontine T2 hyperintensity with sparing of peripheral pontine tissue as well as the descending corticospinal tracts. R/O osmotic demyelination syndrome.
;::msa::{HOME}- "hot cross bun" appearance of T2 hyperintesity in the pons. Atrophy of pons and cerebellum. R/O multiple system atrophy.
::cpp::calcified pleural plaque 
::cpr::blurring of right costophrenic angle
::cps::chronic paranasal sinusitis
;::cre::craniectomy
::cro::craniotomy
::cec::craniectomy
::cot::cranotomy
::crp::cranioplasty
::crf::right femoral catheter 
::crj::right jugular catheter 
::crs::right subclavian catheter
::csd::considered
::csec::Caesarean section
::csf::CSF
::csff::CSF-filled
::csfl::CSF-like
::csfd::CSF-density
::csfi::CSF-intensity
;::cst::cervical stenosis
::hrct::HRCT
::c/t::chemotherapy
::ct::CT
::ctb::bilateral chest tubes
::ctl::left chest tube
::ctn::containing
::ctr::right chest tube
::ctis::cholecystitis
::xctis::xanthogranulomatous cholecystitis
::cv::calvarial vault
::cvc::central venous catheter
::cvr::cardiac valve replacement
::vr::valve replacement
;::cw::compatible with
::cw::consistent with



::daa::dissecting aortic aneurysm
::db::dural-based
:c:DBJ::DBJ catheter
::dbj::double-J catheter
::dbjl::Placement of double-J catheter in left sided collecting system with optimal tip position
::dbjr::Placement of double-J catheter in right sided collecting system with optimal tip position
::dbjb::Placement of double-J catheters in bilateral collecting system with optimal tip position
::dj::double-J catheter
::djs::double-J catheters
::djl::Placement of a left double-J catheter.
::djr::Placement of a right double-J catheter.
::djb::Placement of bilateral double-J catheters.
::j::double-J catheter
::js::double-J catheters
::jl::Placement of a left double-J catheter.
::jr::Placement of a right double-J catheter.
::jb::Placement of bilateral double-J catheters.
::dce::dynamic contrast enhanced
::dch::degenerative change
::dd::D/D
::ddd::differentiated
::ddh::decreased disc height
::dvh::decreased vertebral height
::ddd::degenerative disc disease
::dde::disc desiccation
::ddx::differential diagnosis
::deh::dehydration
::dev::deviation
::devel::development
::ndv::newly developed
::ndev::newly developed
::di0::{HOME}- no definite abnormal restriction on diffusion study.
::d0::{HOME}- no definite abnormal restriction on diffusion study.
::dia::diaphragm
::hdia::hemidiaphragm
::hdi::hemidiaphragm
::din::diffusion negative
::dip::diffusion positive
::dis::distal
::dist::distended
::de::destruction
::dec::decutibus
::des::destructive
::def::definite
::dfo::deformity
::dfod::deformed
::deg::degenerative
::desc::descending
::df::defect
::dfs::defects
::di::diverticulum
::divs::diverticula
::dif::diffuse
::diff::diffuse
::dil::dilated
::dila::dilatation
::ch::change
::dep::dependent
::dfl::definite focal lesion
::dfo::diffuse faint opacity 
::dggo::diffuse ground glass opacity
::dg::deep gray
::dgn::deep gray nuclei
::dnu::deep nuclei
;::dh::diffuse haziness
::ldh::loss of disc height
::dh::disc height
::ddiv::{HOME}- Focal gas/fluid collection between duodenum and pancreatic head, likely diverticulum.
::div::diverticulum
::dtis::diverticulitis
::dlc::dislocation
::dlv::decreased lung volume 
::dlvl::decreased left lung volume 
::dlvr::decreased right lung volume 
::dlvb::decreased lung volume bilaterally
::dni::deep neck infection
::do::diffuse opacity
::doc::disc-osteophyte complex
::dol::diffuse opacification of the residual pleural space in the left hemithorax	
::dor::diffuse opacification of the residual pleural space in the right hemithorax
::dou::Douglas pouch
::doug::Douglas pouch
::mor::Morison pouch
::dp::disc protrusion
::dpr::disc protrusion
::dex::disc extrusion
::dpa::{HOME}- magnetic susceptibility artifacts from the dental prosthesis obscuring and distorting the image details.
::dr::diffusion restriction
::drn::drain
::drns::drains
::drp::drain placement
::rd::restricted diffusion
::ds::different sizes
::vd::varying degree
::vds::varying degrees
::vmg::ventriculomegaly
::vs::vessel
::vss::vessels
::vs::varying size
::vss::varying sizes
::vsd::variable-sized
::dsd::displaced
::dst::displacement
::dsp::displacement
::dsd::spondylosis with marginal osteophytes
::ldsd::lumbar spondylosis with marginal osteophytes
::cdsd::cervical spondylosis with marginal osteophytes
::lsdsd::lumbosacral spondylosis with marginal osteophytes
::lsd::Lumbosacral spondylosis with marginal osteophytes
::dsdd::degenerative spinal/disc disease
::mdsd::Mild spondylosis with degenerative marginal osteophytes
::dst::dural sinus thrombosis
::pby::probably
::pdt::probably due to
::dto::due to
::dt::due to
::dts::drains
::dtu::drainage catheter
::dtp::drainage catheter placement
::du::duodenum
::duo::duodenal
::dvt::deep vein thrombosis
::dx::diagnosis
::ddx::differential diagnosis
::dz::disease
::dzs::diseases
::dzz::diseases
::e::Placement of endotracheal tube
::ea::extra-axial
::ia::intra-abdominal
::iax::intra-axial
::ec::Placement of endotracheal tube, central catheter
::echo::echotexture
::cecho::coarse echotexture
::hecho::hyperechoic
::lecho::hypoechoic
::ecot::echotexture
::ceco::coarse echotexture
::heco::hyperechoic
::leco::hypoechoic
::ecog::echogenecity
::aeco::anechoic

::ed::edema
::ed::disc extruding
::ede::edematous
::eec::esophagectomy
::ef::effusion
::eff::effacement
::effa::effacement
;::eg::esophagogastric
::egj::esophagogastric junction
::egos::esophagogastrostomy
::eh::enlarged heart size
::ehl::Elevated left hemidiaphragm.
::ehr::Elevated right hemidiaphragm.
::emb::embolism
::pem::pulmonary embolism
::emp::emphysematous change over both lungs
::em::emphysema
::ech::emphysematous change
::empii::emphysematous change and increased infiltration over both lungs 
::emal::encephalomalacia
::esrd::end-stage renal disease
::eg::Placement of endotracheal tube, gastric tube
::egc::Placement of endotracheal tube, gastric tube, central catheter 
::enc::encasing
::enh::enhancement
::eng::enhancing
::ael::abnormally enlarged
::el::enlarged
::enl::enlarged
::elm::enlargement
::elt::enlargement
::eo::end-on
::eos::end-ons
::veo::vascular end-on
::veos::vascular end-ons
::eom::extra-orbital muscles
::ep::endplate
::epc::endplate change
::epch::degenerative signal intensity change at vertebral body marrow adjacent to endplates
::epid::epidural
::eq::equivocal
:c:ERCP::ERCP
::ercp::endoscopic retrograde cholangiopancreatography
::es::esophagus
::eso::esophageal
::esp::especially	
::et::endotracheal tube
::etng::endotracheal tube, gastric tube
::etu::ECMO tube
::ev::esophageal varices
::eval::evaluation
:c:EVD::EVD
::evd::extraventricular drainage
::evi::evidence
::exo::exophytic
::ext::extension

:c:GI::GI
::gi::gastrointestinal
::gl::gland
::gls::glands
::git::gastrointestinal tract
::gv::gastric varices

::f::focal
::fy::focally
::fa::facet arthropathy
::fai::free air
::fb::fibrotic band
::fb::foreign body
::fba::fibrotic band
::fbs::fibrotic bands
::ua::upper abdomen
::ua::uncovertebral arthropathy
::uab::upper abdomen
::fua::facet/uncovertebral arthropathy
::ufa::uncovertebral/facet arthropathy
::fao::focal area of increased opacity 
::faos::focal areas of increased opacity	
::fal::fine alignment
::fch::fibrotic change
::fsis::fibrosis
::fcn::fibrocalcified nodule 
::fcns::fibrocalcified nodules
::fcu::fibrotic change at upper lungs
::fd::filling defect
::fds::filling defects
::fess::{HOME}- postoperative change with infundibulectomy
::fessr::{HOME}- postoperative change with right infundibulectomy
::fessl::{HOME}- postoperative change with left infundibulectomy
::ffc::focal fatty change
::fh::forehead
::fi::fat infiltration
::finf::fat infiltration
::fis::fissure
::fiss::fissures
::fxn::fixation
::fle::focal lesion
::fl::fluid
::flk::flank
::fk::flank
::bfk::right flank
::lfk::left flank
::rfk::right flank
::flv::fatty liver
::flx::flexture
::fm::fecal material in the colon
::fmn::formation
::fn::foraminal narrowing
::fn1::mild foraminal narrowing
::fn2::moderate foraminal narrowing
::fn3::severe foraminal narrowing
::fnc::fibronodular change
::fni::fibronodular infiltrate
::fnch::fibronodular change
::fnt::faint
::fo::faint opacity
::foy::focally
::foly::focally
::fo::faint opacity
::foo::faint opacities
::foley::foley catheter
::fly::foley catheter
::uf::urinary foley balloon catheter
::fp::faint patch
::fs::fat stranding
::fs::foraminal stenosis
::fsa::fat-sparing area
::fsas::fat-sparing areas
::fs1::mild foraminal stenosis
::fs2::moderate foraminal stenosis
::fs3::severe foraminal stenosis
::ft::filum terminale
::ftp::froto-temporo-parietal
::fu::follow up
::func::function
::fx::fracture
::fxx::fractures
::fxs::fractures
::fxl::rib fracture on the left
::fxr::rib fracture on the right
;::g0::{HOME}- no abnormal dilatation or wall thickening of imaged GI tract.
;::g0::{HOME}- unremarkable large and small bowel loops.
::i0::unremarkable bowel gas pattern
::bg0::unremarkable bowel gas pattern
::ug::unremarkable bowel gas pattern


::ga::gastric
;::gas::gastric
::gab::gastric body
::gaa::gastric antrum
::gac::gastric cardia
::gat::gastric tubing
::gec::gastrectomy
::geo::geographically
::gga::ground glass attenuation
::ggd::ground glass density
::ggo::ground glass opacity
::ggoo::ground glass opacities
::ggos::ground glass opacities
::ggod::diffuse ground glass opacity
::ghj::glenohumeral joint
::gk::graft kidney
::glu::gluteal
::glue::n-Butyl-2-Cyanoacrylate
::gm::gray matter
::gs::Opaque density at right upper abdomen, R/O gall stone. `
::ghl::gastrohepatic ligament

::h::hepatic
::hnd::hepatic nodule
::hnds::hepatic nodules
::hb::heart border
::rhb::right heart border
::lhb::left heart border
:c:HCC::HCC
;::hcc::hepatocellular carcinoma
::hcc::arterial enhancement and portal venous phase washout
;::hccct::heterogeneously hyperdensity on arterial phase and washout to hypoattenuating on portal venous phase
::hemanct::nodular, discontinuous peripheral enhancement and progressive centripetal fill in
::hct::nodular, discontinuous peripheral enhancement and centripetal fill in
;::thad::peripheral wedge-shaped hypervascular lesion seen only on arterial phase imaging, R/O transient hepatic attenuation difference
::thad::hypervascular hepatic lesion seen only on arterial phase
::thads::hypervascular hepatic lesions seen only on arterial phase
::thd::transient hepatic attenuation difference
::thds::transient hepatic attenuation differences
::hccmr::hyperintensity in arterial phase and hypointensity in portal venous phase
::hc::hepatic cyst
::rhc::right lobe hepatic cyst
::rhcs::right lobe hepatic cysts
::lhc::left lobe hepatic cyst
::lhcs::left lobe hepatic cysts
::hcs::hepatic cysts
::hc::{HOME}- ventricles and Sylvian fissures symmetrically dilated out of proportion to sulcal enlargement, consistent with hydrocephalus.
::hce::{HOME}- ventricles and Sylvian fissures symmetrically dilated out of proportion to sulcal enlargement, consistent with hydrocephalus.
;::hd::high attenuation
::hd::hyperdensity
::hde::hyperdense
::hcec::hemicolectomy
::hch::hyperemic change
::hre::hyperemic
::hdl::hepatoduodenal ligament
::hds::hyperdensities
::hep::hepatic
::het::heterogeneous
::hemi::hemispheric
::ihemi::interhemispheric
::ihem::interhemispheric
::hem::hemisphere
::hems::hemispheres
::hie::hypoxic ischemic encephalopathy
:c:HIVD::HIVD
::hivd::herniated disc
::hj::hip joint
::hjs::hip joints
::hle::hepatic lesion
::hles::hepatic lesions
::hl::hepatic lobe
::hls::hepatic lobes
::hlus::hydrocephalus
::plus::pneumocephalus
::hom::homogeneous
::homo::homogeneous
;::hi::prominent bilateral hilar shadows 
;::hil::prominent left hilar shadow
;::hir::prominent right hilar shadow
;::hi::Increased infiltration in perihilar areas.
;::hir::Increased infiltration in right perihilar area.
;::hil::Increased infiltration in left perihilar area.
::hi::Bilateral perihilar infiltrate.
::hir::Right perihilar infiltrate.
::hil::Left perihilar infiltrate.
::shi::suprahilar
::ihi::infrahilar
::hipp::hippocampus
::hop::hollow organ perforation
::hsis::hydronephrosis
::hnp::hydronephrosis
::htn::hypertension
::phtn::portal hypertension
;::hx::history
::hx::[Relevant History]
::hy::Contrast medium opacification of
::hyp::intake of contrast medium with opacification of
::hyper::hypertrophy
::hypo::hypoplasia
::hwo::homogeneous whiteout
::who::whiteout
::atr::atrophy
::iab::intraabdominal
::ecra::extracranial
::icra::intracranial
::iax::intra-axial
::eax::extra-axial
::cra::cranial

::ia::intraarterial
::iai::intra-abdominal infection
:c:IABP::IABP
::iabp::intra-aortic balloon pump
:c:IV::IV
::iv::intravenous
:c:IAC::IAC
:c:IACs::IACs
:c:EAC::EAC
:c:EACs::EACs
::iac::internal acoustic canal
::iacs::internal acoustic canals
::eac::external acoustic canal
::eacs::external acoustic canals
::id::identified
::ifi::infiltrate
::ifn::infiltration
::ifv::infiltrative
::ifd::infiltrated
::ig::Increased bowel gases.
::ig::injection granuloma
::ih::intrahepatic
::il::Bilateral lower lung infiltrate.
::ile::ileus
::ril::Right lower lung infiltrate.
::lil::Left lower lung infiltrate.
::ill::ill-defined
::ili::iliac
::ib::iliac bone
::iim::in imaged
::im::imaged
::imm::immediate
::imp::[Impression]
::ico::intercostal
::ing::inguinal
::inj::injury
::ins::insertion
::insd::inserted
::ins::insular
::int::interstitial
::itn::internal
::xtn::external
::etn::external
::inv::involving
::invd::involved
::invt::involvement
::io::increased opacity
::iop::intraoperative
::i::increased
::d::decreased
::inc::increased
;::ind::indentation
::ind::indeterminate
::infl::inflammatory
::inch::inflammatory change
::infil::infiltration
::inp::in progression
::ip::in progression
::iq::image quality
::ir::irregularity
::irr::irregular
::iry::irregularity
::irad::irradiation
::isf::is found
::isn::is noted
::isl::is likely
::ios::ileostomy
::arf::are found
::arn::are noted
::rad::radiation
::itl::in the liver
::ivd::intervertebral disc
:c:IUD::IUD
:c:UID::IUD
::iud::Placement of intra-uterine device.
::uid::Placement of intra-uterine device.


::j::junction
::ju::jugular
::je::jejunum
::jel::jejunal
::jos::jejunostomy
::jug::jugular
::jd::jugulodigastric
::jppl::juxtaphrenic peak of left hemidiaphragm 
::jppr::juxtaphrenic peak of right hemidiaphragm	
::k0::Abdomen/KUB shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen.  No abnormal calcification is noted.
::k1::Abdomen/KUB shows no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is noted.
::bo::Dilated small bowel in 
::bo1::Dilated small bowel containing gas-fluid levels in 
::bo2::Ladder-like arrangement of the dilated small bowel containing gas-fluid levels
::sbo::small bowel obstruction
::k1::Abdomen/KUB shows increased intestinal bowel gas. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is noted.
::k11::Abdomen/KUB shows increased intestinal bowel gas. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is noted.
::k2::Abdomen/KUB shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen.
::k3::Abdomen/KUB shows increased bowel gas. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen.
::ka::Interstial pulmonary edema.
::ipe::interstial pulmonary edema
::kb::Short linear opacities coursing perpendicularly to the pleural surfaces
::ka::Long linear opacities coursing diagonally toward the hila in the inner half of the lungs, compatible with Kerley A lines.
::kb::Short linear opacities coursing perpendicularly to the pleural surfaces, compatible with Kerley B lines.
::kal::Kerley A lines
::kbl::Kerley B lines

::kn::knee
::kns::knees
::kec::nephrectomy
::atel::linear atelactasis

::l0::no definite lung lesion
;::l0::no active lung lesion
::c0::{HOME}- No definite lung lesion.
::la0::{HOME}- No definite abnormality in bilateral lung apices.
::lb0::{HOME}- No pulmonary parenchymal mass or pleural effusion.
::l00::No definite lung lesion. Sharp costophrenic sulci
::lp::No active lung lesion. Sharp costophrenic sulci
;::la::lung apex
::lac::lacune
::lacs::lacunes
::ladn::lacunes in deep nuclei
::dl::deep nuclei lacunes
::dwl::deep nuclei and white matter lacunes
::dbl::deep nuclei and brain stem lacunes
::dwbl::deep nuclei, white matter and brain stem lacunes
::wl::white matter lacunes
::ladgbs::lacunae in deep gray nuclei, brain stem
::bla::bilateral lung apices
::lami::laminectomy
::lamr::{HOME}- multifocal small areas of T2 hyperintensity and T1 hypointensity at
::lact::{HOME}- multifocal small hypodensities at
:c:LAP::LAP
:c:LAPs::LAPs
::lap::lymphadenopathy
::laps::lymphadenopathies
::lc::liver cirrhosis
::lc0::Non-cirrhotic appearance of liver. Patent portal veins.
::lc1::Uneven liver surface
::lc2::Nodular liver contour
::lc3::Nodular, retracted liver contour
::lcc::Cirrhotic appearance of liver
;::lc0::{HOME}- Non-cirrhotic appearance of liver. Patent portal veins.
;::lc1::{HOME}- Uneven liver surface
;::lc2::{HOME}- Nodular liver contour
;::lc3::{HOME}- Nodular, retracted liver contour
;::lcc::{HOME}- Cirrhotic appearance of liver
::nlcc::non-cirrhotic appearance of liver
;::ld::low attenuation
::ld::hypodensity
::lde::hypodense
::lds::hypodensities
::ldc::low density change
::da::decreased attenuation
::dac::decreased attenuation change
::lec::lobectomy
::le::lesion
::les::lesions
::lep::leptomeningeal
::leumr::{HOME}- Focal/confluent periventricular T2 hyperintensities, R/O leukoaraiosis.
::lmr::{HOME}- Focal/confluent periventricular T2 hyperintensities.
;::leu::{HOME}- Abnormal confluent SI change as venous hypoxic degeneration of the white matter due to amyloidosis of the ependymal or subependymal veins at the periventricular region, indicating leukoaraiosis.
::leuct::{HOME}- Focal/confluent periventricular hypodensities, R/O leukoaraiosis.
::lct::{HOME}- Focal/confluent periventricular hypodensities.
::leu::leukoaraiosis
::leu1::{HOME}- Punctate subcortical or deep white matter hyperintensity (Fazekas 1).
::leu2::{HOME}- Early confluent white matter hyperintensity (Fazekas 2).
::leu3::{HOME}- Confluent, patchy white matter hyperintensity (Fazekas 3).
::cli::chronic lacunar infarction
::lga::left gastric artery
::rga::right gastric artery
::li::lacunar infarction
::lig::ligament
::lin::linear
::clin::curvilinear
::ling::left upper lobe lingular segment
::lf::thickened ligamentum flavum
;::lla::left lower abdomen
::lle::lung lesion
::lles::lung lesions
:c:LLQ::LLQ
::llq::left lower quadrant
::llqa::left lower quadrant abdomen
::llz::left lower lung zone
::lbz::left basal lung zone
::vlm::vascular lung markings
::pvlm::Prominent vascular lung markings.
::plm::Prominent vascular lung markings.
::lm::Prominent vascular lung markings.
::lm::lateral meniscus
::lmets::bilateral lung masses and nodules	
::lmi::increased vascular lung markings
::lmz::left middle lung zone
::mlmz::left perihilar region
::plmz::peripheral left middle lung zone
::mbmz::bilateral perihilar regions
::pbmz::peripheral bilateral middle lung zones
::ln::lymph node
::ln0::{HOME}- No definite abnormally enlarged lymphadenopathy.
::lns::lymph nodes
::rlns::regional lymph nodes
::lo::lung opacity
::lob::lobulated
;::loc::loss of consciousness
::loc::loculated
::lol::loss of lordosis
::locl::loss of cervical lordosis
::loll::loss of lumbar lordosis
::loo::lung opacities
::lua::left upper abdomen
::luc::lucency	
::luq::left upper quadrant
::luqa::left upper quadrant abdomen
::luz::left upper lung zone
::buz::bilateral upper lung zones
::ruz::right upper lung zone
::mruz::medial right upper lung zone
::mluz::medial left upper lung zone
::pruz::peripheral right upper lung zone
::pluz::peripheral left upper lung zone


::ln::lymph node
::lns::lymph nodes
::lvl::level
::lvls::levels


::rlc::right lung consolidation
::llc::left lung consolidation
::blc::bilateral lung consolidation
::ruc::right upper lung consolidation
::luc::left upper lung consolidation
::buc::bilateral upper lung consolidation
::rllc::right lower lung consolidation
::lllc::left lower lung consolidation
::bllc::bilateral lower lung consolidation
::rblc::right basal lung consolidation
::lblc::left basal lung consolidation
::bblc::bilateral basal lung consolidation
::rli::right lung infiltrate
::lli::left lung infiltrate
::bli::bilateral lung infiltrate
::rui::right upper lung infiltrate
::lui::left upper lung infiltrate
::bui::bilateral upper lung infiltrate
::rlli::right lower lung infiltrate
::llli::left lower lung infiltrate
::blli::bilateral lower lung infiltrate
::rbli::right basal lung infiltrate
::rbi::right basal lung infiltrate
::lbli::left basal lung infiltrate
::lbi::left basal lung infiltrate
::bbli::bilateral basal lung infiltrate
::rlo::right lung opacities
::llo::left lung opacities
::blo::bilateral lung opacities
::ruo::right upper lung opacity
::luo::left upper lung opacity
::buo::bilateral upper lung opacities
::rllo::right lower lung opacity
::lllo::left lower lung opacity
::bllo::bilateral lower lung opacities
::rblo::right basal lung opacity
::lblo::left basal lung opacity
::bblo::bilateral basal lung opacities
::rloo::right lung opacities
::lloo::left lung opacities
::bloo::bilateral lung opacities
::ruloo::right upper lung opacities
::luloo::left upper lung opacities
::buloo::bilateral upper lung opacities
::rlloo::right lower lung opacities
::llloo::left lower lung opacities
::blloo::bilateral lower lung opacities

::ly::likely
;::lip::lipiodol

::rtn::right lobe thyroid nodule
::ltn::left lobe thyroid nodule
::btn::bilateral thyroid nodules
::tn::thyroid nodule
::tns::thyroid nodules

; stone related
::brs::bilateral renal stones
::lrs::left renal stone
::rrs::right renal stone
::lrss::left renal stones
::rrss::right renal stones
::bks::Opaque densities superimposed on bilateral renal shadows, R/O bilateral renal stones.
::lks::Opaque density superimposed on left renal shadow, R/O left renal stone.
::rks::Opaque density superimposed on right renal shadow, R/O right renal stone.
::bus::Opaque densities at bilateral paraspinal area, R/O bilateral ureteral stones.
::lu1::Opaque density at left paraspinal area L1 level, R/O ureteral stone.
::ru1::Opaque density at right paraspinal area L1 level, R/O ureteral stone.
::lu2::Opaque density at left paraspinal area L2 level, R/O ureteral stone.
::ru2::Opaque density at right paraspinal area L2 level, R/O ureteral stone.
::lu3::Opaque density at left paraspinal area L3 level, R/O ureteral stone.
::ru3::Opaque density at right paraspinal area L3 level, R/O ureteral stone.
::lu4::Opaque density at left paraspinal area L4 level, R/O ureteral stone.
::ru4::Opaque density at right paraspinal area L4 level, R/O ureteral stone.
::lu5::Opaque density at left paraspinal area L5 level, R/O ureteral stone.
::ru5::Opaque density at right paraspinal area L5 level, R/O ureteral stone.
::lu12::Opaque density at left paraspinal area L1-2 level, R/O ureteral stone.
::ru12::Opaque density at right paraspinal area L1-2 level, R/O ureteral stone.
::lu23::Opaque density at left paraspinal area L2-3 level, R/O ureteral stone.
::ru23::Opaque density at right paraspinal area L2-3 level, R/O ureteral stone.
::lu34::Opaque density at left paraspinal area L3-4 level, R/O ureteral stone.
::ru34::Opaque density at right paraspinal area L3-4 level, R/O ureteral stone.
::lu45::Opaque density at left paraspinal area L4-5 level, R/O ureteral stone.
::ru45::Opaque density at right paraspinal area L4-5 level, R/O ureteral stone.
::lus::Opaque density at left paraspinal area, R/O ureteral stone.
::rus::Opaque density at right paraspinal area, R/O ureteral stone.
::bps::Opaque densities at bilateral pelvis, R/O stone or phlebolith.
::lps::Opaque density at left pelvis, R/O stone or phlebolith.
::rps::Opaque density at right pelvis, R/O stone or phlebolith.
::bpp::Opaque densities at bilateral pelvis, R/O phlebolith.
::lpp::Opaque density at left pelvis, R/O phlebolith or stone.
::rpp::Opaque density at right pelvis, R/O phlebolith or stone.
::bppp::Opaque densities at bilateral pelvis, R/O phlebolith.
::lppp::Opaque density at left pelvis, R/O phlebolith.
::rppp::Opaque density at right pelvis, R/O phlebolith.
::rss::Opaque density superimposed on right sacrum, R/O ureteral stone.
::lss::Opaque density superimposed on left sacrum, R/O ureteral stone.
::bss::Opaque densities superimposed on bilateral sacrum, R/O ureteral stone.
::lith::phlebolith
::liths::phleboliths
::rkc::right renal cyst
::lkc::left renal cyst
::kc::renal cyst
::kcs::renal cysts
::rkcs::right renal cysts
::lkcs::left renal cysts
::bkc::bilateral renal cysts
::bka::bilateral renal atrophy
::bra::bilateral renal atrophy

::rhc::right lobe hepatic cyst
::lhc::left lobe hepatic cyst
::rhcs::right lobe hepatic cysts
::lhcs::left lobe hepatic cysts

::lra::left renal atrophy
::rhc::low attenuation well-defined lesion at right liver without definite enhancement, R/O hepatic cyst
::lhc::low attenuation well-defined lesion at left liver without definite enhancement, R/O hepatic cyst
::rhcs::low attenuation well-defined lesions at right liver without definite enhancement, R/O hepatic cysts
::lhcs::low attenuation well-defined lesions at left liver without definite enhancement, R/O hepatic cysts
::bhc::low attenuation well-defined lesions at bilateral liver without definite enhancement, R/O hepatic cysts

::lis::larger in size
::lis::spondylolisthesis
::slis::spondylolytic spondylolisthesis
::dlis::degenerative spondylolisthesis
::rlis::retrolisthesis
::alis::anterolisthesis
::ls0::Lumbar spine shows fine alignment of lumbar spine. No obvious fracture or dislocation. Preserved disc spaces
::ls1::Lumbar spine shows straightened curve of lumbar spine. No obvious fracture or dislocation. Preserved disc spaces
::lst::lumbar stenosis

::lsg::lateral segment
::msg::medial segment

::m::multiple
::maj::major
::min::minor
::mb::midbrain
::mi::mild
::mef::mass effect
::mo::moderate
::sel::several
::sev::several
::svr::severe
::sev::severe
;::mal::Absence of left breast shadow, suggesting status post mastectomy.
::mar::marginal
::mba::mild brain atrophy
::mc::metacarpal
::mcb::metacarpal bone
::mcm::prominance of the retro-cerebellar CSF space, R/O mega-cisterna magna
::me::mediastinum
::ume::upper mediastinum
::umel::upper mediastinal
::mec::mastectomy
::me0::{HOME}- mediastinum within normal limit.
::mel::mediastinal
::mem::membrane
::memb::membrane
::meni::menisci
::men::meniscus
::lm::Prominent vascular lung markings.
::lm::lateral meniscus
::mal::malalignment
::mat::material
::smat::suture material
::mm::Mild mediastinal widening.
::mm::medial meniscus
::mes::mesenteric
::mry::mesentery
::met::metallic
::meta::metastatic
::mets::metastasis
::mg::meningogaleal
::mgc::meningogaleal complex
::mln::mediastal lymph nodes
::aln::para-aortic lymph nodes
::alns::para-aortic lymph nodes
::ilns::inguinal lymph nodes
::mhlns::mediastinal and hilar lymph nodes
::mlns::mediastinal lymph nodes
::nlns::neck lymph nodes
::mf::multifocal
::mf::metallic fixation
::mfo::multifocal
::mi::more in
::mk::marked
::mky::markedly
::mle::mass lesion
::mli::mass-like opacity
::mlvl::multilevel
::micromr::{HOME}- a 3mm mass that exhibits less intense enhancement than the surrounding pituitary gland.
::pithyper::convex superior pituitary contour and pituitary height of mm
::mri::MRI
::ml::more on the left
::mpd::pancreatic duct
::mr::more on the right
::mrnd::modified radical neck dissection
::ms::midline shift
::msa::* Suboptimal study due to metallic susceptibility artifact.
::moa::* Suboptimal study due to motion artifact.
::rmoa::* suboptimal study due to respiratory motion artifact.
::dea::* suboptimal study due to dental artifact.
::mod::moderate
::mra::MRA
::tof::TOF
::msmr::{HOME}- multiple perpendicular callososeptal T2 hyperintensities - hyperintense rim and central hypointensity - confluent multiple sclerosis plaques
::mt::mediastinal tube
::mts::mediastinal tubes
;::mt::meniscal tear
::mtu::mediastinal tube
::mtus::mediastinal tubes
::mu::muscle
::muc::mucosal
::mus::muscles
::mw::mediastinal widening
::mmw::Mild mediastinal widening.
:c:MVM::MVM
::mvm::medullary venous malformation
::mx::mix
::mxd::mixed
::mxg::mixing
::myo::myoma

::oms::oral mucosal space
::bms::buccal mucosal space
::n::and
::g::Placement of gastric tube
::n0::Fine alignment of spinal curve. No obvious fracture or dislocation. Preserved disc spaces. No obvious prevertebral soft tisue swelling
::n1::Straightened curve of spinal curve. No obvious fracture or dislocation. Preserved disc spaces. No obvious prevertebral soft tisue swelling
::nb::{HOME}- no definite osteolytic lesion or fracture in the calvarial vault or skull base.
::sk0::{HOME}- no definite osteolytic lesion in calvarial vault.`n- skull base within normal limit.
::v0::{HOME}- ventricles, cisterns and sulci of expected size and morphology.
::nab::Nabothian cyst
::nabs::Nabothian cysts
::nc::Nabothian cyst
::ncs::Nabothian cysts
::bar::Bartholin cyst
::bars::Bartholin cysts
::nba::{HOME}- ventricle, cisterns and sulci of expected size and morphology.
::ba0::{HOME}- ventricle, cisterns and sulci of expected size and morphology.
::ban::{HOME}- ventricle and sulci of expected size and morphology for the patient's age.

::n/a::not available
::na::narrowing
::nar::narrowing
::nc::Placement of gastric tube, central catheter
::gc::Placement of gastric tube, central catheter
::gct::Placement of gastric tube, tracheostomy tube, central catheter
::gt::Placement of gastric tube, tracheostomy tube
::gtc::Placement of gastric tube, tracheostomy tube, central catheter
::nd::no definite
::ndfl::no definite focal lesion
::ae::abnormal enhancement
::aae::arterial enhancement
::aenh::arterial enhancement
::nael::no abnormally enlarged or clustered
::ne::no evidence of
::nec::necrotic
::neg::No definite abnormality in this study
::neng::non-enhancing
::leng::less-enhancing
::aeng::abnormally enhancing
::nf::neural foramen
::nff::neural foramina
:c:NF::neurofibromatosis
:c:NF1::neurofibromatosis I
:c:NF2::neurofibromatosis II
::ng::nasogastric tube
::nh::normal heart size 
::nhc::normal heart size with wall calcification of the aorta
::nhpen::Normal cardiac silhouette and sharp costophrenic angles
::nht::normal heart size with tortuous aorta 
::nhtc::normal heart size with wall calcification of the tortuous aorta	
;::ni::there is no significant interval change since the prior examination
::ni::no significant interval change
::nip::nipple
::ns::nonspecific
::nsp::nonspecific
::nt2::{HOME}- multiple nonspecific hyperintense patches on FLAIR at bilateral periventricular white matter. 
::nfc::neural foraminal compromise
::nfn::nonfunctional
::dfn::dysfunctional
::nfn::neural foraminal narrowing
::nfn1::mild neural foraminal narrowing
::nfn2::moderate neural foraminal narrowing
::nfn3::severe neural foraminal narrowing
::nfs::neural foraminal stenosis
::nfs1::mild neural foraminal stenosis
::nfs2::moderate neural foraminal stenosis
::nfs3::severe neural foraminal stenosis
::lnd::lung nodule
::lnds::lung nodules
::blnds::bilateral lung nodules
::lma::lung mass
::lmas::lung masses
::tnd::thyroid nodule
::tnds::thyroid nodules
::nod::nodule
::nodl::nodular
::ndl::nodular
::nods::nodules
::nds::nodules
::noo::no obvious
;::np::nasopharynx
::np::Normal cardiac silhouette and sharp costophrenic sulci
::num::numerous
::innum::innumerable
::nv::normal variant
::pnp::paranasopharyngeal

::o::opacity
::obv::obvious
;::obs::obscuration
::ob::obstruction
::obs::obstructive
::oa::osteoarthritis change
::oac::joint space narrowing, subchondral sclerosis/eburnation, subchondral cysts and osteophyte formation
::obl::over both lungs
::orl::over right lung
::oll::over left lung
::ibl::in both lungs
::iblo::in both lobes
::iblv::in both hepatic lobes
::oi::old insult
::ois::old insults
::oin::old insult with parenchymal loss
::lome::lesser omentum
::ome::omentum
::omen::omental
::omu::ostiomeatal unit
::oo::opacities
:c:OP::OP
::op::postoperative change
::pop::post-operative
::ptace::post-TACE
::prfa::post-RFA
::opa::opacification
::opad::opacified
::opc::postoperative change with
::opq::opaque
::rop::radiopaque
::orb::orbital
::orif::open reduction and internal fixation
:c:ORN::ORN
::orn::osteoradionecrosis
::ot::other
::otl::on the left
::otr::on the right
::motl::more on the left
::motr::more on the right
::ou::obstructive uropathy
::uo::obstructive uropathy
::ov::ovary
::ova::ovarian
::ovs::ovaries
::ovc::cystic lesions in bilateral adnexa, R/O ovarian cysts
::rovc::cystic lesions in right adnexa, R/O ovarian cysts
::lovc::cystic lesions in left adnexa, R/O ovarian cysts
::oly::osteolytic
::lyt::osteolytic
::osc::osteosclerotic
::ow::otherwise

::p::placement of
;::p0::{HOME}- No definite abnormal focal lesion in pelvic cavity.
::p0::{HOME}- No free fluid or abnormally enlarged lymph nodes in the pelvis.
::pab::perfusion abnormality
::pad::peripheral arterial disease
::paren::parenchyma
::pae::posterior acoustic enhancement
::pas::posterior acoustic shadow
:c:PCN::PCN
::pcn::percutaneous nephrostomy tube
::pcns::percutaneous nephrostomy tubes
::pmal::parenchymal
::pma::parenchyma
::pmc::pseudomembranous colitis
::pme::pneumomediastinum
::pch::parenchymal change
::pat::patent
::pbt::peribronchial thickening
::pbc::peribronchial cuffing
::pbvt::peribronchovascular thickening
::lpa::left portacath
::rpa::right portacath
::lspa::left subclavian portacath
::rspa::right subclavian portacath
::ljpa::left jugular portacath
::rjpa::right jugular portacath
::pb::probable
::pbl::probable
::pb::parenchymal band
::pbs::parenchymal bands
::pbv::peribronchovascular
::pco::paracolic
;::pd::peritoneal dialysis
::pd::disc protruding
::pdc::peritoneal dialysis catheter
::pce::pericardial effusion
::pe::pleural effusion
::peb::bilateral pleural effusion
::bpe::bilateral pleural effusion
::rpe::right pleural effusion
::lpe::left pleural effusion
::ped::peduncle
::peds::peduncles
;::pel::left pleural effusion 
::pel::pelvic
::pen::sharp costophrenic angles 
::penia::osteopenia
::poro::osteoporosis
::pw::pelvic wall


::ope::osteopenia
::och::Osteopenic change of imaged bone structures.
::opo::osteoporosis

::path::pathology
::peng::peripherally enhancing
::per::right pleural effusion
::peri::peripheral
:c:PES::PES
::pes::panendoscopy
::pfu::perfusion
::ph::perihepatic
::hp::Prominent hilar shadows.
::hpr::Prominent right hilar shadow.
::hpl::Prominent left hilar shadow.
::phi::perihilar
::phl::left perihilar
::phr::right perihilar 
:c:PICC::PICC
::picc::peripherally inserted central catheter
::pig::pigtail drainage tube
::pip::pigtail drainage tube placement
::pigp::pigtail drainage tube placement
::pl::Placecment of left portacath.
;::pl::parenchymal loss
::pvl::parenchymal volume loss
::ple::pleural
::plu::pleural
::platy::a foreshortened clivus, platybasia, and a retroflexed odontoid.
::plc::parenchymal lung change
::pld::parenchymal liver disease
::plq::plaque
;::pc::parenchymal change
::pc::pelvic cavity
::pckd::polycystic kidney disease
::pcv::paracaval
::pcu::percutaneous
::ptu::pelvic tubing
::pit::pituiary
::pm::pace maker
;::pm::transvenous pace maker
::pneu::pneumatization
::ptail::pancreatic tail
::ptis::pancreatitis
::psh::pancreatic head
::psd::pancreatic duct
::psb::pancreatic body
::psn::pancreatic neck
::pst::pancreatic tail
::psu::pancreatic uncinate process
::pduct::pancreatic duct
::pdu::pancreatic duct
::plr::pleural
::ppd::portal perfusion defect
::ppp::poor portal perfusion
::ppan::peripancreatic
::pth::pneumothorax
::hth::hemothorax
::hpth::hemopneumothorax
::pthl::left pneumothorax	
::pthr::right pneumothorax
::pn0::imaged paranasal sinuses and mastoid air cells clear
::pns::paranasal sinusitis
::pps::parapharyngeal space
::pao::para-aortic
::pg::percutaneous gastrostomy
::gos::gastrostomy
::gjos::gastrojejunostomy
::pf::pelvic floor
::pf::parafalcine
::pfal::parafalcine
::pfo::perifocal
::pso::psoas
::psp::paraspinal
::pver::perivertebral
::phi::parahippocampal
::phip::parahippocampal
::phe::porta hepatis
::phep::porta hepatis
::php::porta hepatis
::pn::paranasal
::por::periorbital
::poh::porta hepatis
::poc::portocaval
::pov::papilla of Vater
::ppbs::porsterior pituitary bright spot
::pven::periventricular
::prep::preparation
::prom::prominent
::prm::prominent
::prox::proximal
::px::proximal
::prt::interstitial edema, thickening and increased enhancement of the neck as well as diffuse fatty replacement of cervical spine and clivus
::pic::post-irradiation change
::prtsp::fatty marrow replacement throughout vertebral bodies.
::psc::sinusitis change
::psw::pelvic side wall
::pto::peritoneal
::ppto::pneumoperitoneum
::pte::pterional
::rpto::retroperitoneal
::msf::mastoid air cell fluid
::msc::poor mastoid pneumatization
;::msc::mastoiditis change
::mch::mastoiditis change with poor pneumatization
::rsc::rhinosinusitis change
:c:OPLL::OPLL
::opll::ossification of posterior longitudinal ligament
::phb::phthisis bulbi=
::phth::phthisis bulbi
::phen::phenomenon
::pll::posterior longitudinal ligament
;::po::patchy opacity
::po::operative change with placement of
::poo::patchy opacities
::pore::porencephaly
::ponsrar::{HOME}- ill-defined central pontine mild T2 hyperintensity without mass effect or restricted diffusion, R/O pontine ischemic rarefaction.
::pir::{HOME}- ill-defined central pontine mild T2 hyperintensity without mass effect or restricted diffusion, R/O pontine ischemic rarefaction.
::poss::possible
::pr::Placecment of right portacath.
::pl::Placecment of left portacath.
::pre::preserved
::pre::predominantly
::prel::predominantly on the left	
::prer::predominantly on the right
::prev::previous
::prob::probable
::proc::process
::pt::pleural thickening
:c:PTCD::PTCD
::ptcd::percutaneous transhepatic cholangial drainge
::ptl::partial
::ptly::partially
::pul::pulmonary
::pu::pulmonary
::pun::punctate
::pvh::periventricular hyperintensity
::pvt::portal vein thrombosis
::py::patchy

::scwm::subcortical white matter
::sdwm::subcortical/deep white matter
::spwm::subcortical/periventricular white matter
::swm::subcortical white matter
::dwm::deep white matter
::pvwm::periventricular white matter

::q::central catheter
::qq::central catheters
::pq::Placement of central catheter
::qp::Central catheter placement

::r/t::radiotherapy
::ras::renal artery stenosis
::re::region
::red::reduction
::reg::region
::rel::related
::rem::remnant
::ren::renal
::reng::rim enhancing
::renh::rim enhancement
::peng::peripherally enhancing
::penh::peirpheral enhancement
::heng::heterogeneously enhancing
::henh::heterogeneous enhancement
::meng::marginally enhancing
::menh::marginal enhancement
::rc::rotator cuff
::rci::rotator cuff injury
::rcm::rotator cuff muscles
::rct::rotator cuff tear
::rec::recurrence
::rep::replacement
::res::regions
::resp::respiratory
::rma::respiratory motion artifact
::req::Radiological images from outside hospital had been uploaded into the PACS (Picture Archiving and Communicaation System) server as a baseline or for comparison. Please check the original formal report of these images from the source hospital. If a second opinion is required, please send a consultation sheet to our department.
::ret::retention
::bre::barium retention
::cre::contrast medium retention
::lre::lipiodol retention
::lres::lipiodol retentions
:c:RFA::RFA
::rfa::radiofrequency ablation
::rfad::radiofrequency ablation defect
::rfd::radiofrequency ablation defect

::rfx::rib fracture
::rfxs::rib fractures

::rx::Right rib fracture.
::rxx::Right rib fractures.
::rxs::Right rib fractures.
::lx::Left rib fracture.
::lxs::Left rib fractures.
::lxx::Left rib fractures.
::bxx::Bilateral rib fractures.

::orx::Old right rib fracture.
::orxx::Old right rib fractures.
::orxs::Old right rib fractures.
::olx::Old left rib fracture.
::olxs::Old left rib fractures.
::olxx::Old left rib fractures.
::obxx::Old bilateral rib fractures.

::rt::right hemithorax
::lt::left hemithorax
::rla::right lower abdomen
::lla::left lower abdomen
::ra::right lung apex
::la::left lung apex
::bla::bilateral lung apices
:c:RLQ::RLQ
::rlq::right lower quadrant
::rlqa::right lower quadrant abdomen
::rlz::right lower lung zone
::mrlz::medial right lower lung zone 
::prlz::peripheral right lower lung zone 
::mllz::left retrocardiac region
::pllz::peripheral left lower lung zone 
::rmz::right middle lung zone
::prmz::peripheral right middle lung zone
::mrmz::right perihilar region
::rbz::right basal lung zone
::rn::regenerative nodule
::rns::regenerative nodules
::dn::drain
::dns::drains
::dn::dysplastic nodule
::dns::dysplastic nodules
::rp::Retrograde pyelography shows
::rpul::retropulsion
::rmt::retromollar trigone
::rosc::return of spontaneous circulation
::fom::floor of mouth
:c1:ro::R/O
::rs::rectosigmoid
::rsj::rectosigmoid junction
::rup::rupture
::ic::intracranial
::ice::ileocecal
::icv::ileocecal valve
::rw::rightward
::lw::leftward
::uw::upward
::dw::downward



::ates::subsegmental atelectasis
::sate::subsegmental atelectasis
::ated::dependent atelectasis
::sasis::subsegmental atelectasis
::s0::{HOME}- no definite rhinosinusitis change.
::sa::Standing abdomen shows
::sal::salivary
::sar::subarticular
::sb::small bowel
::sbl::small bowel loops
::sbt::Sengstaken-Blakemore tube
::sc::sigmoid colon
::sc::spinal canal
::scat::scattered
::sco::scoliosis of the spine
;::sco::Smooth, S-shaped spinal curvature of thoracic and lumbar spine
::scoa::Asymmetry of the thoracolumbar spine
::scob::Scoliosis of the thoracolumbar spine
::scp::scalp
;::scs::spinal canal stenosis
::scs::canal stenosis
::scn::spinal canal narrowing
::sct::CT correlation is advised.
::sec::splenectomy
::skd::surgical skull defect
::ssd::surgical skull defect
::sdn::surgical drain
::sdns::surgical drains
::sd::surgical defect
::sds::surgical defects
::se::subcutaneous emphysema
::cse::chest wall subcutaneous emphysema
::seg::segment
::segl::segmental
::sen::sensitive
::seq::sequence
::sev::severe
::sf::superficial
::sht::shunt tubing
::drt::drainage tubing
;::sig::significant
::sig::sigmoid
::sit::subpleural interstitial thickening
::sg::Swan-Ganz catheter
::sgl::Swan-Ganz catheter implantation with the tip in left pulmonary artery 
::sgr::Swan-Ganz catheter implantation with the tip in right pulmonary artery
;::sh::shaft
::sh::scalp hematoma
;::si::signal intensity
::si::signal
::sic::signal intensity change
::sihi::hyperintensity
::sim::superimposed on
::slv::small lung volume
::hmg::hepatomegaly
::hsmg::hepatosplenomegaly
::smg::splenomegaly
::ssel::superselective
::hs::hyperintensity
::hse::hyperintense
::hss::hyperintensities
::hsi::hyperintensity
::hisi::hyperintensity
::silo::hypointensity
::lsi::hypointensity
::ls::hypointensity
::lse::hypointense
::lss::hypointensities
::isi::isointensity
::ise::isointense
::ide::isodense
::shd::shadow
::shds::shadows
::sho::shoulder
::sij::sacroiliac joint
::sijs::sacroiliac joints
::osi::obliteration of sacroiliac joints
::sil::silhouette
::sild::silhouetted
::sl::slight
::sli::slight
::sly::slightly
::sk::skull
::skb::skull base
;::sm::surgical material
::sao::small amount of
::mao::moderate amount of
::lao::large amount of
::sm::small
::smc::small-caliber
::sis::smaller in size
::sn::Schmorl's node
;:c1:sp::S/P
::sp::status post
::sos::suboptimal study
::sol::solid organ laceration
::spa::spinal accessory
::spe::specific
::spi::spinal
::spur::osteophyte
::spu::osteophyte
::spon::spondylosis
::spo::spondylosis
::sten::supratentorial
::iten::infratentorial
::scl::sclerotic
::sch::sclerotic change
::scla::supraclavicular
::srs::splenorenal shunt
::ss::shows
;::ss::sternal staples
::ss::scalp swelling
::st::soft tissue
::ste::stenosis
::sti::soft tissue infiltration
::sta::surgical stapling
::asta::abdominal wall surgical staples
::csta::chest wall surgical staples
::ast::abdominal wall surgical stapling
::cst::chest wall surgical stapling
::stat::stationary
::sts::soft tissue swelling
::std::soft tissue density
::stu::study
::ssw::subcutaneous swelling
::stru::structure
::subco::subcortical
::subcu::subcutaneous
::subc::subcutaneous
::suba::subarachnoid
::subd::subdural
::subf::subfalcine
::subg::subgaleal
::sfal::subfalcine
::subh::subhepatic
::subl::sublingual
::slin::sublingual
::subm::submandibular
::sman::submandibular
::sop::suboptimal
::sto::stomach
::stt::stent
::stg::stenting
::subp::subpleural
::subph::subphrenic
::subt::subtentorial
::sus::suspicious
::susc::susceptibility
::sut::subtotal
::sv::splenic varices
::svl::Small volume lungs.
::svl::Poor inspiratory effort.
::srlv::small right lung volume
::sllv::small left lung volume
::slv::small lung volume
::sur::surgical
::svd::small vessel disease
::sys::system
::swe::swelling
::bsys::biliary system
::csys::collecting system
::usys::urinary system
::pcsys::pelvicalyceal system
::csvd::cerebral small vessel disease
::syl::sylvian
::sw::swelling
::swi::sternostomy wiring
::siw::side wall
:c:SWI::SWI
::swi::susceptibility weighted images
::sclv::subclavicular
::scla::subclavian


::t::tracheostomy tubing
::t::subcutaneous swelling
::tael::embolic materials in the liver
::t2l::{HOME}- scattered foci of varying size demonstrating high signal intensity on long TR images. 
::t1wi::T1WI
::t1hi::T1 hyperintensity
::t1his::T1 hyperintensities
::t1lo::T1 hypointensity
::t2wi::T2WI
::t2hi::T2 hyperintensity
::t2hse::T2 hyperintense
::t2lse::T2 hypointense
::t2his::T2 hyperintensities
::t2lo::T2 hypointensity
::t1iso::T1 isointensity
::t2iso::T2 isointensity
::t1hse::T1 hyperintense
::t1lse::T1 hypointense
:c:TB::TB
::tb::tuberculosis
::tci::territorial cortical infarct
::tcu::transcutaneous
::td::tendon
::thru::through
::tin::territorial infarct
::ter::territory
::terr::territories
:c:TFCC::TFCC
::tfcc::triangular fibrocartilage complex
::thk::thickening
::ithk::interstitial thickening
::iinf::interstitial infiltration
::iit::intralobular interstitial thickening
::ist::interlobular septal thickening
::sit::subpleural interstitial thickening
::siit::subpleural intralobular interstitial thickening
::st::septal thickening
::pit::peribronchovascular interstitial thickening
::tbsis::traction bronchiectasis
::st::septal thickening
::wthk::wall thickening
::wsw::wall swelling
::mthk::mucosal thickening
::tgdc::thyroglossal duct cyst
::thn::thinning
::thr::total hip arthroplasty
::thr2::unipolar hip hemiarthroplasty
::ti::there is
::ta::there are
::tkr::total knee arthroplasty
::tl::thoracolumbar
::tmj::temporomandibular joint
::tor::tortuous
::tps::transpedicular screw
::tym::tympanic
::etym::epitympanum
::mtym::mesotympanum
::htym::hypotympanum
;::ps::pedicle screw
::pss::pedicle screws
::fc::fusion cage
::fcs::fusion cages
::tp::transition point
::tr::tumor recurrence
::tr::<tentative report (初步報告)>
::trans::transverse
::ts::thecal sac
::tsm::too small to be characterized
::tt::torus tubarius
::ttl::to the left
::ttr::to the right
::ttu::T-tube
::tu::tubing
::tub::tubing
::tur::transurethral resection
::turbt::transurethral resection of bladder tumor
::trup::transurethral resection of prostate
::tw::thick-walled 
::tx::treatment
::txx::transplantation
::typ::typical
::aty::atypical
::atyp::atypical

::u::ureter
::uu::ureters
::ual::ureteral
::utb::fibronodular upper lung infiltrate
::utbr::fibronodular upper lung infiltrate on the right
::utbl::fibronodular upper lung infiltrate on the left
::u0::{HOME}- no definite abnormality in the imaged urinary system.
::um::umbilicus
::umb::umbilical
::unc::uncinate
::unp::uncinate process
::upj::ureteropelvic junction
::upp::upper
::ure::unremarkable
::us::ultrasound
::uvj::ureterovesical junction
::uri::urinary
::ut::uterus
::utm::uterine myoma
::uth::urothelial
:c:UTI::UTI
::uti::urinary tract infection
::ute::uterine
::vuf::vesicoureteral reflux
::ger::gastroesophageal reflux
::tinnitus::{HOME}- tortuous course of the left AICA at left pontocerebellar cistern with a suspicious vascular ring formation near left 8th nerve. 
::tra::tracheostomy tube
::tos::tracheostomy
::trang::tracheostomy, nasogastric tube
::ty::tiny

::v5::{HOME}- prominent cavum septum pellucidum.
::v6::{HOME}- prominent cavum velum interpositum.
::v56::{HOME}- prominent cavum septum pellucidum and cavum velum interpositum.
::vac::vacuum
::var::varices
::vas::vascular
::hva::hypervascular
::hvas::hypervascular
::lvas::hypovascular
::vb::vertebral body
::vba::vertebrobasilar arteries
::vbd::vertebrobasilar dolichoectasia
::vbs::vertebral bodies
::vc::vertebral collapse
::vcs::vertebral collapses
::ve::ventricle
::ven::ventricular
::ves::ventricles
::ver::vertebral
::vhem::fatty signal intensity throughout the vertebral body with linear low signal striations due to thickened trabeculae.
::vhl::von Hippel-Lindau
::vis::visualized
::vol::volume
::vl::volume loss
::vm::ventriculomegaly
:c:VP::VP
::vp::vertebroplasty
::vsl::vessel
::vsls::vessels
::vt::viable tumor
::vts::viable tumors
::lvt::local viable tumor
::lvts::local viable tumor
::vu::vesicoureteral
::vur::vesicoureteral reflux


::wd::well-demarcated
::wed::wedge-shaped
::weng::wall enhancing
::wenh::wall enhancement
::wi::within
::wo::without
::woo::without obvious
::wm::white matter
::wme::white matter edema
::wmh::white matter hyperintensity
::wnl::within normal limit
::wt::wall thickening
::xg::suggesting
::xin::suggesting
::xed::suggested
::xd::suggested
::xc::Clinical correlation is advised
::xt::Suggest clinical correlation to rule out small hemorrhage or trace fracture
::xcf::Clinical correlation and follow up is advised
::xct::Suggest CT correlation
::xent::Suggest ENT local finding correlation
::xgyn::GYN correlation is advised
::xf::Follow up is advised
::xfu::Follow up is advised
::xpes::Suggest PES correlation.
::xercp::Suggest ERCP correlation.
::xmr::Suggest MRI correlation
::xus::Suggest ultrasound correlation
::x::suggest
::xv::suggestive of
::xo::(Please correlate with imaging reports of other body parts.)
::y::cyst
::yc::cystic
::yy::cysts
::ys::cysts
::ych::cystic change
::ytis::cystitis
::yle::cystic lesion
::yles::cystic lesions
::cle::cystic lesion
::cles::cystic lesions
::z::measuring approximately
::zsa::with short-axis diameter of
::za::zygomatic arch
::zmm::mm in size
::zcm::cm in size
::zyg::zygomatic

; plain film

;::cam::enlarged cardiac shadow
::copd::hyperinflation with chronic infiltration over bilateral lungs, COPD is compatible.
:c:II::II
::ii::increased infiltration
::iin::increased infiltration
::ini::interstitial infiltration
::inn::increased infiltration
::pbc::peribroncial cuffing
::bvm::blurring of vessel margins
::bv::blurring of vessel margins

:c:AP::AP
:c:PA::PA
::ap::Chest AP shows
::pa::Chest PA shows
::cx::Chest shows
::cx0::Chest shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear.
::cxx::Chest shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear.
::pa0::Chest PA shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear.
;::pa0::Chest PA shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are symmetrically expanded with clear lung fields
::pa1::Chest shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp
::ap1::Chest shows normal cardiac size, air-space shadows in bilateral lungs
::ap2::Chest shows borderline cardiac size, air-space shadows in bilateral lungs
::ap3::Chest shows enlarged cardiac shadow, air-space shadows in bilateral lungs

!,::SendInput S/P `
!.::SendInput R/O `
!0::SendInput, Chest radiograph shows normal heart size. `
!1::SendInput, Chest radiograph shows normal cardiac size. `
!2::SendInput, Chest radiograph shows borderline cardiac size. `
!3::SendInput, Chest radiograph shows enlarged cardiac shadow. `
!4::SendInput, Placement of endotracheal tube, gastric tube, central catheter. `
!5::SendInput, Placement of endotracheal tube, gastric tube, central catheter, `
!7::SendInput Right pleural effusion. `
!8::SendInput Bilateral pleural effusion. `
!9::SendInput Left pleural effusion. `
!Delete::SendInput Increased bowel gas in right lower abdomen. `
!End::SendInput Increased bowel gas in lower abdomen. `
!Home::SendInput Increased bowel gas in upper abdomen. `
!Insert::SendInput Increased bowel gas in right upper abdomen. `
!PgDn::SendInput Increased bowel gas in left lower abdomen. `
!PgUp::SendInput Increased bowel gas in left upper abdomen. `
!a::SendInput, Chest radiograph shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. The lungs are clear. `
!b::SendInput, Bone structures are anatomic in alignment. No obvious fracture or dislocation. `
!c::SendInput, Sharp costophrenic sulci. `
!e::SendInput, Emphysematous lung change. `
;!e::SendInput, Emphysematous change over both lungs. `
!f::SendInput, Fecal material in the colon. `
!g::SendInput, Placement of gastric tube. `
!h::SendInput, Bilateral perihilar infiltrates. `
;!h::SendInput, Increased infiltration in perihilar areas. `
!i::SendInput, Spondylosis with marginal osteophytes. `
!j::SendInput, Lung opacity in `
!k::SendInput, Abdomen/KUB shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is noted. `
!l::SendInput, No definite lung lesion. `
!m::SendInput, Mediastinal widening. `
!n::SendInput, Fine alignment of spinal curve. No obvious fracture or dislocation. Preserved disc spaces. No obvious prevertebral soft tisue swelling. Patent airways. `
!o::SendInput, Postoperative change at `
!p::SendInput, Placement of `
!q::SendInput, Surgical material placement in `
;!q::SendInput, {Esc}
!s::SendInput, Scoliosis of the spine. `
!t::SendInput, An atherosclerotic partially calcified tortuous aorta. `
!u::SendInput, Unremarkable bowel gas pattern. No definite free air. `
!v::SendInput, Bilateral lung opacities. `
!w::SendInput, Partial wall calcification of the aorta. `
;!w::SendInput, An atherosclerotic partially calcified aortic knob. `
!x::SendInput, Suggest clinical correlation. `
!y::SendInput, Bilateral lung infiltrate. `
!z::SendInput, Central catheter placement. `

;!h::SendInput Normal heart size. `
;!l::SendInput, Lumbar spine shows fine alignment of lumbar spine. No obvious fracture or dislocation. Preserved disc spaces. `
;!q::SendInput, Chest radiograph shows normal cardiomediastinal silhouette. The costophrenic sulci are sharp. `
;!s::SendInput, Abdomen/KUB shows unremarkable bowel gas pattern. There is no evidence of free intraperitoneal air. No abnormal gas distribution is seen. No abnormal calcification is seen.{F3}
TAB::SendInput, {HOME}- `

^1::SendInput {HOME}1. `
^2::SendInput {HOME}2. `
^3::SendInput {HOME}3. `
^4::SendInput {HOME}4. `
^5::SendInput {HOME}5. `
^6::SendInput {HOME}6. `
^7::SendInput {HOME}7. `
^8::SendInput {HOME}8. `
^9::SendInput {HOME}9. `
^0::SendInput {HOME}10. `

^Del::SendInput {Shift Down}{Ctrl Down}{Right}{Ctrl Up}{Shift Up}{Del}
^Backspace::SendInput {Shift Down}{Ctrl Down}{Left}{Ctrl Up}{Shift Up}{Del}
^w::SendInput {Shift Down}{Ctrl Down}{Left}{Ctrl Up}{Shift Up}
^s::SendInput {Shift Down}{Ctrl Down}{Right}{Ctrl Up}{Shift Up}{Del}
^d::SendInput {Del}
;^w::SendInput {Shift Down}{Ctrl Down}{Left}{Ctrl Up}{Shift Up}{Del}
^e::SendInput {Shift Down}{End}{Shift Up}
^f::SendInput {Ctrl Down}{Right}{Ctrl Up}
^b::SendInput {Ctrl Down}{Left}{Ctrl Up}
^l::reload
^q::SendInput {Home}{Shift Down}{Ctrl Down}{Right 2}{Ctrl Up}{Shift Up}- {Down}
^r::SendInput {Home}{Shift Down}{Ctrl Down}{Right 1}{Ctrl Up}{Shift Up}- {Down}

+Enter::SendInput {Home}{Enter}{Up}

::pabh::Chest shows borderline heart size. The costophrenic sulci are sharp. The lungs are clear
::pacm::Chest shows enlarged cardiac size. The costophrenic sulci are sharp. The lungs are clear

::icu1::normal cardiac size, air-space shadows at bilateral lungs, blurring of bilateral costophrenic angles
::icu2::borderline cardiac size, air-space shadows at bilateral lungs, blurring of bilateral costophrenic angles
::icu3::enlarged cardiac shadow, air-space shadows at bilateral lungs, blurring of bilateral costophrenic angles

; intussusception
::intu::Lower GI barium enema study and reduction were performed for suspect intussusception. Initially, patients are immobilized and a large-bore rubber catheter is inserted into the rectum. The buttocks are taped firmly around this catheter. A plastic bag is filled with barium, and the "rule of threes" is followed. Barium is suspended 3 feet above the table, three attempts are performed at reduction, and 3 minutes are allowed per attempt. Transient holdups of barium may occur, particularly in the cecum. If no progress occurs after 3-5 minutes, barium is siphoned out by lowering the plastic reservoir bag to the floor and allowing the infant to evacuate. The enema may be restarted following this evacuation. Attempts at hydrostatic reduction are terminated following three attempts if successful reduction has not occurred. The hallmark of successful intussusception reduction is the free flow of barium into the terminal ileum. A postcvacuation radiograph should be obtained to document successful hydrostatic reduction.

; fracture fixation
::nail::intramedullary nail
::mp::metallic plate
::lp::locking plate
::tf::transfixed with
;::tib::tibial
::tib::tree-in-bud
::fi::fibular
::ul::ulnar
::ra::radial
:c:HU::HU
::hu::hydroureter
::hum::humeral
::hun::humeral neck
::huh::humeral head
::hus::humeral shaft
::fe::femoral
::feh::femoral head
::fen::femoral neck
::fes::femoral shaft
::fem::femur
::ma::surgical material
::ma::malleolar

;:c0:vp::Vertebroplasty was performed smoothly via left transpedicular approach shows compression fracture at the L1 vertebral body. Bone cement was injected into the L1 vertebral body with partial restoration of the vertebral height. There was no definite leakage of the bone cement during the procedure and the patient tolerated the procedure well. Compression fracture of L2 vertebral body, s/p VP.
;::vps::Vertebroplasty was performed smoothly via left transpedicular approach shows compression fracture at the T12 and L1 vertebral bodies. Bone cement was injected into the T12 and L1 vertebral bodies with partial restoration of the vertebral height. There was no definite leakage of the bone cement during the procedure and the patient tolerated the procedure well. Compression fracture at T12 and L1 vertebral bodies, s/p VP.
::vps::ventriculoperitoneal shunt tubing
::bmd::
  MsgBox, 4, , Lumbar?
  IfMsgBox Yes
    location = lumbar spine from L2 to L4
  else
    location = proximal femur

  InputBox, T, T score,,,100,120
  InputBox, Z, Z score,,,100,120

  if (T < -2.5)
    Dx = Osteoporosis
  else if (T > -1)
    Dx = Normal
  else
    Dx = Osteopenia

  SetTitleMatchMode 2
  WinActivate, 檢查報告, 
  Sleep 100
  SendInput,
  (
Quantification of the bone mineral density (BMD) at %location% was performed by the technique known as Dual-Energy-X-Ray absorptiometry (DXA).

  The T Score: %T%
  The Z Score: %Z%

Impression: %Dx%
  )
return

::boneage::
  InputBox, bioage, 實際年齡(f6y5m),,, 150, 120
  InputBox, boneage, Bone age,,, 100, 120
  
  RegExMatch(bioage, "(\S)(\d*)y(\d*)m", bio)
  if (bio3 <= 6)
    bioage = %bio1%%bio2%
  else
    bioage = %bio1%%bio2%.5

  RegExMatch(boneage, "(\d*)y(\d*)m", bone)

  if (bioage = "f1")
  {
    age1 = 1 y/o
    age2 = 1.5 y/o
    sd1 = 2.7m
    sd2 = 3.4m
  }
  else if (bioage = "f1.5")
  {
    age1 = 1.5 y/o
    age2 = 2 y/o
    sd1 = 3.4m
    sd2 = 4.0m
  }
  else if (bioage = "f2")
  {
    age1 = 2 y/o
    age2 = 2.5 y/o
    sd1 = 4m
    sd2 = 4.8m
  }
  else if (bioage = "f2.5")
  {
    age1 = 2.5 y/o
    age2 = 3 y/o
    sd1 = 4.8m
    sd2 = 5.6m
  }
  else if (bioage = "f3")
  {
    age1 = 3 y/o
    age2 = 3.5 y/o
    sd1 = 5.6m
    sd2 = 6.5m
  }
  else if (bioage = "f3.5")
  {
    age1 = 3.5 y/o
    age2 = 4 y/o
    sd1 = 6.5m
    sd2 = 7.2m
  }
  else if (bioage = "f4")
  {
    age1 = 4 y/o
    age2 = 4.5 y/o
    sd1 = 7.2m
    sd2 = 8m
  }
  else if (bioage = "f4.5")
  {
    age1 = 4.5 y/o
    age2 = 5 y/o
    sd1 = 8m
    sd2 = 8.6m
  }
  else if (bioage = "f5")
  {
    age1 = 5 y/o
    age2 = 5.5 y/o
    sd1 = 8.6m
    sd2 = 8.9m
  }
  else if (bioage = "f5.5")
  {
    age1 = 5.5 y/o
    age2 = 6 y/o
    sd1 = 8.9m
    sd2 = 9m
  }
  else if (bioage = "f6" || bioage = "f6.5")
  {
    age1 = 6 y/o
    age2 = 7 y/o
    sd1 = 9m
    sd2 = 8.3m
  }
  else if (bioage = "f7" || bioage = "f7.5")
  {
    age1 = 7 y/o
    age2 = 8 y/o
    sd1 = 8.3m
    sd2 = 8.3m
  }
  else if (bioage = "f8" || bioage = "f8.5")
  {
    age1 = 8 y/o
    age2 = 9 y/o
    sd1 = 8.3m
    sd2 = 9.3m
  }
  else if (bioage = "f9" || bioage = "f9.5")
  {
    age1 = 9 y/o
    age2 = 10 y/o
    sd1 = 9.3m
    sd2 = 10.8m
  }
  else if (bioage = "f10" || bioage = "f10.5")
  {
    age1 = 10 y/o
    age2 = 11 y/o
    sd1 = 10.8m
    sd2 = 12.3m
  }
  else if (bioage = "f11" || bioage = "f11.5")
  {
    age1 = 11 y/o
    age2 = 12 y/o
    sd1 = 12.3m
    sd2 = 14m
  }
  else if (bioage = "f12" || bioage = "f12.5")
  {
    age1 = 12 y/o
    age2 = 13 y/o
    sd1 = 14m
    sd2 = 14.6m
  }
  else if (bioage = "f13" || bioage = "f13.5")
  {
    age1 = 13 y/o
    age2 = 14 y/o
    sd1 = 14.6m
    sd2 = 12.6m
  }
  else if (bioage = "f14" || bioage = "f14.5")
  {
    age1 = 14 y/o
    age2 = 15 y/o
    sd1 = 12.6m
    sd2 = 11.2m
  }
  else if (bioage = "f15" || bioage = "f15.5")
  {
    age1 = 15 y/o
    age2 = N/A
    sd1 = 11.2m
    sd2 = N/A
  }
  else if (bioage = "m1")
  {
    age1 = 1 y/o
    age2 = 1.5 y/o
    sd1 = 2.1m
    sd2 = 2.7m
  }
  else if (bioage = "m1.5")
  {
    age1 = 1.5 y/o
    age2 = 2 y/o
    sd1 = 2.7m
    sd2 = 4m
  }
  else if (bioage = "m2")
  {
    age1 = 2 y/o
    age2 = 2.5 y/o
    sd1 = 4m
    sd2 = 5.4m
  }
  else if (bioage = "m2.5")
  {
    age1 = 2.5 y/o
    age2 = 3 y/o
    sd1 = 5.4m
    sd2 = 6m
  }
  else if (bioage = "m3")
  {
    age1 = 3 y/o
    age2 = 3.5 y/o
    sd1 = 6m
    sd2 = 6.6m
  }
  else if (bioage = "m3.5")
  {
    age1 = 3.5 y/o
    age2 = 4 y/o
    sd1 = 6.6m
    sd2 = 7m
  }
  else if (bioage = "m4")
  {
    age1 = 4 y/o
    age2 = 4.5 y/o
    sd1 = 7m
    sd2 = 7.8m
  }
  else if (bioage = "m4.5")
  {
    age1 = 4.5 y/o
    age2 = 5 y/o
    sd1 = 7.8m
    sd2 = 8.4m
  }
  else if (bioage = "m5")
  {
    age1 = 5 y/o
    age2 = 5.5 y/o
    sd1 = 8.4m
    sd2 = 9.1m
  }
  else if (bioage = "m5.5")
  {
    age1 = 5.5 y/o
    age2 = 6 y/o
    sd1 = 9.1m
    sd2 = 9.3m
  }
  else if (bioage = "m6" || bioage = "m6.5")
  {
    age1 = 6 y/o
    age2 = 7 y/o
    sd1 = 9.3m
    sd2 = 10.1m
  }
  else if (bioage = "m7" || bioage = "m7.5")
  {
    age1 = 7 y/o
    age2 = 8 y/o
    sd1 = 10.1m
    sd2 = 10.8m
  }
  else if (bioage = "m8" || bioage = "m8.5")
  {
    age1 = 8 y/o
    age2 = 9 y/o
    sd1 = 10.8m
    sd2 = 11m
  }
  else if (bioage = "m9" || bioage = "m9.5")
  {
    age1 = 9 y/o
    age2 = 10 y/o
    sd1 = 11m
    sd2 = 11.4m
  }
  else if (bioage = "m10" || bioage = "m10.5")
  {
    age1 = 10 y/o
    age2 = 11 y/o
    sd1 = 11.4m
    sd2 = 10.5m
  }
  else if (bioage = "m11" || bioage = "m11.5")
  {
    age1 = 11 y/o
    age2 = 12 y/o
    sd1 = 10.5m
    sd2 = 10.4m
  }
  else if (bioage = "m12" || bioage = "m12.5")
  {
    age1 = 12 y/o
    age2 = 13 y/o
    sd1 = 10.4m
    sd2 = 11.1m
  }
  else if (bioage = "m13" || bioage = "m13.5")
  {
    age1 = 13 y/o
    age2 = 14 y/o
    sd1 = 11.1m
    sd2 = 12.0m
  }
  else if (bioage = "m14" || bioage = "m14.5")
  {
    age1 = 14 y/o
    age2 = 15 y/o
    sd1 = 12.0m
    sd2 = 14.2m
  }
  else if (bioage = "m15" || bioage = "m15.5")
  {
    age1 = 15 y/o
    age2 = N/A
    sd1 = 14.2m
    sd2 = N/A
  }
  WinActivate, 檢查報告, 
  SendInput,
(
Chronological age: %bio2%y%bio3%m
Examed Skeletal bone age: %boneage%

Standard deviation of %age1%: %sd1%
Standard deviation of %age2%: %sd2%
)
return

::angioa::
(
Angiography of celiac and superior mesenteric arteries was performed smoothly via right transfemoral approach and shows:
- S/P cholecystectomy with metallic clips at hepatic hilum.
2. cork-screw change of intrahepatic vessels, indicating mild cirrhotic change.
3. a hypervascular tumor stain at medial segment of left hepatic lobe.
4. patent portal veins.
TAE was performed with catheter tip in the proper hepatic artery. 40mg doxorubicin, 5cc lipiodol, and gelfoam were introduced till the flow stasis.
Suggest: 1. check liver function.  2. F/U CT one week later." 
)

::angion::
(
Diagnostic angiography with bilateral CCAs and left VA injection was performed smoothly via right femoral approach and shows:
- no definite vascular abnormality in this study.
- an small saccular aneurysm, sized 3.2mm, pointing posteromedially at right posterior communicating artery.
- an small saccular aneurysm, sized 3.2mm, pointing anteromedially at right anterior communicating artery.
- no evidence of vasospasm.
- a hypervascular tumor stain with homogenous enhancement in upper portion of left hepatic lobe of liver supplied by left hepatic artery.
- no definite venous abnormality.
)

::avmmr::
(
Head MRI without and with contrast enhancement shows:
- a cluster of engorged vessels in left anteroinferior frontal lobe with numerous engorged  adjacent cortical, deep drainage veins. The glomus of the AVM is about 7cm. The supplying arteries are from left MCA and ACA
- Adjacent high signal change on long TR sequeces of the brain parenchyma suggests gliosis.
- no definite evidence of intracranial hemorrahge.
- no definite area of diffusion restriction on the DWI study.
- a large AVM (>6cm), left anterior frontal, with superficial and deep vein drainage.
- No significant evidence of previous bleed
)

::BXC::
(
CT guided biopsy of the lung was performed in oblique prone supine position with the use of 19G coaxial guiding needle and 20 G automatic biopsy needle. 
 - indication of biopsy: lung mass
 - size of the lesion:
 - location of the lesion:
 - emphysema: no
 - total length of the needle from skin to lesion:  cm
 - total length of the needle traversing lung:  cm
 - number of coaxial needle pass: 1
 - number of cutting for biopsy needle: 3
 - pneumothorax: minimal
 - hemorrhage: no
 - hemoptysis: no
 - vital signs after biopsy: stable
 - recommanded position after biopsy: supine
 - There were total 3 tissue stripes and 5 imprint smears obtained for pathology and cytology. Suggest complete bed rest with puncture site at dependent position and follow up chest radiography 4 hours after biopsy.
)

::CHOLE::
(
HRCT for temporal bones without contrast enhancement:
- retraction of left tympanic membrane with abnormal soft tissue opacity filled in the left tympanic cavity, accompanied by bony erosion of the malleus, incus and stapes head (mainly the incus). Cholesteatoma is considered.
- normal appearance of the facial nerve canal and tegmen tympanum
- decreased pneumatization of left mastoid with sclerotic change. chronic mastoiditis change is considered.
- normal appearance of bilateral inner ear bony labyrinthes
- high jugular bulb, right.
- normal appearance of right temporal bone.
)

::cpsct::
(
Non-enhanced sinus CT shows:
- postoperative change from prior endoscopic surgery.
- mucosal thickening at maxillary, ethmoid, sphenoid and frontal sinuses.
- normal aeration of the paranasal sinuses without any evidence of mucosal thickening or air-fluid levels.
- moderate mucosal swelling over all the nasal turbinates. 
- retention cyst present within the right maxillary sinus. 
- soft tissue opacification and non-expansion at maxillary, ethmoid, sphenoid and frontal sinuses.
- polypoid soft tissue masses in maxillary, ethmoid, sphenoid and frontal sinuses.
- thickening and sclerosis of sinus bony walls consistent with chronic osteitis.
- osteomeatal occlusion.
- symmetric and unremarkable bilateral orbits.
- no definite focal lesion at the nasopharynx.
)

::CTDRAIN::
(
* Preprocedure diagnosis
  - Liver abscess.
* Postprocedur diagnosis
  - Status after successful placement of 25cm 8F catheter in liver abscess.
* Procedures performed
  - Limited CT scan of abdomen to localize abscess in the liver.
  - Sono-guided penetration of Chiba needle with aspiration of 5cc pus.
  - CT-guided placement of 25cm 8F catheter into liver asbcess.
* Anesthesia and medication
  - 5ml 1`% lidocaine in soft tissues overlying the target of drainage.
* Description of procedure and findings
  - Informed consent was obtained. The patient was prepped and draped in the usual sterile fasion with monitoring of vital signs. A limited noncontrast CT scan of the abdomen was performed, revealing lobulated liver abscess. The soft tissues of the intercostal space were infiltrated with lidocaine for local anesthesia. Placement of a 25cm 8F pigtail catheter was performed under ultrasonographic guidance, with the loop positioned in the liver abscess. The drainage catheter was secured to the skin with a suture and the exit site was covereed with a dry sterile dressing
  - The patient tolerated the procedure well, with no immediate complications, and was returned to the ER in good condition." Status after successful CT and ultrasonographic guided drainge of liver abscess.
)

::HC0::
(
Head and cervical spine CT study without contrast enhancement shows:
- ventricles, cisterns and sulci of expected size and morphology.
- no obvious intracranial hemorrhage, midline shift, or mass effect.
- no definite abnormal density change in brain parenchyma.
- preserved normal gray-white differentiation.
- no definite osteolytic lesion in calvarial vault.
- skull base within normal limit.
- no definite rhinosinusitis change.
- no definite fracture or subluxation/dislocation at cervical spine.
- paraspinal soft tissue within normal limit.

Suggest clinical correlation to rule out small hemorrhage or trace fracture.
)

;- ventricles, cisterns and sulci of expected size and morphology for the patient's age.


::h00::
(
* Extra axial spaces: normal in size and morphology for the patient's age
* Hemorrhage: none
* Ventricular system: normal in size and morphology for the patient's age
* Basal cisterns: normal
* Cerebral parenchyma: [normal; microvascular changes; infarction; encephalomalacia; gliosis; hemorrhage]
* Midline shift: none
* Cerebellum: normal
* Brainstem: normal
* Calvarium: [normal; non-depressed fracture; depressed fracture; osteolysis; sclerosis]
* Vascular system: [normal* | vascular calcifications (CT) | appropriate arterial and dural sinus flow voids (MR)]
* Visualized Paranasal sinuses: [clear* | scattered mild inflammatory mucosal thickening]
* Visualized Orbits: normal
* Visualized upper cervical spine: normal
* Sella and skull base: [normal* | partially empty sella | left/right mastoid air cell fluid]
)

::hcta::
(
Head CT study without contrast enhancement shows: 
- Ventricles, cisterns and sulci of expected size and morphology.
- No definite abnormal density change in brain parenchyma.
- No obvious intracranial hemorrhage, midline shift, or mass effect.
- Preserved normal gray-white differentiation.
- No definite osteolytic lesion in calvarial vault.
- Skull base within normal limit.
- No definite rhinosinusitis change.
)


::hctb::
(
Head CT study with contrast enhancement shows: 
- no obvious abnormal enhancement or density change in brain parenchyma.
- ventricles, cisterns and sulci of expected size and morphology.
- no obvious intracranial hemorrhage, midline shift, or mass effect.
- preserved normal gray-white differentiation.
- no definite osteolytic lesion in calvarial vault.
- skull base within normal limit.
- no definite rhinosinusitis change.
)

::hctc::
(
Head CT study without and with contrast enhancement shows: 
- No obvious abnormal enhancement or density change in brain parenchyma.
- Ventricles, cisterns and sulci of expected size and morphology.
- No obvious intracranial hemorrhage, midline shift, or mass effect.
- Preserved normal gray-white differentiation.
- No definite osteolytic lesion in calvarial vault.
- Skull base within normal limit.
- No definite rhinosinusitis change.
)


::hmrc::
(
MRI study of the head without and with contrast enhancement shows:
- No obvious abnormal enhancement or signal change in brain parenchyma.
- Ventricles and sulci of expected size and morphology.
- No obvious intracranial hemorrhage, midline shift, or mass effect.
- No definite abnormal restriction on diffusion study.
- No evidence of major vascular abnormality on MRA study.
- No definite calvarial vault lesion.
- Skull base within normal limit.
- No definite rhinosinusitis change.
)


::hmra::
(
MRI study of the head without contrast enhancement shows:
- No obvious abnormal signal change in brain parenchyma.
- Ventricles and sulci of expected size and morphology.
- No obvious intracranial hemorrhage, midline shift, or mass effect.
- No definite abnormal restriction on diffusion study.
- No evidence of major vascular abnormality on MRA study.
- No definite calvarial vault lesion.
- Skull base within normal limit.
- No definite rhinosinusitis change.
)

::hmrb::
(
MRI study of the head with contrast enhancement shows:
- no obvious abnormal enhancement or signal change in brain parenchyma.
- ventricles and sulci of expected size and morphology.
- no obvious intracranial hemorrhage, midline shift, or mass effect.
- no definite abnormal restriction on diffusion study.
- no evidence of major vascular abnormality on MRA study.
- no definite calvarial vault lesion.
- skull base within normal limit.
- no definite rhinosinusitis change.
)

::spmra::
(
MRI of the spine without IV contrast enhancement shows:
1. normal alignment of the spine with fine hydration of the intervertebral discs.
2. no obvious evidence of intervertebral disc herniation or neural foraminal narrowing.
3. no evidence of abnormal signal lesion in the spinal cord.
)

::hipmra::
(
MRI of the both hips without IV contrast enhancement shows:
1. minimal effusions in the both hip joint spaces.
2. no evidence of abnormal signal lesion at the visible bony and muscular structures.
)

::infarctmr::
(
MRI study of the head without and with contrast enhancement shows:
- multiple focal area of restricted diffusion and abnormal T2 hyperintensity at left frontal-parietal junction, left insula, bilateral cerebellum and pons. Enhancement is noted at the lesion in frontal-parietal area. 
- multifocal stenosis in bilateral ICA.
- ventricles, cisterns and sulci are symmetric and normal in size.
- no definite thickening mucosa of paranasal sinuses.
)

::intu::
(
The 1 y/o male baby was suspected to have intussusception. Barium exam and reduction were performed smoothly. A cupping at T-colon was found. The barium enema prolapsed the lobulated filling defect and sustained for a long period. After barium past the ileocecal valve, the examination was completed.
After repeating 3 trials, the barium refluxed to the terminal ileum uneventfully, but a suspected lobulated filling defect in the middle distal ileum was noted and its nature is to be determined.
Impression : Ileocolic/ colocolic intussusception. Barium reduction was achieved.
)

:c:IVU::IVU
::ivu::
(
KUB and IVU shows:
- normal enhancement of bilateral kidneys with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of bilateral collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impression: No definite obstructive lesion in this study.
)

::ivur::
(
KUB and IVU shows:
- 
- normal enhancement of left kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of left-sided collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impression: Right  stone.
)

::ivul::
(
KUB and IVU shows:
- 
- normal enhancement of right kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of right-sided collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impression: Left  stone.
)

::ivurk::
(
KUB and IVU shows:
- opaque density superimposed on right kidney, consistent with right renal stone.
- normal enhancement of left kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of left-sided collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impresssion: Right renal stone.
)

::ivulk::
(
KUB and IVU shows:
- opaque density superimposed on left kidney, consistent with left renal stone.
- normal enhancement of right kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of right collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impresssion: Left renal stone.
)

::ivuru::
(
KUB and IVU shows:
- opaque filling defect in right ureter with proximal collecting system dilatation, consistent with right ureteral stone.
- normal enhancement of left kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of left-sided collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impresssion: Right ureteral stone.
)

::ivulu::
(
KUB and IVU shows:
- opaque filling defect in left ureter with proximal collecting system dilatation, consistent with left ureteral stone.
- normal enhancement of right kidney with size, shape and axis within normal limit.
- no definite dilatation, filling defect or obstruction of right collecting system.
- well-distended urinary bladder with smooth contour. 
- several phlebolithes at pelvic cavity.
- The postvoiding film reveals significant residual urine. The lateral film reveals marked indentation on the bladder floor. There is also hooking of bilateral ureters on the delayed films. All of these pictures are compatible with enlarged prostate gland.

Impresssion: Left ureteral stone.
)

:c:LGI::LGI
::lgi::
(
Lower GI barium study under the fluoroscopic control shows:
- no definite filling defect or obstructive lesions noted.
- normal haustration, caliber and profile of the lower GI tract.
- no widening of the presacral space.
- the ileocecal valve is patent.
- the appendix is demonstrated.
)

::macromr::There is a large intrasellar mass lesion producing diffuse expansion of the sella turcica.  This mass lesions measures approximately 16 x 18 x 18mm (craniocaudal x AP x mediolateral) in size.   The lesion extends into the left cavernous sinus along the inferior edge of the C3 segment of the left cavernous carotid artery obscuring the left cranial nerves III, IV and VI.  The V1 and V2 branches however can be identified.  There is intense enhancement of this lesion following gadolinium augmentation. There is a focal central area of nonenhancement which measures approximately 4mm in diameter.  There is right-sided deviation of the infundibulum with mild convex bowing of this mass lesion into the suprasellar cistern, however, there is no impingement upon the optic chiasm.  There is pressure erosion of the floor of the sella turcica bulging into the sphenoid sinus without a demonstrated cortical destruction or invasion of the sphenoid sinus.


::mrcsp::
(
MRI of cervical spine without contrast enhancement shows:
- normal alignment of the cervical spine without malalignment of the vertebrae, marrow edema or compression abnormalities.
- cervical spondylosis with marginal osteophytes formation and bulging disc at C4-7 level with mild narrowing of thecal sac.
- block vertebrae, C3-4.
- no evidence of intrathecal lesion. 
- no focal SI change in the imaged spinal cord.
- normal brainstem and cervical cord junction. Normal cisterna magna with no tonsillar ectopia.  
)

::mrkl::
(
MRI of the left knee without IV contrast enhancement shows:
- grade 1-2 injury of the medial collateral ligament with increased SI at its upper portion.
- intact anterior and posterior cruciate, and fibular collateral ligaments.
- grade 1 signal at the anterior horn and body of lateral meniscus; no evidence of meniscal tear at the medial meniscus.
- mild increased effusion with synovial proliferation in the suprapatellar bursa.
- no evidence of chondromalacia patellae.
- subchondral contussion marrow edema at the lateral tibial condyle.
- mild effusion in the deep infrapatellar bursa.
- subcutaneous edema at the superficial infrapatellar area.
)

::mrkr::
(
MRI of the right knee without IV contrast enhancement shows:
- grade 1-2 injury of the medial collateral ligament with increased SI at its upper portion.
- intact anterior and posterior cruciate, and fibular collateral ligaments.
- grade 1 signal at the anterior horn and body of lateral meniscus; no evidence of meniscal tear at the medial meniscus.
- mild increased effusion with synovial proliferation in the suprapatellar bursa.
- no evidence of chondromalacia patellae.
- subchondral contussion marrow edema at the lateral tibial condyle.
- mild effusion in the deep infrapatellar bursa.
- subcutaneous edema at the superficial infrapatellar area.
)


::mrls::
(
MRI of the lumbosacral spine without IV contrast enhancement shows:
- slight scoliosis and degenerative change of the lumbar spine with dehydrated discs at multiple levels.
- eccentric protruding disc and focal torn annulus fibrosus at the posterior central to left paracentral area of L1-2 level, causing adjacent thecal sac indentation.
- posterior bulging disc and focal torn annulus fibrosus at the L2-3 level, causing mild central canal stenosis and adjacent thecal sac indentation.
- posterior concentric bulging disc at the L3-4 level with bilateral hypertrophic facet arthropathy and thickened ligamenta flavum, causing central canal stenosis and adjacent thecal sac indentation.
- posterior bulging disc and focal torn annulus fibrosus at the L4-5 level with bilateral hypertrophic facet arthropathy and thickened ligamenta flavum, causing central canal stenosis and adjacent thecal sac indentation.
- no evidence of abnormal signal lesion in the visible spinal cord.
- tiny foci of high SI on T1WI in the thecal sac at the L1 and L5 levels.
)

::mtsmr::
(
Non-contrast head MRI shows:
- hippocampal atrophy on the left side along with mild T1 hypointensity, mild T2 hyperintensity, and loss of the internal architecture as defined by stratum radiatum.
- mild left temporal horn dillatation.
- collateral white matter atrophy, parahippocampal atrophy, temporal lobe atrophy, and atrophy of the fornix and mammilary body on the left side.
- no evidence of acute ischemic infarct on the diffusion study.
- The right hippocampal MRS appears relatively normal.
- The left hippocampal MRS shows decreased NAA:creatine ratios (signifying neuronal loss and/or metabolic dysfunction)."
)

::mtsl::
(
Non-contrast head MRI shows:
- hippocampal atrophy on the left side along with mild T1 hypointensity, mild T2 hyperintensity, and loss of the internal architecture as defined by stratum radiatum.
- mild left temporal horn dillatation.
- collateral white matter atrophy, parahippocampal atrophy, temporal lobe atrophy, and atrophy of the fornix and mammilary body on the left side.
- no evidence of acute ischemic infarct on the diffusion study.
- The right hippocampal MRS appears relatively normal.
- The left hippocampal MRS shows decreased NAA:creatine ratios (signifying neuronal loss and/or metabolic dysfunction)."  compatible with left mesial temporal sclerosis, suggest clinical correlation.
)

::mtsn::
(
MRI study of the head without contrast enhancement shows:
- no obvious size asymmetry or abnormal signal within bialteral hippocampus. 
- ventricles, cisterns and sulci are symmetric and normal in size.
- no evidence of acute ischemic infarct in diffusion study.
- neither abnormal SI change nor pathological enhancement detected at the brain, brainstem and cerebellum.
)

::mtsr::
(
Non-contrast head MRI shows:
- hippocampal atrophy on the right side along with mild T1 hypointensity, mild T2 hyperintensity, and loss of the internal architecture as defined by stratum radiatum.
- mild right temporal horn dillatation.
- collateral white matter atrophy, parahippocampal atrophy, temporal lobe atrophy, and atrophy of the fornix and mammilary body on the right side.
- no evidence of acute ischemic infarct on the diffusion study.
- the left hippocampal MRS appears relatively normal.
- the right hippocampal MRS shows decreased NAA:creatine ratios (signifying neuronal loss and/or metabolic dysfunction)." compatible with right mesial temporal sclerosis, suggest clinical correlation.
)

::comct::
(
Temporal bone HRCT shows:
- abnormal soft tissue density in the left middle ear involving epitympanum, mesotympanum, and hypotympanum, and in left mastoid air cells as well. The auditory ossicles are still relatively intact and not destructed. The overlying tegmen tympani is intact. R/o otitis media with inflammatory debris.
- a large soft-tissue mass fills the middle ear cavity and mastoid antrum. The ossicles are partially eroded and displaced laterally.
- Bilateral cochlea and semicircular canals are well-developed and within normal limit. No abnormal ossification of the labyrinthe. Vestibular aqueducts are not enlarged.
- Bilateral internal auditory canal (IAC) are not abnormally expanded.
)

::sialo::
(
Sialography of right parotid gland was performed smoothly and shows
1. no evidence of radio-oapque stone on the plain film in AP view;
2. smooth outline of the Stenson's duct without apparent filling defects;
3. homogeneous stain in the parotid glandat the parenchymal phase.
4. some contrast stasis at the parotid gland after evacuation.
)

::lgis::
(
Single contrast study of lower GI tract under fluoroscopic control revealed:
- no definite filling defect or obstructive lesion is noted.
- normal haustration, caliber and profile of lower GI tract.
- no definite widening of presacral space.
- the ileocecal valve is patent.
- the appendix is demonstrated.
)

:c:TAE::TAE
::tae::
(
The angiography of celiac and common hepatic a. was smoothly performed via right transfemoral approach and shows:

TACE was smoothly performed with doxorubicin 40mg, Lipiodol 10cc and Gelfoam particle delivered into the proper hepatic artery with a 4-Fr RC-1 catheter until the stasis of blood flow. 

No specific complaints immediately after this TACE.
Please follow up liver function and watch for any possible post-TAE complication. 
Another session of TAE is indicated one month later.
)

:c:TACE::TACE
::tace::
(
The angiography of celiac and hepatic ateries was smoothly performed via right transfemoral approach and shows:
- presence of replaced right hepatic artery.
- right portal vein thrombosis with cavernous transformation. There is infiltrative enhancement at right lobe of liver. Infiltrative tumor stain is favored.
- cork-screw change of intrahepatic vessels, indicating mild cirrhotic change.
- several small hypervascular tumor stains around a lipiodol retention at S2.
- another hypervascular tumor stain (about 2 cm in size) at S3 of liver.

A microcatheter (Progreat) was advanced into left hepatic artery with a guiding catheter (4-Fr RC-1). Superselective TACE was smoothly performed with 40mg of doxorubicin, emulsed with 10 ml of lipiodol, delivered into S2 and S3 branches of left hepatic artery, followed by embolization of Gelfoam particles until the stasis of the blood flow. 

Follow up angiogram shows decreased arterial blood flow into lateral segment of liver. There is moderate lipiodol retention at tumor stains at S2 and mild rentention at tumor stain at S3. 

There is no specific complaints of the patient immediately after this TACE.

Please follow up liver function and watch for any possible post-TACE complication.

Impression: Recurrent HCC S/P TACE.
)

::ugis::
(
Small bowel barium study under fluoroscopic control shows:
- smooth passage of barium meal through whole course of the small bowel with fine peristalsis, normal mucosal pattern and profile.
- normal ileo-cecal valve.
- transit time through the small bowel is about    minutes.
- normal visible appendix.
)

:c:TED::TED
::ted::
SendInput,
(
CT of the orbit for Graves' disease shows:
- exophthalmos, bilaterally.
- bilateral lacrimal gland enlargement.
- enlargement of the left superior rectus muscle with heterogeneous lower density areas.
- increased orbital fat.
- no abnormal attenuation at retrobulbar areas noted.
)
MsgBox, 
(
Normative EOM thickness (mm) based on CT data
Inferior:	4.8mm
Medial:	4.2mm
Superior:	4.6mm
Lateral:	3.3mm
)
return

:c:UGI::UGI
::ugi::
(
Esophageal and UGI barium study under fluoroscopy after intake of effervescent agents shows:
- smooth passage of barium through the esophagus with fine peristalsis, normal mucosa pattern and profile.
- visible EG junction in normal position without focal lesion. 
- no gastroesophageal reflux detected during this study.
- normal mucosa pattern and profile in body and antrum of stomach.
- well-distended duodenal bulb shows no obvious ulcer formation or deformity.
- no widening and rigidity of the gastric angularis.
)

:c:VCUG::VCUG
::vcug::
(
KUB and VCUG show:
- bilateral clear psoas shadow, no definite abnormal radiopacity or mass-like lesion was found .
- bilateral vesicoureteral reflux was demonstrated when the urinary bladder was well-distended and happened on the left side at first. Right side hydronephrosis is also identified. Grade IV to V on the right side and Grade III VUR on the left side are impressed.
- no definite stricture of UP junction is identified. The indentation near the left UPJ might be caused by vascular structure.
- well-distended bladder with smooth contour is demonstrated.
- smooth passage of contrast materium through the whole length of the urethra.
- the volume of the residual urine is little.

Impression: 
  1. Right side hydronephrosis with tortuous ureter.
  2. Bilateral VUR; Grade IV to V on the right and Grade III on the left.
)

:c:PTCCD::PTCCD
::ptccd::
(
* Preprocedure diagnosis
  - Cholecystitis.
* Postprocedur diagnosis
  - Status after successful placement of a 25cm 6F catheter in gallbladder.
* Procedures performed
  - Sono-guided penetration of Chiba needle with aspiration of 5cc bile.
  - Fluoro-guided placement of 25cm 6F catheter into distended gallbladder.
* Anesthesia and medication
  - 10ml 1`% lidocaine in soft tissues overlying the target of drainage.
* Description of procedure and findings
  - Informed consent was obtained. The patient was prepped and draped in the usual sterile fasion with monitoring of vital signs. Sonography of the gallbladder was performed, revealing a distended thick-walled gallbladder. The soft tissues of the intercostal space were infiltrated with lidocaine for local anesthesia. Placement of a 25cm 6F pigtail catheter was performed under fluoroscopic guidance, with the loop positioned in the gallbladder. The drainage catheter was secured to the skin with a suture and the exit site was covereed with a dry sterile dressing.
  - 10 ml of drained bile was obtained for culture.
  - The patient tolerated the procedure well, with no immediate complications, and was returned to the ER ward in good condition.

Impression: Status after successful ultrasonographic and fluoroscopic guided drainge of gallbladder.
)

::mrsh::
(
MRI of the shoulder without contrast enhancement shows:
- increased signal intensity within the supraspinatus critical zone, consistent with tendinopathy.
- a small area of fluid signal intensity at bursa surface of the supraspinatus tendon distal insertion, partial tear is favored.
- a small area of high signal intensity at interstial supraspinatus tendon distal insertion.
- high signal intensity at undersurface posterior supraspinatus tendon distal insertion, posterior superior labral fraying and cystic degenerative changes of posterosuperior humeral head, suggesting internal impingement.
- the supraspinatous muscle and tendon are intact and free of significant signal abnormalities.

- posterolateral Hill-Sachs fracture involving the superior humeral head.
- fragmentation and avulsion of the anterior inferior glenoid labrum, indicating Bankart lesion.

- hypertrophy of acromioclavicular joint with marginal osteophyte formation and lateral down-sloping of the acromion.
- mild effusion in the subaromion-subdeltoid bursae.

- amorphous thickening of the rotator interval (superior glenohumeral ligament) with slight T2 hyperintensity and increased effusion at the rotator interval.
- the long head biceps tendon is normal in course and caliber; the bicipital-labral complex is intact and free of significant signal abnormalities.
- increased intra-tendinous signal intensity within a swollen long head of biceps tendon, suggesting biceps tendinopathy.
- there is no evidence of signal abnormalities at the bony structures.
)


::mrshr::
(
MRI of the right shoulder without contrast enhancement shows:
- a small area of fluid signal intensity at bursa surface of the supraspinatus tendon distal insertion, partial tear is favored.
- a small area of high signal intensity at interstial supraspinatus tendon distal insertion.
- high signal intensity at undersurface posterior supraspinatus tendon distal insertion, posterior superior labral fraying and cystic degenerative changes of posterosuperior humeral head, suggesting internal impingement.
- the supraspinatous muscle and tendon are intact and free of significant signal abnormalities.

- posterolateral Hill-Sachs fracture involving the superior humeral head.
- fragmentation and avulsion of the anterior inferior glenoid labrum, indicating Bankart lesion.

- hypertrophy of acromioclavicular joint with marginal osteophyte formation and lateral down-sloping of the acromion.
- mild effusion in the subaromion-subdeltoid bursae.

- amorphous thickening of the rotator interval (superior glenohumeral ligament) with slight T2 hyperintensity and increased effusion at the rotator interval.
- the long head biceps tendon is normal in course and caliber; the bicipital-labral complex is intact and free of significant signal abnormalities.
- increased intra-tendinous signal intensity within a swollen long head of biceps tendon, suggesting biceps tendinopathy.
- there is no evidence of signal abnormalities at the bony structures.
)

::mrshl::
(
MRI of the left shoulder without contrast enhancement shows:
- a small area of fluid signal intensity at bursa surface of the supraspinatus tendon distal insertion, partial tear is favored.
- a small area of high signal intensity at interstial supraspinatus tendon distal insertion.
- high signal intensity at undersurface posterior supraspinatus tendon distal insertion, posterior superior labral fraying and cystic degenerative changes of posterosuperior humeral head, suggesting internal impingement.
- the supraspinatous muscle and tendon are intact and free of significant signal abnormalities.

- posterolateral Hill-Sachs fracture involving the superior humeral head.
- fragmentation and avulsion of the anterior inferior glenoid labrum, indicating Bankart lesion.

- hypertrophy of acromioclavicular joint with marginal osteophyte formation and lateral down-sloping of the acromion.
- mild effusion in the subaromion-subdeltoid bursae.

- amorphous thickening of the rotator interval (superior glenohumeral ligament) with slight T2 hyperintensity and increased effusion at the rotator interval.
- the long head biceps tendon is normal in course and caliber; the bicipital-labral complex is intact and free of significant signal abnormalities.
- increased intra-tendinous signal intensity within a swollen long head of biceps tendon, suggesting biceps tendinopathy.
- there is no evidence of signal abnormalities at the bony structures.
)

::xnod::
(
============================================================================
Recommendations for Follow-up and Management of Indeterminate Lung Nodules Detected Incidentally on Nonscreening CT

Adapted from the Fleischner Society Statement on CT of Small Pulmonary Nodules (Radiology 2005;237:395-400)

Nodule      Low-Risk Patient             High-Risk Patient 
 Size
<= 4 mm     no F/U needed                F/U CT at 12mo;
                                          no F/U if no change

>4-6 mm     F/U CT at 12mo;              F/U CT at 6-12mo then
             no F/U if unchanged          at 18-24mo if no change

>6-8 mm     F/U CT at 6-12mo then        F/U CT at 3-6mo then at 
             at 18-24mo if no change      9-12 & 24mo if no change

> 8 mm      contrast enhanced CT, PET and/or biopsy, OR
             watchful waiting: follow up CT at 3, 9 & 24 months

Notes: diameter = average width; high risk is defined as a history of smoking or other know risk factors for lung cancer; low risk is defined as minimal or absent history of smoking or other known risk factors; caveat: nodules with a ground glass component may require longer follow up to exclude indolent adenocarcinoma.
)


::m0::
(
MRI of abdomen and pelvis for health examination in axial, coronal, and sagittal views shows:
- Liver: Normal. 
- Gallbladder and biliary system: Normal. 
- Spleen: Normal. 
- Pancreas: Normal. 
- Kidneys: No evidence of obstructive uropathy. 
- Adrenal glands: Normal. 
- GI tract: No evidence of bowel obstruction. 
- Peritoneum/retroperitoneum: Normal. 
- Urinary bladder: Normal
- Prostate & seminal vesicles: Normal. (Low sensitivity for prostate cancer in screening MRI study)
- Others: Normal.
)

::f0::
(
MRI of abdomen and pelvis for health examination in axial, coronal, and sagittal views shows:
- Liver: Normal. 
- Gallbladder and biliary system: Normal. 
- Spleen: Normal. 
- Pancreas: Normal. 
- Kidneys: No evidence of obstructive uropathy. 
- Adrenal glands: Normal. 
- GI tract: No evidence of bowel obstruction. 
- Peritoneum/retroperitoneum: Normal. 
- Urinary bladder: Normal
- Uterus, cervix, adnexa: Normal (Low sensitivity for cervical lesions in this screening MRI study)
- Others: Normal. 
)

::zadm::膽囊腺體肌肉增生
::zbph::攝護腺肥大
::zcle::囊狀病灶
::zg::膽囊
::zgb::膽囊
::zgst::膽囊結石
::zhm::血管瘤
::zflv::脂肪肝
::zh::肝臟
::zhc::肝臟囊腫
::zk::腎臟
::zkc::腎臟囊腫
::zle::病灶
::zln::淋巴結
::zop::術後發現
::zp::瘜肉
::zmyo::子宮肌瘤
::znd::結節
::znod::結節
::znab::納氏囊腫
::zpolyp::瘜肉
::zpro::攝護腺
::zps::胰臟
::zs::疑似
::zsus::疑似
::ztumor::腫瘤
::zut::子宮
::zv::脊椎
::zver::脊椎
::zvc::脊椎塌陷
::zy::囊腫
::zyc::囊狀
::zyle::囊狀病灶
::zx::建議
::zxc::建議參照臨床發現評估
::zxf::建議門診追蹤
::zus::建議超音波檢查追蹤評估
::zgyn::建議婦產科追蹤評估



::zneg::
(
No definite abnormality in this study. 
無明顯腹腔骨盆腔異常
)
::zn::
(
No definite abnormality in this study. 
無明顯腹腔骨盆腔異常
)

::xs::
(
- Tumor location/size (if measurable)/invasion: 
- Location of abnormal lymph node(s): 
- Any metastasis in the visible fields: 
)
