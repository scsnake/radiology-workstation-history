::B0::BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest breast ultrasound or mag. spot view correlation.
::B1::BI-RADS 1, negative finding, suggest annual mammogram follow up or at the recommendation of the patient's physician.
::B2::BI-RADS 2, benign finding, suggest annual mammogram follow up or at the recommendation of the patient's physician.
::B3::BI-RADS 3, probably benign finding, suggest 6-month mammogram follow up.
::B4::BI-RADS 4, suspicious malignant lesion. Suggest tissue proof.


::B0C::
  clipboard=性質未定之乳房攝影發現，建議乳房超音波對照，與放大攝影。
  Send ^v
  return
::B1C::
  clipboard=無異常乳房攝影發現，建議每年追蹤。
  Send ^v
  return
::B2C::
  clipboard=良性乳房攝影發現，建議每年追蹤或依臨床醫師建議追蹤。
  Send ^v
  return
::B3C::
  clipboard=可能為良性乳房攝影發現，建議短期追蹤，並加超音波對照。
  Send ^v
  return
::B4C::
  clipboard=疑似不正常的乳房攝影發現，建議乳房超音波對照。
  Send ^v
  return
::LBC::
  clipboard=左乳
  Send ^v
  return
::RBC::
  clipboard=右乳
  Send ^v
  return
::BBC::
  clipboard=雙乳
  Send ^v
  return

::BB::bilateral breasts
::BCT::History of breast cancer s/p BCT with marking wire,
::BFBU::Benign findings of breast ultrasound.
::CAOP::no definite focal mass at ** breast. No definite lymphadenopathy at bilateral axillae, supraclavicular regions and anterior chest wall. Suggest regular follow-up.
::DIG::(digital)
::FA::fibroadenoma 
::FCC::fibrocystic change
::FHX::family history of breast cancer (sister/mother/grandmother),
::FS::For screening. 
::HCU::For health check up.
::JJ::(CUC/Dr.JW)
::LB::left breast
::LNR::benign appearing node at right axilla, size , having fat hilum.
::LNL::benign appearing node at left axilla, size , having fat hilum.
::MAG::spot magnification views
::MASY::Focal asymmetry is noted at right anterior UOQ near central, suggest ultrasound or mag. views.
::MCA::There are benign scattered calcifications present bilaterally.
::MCAV::There are benign appearing vascular wall calcifications at bilateral breasts.
::MCOM::Bilateral MLO/CC digital mammograms are read and compared with prior mammograms dated

::MCOMN::Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison.

::MD1::The breast is almost entirely fat
::MD2::There are scattered fibroglandular densities
::MD3::The breast is heterogeneously dense, which could obscure detection of small masses
::MD4::The breast is dense. This may lower the sensitivity of mammography
::MDE::The breast tissue is extremely dense, and this may obscure a lesion on mammography.
::MF::The breast tissue is almost entire fat.
::MFG::There are bilateral scattered fibroglandular tissues.
::MHDE::The breast tissue is heterogeneously dense, and this may lower the sensitivity of mammography.
::MHX::History: right breast tumor s/p op. Family history of breast cancer (mother). 
::MN::There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
::MMIC::There are two clusters of pleomorphic to amorphous microcalcifications at right UOQ, suggest biopsy.
::MMIC2::There are segmentally to regionally distributed microcalcifications at the UOQ left breast with probably benign appearance.
::MNE::There are no definite mass, and no architectural distortion in this study. 
::MNO::Bilateral MLO and CC digital mammograms are read without prior exams available for comparison.
::MOP::Focal parenchymal loss, architectural distortion and skin retraction are noted at left upper central breast under the wire, compatible with postop change. 
::MOP2::Focal architectural distortion, parenchymal retraction is noted at right UOQ under the wire and focal asymmetry near the surgical bed.
::MOP3::Post-op. changes at left UIQ breast with parenchymal loss, architectural deformity, skin retraction and thickening.
::MRM::History of breast cancer s/p MRM,
::MSUG::suggest breast ultrasound correlation and right mag. views.
::NP::No definite focal mass lesion. Suggest follow-up.
::PL::pleomorphic
::RB::right breast
::SAR::subareolar region
::SFUFNA::Suggest follow up and considered FNA if there is interval change. 
::SFU::Suggest follow up.
::SM::History: screening mammogram.
::SR::skin retraction
::ST::skin thickening
::USB::Ultrasound of both breasts shows 
::USH::Heterogenous breast tissue of bilateral breasts.
::USL::A cm hypoechoic lesion in right/left breast at o'clock/cm,
::USN::Probably benign ultrasound findings. Suggest follow up.
::WM::wire marked.

::NOPL::
(
1. s/p left mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in right breast. 
3. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
)

::NOPR::
(
1. s/p right mastectomy. No definite local recurrence. 
2. No definite mass lesion detected in left breast. 
3. No definite LAP at bil axillae, supraclavicular regions and anterior chest wall. 
)

::MFS::
(
History: follow up. 
Bilateral MLO/CC digital mammograms are read and no prior mammography for comparison. There are bilateral scattered fibroglandular tissues. There are benign appearing vascular wall calcifications at bilateral breasts. There are no definite mass, and no architectural distortion in this study.  (CHM/Dr.JW) 
)

::BE::
(
Ultrasound of breasts shows:
1. Heterogenous breast tissue of bilateral breasts. 
2. s/p right/left mastectomy/lumpectomy
3. A hypoechoic lesion in right/left breast at o'clock/cm sized cm, R/O
4. No definite axillary lymphadenopathy.
)
