;
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


::CTGGO::
(
CT of the chest without contrast enhancement and HRCT show: 
1. bilateral extensive ground glass opacity (GGO), more at lower lobes, right middle and inferior lingular segment of the left upper lobe. Some peripheral subpleural patchy ground glass opacity (GGO) are at upper lobes.
2. no definite mediastinal or hilar lymphadenopathy. bilateral small mediastinal lymph nodes. 
3. minimal left basal pleural effusion.  
4. no definite abnormality of both adrenals. 
extensive bilateral ground glass opacity (GGO). The possibility of pulmonary infection such as viral, PJP or atypical infection should be considered first if there is appropriate clinical setting. Other possibilities include hypersensitivity pneumonitis, drug-related change, DIP, etc. Clinical evaluation or BAL is suggested.
)
::hltr::
(
Clinical information: PDA with pulmonary hypertension. Pre-heart transplant evaluation. 
Paired inspiration/expiration thin section CT and ECG-gating chest CT with 3D and multiplanar reformation show:
1) Communication of pulmonary trunk and proximal descending aorta. The finding is consistent with PDA. Agenesis of right main pulmonary artery with prominent collateral vessels from systemic circulation, compatible with major aortopulmonary collateral arteries. Some engorged pulmonary arteries at peripheral RML.
2) Smooth thickening of interlobular septae, more on right upper lung, which are due to prominent pulmonary veins.
3) Diameters of the pulmoanry trunk about 2.5cm, ascending aorta 2.9cm, descending aorta 2.8cm (SE189 IM36). The largest diemaeter of the PA is about 3.1 cm at proximal portion (SE189, IM34). hypertrophy of the RV myocardium. pulmonary arterial hyertension is considered. 
4) Multiple calcified nodules at RUL, which are suggestive of old granulomatous infection. 
5) Small nonspecific lymph nodes at mediastinum. Some of lymph nodes are calcified. 
6) EF of RV: 71% (Biplane), EF of LV: about 72% (Biplane). 
7) Bronchial situs solitus. (HYS/Dr.YCC) 
)

 
::biopsyl::
(
CT-guided biopsy of the lung is performed in left decubitus position with the use of a 19G coaxial guiding needle and a 20G biopsy needle:
-- Location of the lesion: an subpleural nodule, measured 2.0cm in the greatest dimension, at the right lower lobe.
-- Underlying lung condition: no pulmonary emphysema 
-- Total length of the needle from skin to lesion: 5.1 cm
-- Total length of the needle traversing lung: 2.4 cm
-- Number of coaxial needle pass: 1
-- Number of cutting for biopsy needle: 2 (There is blood oozing from the coaxial needle after the first fire)
-- Pneumothorax: minimal
-- Hemothorax: nil
-- Hemorrhage: minimal focal hemorrhage
-- Hemoptysis: nil
-- Vital signs after biopsy: stable
-- Recommanded position after biopsy: right decubitus
-- There are total 2 tissue stripes and 3 imprint smears obtained for pathology and cytology studies. Suggest complete bed rest for 4 hours in right decubitus position. (HYS/Dr.YCC) 
)

::biopsym::    ;CT-guided mediastinum biopsy  M=mediastinum
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
-- There are total 1 tissue stripe, 4 imprint smears obtained for pathology and cytology studies. Suggest complete bed rest for 4 hours in supine position and follow up chest radiography 6 hours later after biopsy.(HYS/Dr.YCC) 

IMPRESSION:
Anterior mediastinal mass, status post CT-guided biopsy.
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
::CTNL::
(
History of a small RLL GGO nodule, for pre-operative CT-guided needle localization.
CT-guided needle localization is performed in prone position with the use of 20G localization wire.
-- Indication of needle localization:  RLL nodule. R/O malignancy.
-- Size and location of the lesion: a nodule (1cm) at the RLL.
-- Emphysema: no
-- Total length of the needle from skin to lesion: 7.3 cm
-- Total length of the needle traversing lung: 2.8 cm
-- Number of coaxial needle pass: 2
-- Pneumothorax: moderate
-- Hemorrhage: minimal
-- Hemoptysis: no
-- Vital signs after biopsy: stable
-- Recommanded position after procedure: supine.
The tip of hookwire passes the inferior portion of the targeted GGO nodule about 1 cm. Moderate pneumothorax happened while the 1st attempt of insertion of the localization wire. Thus, the wire was deployed 5mm inferiorly and 15mm medially to the lesion due to  increasing size of the left pneumothorax. Suggest arrangement of surgical intervention as soon as possible and complete bed rest  in supine position until initiation of surgery. Give adequate O2 supply and closely monitor patient's respiratory pattern.
(HYS/Dr.YCC) 

CT-guided needle localization of the ground glass opacity (GGO) nodule at RLL is performed.
)
::coroct::
(
HEART RATE: Mean heart rate 65 bpm.

EXAM:
Technique:
Computed tomography examination was performed using a 256-slice MDCT scanner (Brilliance iCT, Philips). Initial unenhanced axial CT imaging of the heart was obtained with prospective ECG trigger for the purpose of coronary artery calcium scoring (Agatston Method). Contrast enhanced CT imaging was performed with images obtained from the mid ascending aorta to the diaphragm at 0.8mm slice thickness and 0.27s tube rotation time. Nonionic contrast media (Ultravist 370mgI/ml, Bayer HealthCare) was injected using a dual-barrel injector (Stellant D, Medrad). Image reconstruction was performed using retrospective cardiac gating. The estimated effective radiation dose is 7.8 mSv.
Quality assessment:
Examination is of good quality with good bolus timing and good demonstration of coronary arteries.

FINDINGS:
Calcium score: (Agatston method)
* LM: 0
* LAD: 0
* LCX: 0
* RCA: 0
* Total: 0 (No detectable calcified plaque) 

Coronary artery analysis:
* No evidence of congenital vascular anomaly.
* Dominance: right.
* LM: patent.
* LAD: patent.
* LCX: patent.
* RCA: noncalcified plaque at middle RCA with moderate (about 50%) stenosis. 

LV functional analysis:
* No definite regional wall motion abnormality.
* End diastolic volume: 110.3(ml)
* End systolic volume: 24.7(ml)
* Stroke volume: 85..6(ml)
* Ejection fraction: 78%

Other findings:
* Normal left atrial appendage with no evidence of thrombosis. 
* The aortic valve is trileaflet. Normal mitral valve.
* Normal pericardium without pericardial thickening or effusion. 
* The visualized thoracic aorta appears normal in size. 
* Subsegmental atelectasis at right upper lobe.

Ventricular function: Normal.
Coronary artery: Coronary atherosclerosis with moderate (about 50%) stenosis at middle RCA.
Coronary artery dominance: Right.
)