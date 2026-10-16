﻿﻿;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         陳盈蓁
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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;以下為片語區 
;;;格式為 ::縮寫::完整語句
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;以下為CXR片語區;;;;;;;;;;;

::2T::Placement of endotracheal and NG tubes
::3T::Status post endotracheal tube, nasogastric tube, and central line insertion
::aor::tortuous aorta
::asd::status post Amplatzer spetal occluder deployment
::b::both lungs
::bn::blunting of bilateral CP angles
::bnl::blunting of left CP angle
::bnr::blunting of right CP angle
::br::blurring of bil. CP angles
::brl::blurring of left CP angle
::brr::blurring of right CP angle
::bor::boderline heart size
::cap::Chest AP shows
::cht::s/p chest tube insertion
::cla::Chest lateral view shows
::clip::status post op with clips at 
::co::bil. lung consolidation
::con::diffuse consolidation at both lungs
::copd::Hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible.
::cor::suggest clinical correlation and f/u
::cpa::Chest PA shows
::cv::status post central line insertion
::d::status post drainage tube insertion at
::dbs::status post DBS device implantation at left upper chest wall
::dg::degenerative change
::e::emphysematous change
::ecmo::placement of ECMO with large venous cannula in SVC and IVC
::en::stasus post endotracheal tube insertion
::foley::status post Foley insertion
::ggo::ground glass opacity
::h::ill-defined haziness
::hs::normal heart size
::iabp::status post IABP insertion with tip at the level of proximal descending aorta
::infil::increased infiltration at both lungs
::knob::calcification of the aortic knob
::l::on the left side
::lh::elevation of left hemidiaphragm 
::lhs::cardiomegaly
::lll::lower lung field
::ull::upper lung field
::mark::increased lung markings in both lungs
::med::mediastinum widening
::n::no definite lung lesion
::ng::status post NG tube placement
::nip::possible nipple shadow
::pl::pleural effusion
::par::Port-A at right upper chest
::pal::Port-A at left upper chest
::pace::status post pacemaker placement
::pat::patchy consolidation in both lungs
::pe::bilateral pleural effusion
::pig::status post pigtail insertion
::pne::pneumothorax
::r::on the right side
::rh::elevation of right hemidiaphragm
::sp::status post
::stern::status post sternotomy with metallic wire fixation
::swan::Swan-Ganz catheter implantation with the tip in right pulmonary artery
::tor::tortuous aorta with wall calcification
::tra::stasus post tracheostomy
::lv::decreased capacity of both lungs
::lvr::decreased right lung capacity
::lvl::decreased left lung capacity
::val::status post cardiac valve replacement

;;;以下為ortho片語區;;;;;;;;;;;;;;;

::ac::acromioclavicular joint
::dj::decreased joint space
::fa::suspicious facet arthrosis at lower L-spine
::mal::malalignment
::mars::marginal spur formation
::spon::spondylolytic spondylolisthesis
::pel::Pelvis shows
::bk::Both knee shows
::rk::Right knee shows
::lk::Left knee shows
::bs::Both shoulder shows
::rs::Right shoulder shows
::bh::Both hands show
::f::(previous) fracture(s)
::ft::femorotibial joint
::cf::comminuted fracture
::fla::ligamentum flavum hypertrophy
::gh::glenohumeral joint
::lss::Lumbosacral spine shows
::ls::lumbosacral spine
::oc::osteoarthritic change
::ost::osteopenia
::osp::osteopenia of visible bony structures
::sco::scoliosis
::nail::status post intramedullary nail and interlocking screw fixation
::ss::subchondral sclerosis
::t::thoracic spine
::thr::s/p total hip arthroplasty
::tl::thoracolumbar spine
::tls::Thoracolumbar spine shows

;;;以下為其他常用片語;;;;;;;;


;;;以下為Neuro片語區;;;;;;;;

::atr::brain cortical atrophy with prominent sulci, fissures and dilated ventricles
::milda::mild brain cortical atrophy with dilated sulci and fissures 
::cal::Some high density spots are found at falx, bilateral choroid plexus, and pineal gland; calcifications are considered.
::com::> Osteosclerotic changes of right side temporal bone with loss of mastoid air cells, compatible with right side COM.
::cps::> Osteomucosal hypertrophy, excretion retention and adjacent cortical thickening are noted at the bilateral maxillary, ethmoid, frontal and sphenoid sinuses; compatible with chronic paranasal sinusitis.
::dwi::No definite diffusion restriction on DWI and ADC map.
::ede::> Blurred demarcation of lateral ventricles, decreased density of white matter and effacement of sulci, fissures indicating brain edema.
::leu::Confluent patches of increased SI on FLAIR images at bil. periventricular white matter, leukoaraiosis is considered.
::leuct::Confluent patches of decreased density at bil. periventricular white matter, leukoaraiosis is considered.
::ostosis::>hyperostosis of the inner table of frontal bone suggestive of internal frontal hyperosterosis
::vau::intact cranial vault

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;以下為罐頭區;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Neuro;;;;;;;;;;

::HCT0:: ;正常的Brain CT
(
CT scan of the head without and with contrast enhancement shows:
> The sulci, fissures and ventricles are normal.
> There is no definite abnormal attenuation or enhancement in the brain parenchyma.
> No intracranial hemorrhage or large territory infarction.
> There is no definite focal lesion in the cranial vault.
)

::CTN::
(
CT scan of the head without intravenous contrast enhancement shows: 
> Bil. symmetric ventricles, sulci, and fissures.
> No acute intracranial hemorrhage, large territory vascular infarct or ischemia, mass, or mass effect is identified. 
> The brain parenchyma appears normal with preservation of the gray-white junction throughout. 
> No abnormal extra-axial fluid collections are identified. 
> The paranasal sinuses and mastoid air cells are well developed and clear. 
>The orbits and globes are unremarkable. 
> The bones and soft tissues of the scalp are unremarkable.
No definite abnormality in this study
)

::CTVP::
(
Previous vertebroplasty was performed at    due to back pain
CT of the spine shows:
1. Compression fractures were found at
2. Hyperdense materials were found at 
3. No definite leakage to spinal canal was noted.
4. Mild venous leakage was noted without significant compromise of the spinal canal.
)

::NCT0::  ;正常的Neck CT
(
Neck CT without/with contrast enhancement shows:
> no obvious mass lesion noted.
> no abnormal LAPs at neck.
> the parotid, submandibular glands and nasopharynx appear normal.
)

::CTMET::
(
CT of head without and with IV contrast enhancement shows:
> Neither abnormal attenuation nor pathological enhancement within brain parenchyma. There is no visible brain mets.
> Cranial vault is intact without bone mets.
> Symmetric ventricles and sulci.
> No abnormal extra-axial fluid collections are identified.
> The paranasal sinuses and mastoid air cells are well developed and clear.
> The orbits and globes are unremarkable.

No evidence of intracranial and cranial vault mets.
)

::NCTOP::  ;開過刀的Neck CT
(
Neck CT without/with contrast enhancement shows:
> post-operative change with neck dissection. soft tissue swelling and blurring fat planes are found due to recent operation.
> no obvious abnormal mass lesion is noted.
> no obvious abnormal lymph adenopathy.

suggest follow-up.
)

::NPC1::  ;鼻咽癌MRI-新來的
(
MRI of neck without/with contrast enhancement shows:
> abnormal mucosal thickening at nasopharynx, NPC is considered.
> no obvious abnormality at skull base and visible brain.
> abnormally enlarged LAPs at carotid and posterior cervical spaces.
> the paranasal sinuses are clear. 
)

::NPC2:: ;鼻咽癌MRI-治療後有效
(
MRI of neck without/with contrast enhancement shows:
> op change in right oral cavity and right neck.
> focal area of SI change and heterogeneous enhancement in right masticator space, mandible and medial pterygoid muscle. As compared with MRI dated May 22, 2007, the lesion is decreased in size but viable tumor cannot be excluded. 
> post-RT change with flattened mucosa at nasopharynx, no obvious local recurrent tumor is found.
> no obvious abnormality at skull base and visible brain.
> no evidence of abnormally enlarged LAPs.
> mild paranasal sinusitis change and mastoiditis change.  
significantly reduced lesion size on the right, but residual tumor cannot be excluded.
)

::REQ:: ;外院片
(
The medical images from outside hospital for shared information have been successfully uploaded into the PACS (Picture Archiving and Communication System) server for reference purpose. Please check the attached original formal report from the source hospital. If a second opinion of these images is required, please send a formal consultation to the Department of Medical Imaging with the mention of "Request a Second Opinion".
)

::HMR0:: ;正常的Brain MRI
(
MRI of head without contrast enhancement shows:
> no abnormal bright up on DWI.
> no abnormal focal SI change in the brain parenchyma.
> symmetrical sulci, fissures and ventricles. 
> contrast-enhanced MRA of cervicocranial vessels appears normal.
> the cranial vault and skull base appear normal.
)

::MRIN::
(
MRI of head without and with IV contrast enhancement shows:
1. No definite diffusion restriction on DWI and ADC map.
2. No abnormal focal SI change in the brain parenchyma.
3. Symmetrical sulci, fissures and ventricles. 
4. TOF MRA of circle of Willis and contrast-enhanced MRA of cervicocranial vessels appear normal.
5. The cranial vault and skull base appear normal.
No intracranial abnormality
)

::NMR0:: ;正常的Neck MRI
(
MRI of neck without/with contrast enhancement shows:
> dental artifacts on the right side.
> no obvious local recurrent tumor is found.
> no evidence of abnormally enlarged LAPs.
> no obvious abnormality at skull base and visible brain.
> mild paranasal sinusitis change and mastoiditis change.  
)

::HCT1::  ;頭撞壞了
(
Head CT without contrast enhancement shows: 
> traumatic brain injury with hemorrhage and some low density change at frontal and temporal lobe. 
> subdural hematoma at 
> midlnie shift
> no obvious skull fracture.
)

::SELLA0:: ;正常的蝶鞍MRI
(
MRI of sella without/with contrast enhancement shows:
> normal size and shape of the pituitary gland. 
> no evidence of focal lesion in the pituitary gland.
> normal dynamic enhancement pattern.
> the posterior lobe brightness is preserved. 
> normal size of sulci, fissures and ventricles of the visible brain.
)

::SELLA1:: ;異常的蝶鞍MRI
(
MRI of sella without/with contrast enhancement shows:
> enlargement of the sellar turcica with a less enhancing mass lesion, about 1.6x1.8x1.4cm sized, in the sellar fossa, more on the right. pituitary tumor is considered.
> the stalk and residual pituitary tissue are displaced to the left.
> the optic chiasm is displaced upwardly.
> the posterior lobe brightness is preserved. 
> normal size of sulci, fissures and ventricles of the visible brain.
)

::SELLAOP:: ;開過刀的蝶鞍MRI
(
MRI of sella without/with contrast enhancement shows:
> evidence of prior transsphenoid hypophysectomy with increased SI in the sphenoid sinus and bony defect at the sellar floor.
> no evidence of local recurrent tumor.
> the sellar turcica is enlarged with minimal residual normal glandular tissue. the stalk is deviated to the left.
> the postrior lobe brightness is found.
> mild deformity of the optic chiasm.
> symmetrical sulci, fissures and ventricle of the brain without focal SI change.

IMP: post-op change of the sella without evidence of recurrent tumor.
)

::THRCT::  ;Temporal bone HRCT
(
HRCT for temporal bones without contrast enhancement:
> normal appearance of bilateral external ear canal and middle ear osscicles.
> normal appearance of bilateral inner ear bony labyrinthes.
> well pneumatization of bil. mastoid.
)

::RFAL2::  ;神經電燒
(
This study is for CT-guided radiofrequency thermocoagulation of L2 periradicular region for back pain treatment.
>Under CT-guidance, two RF probes were inserted from posterior approach with tips at around L2 dorsal root ganglion region bilaterally. 
> After RF stimulation to confirm the correct needle location, RF thermocoagulation at 49 degree Celsius for 90 seconds was performed. 
> The patient tolerated the whole procedure well. 
)


::CS::     ;正常的海綿竇
(
MRI of head without/with contrast enhancement shows:
> no abnormal bright up on DWI
> no abnormal focal SI change in the brain parenchyma
> symmetrical sulci, fissures and ventricles. 
> no obvoius abnormality along the cisternal portion of upper cranial nerves, the cavernous sinuses, retrobulbar region.
> post-contrat TOF MRA of circle of Willis appears normal.
> the cranial vault and skull base appear normal
)

::CPS:: 慢性鼻炎CT
(
CT for paranasal sinuses without contrast enhancement shows:
> increased soft tissue in maxillary, ethmoid, frontal and sphenoid sinuses, paranasal sinusitis is considered.
> no abnormal bone destruction.
)

::SEIZ::    ;癲癇檢查MRI-正常
(
MRI of head without contrast enhancement shows
> no abnormal focal SI change in the brain parenchyma.
> symmetrical sulci, fissures and ventricles. 
> normal appearance of bil. hippocampus.
> MRS of bil. medial temporal lobe shows no obvious abnormality.
)

::facet:: ;神經阻斷 
(
The study was for CT-guided facet block. The patient had low back pain, more on the right side.
> Image findings: lumbar spondylosis and facet arthrosis of L4-5, L5-S1 bilaterally. 
> RF needles were placed with tips in the rescess of right transverse process and facet joint of L4-5, L5-S1. RF thermocoagulation was done at 80 degree celsius for 120 seconds at each site. 
> Two 26G needles were inserted from left posterior approach with tip into the L4-5, L5-S1 facet joint region. 2.5cc mixed steroid, 2% xylocaine and contrast medium was injected slowly through the needle at two sites respectivley. 
> F/U CT showed well dispersion of the contrast medium in the left facet joint region.
> the patient tolerated the procedure well and experienced pain relief after the procedure.
)

::prt:: ;神經阻斷 
(
The study is for CT-guided periradicular therapy for treatement of radiculopathy.
1. Image findings: lumbar spondylosis and L45 HIVD (lateral and far laterally) with compression of the L4, 5 nerve roots.
2. Two 26G needles were inserted from left posterior approach with tip into the L4, 5 periradicular region.
3. After confirmation of the exact location at periradicular epidural space using contrast medium injection, 2.5cc mixed steroid (40mg kenacort), 2% xylocaine and contrast medium was injected slowly through the needle at two sites respectively. 
4. F/U CT showed well dispersion of the contrast medium in the epidural space and along the nerve roots.
5. the patient tolerated the procedure well.
)

::CSPINE::
(
MRI of cervical spine without contrast enhancement shows:
> cervical spondylosis with marginal spur formation and bulging disc at C5-6, C6-7 level with narrowing of thecal sac.
> no evidence of intrathecal lesion. no focal SI change in the visible spinal cord.
> normal alignment of C spine, no focal bony destruction is found.
> the paraspinal soft tissue is unremarkable. 
)

::LSPINE::
(
MRI of lumbar spine without contrast enhancement shows:
> lumbar spondylosis with marginal spur formation and bulging disc at L4-5, L5-S1 level with narrowing of thecal sac.
> no evidence of intrathecal lesion. no focal SI change in the visible spinal cord.
> normal alignment of L spine, no focal bony destruction is found.
> the paraspinal soft tissue is unremarkable. 
)

::MRLS::
(
MRI of the lumbosacral spine without and with IV contrast enhancement shows: 
1. scoliosis and degenerative change of L-spine with dehydrated discs at the multiple levels. 
2. old compression fracture with contrast enhancement over the superior aspect ofL2 vertebral body; mild retrobulging at the L1-2 disc level and causing compression to the adjacent spinal canal. 
3. bulging disc at posterior central area of L3-4 and causing compression to the adjacent thecal sac. 
4. mixed type 1 and type 2 end-platechange at the adjacent L4-5. 
5. no evidence of abnormal signal in the visible spinal cord. 

Degenerative spinal disease
)

::PARO::     ;for parotid tumor benign favored.
(
Neck CT without/with contrast enhancement shows:
1. a  cm sized lobulated tumor in parotid gland, mainly superficial lobe, showing solid and cystic component. A benign tumor is more favered, suggest pathologic correlation.
2. no abnormal LAPs at neck.
3. no obvious pharyngeal mucosal mass lesion noted.
4. clear paranasal sinuses.
)

::SKULL0::
(
Skull: no abnormal bony destruction. Normal size of the sellar turcica.
)

::ORBIT0::
(
CT for orbits without contrast enhancement shows:
> normal size and shape of both eyeglobes.
> no obvious exophthalmos.
> no evidence of retrobulbar mass.
> normal size of the extraocular muscles and optic nerves.
)

::ORBIT1::
(
CT for orbits without/with contrast enhancement shows:
1. right exophthalmos, with fusiform shaped enlargement of right inferior, medial, superior and lateral rectus as well as superior oblique muscles. The tendinous insertion portion was spared. The left eye was spared.
Graves' ophthalmopathy with unilateral eye invovlement is considered first.
2. no obvious parasellar lesion.
3. clear paranasl sinuses.
)

::ia::
(
A Patient presented with right side weakness and aphasia for 3 hours (4.5 hours at the time IA thrombolysis was started). 
Initial NE:   -- coma scale : E4VaM6
                  -- muscle power : Right upper extremity: 1; Right lower extremity: 1-2
Angiography shows total occlusion of left M1-M2 junction. A Renegade microcatheter was navigated into left M2 branches and totally 360,000 IU urokinase was given. Post-thrombolysis angiography shows well opacification of the left MCA branches without flow stasis. Patient vital signs were stable during the procedure and she stood the procedure well.

Post-thrombolysis NE:   -- coma scale : E4VaM6
                                 -- muscle power : Right upper extremity: 1; Right lower extremity: 3-
F/U CTA + perfusion was performed immediately after thrombolysis.
Please close monitory vital signs and neurologic signs. If there is newly-developed neurologic deficits, please do emergent non-contrast head CT immediately.
)

::MRIH0::
(
MRI of head without contrast enhancement shows:
1. no abnormal focal SI change in the brain parenchyma.
2. multiple patchy hyperintensities on FLAIR at bil. periventricular white matter and subcortical white matter.  
3. symmetrical sulci, fissures and ventricles, which is appropriate for his age.
4. no definite abnormality at the circle of Willis portion of intracranial arteries as well as the cervical portion of carotid and vertebal arteries.
5. the cranial vault appears normal.

No obvious intracranial abnormality.無明顯顱內異常.
moderate leukoaraiosis change and a lacune.
)

::graves::
(
CT of the orbit for Graves' disease shows: 
1. exophthalmos, bilaterally. 
2. increased size of the lacrimal glands, bilaterally. 
3. hypertrophy of the left superior rectus muscle, but the rest of the extraocular muscles are not involved. 
4. increasedperiorbital fat bilaterally. 
5. no abnormal attenuation at retrobulbar areas noted. 
Ccompatible with the clinical diagnosis of Graves' disease.
)

::CTBX::
(
CT-guided biopsy of the      was performed smoothly with the use of 19G coaxial guiding needle and 20 G automated biopsy needle. There were total 3 tissue stripes and 6 imprint smears obtained for pathology and cytology studies. Suggest complete bedrest for 4hours.
)

::myelo::
(
Myelography of lumbar spine is performed smoothly via L3-4 puncture with injection of 10 cc. Omnipaque contrast medium and it shows:
1. S/P left lateral fixation at L2-4.  
2. Compression fracture and collapsed of L3 vertebral body. Indentation over the anterior aspect of the contrast column of L2-3, L3-4, L4-5 due to spur and bulging disc. 
3. Displacement of the nerve of bilateral L4 and L5. more severe on the left L4 nerve root. 
4. Smooth opacification of thecal sac up to the thoracolumbar junction.    
Please correlate with clinical manifestation and meylo-CT .
)

::neu::
(
Angiographies of bilateral CCA, left ICA, and left VA show:
1. The patient was put at supine position.
2. A 5F H1 catheter was used to navigated bil. CCAs, left VA smoothly.
3. Sun-burst pattern hypervascular, persistent stain at left parasellar region, cavernous sinuses and probably part of sella turcica. The bloold supply comes from left middle meningeal artery, bil. hypophyseal aa., left sphenopalatine a. Encasement of left ICA especially at acending part of petrous portion and lower horizontal part of left cavernous ICA.
4. Decreased flow in bil. ophthalmic vv. with little or no opacification of bil. cavernous sinuses in venous phase.
5. Mild stasis of left transverse sinus is noted at late venous phase in all injection, this could be due to laminar flow or other possibility.
)

::sialo::
(
Right parotid sialography shows patent Stenson's duct without filling defect. The intra-glandular ducts are well opacified. CT sialography shows no definite defect in the parotid gland.
)