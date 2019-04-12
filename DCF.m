%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETRI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_iterazioni=1000000;
anni_previsti = 10;
anni_decad = 10;
periodo = 2;
importanza_ultimi_anni = 1.2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



data_start = '01012017';
data_end = '01012018';
ford = hist_stock_data(data_start,data_end,'F');
sp500 = hist_stock_data(data_start,data_end,'^GSPC');
pf = ford.AdjClose;
pm = sp500.AdjClose;
s=size(pf);
s=s(1)-1;
X=1:s;
for i=X
    rappF(i) = pf(i+1)/pf(i)-1;
    rappSP(i) = pm(i+1)/pm(i)-1;
end
COVbeta = cov(rappF,rappSP);
beta = COVbeta(1,2)/COVbeta(2,2);
riskfree = 0.0269;
market_risk_premium = 0.0596;
cost_of_equity = riskfree + beta * market_risk_premium;

spread = 0.019;
cost_of_debt = riskfree + spread;

num_stock = 3974000000;
val_stock = 7.65;
value_of_equity = num_stock * val_stock;

interest_on_debt = 1200000000;
maturity = 15;
market_value_of_debt = 93635000000;
value_of_debt = interest_on_debt*(1-(1/((1+cost_of_debt)^maturity)))/cost_of_debt + market_value_of_debt/((1+cost_of_debt)^maturity);

tot_value = value_of_equity + value_of_debt;
tax_rate = 0.27;

WACC = cost_of_equity*(value_of_equity/tot_value) + cost_of_debt*(value_of_debt/tot_value)*(1-tax_rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

operating_income = [3203 	4881 	5786 	6982 	200 	12791 	5799 	7404 	7482 	-1955 	-15542 	-8464 	-16973 	-353 	4087 	1266 	1514 	-5952 	8264 	9748 	23814 	10699 	6003 	6681 	8574 	4120 	65 	-2333 	1532 	5141 	7664 	7651 	5427 	2730 	3422 	1804];

depreciation = [9280 	9122 	9023 	7993 	7385 	6504 	5486 	4717 	5900 	7667 	12536 	12820 	0	14010 	13038 	14229 	15040 	15136 	14146 	14305 	13903 	13583 	12791 	11719 	9336 	7468 	6756 	5778 	4880 	4229 	3792 	3460 	3152 	2393 	2308 	2292];
ammortization = [0 	0 	0 	0 	38 	40 	0 	0 	0 	0 	0 	0 	66 	55 	36 	35 	40 	296 	305 	193 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0];
DeA = depreciation + ammortization;

capital_expenditures = [-7785 	-7049 	-6992 	-7196 	-7463 	-6597 	-5488 	-4293 	-4092 	-4059 	-6492 	-5717 	-6848 	-7516 	-6738 	-7726 	-7263 	-6952 	-8348 	-7659 	-7756 	-8717 	-8651 	-8997 	-8546 	-6714 	-5697 	-5723 	-7163 	-6695 	-4712 	-3674 	-3409 	-3737 	-3515 	-2333];
CAPEX = capital_expenditures;
changes_in_working_capital = [3731 	2887 	2994 	2340 	1430 	-1824 	-3536 	-3332 	-2179 	2936 	-11060 	7046 	14265 	-3449 	-6582 	-5276 	5428 	3976 	1181 	605 	4703 	5505 	4436 	1637 	3826 	3086 	3314 	2884 	-214 	566 	220 	1873 	2795 	1015 	1799 	923];

operating_income = fliplr(operating_income);
DeA = fliplr(DeA);
CAPEX = fliplr(CAPEX);
changes_in_working_capital = fliplr(changes_in_working_capital);

FCFF = operating_income + DeA + CAPEX + changes_in_working_capital;
FCFF = 1000000*FCFF';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% calcola il grow rate %%%%%%
FCFF_ammortizzato = [];
grow_rate = [];
for i = 1 : (36/periodo)
    FCFF_ammortizzato(i) = mean(FCFF(periodo*(i-1)+1 : periodo*i));
    if (i>1)   grow_rate(i-1) = (FCFF_ammortizzato(i)-FCFF_ammortizzato(i-1)) / abs(FCFF_ammortizzato(i-1));
    end
end
%figure; plot(grow_rate); set(gca,'Xticklabel',[]); legend('Grow Rate 2-years'); saveas(gcf,'Grow_Rate_2.png')

%%%%%% assegna peso maggiore agli anni più prossimi %%%%%%%
counter=1; grow_rate_pesato=[];
for i = 1: (36/periodo - 1)
    for x=1:(round(importanza_ultimi_anni^i)+1)
        grow_rate_pesato(counter)=grow_rate(i);
        counter=counter+1;
    end
end
%figure; plot(grow_rate_pesato); set(gca,'Xticklabel',[]); legend('Grow Rate 2-years Pesato'); saveas(gcf,'Grow_Rate_2_Pesato12.png')
E = mean(grow_rate_pesato)^(1/periodo);
V = sqrt(var(grow_rate_pesato));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Plot Grow Rate %%%%%
fig_GR = figure;
hold on;
years=1983:2017;
for i = 2:36
    grow_rate(i-1) = (FCFF(i)-FCFF(i-1)) / abs(FCFF(i-1));
end
figure(fig_GR); plot(years,grow_rate);
%%%%% Plot FCFF %%%%%%
fig_FCFF = figure; 
hold on;
years=1983:2018; 
figure(fig_FCFF); plot(years,FCFF); 
ylim([-100000000000 100000000000])
%%%%% Plot Distribuzione %%%%%%
fig_DISTR = figure;
hold on;
distr_X = -99:200; distribuzione=zeros(1,300);
figure(fig_DISTR); bar(distr_X,distribuzione,'b');



%%%%%% Inizio Iterazioni %%%%%%
pause(12);
buy=0; not_buy=0; future_FCFF=[]; future_grow_rate=[]; PV=[]; da_plottare_FCFF=[]; da_plottare_GR=[];
for iterazioni=1:num_iterazioni
    %%%%%% ipotizza GrowRate futuri 
    for i=1:anni_previsti
        future_grow_rate(i) = randn*V+E;
    end
    grow_rate_terminale = mean(future_grow_rate);
    
    %%%%%% ipotizza FreeCashFlow futuri
    future_FCFF(1) = FCFF(36) + future_grow_rate(1)*abs(FCFF(36));
    for i=2:anni_previsti
        future_FCFF(i) = future_FCFF(i-1) + future_grow_rate(i)*abs(future_FCFF(i-1));
    end
    
    %%%%%%% ipotizza TerminalValue
    TV = future_FCFF(anni_previsti) * (1 + grow_rate_terminale)/(WACC - grow_rate_terminale);
    if grow_rate_terminale>=WACC
        TV=0;
        GR_decad_lineare = linspace(grow_rate_terminale, 0.05, anni_decad);
        provv=future_FCFF(anni_previsti);
        for j=1:anni_decad  %%%%numero di anni in cui il growrate arriva allo standard
            provv = provv*GR_decad_lineare(j);
            TV = TV + provv/((1+WACC)^j);
        end
        TV = TV  +  provv * (1 + 0.05)/(WACC - 0.05) * (1/((1+WACC)^10));
    end
    if grow_rate_terminale<-1
        TV=0;
    end
    
    
    %%%%%%% discount al tempo attuale
    for i=1:anni_previsti
        PV(i) = future_FCFF(i)/((1+WACC)^i);
    end
    TV = TV/((1+WACC)^anni_previsti);
    %%%%%%% calcola il firm value
    tot = sum(PV)+TV;
    valore_calcolato = (tot - market_value_of_debt)/ num_stock;
    if valore_calcolato>val_stock
        buy=buy+1;
    else
        not_buy=not_buy+1;
    end
    if (valore_calcolato>=-99) && (valore_calcolato<=199)
        distribuzione(round(valore_calcolato+0.5)+100) = distribuzione(round(valore_calcolato+0.5)+100)+1;
    end


    %%%% PLOTTA FCFF %%%%
    da_plottare_FCFF(1)=FCFF(36);
    for i=2:(anni_previsti+1)
        da_plottare_FCFF(i)=future_FCFF(i-1);
    end
    years=2018:(2018+anni_previsti);
    figure(fig_FCFF); plot(years,da_plottare_FCFF);
    %%%% PLOTTA Grow Rate %%%%
    da_plottare_GR(1)=grow_rate(36/periodo -1);
    for i=2:(anni_previsti+1)
        da_plottare_GR(i)=future_grow_rate(i-1);
    end
    years=2017:(2017+anni_previsti);
    figure(fig_GR); plot(years,da_plottare_GR);
    %%%% PLOTTA la distribuzione %%%%
    figure(fig_DISTR); bar(distr_X,distribuzione,'b');
end
%%%%% Salva i plot su file %%%%%
figure(fig_FCFF); saveas(gcf,'MontecarloFCFF.png')
hold off;
figure(fig_GR); saveas(gcf,'MontecarloGR.png');
hold off;
figure(fig_DISTR); bar(distr_X,distribuzione,'b'); saveas(gcf,'MontecarloDistribuzione.png');
hold off;

percentuale_simulazioni_positive = buy/(buy+not_buy)