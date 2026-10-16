﻿﻿; Author:         HTL
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;--------------------------------------------------------------------------
^!s::Suspend  ; Assign the toggle-suspend function to a hotkey.

^!q:: ; Assign Ctrl-Alt-Q as a hotkey to quit RIS and the script.
ExitApp

^!e:: ; Assign Ctrl-Alt-E as a hotkey to edit the script.
Edit
return

^!r:: ; Assign Ctrl-Alt-R as a hotkey to restart the script.
Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return
;----------------------------------------------------------------------------



;F10::F9
;F1::F2
;F3::F2

::AD::No definite lesion at both adrenal glands. 	
::AO::Atherosclerosis with wall calcification of the aorta. 	
::BCT::s/p bilateral chest tube insertion.	
::BI::There are bilateral lung consolidations. 	
::bil.::bilateral 
::BLL::bilateral lower lung zones. 	
::BO::Borderline heart size. 	
::BP::Diffusely decreased visible bone density, suggestive of osteoporosis. 
::C::Enlarged heart shadow. 	
::CAD::Calcified atherosclerotic plaque noted at coronary artery. Coronary atherosclerosis is considered. 	
::CM::Compared with previous study, no significant interval change is noted. 	
::CO::Consolidation noted at 	
::CP::CP angle. 	
::DJ::Degenerative change of both shoulders. 	
::EF::Much fecal material is noted in the bowel. 	
::EL::Focal dilated bowel loops, suggestive of focal ileus at 	
::EU::Dilated bowel loops, suggestive of ileus. 
::F::Fracture line noted at 
::FC::Compression fracture is noted at 
::FI::Fibrotic change noted at 
::FU::Mild fibrotic change in upper lung zones with apical pleural thickening. 
::GB::Metallic clips noted at RUQ, previous cholecystectomy is considered. 
::GG::Suggest follow up and correlate with clinical manifestation. 
::GS::Radiopaque lesion at RUQ of abdomen. R/O gallstone. 
::GT::Suggest correlation with CT study. 
::HD::hemidiaphragm. 
::I::There are line(s) / tube(s) placement with courses and tips superimposed at normal position. 
::IC::is considered. 
::ICP::is compatible. 
::ID::ill-defined 
::II::Increased infiltration at 
::IOR::This study was performed in the operating room for evaluation of catheter placement. No evidence of malpositioning of the catheter is noted. 
::KN::Normal alignment. Mild marginal osteophytes formation is noted. 
::LAP::lymphadenopathy 
::LCT::s/p chest tube insertion at left side. 
::LE::Emphysematous change of both lung. 
::LG::Diffusely linear shadows over bilateral lungs, chronic interstitial lung disease is considered. 
::LL::The lung parenchyma are symmetrical in density with normal pulmonary markings and no masses evident. There is no pleural thickening and the costophrenic angles are sharp. 
::LLL::left lower lung zone. 
::LM::Increased bilateral lung marking. 
::LML::left middle lung zone. 
::LN::No definite lymphadenopathy. 
::LT::left 
::MCT::s/p drainage tube insertion at mediastinum. 
::META::metastasis 
::MT::Multiple varied-size nodules at both lungs. Compatible with lung metastasis. 
::N::Normal heart size. 
::NA::The bowel gas pattern is unremarkable. No abnormal calcific density in the region of the kidney or ureter is noted. 
::NG::S/p NG tube insertion. 
::NLC::Nuchal ligament calcification is noted. 
::NT::No significant lesion at 
::NOS::Non-specific small mediastinal lymph nodes. 
::NP::Non-specific bowel gas pattern. 
::OA::Joint space narrowing with spurs formation, osteoarthritis is compatible. 
::OC::External casting is found. 
::OFA::Old fracture noted at 
::OW::Post-op change with metallic wire fixation at sternum. 
::PA::S/P portacath insertion. 
::PM::s/p pacemaker insertion. 
::PD::Hyperinflation with chronic infiltration is noted over bilateral lungs, COPD is compatible. 
::PE::Increased infiltration at bil. perihilar region. R/O pulmonary edema. 
::PH::Phleboliths noted in pelvic cavity. 
::PIGTAIL::pigtail catheter insertion 
::PL::pleural effusion. 
::PO::Post op change with 
::PR::Prominent 
::RCT::s/p chest tube insertion at right side. 
::RLL::right lower lung zone. 
::RML::right middle lung zone. 
::RS::renal stone 
::RT::right 
::RUL::right upper lung zone. 
::SB::Suboptimal study due to motion artifacts. 
::SD::Multiple marginal osteophytes with degenerative scoliosis are noted. 
::SE::Subcutaneous emphysema is noted at 
::SG::s/p pulmonary artery catheter insertion. 
::SH::The bilateral costophrenic angles are sharp. 
::SI::superimposed at 
::SKU::No definite bone lesion or fracture is recognized. No increased soft tissue density. 
::SL::Scoliosis of TL spine is noted. 
::SP::Spondylosis with degenerative marginal spurs are noted. 
::SUSP.::suspicious 
::T::Tortuous aorta. 
::TA::S/P endotracheal tube insertion. 
::TAE::Radiopaque density at RUQ of abdomen. Lipiodol retention from previous TAE effect is considered. 
::TAG::s/p Endotracheal tube and NG tube insertion. 
::TB::Fibronodular change of the bilateral upper lungs. R/O TB. 
::TC::Tortuous aorta with calcification. 
::TG::S/P nasogastric intubation. 
::TH::Bilateral apical pleural thickening. 
::TP::S/P central venous catheter insertion. 
::TR::S/P tracheostomy. 
::UD::IUD is noted superimposed in the pelvic cavity. 
::WA::was read and compared with previous study on 2007-. This study 
::WM::Widening mediastinum. 

