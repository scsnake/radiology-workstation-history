﻿﻿﻿;

; AutoHotkey Version: 1.x

; Language:       English

; Platform:       Win9x/NT

; Author:         CCC

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



; 自動啟動 RIS + IMPAX + N hospital 並輸入帳號密碼

#r::   ; 按Win-key + r 鍵自動啟動

ris="http://10.0.0.100:8888/NH/NH.jnlp"

impax="C:\impax\select\bin\impax_select.exe"

uname=019230   ;RIS和IMPAX的帳號 (6位數字員工代號)

rpasswd=12          ;RIS密碼

ipasswd=0          ;IMPAX密碼



Run, %impax%,,,

WinWait,登入,,,,

WinActivate,ahk_class ThunderRT6FormDC,,,

control,editpaste,%uname%,ThunderRT6TextBox2,ahk_class ThunderRT6FormDC,,,

control,editpaste,%ipasswd%,ThunderRT6TextBox1,ahk_class ThunderRT6FormDC,,,

controlclick,ToolbarWindow321,ahk_class ThunderRT6FormDC,,,,,,



Run, %ris%,,,

Winwait, Login,,,,

WinActivate,ahk_class SunAwtDialog,,,

winget,rpid,PID, ahk_class SunAwtDialog,,,

controlsend, ,%uname%{enter}, ahk_pid %rpid%

controlsend, ,%rpasswd%{enter}, ahk_pid %rpid%

Return



; 按Window Key + N 啟動 N hospital intranet (logged-in)

#n::

nhosp="http://intra.hospital-n.local/portal.php"

Run, %nhosp%,,,

Return



; 按Window Key+ C 啟動 Activate Case Collection Database (PHPmyAdmin)

#c::

casedb="http://sama.cyyang.org/phpmyadmin/"

casedb_login=CCC

casedb_passwd=CCC



Run, %casedb%

WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer,

WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

  , javascript:void(document.login_form.pma_username.focus());

  , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_login%{Del 3}



WinWait,phpMyAdmin - Microsoft Internet Explorer,

IfWinNotActive,phpMyAdmin - Microsoft Internet Explorer,

WinActivate,phpMyAdmin - Microsoft Internet Explorer,

WinWaitActive,phpMyAdmin - Microsoft Internet Explorer,



ControlSetText, Edit1

  , javascript:void(document.login_form.pma_password.focus());

  , phpMyAdmin - Microsoft Internet Explorer

ControlSend, Edit1, {Enter},phpMyAdmin - Microsoft Internet Explorer

Send {Home}%casedb_passwd%{Del 10}+{Enter}



Return





;

; 以下為片語區 

; 格式為 ::縮寫::完整語句

; 



;CxR



::l::left

::r::right

::cap::Chest AP film shows:

::cpa::Chest PA film shows:

::spicu::Status post endotracheal intubation, nasogastric tube insertion and placement of

::sp::status post

::spicu::Status post endotracheal intubation, nasogastric tube insertion and placement of

::et::endotracheal intubation

::tras::tracheostomy

::ng::nasogastric tube insertion

::pla::placement of

::rjcvp::right jugular central venous line 

::ljcvp::left jugular central venous line

::rscvp::right subclavian central venous line

::lscvp::left subclavian central venous line

::icvp::central venous line in IVC

::portl::Port-A catheter at the left upper chest with its tip in SVC

::portr::Port-A catheter at the right upper chest with its tip in SVC

::sg::Swan-Ganz catheter

::dt::drainage tube

::cht::chest tube

::medi::mediastinum

::se::subcutaneous emphysema

::con::consolidation

::bcon::diffuse bilateral consolidation

::cw::chest wall

::wm::widening of mediastinum

::pe::pleural effusion

::nall::no active lung lesion

::cbcp::clear bilateral costophrenic angles

::nh::normal heart size

::cm::cardiomegaly

::aa::aortic aneurysm

::bh::borderline heart size

::eh::enlarged heart shadow

::tor::tortuous aorta

::torc::tortuous aorta with wall calcification

::akc::aortic knot calcification

::per::perihilar

::inf::infiltration

::ate::atelectasis

::emp::emphysematous change of both lungs

::ggo::ground-glass opacity

::ido::ill-defined opacity at

::lf::lung field

::ih::increased haziness at the 

::abg::air-bronchogram

::dlv::decreased bilateral lung volume

::plt::pleural thickening at the bilateral apical lungs

::ivm::increased bilateral vascular markings

::ai::alveolar infiltration

::rp::reticular pattern

::lll::left lower lung

::lml::left mid lung

::lul::left upper lung

::lal::left apical lung

::rll::right lower lung

::rml::right mid lung

::rul::right upper lung

::ral::right apical lung

::cal::calcification

::nod::nodule

::erd::elevation of right hemidiaphragm

::eld::elevation of left hemidiaphragm

::prh::prominent right hilar shadow

::plh::prominent left hilar shadow

::blf::both lung fields

::bll::bilateral lower lungs

::bul::bilateral upper lungs

::blcp::blurring of left costophrenic angle; susp. left pleural effusion.

::brcp::blurring of right costophrenic angle; susp. right pleural effusion.

::bbcp::blurring of bilateral costophrenic angles; susp. bilateral pleural effusion.

::brd::blurring of right diaphragmatic border

::bld::blurring of left diaphragmatic border

::nnn::Normal heart size. No active lung lesion. Clear bilateral costophrenic angles.

::hd::hemidiaphragm

::ss::surgical staples at the anterior chest wall

::oph::post-operative change with metallic wires at the sternum, surgical staples at the anterior chest wall and placement of 

::rot::Suboptimal study due to rotation of patient position.

::idp::ill-defined patchy consolidation

::ibl::in both lungs

::pnt::pneumothorax

::asa::atherosclerosis of aorta with wall calcification

::empc::Emphysematous change of both lungs and chronic infiltration in both lungs.

::iib::Increased infiltration at the bilateral hilar regions.

::bl::both lung fields

::sm::suture materials at the

::cvpi::central venous line in IVC

::nto::nearly total opacity over the

::eso::esophagectomy and reconstruction with clips at mediastinum

::rcp::The right CP angle is not included in this film

::lcp::The left CP angle is not included in this film

::scc::suggest correlation with clinical findings and CT study

::scf::suggest correlation with clinical findings

::ns::nipple shadow



::nsc::no significant interval change as compared with prior radiograph.

::dbh::Diffuse bilateral lung haziness.

::spenr::Status post endotracheal intubation, nasogastric tube insertion and placement of right jugular central venous line.

::spenl::Status post endotracheal intubation, nasogastric tube insertion and placement of left jugular central venous line.

::ibp::Increased bilateral perihilar infiltration.





;KUB and abdomen



::abd::abdomen

::ruq::RUQ of abdomen

::luq::LUQ of abdomen

::cbps::clear bilateral psoas shadows

::unbo::unremarkable bowel loops

::npp::no pneumoperitoneum

::pnp::pneumoperitoneum

::phl::phlebolith

::phls::phlebolithes

::ure::ureter

::ub::urinary bladder

::gb::gall bladder

::urs::ureteral stone

::ile::ileus

::nds::No definite radiopaque stone in bilateral collecting system

::rss::renal stone

::rs::renal shodow

::pc::pelvic cavity

::pf::pelvic floor

::pst::prominent colon gas and fecal material

::obr::obscuring of bilateral renal shadows

::obs::obscuring

;location and number



::bb::bilateral

::bbl::bilaterally

::at::at the

::mu::multiple

::nu::numerous

::sev::several

::prx::proximal

::dis::distal

::lat::lateral

::med::medial

::reg::region

::id::ill-defined



;ortho-general



::ef::effusion

::nfx::no definite bony fracture

::ofx::old fracture

::bfx::bony fracture

::fx::fracture

::mf::metallic fixation at the 

::oc::osteopenic change of visible bones

::msf::metallic screw fixation

::mpsf::metallic plate and screw fixation

::fba::fine bony alignment

::aba::acceptable bony alignment

::sts::soft tissue swelling

::cfx::comminuted fracture

::pcf::previous comminuted fracture

::ost::osteophyte

::tost::traction osteophyte

::te::traction enthesophyte

::rha::rheumatoid arthritis

::oa::osteoarthritis

::vld::valgus deformity

::vrd::varus deformity

::hhh::However, small osseous or soft tissue lesion may not be detected by the plain radiography. Advise correlate with other imaging study, if clinically indicated. 

::js::joint space narrowing

::dc::degenerative change

::spcast::status post external casting which may obscure the details of images

::bf::bony fragment

::uas::uneven articular surface

::ie::intraarticular extension to

::bk::Both knees:

::lk::Left knee:

::rk::Right knee:

::ps::previous



;spine

::sta::straightening alignment of

::scotl::scoliosis of thoracolumbar spine

::scol::scoliosis of lumbar spine

::csp::cervical spondylosis with

::nbnf::narrowing of bilateral neural foramina

::nrnf::narrowing of right neural foramen

::nlnf::narrowing of left neural foramen

::ssls::scoliosis and spondylosis of lumbar spine with marginal spur formation

::sls::spondylosis of lumbar spine with marginal spur formation

::scs::spondylosis of cervical spine with marginal spur formation

::sths::spondylosis of thoracic spine with marginal spur formation

::stls::spondylosis of thoracolumbar spine with marginal spur formation

::lus::lumbar spine

::ths::thoracic spine

::nis::narrowing of intervertabel space

::pis::preserved intervertebral space

::dvh::decreased vertebral body height

::nf::neural foramina1

::sa::straightening alignment

::nlc::nuchal ligament calcification

::dspl::degenerative spondylolisthesis

::sspl::spondylolytic spondylolisthesis

::fja::facet joint arthroses

::scotlr::scoliosis of the thoracolumbar spine with main convexity to the right and apical vertebra at the

::scotll::scoliosis of the thoracolumbar spine with main convexity to the left and apical vertebra at the

::pdecom::posterior decompression and posterior instrumentation at the

::pop::posterior decompression, posterior instrumentation, posterior lateral fusion and interbody fusion at the

::vap::vacuum phenomenon

::wd::wedged-deformity and decreased vertebral height

::mof::marginal osteophyte formation

::oac::osteoarthritic change of

::css::cervical spine

::dspl::degenerative spondylolisthesis

::ma::mal-alignment



;foot and ankle



::ipj::interphalangeal joint

::ttj::tibiotalar joint

::stj::subtalar joint

::tmtj::tarsometatarsal joint

::mtpj::metatarsophalangeal joint

::mm::medial malleolus

::lm::lateral malleolus

::vdbm::valgus deformity of bilateral 1st metatarsophalangeal joints

::vdrm::valgus deformity of right 1st metatarsophalangeal joint

::vdlm::valgus deformity of left 1st metatarsophalangeal joint

::oatj::marked irregular joint space narrowing with subchondral sclerosis at tarsal joints on both sides

::oaip::marked irregular joint space narrowing with subchondral sclerosis at interphalangeal joints

::df::degenerative arthroses at tibiotalar joint, midtarsal and intertarsal joints, and tarso-metatarsal joints

::mmf::medial malleolar fracture

::lmf::lateral malleolar fracture

::adf::r/o non-fused apophysis at distal fibula

::clc::calcaneus

::cll::calcaneal



;knee

::iesb::increased effusion at the suprapatellar bursa

::oack::osteoarthritic change of both knee with

::oaft::osteoarthritic change of femorotibial joint with

::oapf::osteoarthritic change of patellofemoral joint with

::oakm::mildly osteoarthritic change of knee joint with tiny marginal spur formation

::oaka::advanced osteoarthric change of knee joint with marginal spur formation, subchondral sclerosis, uneven articular surface, and narrowing of joint space

::ter::traction enthesophyte formation at right patellar base

::tel::traction enthesophyte formation at left patellar base

::jsn::joint space narrowing at medial joint compartments of both knee joints.

::iss::interspinous spur formation

::ice::intercondylar eminence

::ms::marginal spur formation

::njs::narrowing of joint space

::nmc::narrowing of medial compartment

::tkr::total knee replacement

::thr::total hip replacement

::mc::medial compartment

::ftj::femorotibial joint

::pfj::patellofemoral joint

::wsps::widening of suprapatellar space; r/o increased joint effusion



;shoulder

::sao::subacromial osteophyte

::acj::acromioclavicular joint

::dsa::down-sloping acromion with subacromial spur formation

::hh::huermal head

::subs::subchondral sclerosis

::subc::subchondral cyst formation

::sube::subchondral erosion

::ghj::glenohumeral joint

::hn::humeral neck

::gt::greater tuberosity

::dsas::decreased subacromial space

::hgt::huermal greater tubercle

::shimp::subacromial spur formation with marked decreased acromiohumeral distance and traction enthesophyte formation over the greater humeral tubercle on right side, suggestive of shoulder impingement, r/o injured rotator cuff tendons.



;hand

::dip::distal interphalangeal joint

::pip::proximal interphalangeal joint



;pelvis

::p::pelvis

::dsi::degenerative change of bilateral sacroiliac joints

::sij::sacroiliac joint

::fh::femoral head

::uhlp::unipolar hemiarthroplasty of left hip

::uhrp::unipolar hemiarthroplasty of right hip

::fn::femoral neck

::tro::trochanter

::ita::intertrochanteric area



;general



::op::post-operative change with 

::opc::post-operative change with surgical clips at

::opw::post-operative change with metallic wires at the sternum

::sc::surgical clips at the

::mw::metallic wires at the sternum

::ac::advise clinical correlation and follow-up

::lap::lymphadenopathy

::ln::lymph nodes

::us::ultrasound findings

::asc::ascites

::nda::no definite abnormality of

::sug::suggest

::sugc::suggest correlation with

::den::density

::des::densities

::sio::superimposed on

::prom::prominent

::nos::non-specific

::ae::active extravasation

::pa::pseudoaneurysm

::pdt::probably due to

::vs::varying-sized

::sugcc::suggest clinical correlation

::adj::adjacent

::ro::radiopaque

::rl::radiolucent

::inc::increased

::dec::decreased

::wt::with its tip at the

::sct::suggest correlation with CT findings

::sus::suggest correlation with ultrasound findings

::sfs::suggest further study if clinically indicated

::ilu::marked dilatation of bowel loops with air fluid level, suggestive of ilues.

::fol::foley catheter insertion



;body



::K::KUB

::ndaa::no definite abonrmality of gall bladder, pancreas, spleen, bilateral adrenals and both kidneys.

::nlap::no definite paraaortic lymphadenopathy.

::nlapp::no definite enlarged lymphadenopathy at the bilateral paraaortic, pelvic and inguinal regions.

::lc::uneven hepatic surface with splenomegaly, suggestive of cirrhotic pattern.

::paa::para-aortic

::ing::inguinal

::duo::duodenum

::mes::mesentry

::cel::celiac trunk

::sma::superior mesenteric artery

::bso::bilateral salpingo-oophorectomy

::hys::hysterectomy

::cho::cholecystectomy

::hemal::peripheral centripetal enhancement pattern progressing to homogeneity

::ptae::radiopaque density at the RUQ of abdomen, probably due to previous TAE change and lipiodol retention.

::bbrs::blurring of bilateral renal shadows due to overlapping bowel gas

::brrs::blurring of right renal shadow

::blrs::blurring of left renal shadow

::pbcg::prominent bowel and colon gas

::pbg::prominent bowel gas

::pcg::prominent colon gas

::pcgf::prominent colon gas and fecal material

::sti::stool impaction

::cbprs::clear bilateral psoas and renal shadows



::pt::pleural thickening

::fc::fibrotic change

::ds::degenerative change of thoracolumbar spine with marginal spur formation.

::sds::scoliosis and degenerative change of thoracolumbar spine with marginal spur formation.

::cf::compression fracture and wedge deformity at the

::ibc::increased bilateral peribronchial cuffing

::haz::haziness

::hy::hazy

::opa::opacity

::ops::opacities

::ex::expansile

::vas::vascular

::eng::engorged

::pul::pulmonary

::ar::artery

::ars::arteries

::cp::costophrenic

::medl::mediastinal

::def::deformity

::peri::peripheral

::prox::proximal 

::car::cardiac

::pv::portal vein

::dia::diaphragm

::diac::diaphrgmatic

::bal::bilateral apical lungs

::ang::angles

::dev::deviation

::disp::displacement

::tls::thoracolumbar spine

::aso::Amplatzer septal occluder deployment

::nsic::No significant interval change

::dlc::double lumen catheter

::icr::increased cardiothoracic ratio

::dcr::decreased cardiothoracic ratio

::dlvi::decreased bilateral lung volume, probably due to insufficient inspiration.

::ass::Ossification of interspinous and supraspinatous ligament, ankylosing spondylitis is considered.

::pbh::prominent bilateral hilar shadows

::mfm::much fecal material



::pig::pigtail catheter

::rcht::placement of right chest tube

::lcht::placement of left chest tube



::nsicc::no significant interval change comparing with prior chest radiograph on

::oph1::post-operative change with metallic wires at the sternum and placement of mediastinal drainage tubes.

::oph2::post-operative change with metallic wires at the sternum and surgical clips at the mediastinum.

::oph3::post-operative change with metallic wires at the sternum, surgical clips at the mediastinum, and placement of 

::opvr::post-operative change with metallic wires at the sternum and valve replacement.





::fm::formation

::sas::Ossification of interspinous and supraspinous ligament and syndesmophyte formation, r/o ankylosing spondylitis.

::nd::no definite



::icur::Status post endotracheal intubation, nasogastric tube insertion, placement of right jugular central venous line. Cardiomegaly. Diffuse bilateral consolidation and bilateral pleural effusion.

::icul::Status post endotracheal intubation, nasogastric tube insertion, placement of left jugular central venous line. Cardiomegaly. Diffuse bilateral consolidation and bilateral pleural effusion.

::icurs::Status post endotracheal intubation, nasogastric tube insertion, placement of right jugular central venous line. Cardiomegaly. Diffuse bilateral consolidation and bilateral pleural effusion. Placement of Swan-Ganz catheter with its tip at the

::iculs::Status post endotracheal intubation, nasogastric tube insertion, placement of left jugular central venous line. Cardiomegaly. Diffuse bilateral consolidation and bilateral pleural effusion. Placement of Swan-Ganz catheter with its tip at the



::eab::erect abdomen:

::njsmc::narrowing of joint space, esp. at the medial compartment of femorotibial joint

::ndfa::no definite subphrenic free air

::sb::small bowel

::fem::fecal material

::sco::scoliosis



::eabn::

(

Erect abdomen:

No definite subphrenic free air. Unremarkable bowel loops. Advise clinical correlation and follow-up.

)



::eabs::

(

Erect abdomen:

No definite subphrenic free air. Prominent colon gas and fecal material. Advise clinical correlation and follow-up.

)





::BMD::

(

Bone Mineral Density (BMD) of the Lumbar Spine (A-P) from L2 to L4 with quantitative dual-energy x-ray absorptiometry shows:

1. The BMD of L2, L3, and L4 is g/cm2, g/cm2, and g/cm2, respectively.

2. The total BMD of lumbar spine (L2-L4) is g/cm2 (T-score= - and Z-score= , which are matched to Taiwanese female).



Impression: osteopenia, osteoporosis, normal

)





::sk::

(

Skull:

No definite bony defect nor displaced fracture. Advise clinical correlation and follow-up.

)