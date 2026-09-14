clear all
set more off

import excel "D:\Kerjaan\Research Consultant\Project GMM Stata\Dataset with ID.xlsx", sheet("Sheet1") firstrow
xtset ID Year

* There is 2 models
* NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP
* LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP

* Analisis Deskriptif
summarize ROA ROE NIM NPL_n LLP GCLR BOPO CAR Aset GGDP

* ssc install winsor
winsor NIM, gen(NIM_w) h(8)
winsor GCLR, gen(GCLR_w) h(3)
winsor BOPO, gen(BOPO_w) h(15)
winsor CAR, gen(CAR_w) h(8)

gen LnAset = log(Aset)

summarize ROA ROE NIM_w NPL_n LLP GCLR_w BOPO_w CAR_w LnAset GGDP

* Matriks Korelasi
correlate ROA ROE NIM_w NPL_n LLP GCLR_w BOPO_w CAR_w LnAset GGDP

*** Model 4 ***
*** Common Effects Model ***
reg NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP
estimates store cem4

*** Fixed Effects Model ***
xtreg NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, fe
estimates store fem4

*** Random Effects Model ***
xtreg NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, re
estimates store rem4

* Hausman test
hausman fem4 rem4

* LM test
xtreg NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, re
xttest0

*** Model terbaik untuk model 4 adalah REM ***
xtreg NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, re


*** Model 5 ***
*** Common Effects Model ***
reg LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP
estimates store cem5

*** Fixed Effects Model ***
xtreg LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, fe
estimates store fem5

*** Random Effects Model ***
xtreg LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, re
estimates store rem5

* Hausman test
hausman fem5 rem5

*** Model terbaik untuk model 5 adalah FEM ***
xtreg LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, fe

save "D:\Kerjaan\Research Consultant\Project GMM Stata\Final Data NLP and LLP.dta", replace