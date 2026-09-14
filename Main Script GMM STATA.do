clear all
set more off

import excel "D:\Kerjaan\Research Consultant\Project GMM Stata\Dataset with ID.xlsx", sheet("Sheet1") firstrow
xtset ID Year

* There is 5 models
* ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
* ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
* NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
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

* Model 1
*** Common Effects Model ***
reg ROA l.ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
estimates store cem

*** Fixed Effects Model ***
xtreg ROA l.ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, fe
estimates store fem

*** Diff GMM Two Step Estimator ***
xtabond ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store fdgmm

** Uji Instrumen yg Digunakan (overidentifying restrictions) valid (Ho) pada Diff GMM **
estat sargan

** Uji Konsistensi: Arellano-Bond test for zero autocorrelation in first differenced errors pada Diff GMM **
estat abond

*** Diff GMM Two Step Estimator ***
xtdpdsys ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store sysgmm

** Uji Instrumen yg Digunakan (overidentifying restrictions) valid (Ho) pada Sys GMM **
estat sargan

** Uji Konsistensi: Arellano-Bond test for zero autocorrelation in first differenced errors pada Sys GMM **
estat abond

*** Pemilihan Model Terbaik ***
estimates table fem fdgmm sysgmm cem, star stats(N r2 r2_a)

*** Persamaan Jangka Panjang Model Terbaik ***
xtabond ROA GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep

*** Rasio Jangka Panjang untuk Tiap Variabel ***
nlcom (_b[GCLR_w] / (1 - _b[L1.ROA])) (_b[BOPO_w] / (1 - _b[L1.ROA])) (_b[CAR_w] / (1 - _b[L1.ROA])) (_b[NPL_n] / (1 - _b[L1.ROA])) (_b[LnAset] / (1 - _b[L1.ROA])) (_b[GGDP] / (1 - _b[L1.ROA]))

*** Model 2 ***
*** Common Effects Model ***
reg ROE l.ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
estimates store cem2

*** Fixed Effects Model ***
xtreg ROE l.ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, fe
estimates store fem2

*** Diff GMM Two Step Estimator ***
xtabond ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store fdgmm2

estat sargan
estat abond

*** Sys GMM Two Step Estimator ***
xtdpdsys ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store sysgmm2

estat sargan
estat abond

*** Pemilihan Model Terbaik ***
estimates table fem2 fdgmm2 sysgmm2 cem2, star stats(N r2 r2_a)

*** Rasio Jangka Panjang Model Terbaik ***
xtabond ROE GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep

nlcom (_b[GCLR_w] / (1 - _b[L1.ROE])) (_b[BOPO_w] / (1 - _b[L1.ROE])) (_b[CAR_w] / (1 - _b[L1.ROE])) (_b[NPL_n] / (1 - _b[L1.ROE])) (_b[LnAset] / (1 - _b[L1.ROE])) (_b[GGDP] / (1 - _b[L1.ROE]))

*** Model 3 ***
*** Common Effects Model ***
reg NIM_w l.NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP
estimates store cem3

*** Fixed Effects Model ***
xtreg NIM_w l.NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, fe
estimates store fem3

*** Diff GMM Two Step Estimator ***
xtabond NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store fdgmm3

estat sargan
estat abond

*** Sys GMM Two Step Estimator ***
xtdpdsys NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep
estimates store sysgmm3

estat sargan
estat abond

*** Pemilihan Model Terbaik ***
estimates table fem3 fdgmm3 sysgmm3 cem3, star stats(N r2 r2_a)

*** Persamaan Jangka Panjang Model Terbaik ***
xtdpdsys NIM_w GCLR_w BOPO_w CAR_w NPL_n LnAset GGDP, lags(1) artest(2) twostep

*** Rasio Jangka Panjang Model Terbaik ***
nlcom (_b[GCLR_w] / (1 - _b[L1.NIM_w])) (_b[BOPO_w] / (1 - _b[L1.NIM_w])) (_b[CAR_w] / (1 - _b[L1.NIM_w])) (_b[NPL_n] / (1 - _b[L1.NIM_w])) (_b[LnAset] / (1 - _b[L1.NIM_w])) (_b[GGDP] / (1 - _b[L1.NIM_w]))

*** Menghitung Kecepatan Convergence ***
display -log(0.617405)

*** Model 4 ***
*** Common Effects Model ***
reg NPL_n l.NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP
estimates store cem4

*** Fixed Effects Model ***
xtreg NPL_n l.NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, fe
estimates store fem4

*** Diff GMM Two Step Estimator ***
xtabond NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep
estimates store fdgmm4

estat sargan
estat abond

*** Sys GMM Two Step Estimator ***
xtdpdsys NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep
estimates store sysgmm4

estat sargan
estat abond

*** Pemilihan Model Terbaik ***
estimates table fem4 fdgmm4 sysgmm4 cem4, star stats(N r2 r2_a)

*** Rasio Jangka Panjang Model Terbaik ***
xtdpdsys NPL_n GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep

nlcom (_b[GCLR_w] / (1 - _b[L1.NPL_n])) (_b[BOPO_w] / (1 - _b[L1.NPL_n])) (_b[CAR_w] / (1 - _b[L1.NPL_n])) (_b[ROA] / (1 - _b[L1.NPL_n])) (_b[LnAset] / (1 - _b[L1.NPL_n])) (_b[GGDP] / (1 - _b[L1.NPL_n]))

display -log(.5679474)

*** Model 5 ***
*** Common Effects Model ***
reg LLP l.LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP
estimates store cem5

*** Fixed Effects Model ***
xtreg LLP l.LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, fe
estimates store fem5

*** Diff GMM Two Step Estimator ***
xtabond LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep
estimates store fdgmm5

estat sargan
estat abond

*** Sys GMM Two Step Estimator ***
xtdpdsys LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep
estimates store sysgmm5

estat sargan
estat abond

*** Pemilihan Model Terbaik ***
estimates table fem5 fdgmm5 sysgmm5 cem5, star stats(N r2 r2_a)

*** Rasio Jangka Panjang Model Terbaik ***
xtdpdsys LLP GCLR_w BOPO_w CAR_w ROA LnAset GGDP, lags(1) artest(2) twostep

nlcom (_b[GCLR_w] / (1 - _b[L1.LLP])) (_b[BOPO_w] / (1 - _b[L1.LLP])) (_b[CAR_w] / (1 - _b[L1.LLP])) (_b[ROA] / (1 - _b[L1.LLP])) (_b[LnAset] / (1 - _b[L1.LLP])) (_b[GGDP] / (1 - _b[L1.LLP]))

display -log(.7890212)

save "D:\Kerjaan\Research Consultant\Project GMM Stata\Final Data.dta", replace