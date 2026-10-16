Dependency:
- ImpaxContextServer
- Google Chrome (安裝 or 在資料夾內放portal版本)

Hotkey(對應按鈕):
- F5 (Open Study): 開啟影像(含舊片)
- Ctrl + S (Save): 存檔、開啟html（國健問卷）、發送報告
- Ctrl + 1: BI-RADS 1 template (於MammoSR.ini設定)
- Ctrl + 2: BI-RADS 2 template (於MammoSR.ini設定)
- Shift + Ctrl + 1: BI-RADS 1 template、Comparison選擇「第一次篩檢」
- Shift + Ctrl + 2: BI-RADS 2 template、Comparison選擇「第一次篩檢」
- Alt + 1, 2, 3, 4: 選擇breast composition
- Ctrl + Tab: activate主視窗

前置作業:
- MammoSR.ini中可設定BI-RADS 1、2的範本報告
- sign資料夾內放置簽名的圖片檔

建議流程:
- 開啟RIS/Impax
- 開啟報告撰打介面，並顯示以下欄位：照會單號、病歷號、姓名、性別、年齡
- 開啟MammoSR.exe
- 點Open Study（或者勾選Auto-open自動開啟影像），開啟影像時看一下問卷；非國健醫令不會動作
- 填入各項資訊
- BI-RADS 0,3,4,5的finding，「一定」要從小按鈕介面輸入(Calcification/Mass/Asymmetry等)，而且要在Suggestion欄位選取適當選項！
- 以小按鈕介面輸入的finding，要用Delete Last來刪除，如果出現錯誤建議按Reset All全部重新開始
- 文字輸入區可自由修改
- 點Save鈕，報告貼到RIS並開啟html
- html檔也可自由勾選，如果有修改要按網頁最下面的Save按鈕(限Chrome)
- 點Send鈕，將html傳送到server端
- RIS點發送報告

列印流程：
- 到PACS小組中間那台電腦
- 執行MammoSRSilentPrint.exe
- 選取html檔案（國健問卷），預設在MammoReportSaved資料夾內
- 列印順序為打報告順序（存檔時間排序）
- 已列印的html檔案會移動到MammoReports_printed資料夾內