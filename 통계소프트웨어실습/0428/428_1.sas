filename ds "/folders/myfolders/help.csv";

proc import datafile=ds dbms=csv out=help replace;
	getnames=yes;
run;

data CESD;
	set help;
	keep id cesd cesd1 cesd2 cesd3 cesd4 f1a -- f1t female treat substance 
		age racegrp;
run;

data ds1;
set CESD;
if id = . then delete;
run;
 
proc means data=ds1;
var age;
run;

proc summary data= ds1;
var age;
output out= ds1_sum;
run;

proc print data=ds1_sum;
run;

proc univariate data=ds1;
var age;
run;

ods output moments=moments_of_x;
proc univariate data=ds1;
var age;
run;
/* 정규분포 기준, 첨도(kurtosis) : 분포의 뾰족한 정도, 
0보다 크면 봉우리가 볼록해지고 반대로 작으면 분포의 높이가 낮아진다.*/
/* 왜도(skewness) : 분포의 비대칭성 정도,
양수이면 오른쪽으로 치우져져 있고 음수이면 왼쪽으로 치우져짐 */

proc univariate data=ds1 trimmed=0.1;
var age;
run;

proc univariate data=ds1;
var age;
output out=ds3 pctlpts=2.5, 95 to 97.5 by 1.25 /* 2.5와 95, 96.25, 97.5 퍼센타일의 수를 빼서 따로 데이터를 ds3로 만듦*/
pctlpre=p pctlname=P2_5 P95 P96_25 P97_5; /* 각 열의 이름 앞에 붙을 것 = p, 각 수치에 해당하는 열 이름부여 */
run;

proc standard data=ds1 out= ds4 mean=0 std=1;
var age; /* age를 기준 표준화하여 표준정규분포의 형태로 나타냄 (etc. 0에 가까울수록 평균에 가까움) */
run;

proc means data=ds1 lclm mean uclm;
var age;
run;

proc freq data=ds1;
tables age/binomial;
run;