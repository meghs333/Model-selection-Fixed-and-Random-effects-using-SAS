
data hw2;
set work.WAGE19;
run;

data hw;
set hw2;
wage = log(wage);
run;

* checking correlations;

proc corr data = hw;
  var edu hr famearn selfempl salaried married numkid age locunemp;
run;

* Model 1;

proc reg data = hw;
model wage = edu hr selfempl salaried married numkid age locunemp/vif collinoint;
run;

* adding variables to the data to find best models;

data hello; 
set hw;
run;
proc sql;
 alter table hello add agesqr numeric(10);
run;
proc sql;
  update hello
           set agesqr = age*age;             
RUN;
proc sql;
 alter table hello add hrsqr numeric(10);
run;
proc sql;
  update hello
           set hrsqr = hr*hr;            
RUN;
proc sql;
 alter table hello add edusal numeric(10);
run;
proc sql;
  update hello
           set edusal = edu*salaried;            
RUN;

*Models obtained by adding and removing required variables;

proc reg data = hello;
model wage = edu edusal hr selfempl salaried married numkid age locunemp/vif collinoint;
run;


* white test of model1;

proc model data = hw;
parms b0 b1 b2 b3 b4 b5 b6 b7; 
wage = b0 + b1*edu + b2*selfempl + b3*salaried + b4*married + b5*numkid+ b6*age+ b7*locunemp;
fit wage/white;
run;

*Q2;

PROC sgscatter  DATA = hw;
   PLOT wage * age;
RUN;

proc corr data = hw;
var wage age;
run;

proc loess data=hw;
 model wage= age;
 ods output OutputStatistics=Results;
run;

proc reg data = hello;
model wage = age agesqr;
run;


* Q3 ;

proc reg data = hw;
model wage = edu famearn hr selfempl salaried married numkid age locunemp/vif collinoint;
run;

proc corr data = hw;
  var wage famearn;
run;




* Q4 ;


proc panel data=hw;       
id ID Year;       
model wage = edu hr selfempl salaried married numkid age locunemp/fixone fixtwo ranone rantwo;    
run;





