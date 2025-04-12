*This .do file is intended to be copied and pasted into the command window one paragraph at a time to generate each of the final figures. It comprises the final 30 studies included in this meta-analysis. This is not an exhaustive list of all analyses conducted but a presentation of the final results presented in the paper ~ Dr James S. Morris 15:32 GMT 21/03/2025.

capture log close
clear
/* .dta file availabel at https://github.com/TKMarkCheng/scerc2/blob/main/code/SCERC2_MA_DATA.dta

Code used to generate nice study labels for forest plots:
gen ncancerstring =string(ncancer, "%10.0fc")
replace ncancerstring = "NR" if ncancer==.
gen ncontrolstring =string(ncontrol,  "%10.0fc")
replace ncontrolstring = "NR" if ncontrol==.
gen a = "" in 1/-1
egen b = concat(ref Cohort), punct(" (")
rename ref Reference
egen c = concat(b ncancerstring), punct(": n=") format(%8.0fc)
egen d = concat(c ncontrolstring), punct(", m=") format(%8.0fc)
egen ref = concat(d a), punct(")")
drop a - d
sort ref
*/

* Total (All Cancer) All Outcomes mOR Only
preserve
drop in 173
drop in 170
drop in 168
drop in 167
drop if (outcome=="Critical Disease" | outcome=="Moderate Disease" | outcome=="Invasive Ventilation")
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mor"), random(reml) studylabel(ref) studysize(n) level(95)
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) *" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
drop if ref=="Konermann 2023 (Delta Cancer Cohort)" | ref=="Konermann 2023 (Omicron Cancer Cohort)"
gen neworder = 1 if outcome=="Hospitalisation"
replace neworder = 2 if outcome=="Severe Disease"
replace neworder = 3 if outcome=="ICU Admission"
replace neworder = 4 if outcome=="Mortality"
label define neworder 1 "Hospitalisation" 2 "Severe Disease" 3 "ICU Admission" 4 "Mortality"
label values neworder neworder
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys outcome (id) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
meta forestplot _id _plot _esci weight Ca Co, col(weight, format(%5.2f) title("Weight")) col(Ca, title("Cancer" "(n)")) col(Co, title("Non-Cancer" "(n)")) random(reml) level(95) subgroup(neworder) nullrefline transform("OR": exp) nooverall noohet noohom nogsig nogbhom ghetstats1text("Heterogeneity: {&chi}{sup:2}(10) = 2071.1, {it:p} < 0.0001, I{sup:2}=99.5%") gwhomtest1text("H{sub:0}: OR = 1, z = 3.46, {it:p} = 0.0005") ghetstats3text("Heterogeneity: {&chi}{sup:2}(13) = 763.4, {it:p} < 0.0001, I{sup:2}=97.3%") gwhomtest3text("H{sub:0}: OR = 1, z = 1.41, {it:p} = 0.16") ghetstats4text("Heterogeneity: {&chi}{sup:2}(19) = 2048.6, {it:p} < 0.0001, I{sup:2}=99.2%") gwhomtest4text("H{sub:0}: OR = 1, z = 4.63, {it:p} < 0.0001") ghetstats2text("Heterogeneity: {&chi}{sup:2}(11) = 164.7, {it:p} < 0.0001, I{sup:2}=97.0%") gwhomtest2text("H{sub:0}: OR = 1, z = 0.02, {it:p} = 0.98") noosig markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium))  gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10)) nullrefline(lcolor(red%85)) title(" {bf:Pooled Odds Ratios of Hospitalisation, ICU Admission, Mortality and}" "{bf:Severe Disease Amongst the Total Cancer Cohort versus Controls}", size(large) ring(30)) xlabel(0.25 "1/4" 0.5 "1/2" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16" 32 "32",labsize(small)) crop(0.01 50) subtitle("  "" "" "" "" " "{bf: <-- Greater Odds In Control Patients      Greater Odds In Cancer Patients -->                  }", color(maroon) ring(0) size(medsmall)) note("Restricted maximum-likelihood estimates for the pooled OR, weighted by the inverse variance of reported multivariate-adjusted ORs." "H{sub:0}: OR = 1 refers to the null hypothesis that the pooled OR for a given outcome is equal to 1." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies in each sub-group" "report multivariate-adjusted ORs sampled from one homogeneous population." "* The cancer cohort was split into recent treatment (n=4,296) and no recent treatment (n=9,991)")
restore

* Total (All Cancer) All Outcomes mHR Only
preserve
drop in 173
drop in 170
drop in 168
drop in 167
drop if (outcome=="Critical Disease" | outcome=="Moderate Disease"| outcome=="Invasive Ventilation" | outcome=="Severe Disease")
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mhr"), random(reml) studylabel(ref) studysize(n) level(95)
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys outcome (id) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
meta forestplot _id _plot _esci weight Ca Co, col(weight, format(%5.2f) title("Weight")) col(Ca, title("Ca." "(n)")) col(Co, title("Non-Ca." "(n)")) random(reml) level(95) subgroup(outcome) nullrefline transform("OR": exp) nooverall noohet noohom nogsig nogbhom noosig ghetstats1text("Heterogeneity: {&chi}{sup:2}(4) = 34.5, {it:p} < 0.0001, I{sup:2}=88.4%") gwhomtest1text("H{sub:0}: HR = 1, z = 1.75, {it:p} = 0.080") ghetstats2text("Heterogeneity: {&chi}{sup:2}(5) = 8.3, {it:p} = 0.14, I{sup:2}=39.8%") gwhomtest2text("H{sub:0}: HR = 1, z = 5.43, {it:p} < 0.0001") markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium)) gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10)) nullrefline(lcolor(red%85)) title(" {bf:Pooled Hazard Ratios of ICU Admission and Mortality}" "{bf:Amongst the Total Cancer Cohort versus Controls}", size(large) ring(30)) xlabel(0.5 "1/2" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16",labsize(small)) crop(0.25 18.8) subtitle(" "" "" "" "" ""{bf:<-- Greater Hazard In         Greater Hazard In -->                        }" "{bf:Non-Cancer Patients        Cancer Patients                              }", color(maroon) ring(0) size(medsmall)) note("Restricted maximum-likelihood estimates for the pooled HR, weighted by the inverse variance of reported multivariate-""adjusted HRs." "H{sub:0}: HR = 1 refers to the null hypothesis that the pooled HR for a given outcome is equal to 1." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies" "in each sub-group report multivariate-adjusted HRs sampled from one homogeneous population.") 
restore

* Cancer subtype
preserve
drop in 173
drop in 170
drop in 168
drop in 167
replace Cohort="Total Haematological" if (Cohort=="Leukaemia" | Cohort=="Lymphoma" | Cohort=="Multiple Myeloma" )
expand 2 if (Cohort=="Breast"| Cohort=="CNS"| Cohort=="Endocrine" | Cohort=="Gynaecological" | Cohort=="Head and Neck" | Cohort=="Hepato-Pancreato-Biliary" | Cohort=="Lower GI" | Cohort=="Upper GI" | Cohort=="Renal" | Cohort=="Sarcoma" | Cohort=="Skin Cancer" | Cohort=="Thoracic" | Cohort=="Urological"), gen(bb)
replace Cohort="Total Solid" if bb==1
drop if  statistic!="mor" | (Cohort!="Total Haematological" & Cohort!="Total Solid" & Cohort!="Breast"&  Cohort!="Lower GI" & Cohort!="Thoracic" & Cohort!="Urological" & Cohort!="Metastatic" & Cohort!="Non-Metastatic") | outcome!="Mortality"
drop if bb==1 & (Reference=="Starkey 2023" & ref!="Starkey 2023 (Total Solid)" | Reference=="Leuva 2022" & ref!="Leuva 2022 (Total Solid)" | Reference=="Nolan 2023" & ref!="Nolan 2023 (Non-Metastatic Solid Tumours)" & ref!="Nolan 2023 (Metastatic Solid Tumours)") | Reference =="Rugge 2022 (Breast)"
gen neworder = 1 if Cohort=="Total Haematological"
replace neworder = 2 if Cohort=="Total Solid"
replace neworder = 3 if Cohort=="Breast"
replace neworder = 4 if Cohort=="Lower GI"
replace neworder = 5 if Cohort=="Thoracic"
replace neworder = 6 if Cohort=="Urological"
replace neworder = 7 if Cohort=="Metastatic"
replace neworder = 8 if Cohort=="Non-Metastatic"
label define cancerorder 1 "Total Haematological" 2 "Total Solid" 3 "○         Breast" 4 "○         Lower GI" 5 "○         Thoracic" 6 "○         Urological" 7 "Metastatic" 8 "Non-Metastatic"
label values neworder cancerorder
replace ref ="○         Starkey 2023 (Breast)" if ref=="Starkey 2023 (Breast)" & neworder==3
replace ref ="○         Nolan 2023 (Breast)" if ref=="Nolan 2023 (Breast)" & neworder==3
replace ref ="○         Abuhelwa 2022 (Breast)" if ref=="Abuhelwa 2022 (Breast)" & neworder==3
replace ref ="○         Sullivan 2023 (Breast)" if ref=="Sullivan 2023 (Breast)" & neworder==3
replace ref ="○         Rugge 2022 (Breast)" if ref=="Rugge 2022 (Breast)" & neworder==3
replace ref ="○         Starkey 2023 (Lower GI)" if ref=="Starkey 2023 (Lower GI)" & neworder==4
replace ref ="○         Rugge 2022 (Lower GI)" if ref=="Rugge 2022 (Lower GI)" & neworder==4
replace ref ="○         Leuva 2022 (Colon)" if ref=="Leuva 2022 (Colon)" & neworder==4
replace ref ="○         Abuhelwa 2022 (Lower GI)" if ref=="Abuhelwa 2022 (Lower GI)" & neworder==4
replace ref ="○         Nolan 2023 (Lower GI)" if ref=="Nolan 2023 (Lower GI)" & neworder==4
replace ref ="○         Starkey 2023 (Lung)" if ref=="Starkey 2023 (Lung)" & neworder==5
replace ref ="○         Rugge 2022 (Lung)" if ref=="Rugge 2022 (Lung)" & neworder==5
replace ref ="○         Starkey 2023 (Non-Lung Thoracic)" if ref=="Starkey 2023 (Non-Lung Thoracic)" & neworder==5
replace ref ="○         Leuva 2022 (Thoracic)" if ref=="Leuva 2022 (Thoracic)" & neworder==5
replace ref ="○         Nolan 2023 (Thoracic)" if ref=="Nolan 2023 (Thoracic)" & neworder==5
replace ref ="○         Abuhelwa 2022 (Thoracic)" if ref=="Abuhelwa 2022 (Thoracic)" & neworder==5
replace ref ="○         Starkey 2023 (Urinary Tract)" if ref=="Starkey 2023 (Urinary Tract)" & neworder==6
replace ref ="○         Starkey 2023 (Penis, Testes or Male Genitalia)" if ref=="Starkey 2023 (Penis, Testes or Male Genitalia)" & neworder==6
replace ref ="○         Starkey 2023 (Prostate)" if ref=="Starkey 2023 (Prostate)" & neworder==6
replace ref ="○         Rugge 2022 (Prostate)" if ref=="Rugge 2022 (Prostate)" & neworder==6
replace ref ="○         Rugge 2022 (Bladder)" if ref=="Rugge 2022 (Bladder)" & neworder==6
replace ref ="○         Leuva 2022 (Prostate)" if ref=="Leuva 2022 (Prostate)" & neworder==6
replace ref ="○         Nolan 2023 (Urological)" if ref=="Nolan 2023 (Urological)" & neworder==6
replace ref ="○         Abuhelwa 2022 (Urological)" if ref=="Abuhelwa 2022 (Urological)" & neworder==6
gsort -enddate ref
drop if id==67122
meta set lnvalue se, random(reml) studylabel(ref) studysize(n) level(95)
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys Cohort (id) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
meta forestplot _id _plot _esci weight Ca Co, col(Ca, title("Ca.""(n)")) col(Co, title("Non-Ca.""(n)")) col(weight, format(%5.2f) title("Weight")) random(reml) level(95) subgroup(neworder) nullrefline transform("OR": exp) markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium)) gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10)) nullrefline(lcolor(red%85)) title(" {bf:Pooled Odds Ratios of Mortality Amongst}" "{bf:the Major Cancer Subtypes versus Controls}", size(medium) ring(30)) xlabel(0.5 "1/2" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16" 32 "32",labsize(medsmall)) crop(0.3 30) subtitle(" "" "" "" "" " "{bf:      <-- Greater Odds In Control Patients     Greater Odds In Cancer Patients -->                                     }", color(maroon) ring(0) size(medsmall)) ghetstats1text("Heterogeneity: {&chi}{sup:2}(7) = 325.4, {it:p} < 0.0001, I{sup:2}=97.3%") gwhomtest1text("H{sub:0}: OR = 1, z = 3.81, {it:p} = 0.0001") ghetstats2text("Heterogeneity: {&chi}{sup:2}(10) = 588.3, {it:p} < 0.0001, I{sup:2}=98.1%") gwhomtest2text("H{sub:0}: OR = 1, z = 3.01, {it:p} = 0.0026") ghetstats3text("○         Heterogeneity: {&chi}{sup:2}(3) = 50.1, {it:p} < 0.0001, I{sup:2}=94.0%") gwhomtest3text("○         H{sub:0}: OR = 1, z = 1.00, {it:p} = 0.32") ghetstats4text("○         Heterogeneity: {&chi}{sup:2}(3) = 41.2, {it:p} < 0.0001, I{sup:2}=92.7%") gwhomtest4text("○         H{sub:0}: OR = 1, z = 3.10, {it:p} = 0.0019") ghetstats5text("○         Heterogeneity: {&chi}{sup:2}(4) = 307.0, {it:p} < 0.0001, I{sup:2}=98.7%") gwhomtest5text("○         H{sub:0}: OR = 1, z = 4.05, {it:p} < 0.0001") ghetstats6text("○         Heterogeneity: {&chi}{sup:2}(5) = 96.6, {it:p} < 0.0001, I{sup:2}=94.8%") gwhomtest6text("○         H{sub:0}: OR = 1, z = 1.01, {it:p} = 0.31") ghetstats7text("Heterogeneity: {&chi}{sup:2}(1) = 190.1, {it:p} < 0.0001, I{sup:2}=99.5%") gwhomtest7text("H{sub:0}: OR = 1, z = 2.07, {it:p} = 0.038") ghetstats8text("Heterogeneity: {&chi}{sup:2}(3) = 87.9, {it:p} < 0.0001, I{sup:2}=96.6%") gwhomtest8text("H{sub:0}: OR = 1, z = 3.82, {it:p} = 0.0001")nooverall nogsig nogbhom noomarker ohomtesttext("H{sub:0}: OR{sub:Haem} = OR{sub:Solid} , {&chi}{sup:2}(1) = 3.32, {it:p} = 0.068") osigtesttext("H{sub:0}: OR{sub:Solid Subtype} = OR{sub:{&Sigma}(Solid Subtypes)} , {&chi}{sup:2}(3) = 9.07, {it:p} = 0.028") ohetstatstext("H{sub:0}: OR{sub:Metastatic} = OR{sub:Localised} , {&chi}{sup:2}(1) = 1.28, {it:p} = 0.26") note("Restricted maximum-likelihood estimates for the pooled odds ratio, weighted by the inverse variance of included studies." "H{sub:0}: OR = 1 refers to the null hypothesis that the pooled odds ratio for a given cancer subtype is equal to 1." "H{sub:0}: OR{sub:Haem} = OR{sub:Solid} refers to the null hypothesis that the pooled odds ratios for Haematological and Solid Malignancies were equal." "H{sub:0}: OR{sub:Solid Subtype} = OR{sub:{&Sigma}(Solid Subtypes)} refers to the null hypothesis that the pooled odds ratios for each of the solid cancer subtypes listed were equal." "{sub:0}: OR{sub:Metastatic} = OR{sub:Localised} refers to the null hypothesis that the pooled odds ratios for Metastatic and Localised Malignancies were equal." "This was assessed using the {&chi}{sup:2} test with N-1 degrees of freedom, where N is the number of sub-groups." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies in each sub-group" "report multivariate-adjusted odds ratios sampled from one homogeneous population.")
restore


*SARS-CoV-2*
preserve
drop in 173
drop in 170
drop in 168
drop in 167      
replace wt=1 if Reference=="Kodde 2023"
replace alpha=0 if Reference=="Kodde 2023"
gen omidelta =1 if Reference=="Turtle 2023" | Reference=="Leuva 2022" | Reference=="Salvatore 2023" 
label define neworder2 1 "Omicron" 2 "Omicron/ Delta" 3 "Delta" 4 "Alpha" 5 "Wild-Type"
replace wt=1 if id==71512 | id==141132
replace delta=0 if id==71512 | id==141132
gen strainorder2 = 1 if omicron==1
replace strainorder2 = 5 if wt==1
replace strainorder2 =3 if delta==1     
replace strainorder2 = 4 if Reference=="Udovica 2022" 
replace strainorder2 = 2 if omidelta==1 
label values strainorder2 neworder2 
drop if  statistic!="mor"| outcome!="Mortality" | Cohort!="Total Cancer Cohort"
drop if ref=="Turtle 2023 (Omicron Cancer Cohort)" | ref=="Turtle 2023 (Delta Cancer Cohort)" | ref=="Turtle 2023 (Wild-Type Cancer Cohort)" | ref=="Turtle 2023 (Alpha Cancer Cohort)"
gen omidelta =1 if Reference=="Turtle 2023" | Reference=="Leuva 2022" | Reference=="Salvatore 2023" | Reference=="Konermann 2023" | Reference=="Starkey 2023" | Reference=="Nolan 2023"
gen multistrain = 1 if wt + alpha + delta + omicron > 1
replace multistrain = 0 if multistrain!=1
expand 2 if id==124497, gen(deltaomicron)
replace Cohort="Delta" if id==124497 & deltaomicron==0
replace Cohort="Omicron" if id==124497 & deltaomicron==1
expand 2 if id==73383, gen(wtdelta)
replace Cohort="Delta" if id==73383 & wtdelta==0
replace Cohort="Wild-Type" if id==73383 & wtdelta==1
* expand 2 if id==68513, gen(wtalpha)
replace Cohort="Alpha" if id==68513 & wtalpha==0
replace Cohort="Wild-Type" if id==68513 & wtalpha==1
replace Cohort="Wild-Type" if wt==1 & multistrain==0
replace Cohort="Alpha" if alpha==1 & multistrain==0
replace Cohort="Delta" if delta==1 & multistrain==0
replace Cohort="Omicron" if omicron==1 & multistrain==0
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) **" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) **" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
replace ref="Konermann 2023 (Delta Cancer Cohort) †" if ref=="Konermann 2023 (Delta Cancer Cohort)"
replace ref="Konermann 2023 (Omicron Cancer Cohort) †" if ref=="Konermann 2023 (Omicron Cancer Cohort)"
drop if ref=="Konermann 2023 (Total Cancer Cohort)"
replace strainorder2=1 if Reference=="Park 2024"
meta set lnvalue se, random(reml) studylabel(ref) studysize(n) level(95)
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys strainorder2 (ref) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
label define neworder 1 "Omicron" 2 "Delta" 3 "Alpha" 4 "Wild-Type"
gen strainorder = 1 if Cohort=="Omicron"
replace strainorder = 2 if Cohort=="Delta"
replace strainorder = 3 if Cohort=="Alpha"
replace strainorder = 4 if Cohort=="Wild-Type"
label values strainorder neworder
duplicates tag if Reference== "Udovica 2022" , gen(dropit)
drop if dropit==1
meta forestplot _id _plot _esci weight Ca Co, subgroup(strainorder2) col(Ca, title("Ca." "(n)")) col(Co, title("Non-Ca.""(n)")) col(weight, format(%5.2f) title("Weight")) random(reml) level(95) nullrefline transform("OR": exp) noohet nooverall noomarker  markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium)) nogbhom noosig nogsig ghetstats1text("Heterogeneity: {&chi}{sup:2}(4) = 17.26, {it:p} = 0.0017, I{sup:2}=90.2%") gwhomtest1text("H{sub:0}: OR = 1, z = 4.95, {it:p} < 0.0001") ghetstats2text("Heterogeneity: {&chi}{sup:2}(2) = 57.5, {it:p} < 0.0001, I{sup:2}=95.4%") gwhomtest2text("H{sub:0}: OR = 1, z = 2.82, {it:p} = 0.0048") ghetstats3text("Heterogeneity: N/A") gwhomtest3text("H{sub:0}: OR = 1, z = 7.94, {it:p} < 0.0001") ghetstats4text("Heterogeneity: N/A") gwhomtest4text("H{sub:0}: OR = 1, z = 5.48, {it:p} < 0.0001") ghetstats5text("Heterogeneity: {&chi}{sup:2}(11) = 270.0 {it:p} < 0.0001, I{sup:2}=98.2%") gwhomtest5text("H{sub:0}: OR = 1, z = 3.05, {it:p} = 0.0023") gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10))  ohomtesttext("H{sub:0}: OR{sub:Variant} = OR{sub:{&Sigma}(Variants)}, {&chi}{sup:2}(4) = 20.4, {it:p} = 0.0004") nullrefline(lcolor(red%85)) title("{bf:Pooled Odds Ratios of Mortality Stratified by Predominant SARS-COV-2 Variant}", size(medium) ring(30)) xlabel(0.5 "0.5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16",labsize(vsmall)) crop(0.35 19) subtitle(" "" "" "" "" " "{bf:<-- Greater Odds In Control Patients     Greater Odds In Cancer Patients -->                          }", color(maroon) ring(0) size(medsmall)) note("Restricted maximum-likelihood estimates for the pooled odds ratio, weighted by the inverse variance of included studies." "H{sub:0}: OR = 1 refers to the null hypothesis that the pooled odds ratio for a given variant is equal to 1." "H{sub:0}: OR{sub:Variant} = OR{sub:{&Sigma}(Variants)} refers to the null hypothesis that the pooled odds ratios for each variant were equal." "This was assessed using the {&chi}{sup:2} test with N-1 degrees of freedom, where N is the number of variant sub-groups." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies in each variant" "sub-group report multivariate-adjusted odds ratios sampled from one homogeneous population." "* Two Predominant Variants **Single predominant variant; however, the cancer cohort was split into recent treatment (n=4,296)" "and no recent treatment (n=9,991) †Predominant strain was explicitly stated by the authors for each cohort.")
restore

* Omicron vs Non-Omicron Forest Plot Mortality mOR Only
preserve
drop if  statistic!="mor"| outcome!="Mortality" | Cohort!="Total Cancer Cohort"
drop if ref=="Turtle 2023 (Omicron Cancer Cohort)" | ref=="Turtle 2023 (Delta Cancer Cohort)" | ref=="Turtle 2023 (Wild-Type Cancer Cohort)" | ref=="Turtle 2023 (Alpha Cancer Cohort)"
gen multistrain = 1 if wt + alpha + delta + omicron > 1
replace multistrain = 0 if multistrain!=1
expand 2 if id==124497, gen(deltaomicron)
replace Cohort="Delta" if id==124497 & deltaomicron==0
replace Cohort="Omicron" if id==124497 & deltaomicron==1
expand 2 if id==73383, gen(wtdelta)
replace Cohort="Delta" if id==73383 & wtdelta==0
replace Cohort="Wild-Type" if id==73383 & wtdelta==1
expand 2 if id==68513, gen(wtalpha)
replace Cohort="Alpha" if id==68513 & wtalpha==0
replace Cohort="Wild-Type" if id==68513 & wtalpha==1
replace Cohort="Wild-Type" if wt==1 & multistrain==0
replace Cohort="Alpha" if alpha==1 & multistrain==0
replace Cohort="Delta" if delta==1 & multistrain==0
replace Cohort="Omicron" if omicron==1 & multistrain==0
replace Cohort="Wild-Type" if wt==1 & id==140255
duplicates drop ref Ca Co outcome if ref=="Udovica 2022 (Total Cancer Cohort)", force
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) **" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) **" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
replace ref="Konermann 2023 (Delta Cancer Cohort) †" if ref=="Konermann 2023 (Delta Cancer Cohort)"
replace ref="Konermann 2023 (Omicron Cancer Cohort) †" if ref=="Konermann 2023 (Omicron Cancer Cohort)"
drop if ref=="Konermann 2023 (Total Cancer Cohort)"
replace Cohort = "Pre-Omicron" if Cohort=="Wild-Type" | Cohort=="Alpha" | Cohort =="Delta"
meta set lnvalue se, random(reml) studylabel(ref) studysize(n) level(95)
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys Cohort (id) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
label define preoromicron 1 "Omicron" 2 "Pre-Omicron"
gen strainorder = 1 if Cohort=="Omicron"
replace strainorder = 2 if Cohort=="Pre-Omicron"
replace strainorder = 1 if ref=="Park 2024 (Total Cancer Cohort)"
label values strainorder preoromicron
meta forestplot _id _plot _esci weight Ca Co, subgroup(strainorder) col(Ca, title("Ca." "(n)")) col(Co, title("Non-Ca.""(n)")) col(weight, format(%5.2f) title("Weight")) random(reml) level(95) nullrefline transform("OR": exp) markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium))  gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10)) nullrefline(lcolor(red%85)) title("{bf:Pooled Odds Ratios of Mortality Stratified into Omicron and Pre-Omicron SARS-COV-2 Variants}", size(medium) ring(30)) xlabel(0.5 "0.5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16",labsize(vsmall)) crop(0.35 19) subtitle(" "" "" "" "" " "{bf:<-- Greater Odds In Control Patients     Greater Odds In Cancer Patients -->                         }", color(maroon) ring(0) size(medsmall)) note("Restricted maximum-likelihood estimates for the pooled odds ratio, weighted by the inverse variance of included studies." "H{sub:0}: OR = 1 refers to the null hypothesis that the pooled odds ratio for a sub-group is equal to 1." "H{sub:0}: OR{sub:Omicron} = OR{sub:Pre-Omicron} refers to the null hypothesis that the pooled odds ratios for Omicron and Pre-Omicron variants were equal." "This was assessed using the {&chi}{sup:2} test with N-1 degrees of freedom, where N is the number of sub-groups." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies in each variant" "sub-group report multivariate-adjusted odds ratios sampled from one homogeneous population." "**Single predominant variant; however, the cancer cohort was split into recent treatment (n=4,296)" "and no recent treatment (n=9,991) †Predominant strain was explicitly stated by the authors for each cohort.") noohet nooverall noomarker nogbhom noosig nogsig ghetstats2text("Heterogeneity: {&chi}{sup:2}(16) = 498.5, {it:p} < 0.0001, I{sup:2}=98.3%") gwhomtest2text("H{sub:0}: OR = 1, z = 4.42, {it:p} < 0.0001") ghetstats1text("Heterogeneity: {&chi}{sup:2}(4) = 17.3, {it:p} = 0.0017, I{sup:2}=90.2%") gwhomtest1text("H{sub:0}: OR = 1, z = 4.95, {it:p} < 0.0001") ohomtesttext("H{sub:0}: OR{sub:Omicron} = OR{sub:Pre-Omicron}, {&chi}{sup:2}(1) = 5.30, {it:p} = 0.021")
restore

*==== Analysis of vacciantion status
preserve
drop if Reference=="Turtle 2023" & ref!="Turtle 2023 (Total Cancer Cohort)"
drop if (Cohort!="Total Cancer Cohort" & refno!="(n=13,100, m=13,764)") | ref=="Konermann 2023 (Delta Cancer Cohort)" | ref=="Konermann 2023 (Omicron Cancer Cohort)" | statistic!="mor" | outcome!="Mortality"
replace ref="Leuva 2022 (Total Cancer Cohort) **" if ref=="Leuva 2022 (Total Cancer Cohort)"
replace ref="Chavez-MacGregor 2022 (Total Cancer Cohort) *" if ref=="Chavez-MacGregor 2022 (Total Cancer Cohort)"
meta set lnvalue se, random(reml) studylabel(ref) studysize(n) level(95)
quietly meta sum
egen totalwt = sum(_meta_weight)
gen percenttotalwt = 100* _meta_weight / totalwt
bys vax50 (id) : egen sgwt = sum(_meta_weight)
gen psgwt = 100 * _meta_weight / sgwt
gen a=""
egen weight = concat(psgwt a), format(%5.2f) punct("%")
meta forestplot _id _plot _esci weight Ca Co, col(weight, format(%5.2f) title("Weight")) col(Ca, title("Ca." "(n)")) col(Co, title("Non-""Ca.""(n)"))  random(reml) level(95) subgroup(vax50) nullrefline transform("OR": exp) noosig nogsig nogbhom ghetstats1text("Heterogeneity: {&chi}{sup:2}(4) = 227.0, {it:p} < 0.0001, I{sup:2}=98.3%") gwhomtest1text("H{sub:0}: OR = 1, z = 2.74, {it:p} = 0.0061") ghetstats2text("Heterogeneity: {&chi}{sup:2}(1) = 140.0, {it:p} < 0.0001, I{sup:2}=99.3%") gwhomtest2text("H{sub:0}: OR = 1, z = 1.41, {it:p} = 0.16") ghetstats3text("Heterogeneity: {&chi}{sup:2}(9) = 243.5, {it:p} < 0.0001, I{sup:2}=96.3%") gwhomtest3text("H{sub:0}: OR = 1, z = 3.13, {it:p} = 0.0017") ohomtesttext("H{sub:0}: OR{sub:Vaccinated} = OR{sub:Unvaccinated}, {&chi}{sup:2}(1) = 0.08, {it:p} = 0.77""H{sub:0}: OR{sub:Subgroup X} = OR{sub:Overall}, {&chi}{sup:2}(2) = 0.14, {it:p} = 0.93") ohetstatstext("H{sub:0}: OR = 1, z = 4.59, {it:p} < 0.0001") markeropts(mcolor(dkgreen%75) msize(medium)) ciopts(lcolor(black) lwidth(medium)) gmarkeropts(mcolor(dkgreen) mlwidth(thick) mfcolor(white%10)) omarkeropts(mcolor(red%85) mlwidth(thick) mfcolor(white%10)) nullrefline(lcolor(red%85)) title(" {bf:Pooled Odds Ratio of Mortality Stratified By Vaccination Status}", size(medium) ring(30)) xlabel(0.5 "1/2" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16",labsize(vsmall)) crop(0.3 50) subtitle(" "" "" "" "" "" " "{bf:<-- Greater Odds In Control Patients    Greater Odds In Cancer Patients -->                        }", color(maroon) ring(0) size(medsmall)) note("Restricted maximum-likelihood estimates for the pooled OR, weighted by the inverse variance of included studies." "H{sub:0}: OR = 1 refers to the null hypothesis that the pooled OR for a given sub-group is equal to 1." "H{sub:0}: OR{sub:Vaccinated} = OR{sub:Unvaccinated} refers to the null hypothesis that the pooled ORs from the ≥50% and <50% vaccinated cohorts were equal." "H{sub:0}: OR{sub:Subgroup X} = OR{sub:Overall} refers to the null hypothesis that the pooled ORs of each of the three cohorts were equal.""This was assessed using the {&chi}{sup:2} test with N-1 degrees of freedom, where N is the number of sub-groups." "Heterogeneity is reported both as the Cochran's Q statistic, {&chi}{sup:2}, and the I{sup:2} statistic." "The p value in the heterogeneity is derived from the Cochran's Q statistic, i.e., the likelihood that the individual studies in each sub-group" "report multivariate-adjusted ORs sampled from one homogeneous population.""* The cancer cohort of Chavez-MacGregor 2022 was split into recent treatment (n=4,296) and no recent treatment (n=9,991)" "** Leuva 2022 provided separate ORs of mortality for the vaccinated and unvaccinated cohorts")
restore

*================================ Funnel Plots== ==============================*
preserve
drop in 173
drop in 170
drop in 168
drop in 167  
drop if outcome!="Mortality" | statistic!="mor" | Cohort!="Total Cancer Cohort" |ref=="Konermann 2023 (Delta Cancer Cohort)" | ref=="Konermann 2023 (Omicron Cancer Cohort)"
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mor"), random(reml) studylabel(ref) studysize(n) level(95)
meta bias, egger tdist
meta funnelplot, level(95) random(reml) xtitle("OR of Mortality") ytitle("Standard Error") b2title("Egger's Test: t = 1.03" "{it:p} = 0.32 n = 20", size(small)) title("") xlabel(-0.693147 "1/2" 0 "1" 0.693147 "2" 1.386294 "4" 2.0794415 "8")
graph save mortfunnel, replace
restore
preserve
drop in 173
drop in 170
drop in 168
drop in 167 
drop if outcome!="Hospitalisation" | statistic!="mor" | Cohort!="Total Cancer Cohort"
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mor"), random(reml) studylabel(ref) studysize(n) level(95)
meta bias, egger tdist
meta funnelplot, level(95) random(reml) xtitle("OR of Hospitalisation") ytitle("") b2title("Egger's Test: t = 0.96" "{it:p} = 0.36 n = 11", size(small)) title("") text(0.14 0.76 "Rugge" "2022",size(vsmall)) xlabel(-1.386294 "1/4" -0.693147 "1/2" 0 "1" 0.693147 "2" 1.386294 "4")
graph save hospfunnel, replace
restore
preserve
drop in 173
drop in 170
drop in 168
drop in 167 
drop if outcome!="ICU Admission" | statistic!="mor" | Cohort!="Total Cancer Cohort"
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mor"), random(reml) studylabel(ref) studysize(n) level(95)
meta bias, egger tdist
meta funnelplot, level(95) random(reml) xtitle("OR of ICU Admission") ytitle("") b2title("Egger's Test: t = -1.10" "{it:p} = 0.29 n = 14", size(small)) title("") text(0.02 1.3 "Starkey" "2023",size(vsmall)) xlabel(-1.386294 "1/4" -0.693147 "1/2" 0 "1" 0.693147 "2" 1.386294 "4" 2.0794415 "8")
graph save icufunnel, replace
restore
preserve
drop in 173
drop in 170
drop in 168
drop in 167 
drop if outcome!="Severe Disease" | statistic!="mor" | Cohort!="Total Cancer Cohort"
meta set lnvalue se if (Cohort=="Total Cancer Cohort" & statistic =="mor"), random(reml) studylabel(ref) studysize(n) level(95)
meta bias, egger tdist
meta funnelplot, level(95) random(reml) xtitle("OR of Severe Disease")  ytitle("") b2title("Egger's Test: t = 0.18" "{it:p} = 0.86 n = 12", size(small)) title("") xlabel(-2.079442 "1/8" -1.386294 "1/4" -0.693147 "1/2" 0 "1" 0.693147 "2" 1.386294 "4" 2.0794415 "8")
graph save sevfunnel, replace
restore
grc1leg mortfunnel.gph hospfunnel.gph icufunnel.gph sevfunnel.gph, row(1) legendfrom(mortfunnel.gph) title("Reported Odds Ratios of Adverse Outcomes In The Total Cancer Cohort" "and The Risk of Publication Bias Therein", size(medsmall))

