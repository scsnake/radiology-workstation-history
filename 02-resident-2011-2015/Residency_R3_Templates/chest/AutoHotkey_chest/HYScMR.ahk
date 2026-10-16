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


::LVEF::
(
* LV function: 
EF of LV: 70.1%.
LVEDV= 295.55 ml 
LVESV= 225.08 ml 
LVEDVI= 211.51 ml/m^2
LVESVI= 161.08 ml/m^2 
nCI= 2237.46 ml/m^2_min  
BSA= 1.40 m^2 
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

::CHMRAOV::
(
Hx: Marfan's syndrome, for evaluation of aorta and valvular function.
Pulse sequences: ECG-gating T1 HASTE axial and coronal, T2 TrueFIST axial views, and TrueFISP cine for evaluation of AR. 
MRI findings:
1. Annuloaortic ectasia, with dilatation of the sinuses valsalva into ascending aorta, and with the maximal diameter measured 6 cm at the aortic root and 4.2 cm at the ascending aorta. 
2. No definite aortic dissection. 
3. No obvious AR. 

IMP: annuloaortic ectasia, without obvious aortic dissection or AR.
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

::CHMRPerf::
(
Clincal information: a 46 y/o male with exertional chest tightness. Treadmill and resting Tl-201 myocardial perfusion imaging showed visualization of RV after stress.
Pulse sequences: ECG-gating SR-prepped TurboFLASH for testing, resting, and stress first-pass myocardial perfusion, TrueFISP cine for LV function, and post-Gd IR-prepped segmented TurboFLASH for myocardial scarring
Medications:
> Dipyridamole 50 mg slow IV injection for 4 mins before stress perfusion imaging.
> Aminophylline 250 mg/10 ml slow IV injection after stress perfusion imaging.
MRI findings:
> No evidence of perfusion defect during resting or stress status.
> No chamber enlargement or hypertrophy.
> Normal contractility of LV and RV.
> No transvalvular regurgitation or stenosis.
> No abnormal hyperenhancement in RV or LV walls.
> LV function and mass: please refer to the uploaded images (series 27) on PACS.

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

::CHMRSX::
(
Purpose: syndrome X is suspected by clinical doctor
Pulse sequences: ECG-gating TrueFISP cine for LV function and regional wall motion, SR-prepped TurboFLASH for rest and stress myocardial perfusion, IR-prepped segmented TurboFLASH for myocardial fibrosis
MRI findings:
* Normal size of the cardiac chambers.
* Normal contractility of LV and RV wall.
* No transvalvular regurgitation or stenosis.
* No definite hyperenhancement of the myocardium.

* LV function and mass: (to be continued)
* Rest and stress myocardial perfusion (to be continued)
)

