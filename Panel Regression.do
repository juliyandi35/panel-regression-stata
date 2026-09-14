// Rename dan perbaiki format data
rename var1 Tahun
rename var2 ID
rename var3 GDP
encode var4, gen(ESG)
encode var5, gen(EMP)
encode var6, gen(CCR)
encode var7, gen(TA)
encode var8, gen(DER)
encode var9, gen(ROA)

generate ESGEMP = ESG*EMP
generate ESG2 = ESG^2
generate ESGCCR = ESG*CCR

// Analisis deskriptif
summarize Tahun ID ROA ESG EMP CCR TA DER GDP
xtsum ROA ESG EMP CCR TA DER GDP

// Atur Tahun sebagai variabel waktu
xtset ID Tahun
 
// Uji normalitas
regress ROA ESG EMP CCR TA DER GDP
predict res, r
swilk res

pnorm res // plot norm

// Uji multikolinieritas
// Cara 1
corr ROA ESG EMP CCR TA DER GDP

// Cara 2
reg ROA ESG EMP CCR TA DER GDP
vif

// Uji Heteroskedastisitas
quietly reg ROA ESG EMP CCR TA DER GDP
hettest

// Uji Autokorelasi
xtserial ROA ESG EMP CCR TA DER GDP

// Model CEM
reg ROA ESG ESG2 EMP ESGEMP TA DER GDP
reg ROA ESG ESG2 CCR ESGCCR TA DER GDP

// Model FEM
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, fe
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP, fe

// Model REM
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP

// Uji Chow
// Model 1
reg ROA ESG ESG2 EMP ESGEMP TA DER GDP
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, fe
// hasilnya pilih FE

// Model 2
reg ROA ESG ESG2 CCR ESGCCR TA DER GDP
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP, fe
// hasilnya pilih FE

// Uji Hausman
// Model 1
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, re
quietly xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, fe
estimates store fe
quietly xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, re
estimates store re
hausman fe re
// Hasilnya pilih FE

// Model 2
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP, re
quietly xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP, fe
estimates store fe
quietly xtreg ROA ROA ESG ESG2 CCR ESGCCR TA DER GDP, re
estimates store re
hausman fe re
// Hasilnya pilih FE

// Uji LM
// Model 1
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP
xttest0
// Hasilnya pilih RE

// Model 2
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP
xttest0
// Hasilnya pilih RE

// Pemodelan dengan Fixed Effect
// Model 1
xtreg ROA ESG ESG2 EMP ESGEMP TA DER GDP, fe

// Model 2
xtreg ROA ESG ESG2 CCR ESGCCR TA DER GDP, fe
