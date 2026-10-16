﻿﻿; cheatsheets

cheatsheet(cheat="")
{
  if (cheat = "")
  {
    InputBox, cheat, Which subject?,,,150,120
    if cheat
      cheatsheet(cheat)
	else
	  MsgBox, No cheat is good.
  }
  else if (cheat = "mrs")
  {
    SplashImage, images\MRS.gif, M T
  }
  else if (cheat = "vcug")
  {
    SplashImage, images\VCUG.gif, M T
  }
  else if (cheat = "cyst")
  {
    MsgBox,
(
Bosniak Classification of Renal Cysts:
  1. Class I lesions are simple, benign cysts. The characteristics of a simple cyst include a well-defined and homogeneous mass with a thin, imperceptible wall. These lesions do not enhance and have the attenuation value of water density. If these criteria are met, no further workup is necessary.
  2. Class II lesions are minimally complicated cysts with features that cause concern. Internal septations that are smooth, thin and do not have thickened elements may be considered benign. A thin, peripheral rim of calcification in the cyst wall or septa may also be considered benign. These lesions do not show enhancement, have smooth, sharp margins, and are homogeneous. No further workup is necessary.
     Class IIF lesions are more suspicious cysts. These lesions are minimally complicated cysts but may be hyperdense, may contain more calcium in the wall, or may have thicker internal septations. Follow up scanning is recommended.
  3. Class III lesions are more complicated cystic structures that often show irregular and thickened septa, wall thickening, solid non-enhancing mural nodules, or irregular calcifications. This category also includes multiloculated cysts. These lesions require surgical exploration.
  4. Class IV lesions show non-uniform wall thickening, have irregular margins, and/or contain solid components that enhance on CT. These lesions are clearly malignant and total nephrectomy is warranted.

Key Points:
  * Class I: Simple cysts, 100`% benign
  * Class II: Minimally complicated cyst, 100`% benign
  * Class IIF: Minimally complicated cyst with suspicious features, follow up scan recommended, most likely benign
  * Class III: Moderately complicated or multiloculated cyst, 50`% malignant, surgery recommended
  * Class IV: Cleary malignant lesion, surgery recommended
),
  }
  else if (cheat = "pro")
  {
    MsgBox,
(
Prostate cancer (AJCC, 7th ed)
Primary tumor(T)
Tx--Primary tumor cannot be assessed
T0--No evidence of primary tumor 
T1--Clinically inapparent tumor neither palpable nor visible by imaging 
  T1a--Tumor incidental histologic finding in 5`% or less of tissue resected 
  T1b--Tumor incidental histologic finding in more than 5`% of tissue resected
  T1c--Tumor identified by needle biopsy (e.g.,because of elevated PSA)
T2--Tumor confined within the prostate*
  T2a--Tumor involves one-half of one lobe or less 
  T2b--Tumor involves more than one-half of one lobe, but not both lobes 
  T2c--Tumor involves both lobes 
T3--Tumor extends through the prostate capsule**
  T3a--Extracapsular extension (unilateral or bilateral) 
  T3b--Tumor invades seminal vesicle(s)
T4--Tumor is fixed or invades adjacent structures other than seminal vesicles: bladder neck, external sphincter, rectum, levator muscle and/or pelvic wall
*Note: Tumor found in one or both lobes by needle biopsy, but not palpable or reliably visible by imating, is classified as T1c. 
**Note: Invasion into the prostatic apex or into (but not beyond) the prostatic capsule is not classified as T3, but as T2

Regional lymph node(N)
Nx--Regional lymph nodes were not assessed 
N0--No regional lymph node metastasis 
N1--Metastasis in regional lymph node(s)

Distant metastasis(M)
Mx--Distant metastasis cannot be assessed (not evaluated by any modality)
M0--No distant metastasis 
M1--Distant metastasis 
  M1a--Non-regional lymph node(s)
  M1b--Bone(s)
  M1c--Other site(s) with or without bone disease
)
  }
  else if (cheat = "cr")
  {
    MsgBox,
(
Colorectal Cancer (AJCC, 7th ed)
Primary Tumor (T)
TX--Primary tumor cannot be assessed 
T0--No evidence of primary tumor
Tis--Carcinoma in situ: intraperitoneal or invasion of lamina propria
T1--Tumor invades submucosa
T2--Tumor invades muscularis propria
T3--Tumor invades through the muscularis propria into the subserosa, or into non-peritonealized perocolic or perirectal tissues
T4--Tumor direct invades adjacent organs or structures, and/or perforation visceral peritoneum

Regional Lymph Nodes (N)
NX--Regional lymph node cannot be assessed
N0--No regional lymph node metastasis
N1--Metastasis in 1 to 3 regional lymph nodes
N2--Metastasis in 4 or more regional lymph nodes

Distant Metastasis (M)
MX--Distant metastasis cannot be assessed
M0--No distant metastasis
M1--Distant metastasis
)
  }
  else if (cheat = "cc")
  {
    MsgBox,
(
Cervical Cancer (FIGO stage)
0	Carcinoma in situ (preinvasive carcinoma)
I	Cervical carcinoma confined in uterus (extension to corpus should be disregarded)
IA	Invasive carcinoma diagnosed only by microscopy; no visible lesions
IA1	Stromal invasion less than 3.0 mm in depth and 7.0 mm or less in horizontal spread
IA2	stromal invasion between 3.0 and 5.0 mm with horizontal spread 7.0 mm or less
IB	Clinically visible lesion confirmed at cervix or microscopic lesion greater than IA2/T1a
IB1	Clinically visible lesion 4.0 cm or less in greatest dimension
IB2	Clinically visible lesion more than 4.0 cm in greatest dimension
II	Tumor invades beyond uterus but not to pelvic wall or lower third of vaginau
IIA	Without parametrial invasion, but involve upper 2/3 of vagina
IIB	With parametrial invasion
III	Tumor extends to pelvic wall or lower third of the vagina
IIIA	Tumor involves lower third of vagina, no extension to pelvic wall
IIIB	Tumor extends to pelvic wall and/or causes hydronephrosis or non-functioning kidney
IVA	Tumors invades mucosa of bladder or rectum and/or extends beyond true pelvis
IVB	Distant metastasis
)
  }
  else if (cheat = "npc")
  {
    MsgBox,
(
Nasopharyngeal Cancer (AJCC, 7th ed)
Primary tumor (T)
T1-- Tumor confined to the nasopharynx, or extends to oropharynx and/or nasal cavity without parapharyngeal extension*   
T2-- Tumor with parapharyngeal extension* 
T3-- Tumor involves bony structures of skull base and/or paranasal sinuses   
T4-- Tumor with intracranial extension and/or involvement of involvement of cranial nerves, hypopharynx, orbit, or with extension to the 
infratemporal fossa/masticator space 
* Parapharyngeal extension denotes posterolateral infiltration of tumor. 

Regional lymph node (N)
NX-- Regional lymph nodes cannot be assessed 
N0-- No regional lymph node metastasis 
N1-- Unilateral metastasis in lymph node(s), 6 cm or less in greatest dimension, above the supraclavicular fossa, and/or unilateral or 
bilateral, retropharyngeal lymph nodes, 6 cm or less, in greatest dimension* 
N2-- Bilateral metastasis in lymph node(s), 6 cm or less in greatest dimension, above the supraclavicular fossa* 
N3-- Metastasis in a lymph node(s)* >6 cm and/or extension to supraclavicular fossa 
N3a--greater than 6cm in dimension 
N3b--extension to the supraclavicular fossa** 
* Midline nodes are considered ipsilateral nodes. 
**Supraclavicular zone or fossa is relevant to the staging of nasopharyngeal carcinoma and is the triangular region originally described by Ho. 
It is defined by three points: (1) the superior margin of the sternal end of the clavicle, 
(2) the superior margin of the lateral end of the clavicle, 
(3) the point where the neck meets the shoulder. 
Note that this would include caudal portions of Levels IV and VB. All cases with lymph nodes (whole or part) in the fossa are considered N3b 

Distant metastasis (M) 
MX--distant metastasis cannot be assessed 
M0--No distant metastasis (no pathologic M0; use clinical M to complete stage group) 
M1--Distant metastasis 
)
  }
  else if (cheat = "lung")
  {
    MsgBox,
(
Lung Cancer (AJCC, 7th ed)
Primary Tumor (T)
T0   No evidence of primary tumor
Tis   Tis Carcinoma in situ
T1	Tumor ≦3 cm , surrounded by lung or visceral pleura 
T1a  Tumor ≦2 cm in greatest dimension
T1b  Tumor > 2 cm but ≦3 cm in greatest dimension
T2	Tumor > 3 cm but ≦7 cm or tumor involves main bronchus , ≧2 cm distal to the carina, invades visceral pleura (PL1 or PL2) , Associated with atelectasis or obstructive pneumonitis that extends to the hilar region but does not involve the entire lung
T2a  Tumor > 3 cm but ≦5 cm in greatest dimension
T2b  tumor > 5 cm but ≦7 cm in greatest dimension
T3	Tumor > 7 cm or one that directly invades any of the following: parietal pleural (PL3) chest wall (including superior sulcus tumors), diaphragm, phrenic nerve, mediastinal pleura, parietal pericardium; or tumor in the main bronchus (< 2 cm distal to the carina* but without involvement of the carina; or associated atelectasis or obstructive pneumonitis of the entire lung or separate tumor nodule(s) in the same lobe
T4   Tumor of any size that invades any of the following: mediastinum, heart, great vessels, trachea, recurrent laryngeal nerve, esophagus, vertebral body, carina, separate tumor nodule(s) in a different ipsilateral lobe

Regional Lymph Nodes (N)
NX	Regional lymph nodes cannot be assessed
N0	No regional lymph node metastasis
N1	Metastasis in ipsilateral peribronchial and/or ipsilateral hilar lymph nodes and intrapulmonary nodes, including involvement by direct extension
N2	Metastasis in ipsilateral mediastinal and/or subcarinal lymph node(s)
N3	Metastasis in contralateral mediastinal, contralateral hilar, ipsilateral or contralateral scalene, or supraclavicular lymph node(s)

Distant Metastasis (M)
M0	No distant metastasis  
M1	Distant metastasis
M1a	Separate tumor nodule(s) in a contralateral lobe; tumor with pleural nodules or malignant pleural (or pericardial) effusion 
M1b	Distant metastasis
)
  }


    return
}


!F1::cheatsheet()
^y::SplashImage, Off
