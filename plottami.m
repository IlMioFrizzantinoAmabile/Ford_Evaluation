operating_income = 1000000*[3203 	4881 	5786 	6982 	200 	12791 	5799 	7404 	7482 	-1955 	-15542 	-8464 	-16973 	-353 	4087 	1266 	1514 	-5952 	8264 	9748 	23814 	10699 	6003 	6681 	8574 	4120 	65 	-2333 	1532 	5141 	7664 	7651 	5427 	2730 	3422 	1804];

depreciation = 1000000*[9280 	9122 	9023 	7993 	7385 	6504 	5486 	4717 	5900 	7667 	12536 	12820 	0	14010 	13038 	14229 	15040 	15136 	14146 	14305 	13903 	13583 	12791 	11719 	9336 	7468 	6756 	5778 	4880 	4229 	3792 	3460 	3152 	2393 	2308 	2292];
ammortization = 1000000*[0 	0 	0 	0 	38 	40 	0 	0 	0 	0 	0 	0 	66 	55 	36 	35 	40 	296 	305 	193 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0];
DeA = depreciation + ammortization;

capital_expenditures = 1000000*[-7785 	-7049 	-6992 	-7196 	-7463 	-6597 	-5488 	-4293 	-4092 	-4059 	-6492 	-5717 	-6848 	-7516 	-6738 	-7726 	-7263 	-6952 	-8348 	-7659 	-7756 	-8717 	-8651 	-8997 	-8546 	-6714 	-5697 	-5723 	-7163 	-6695 	-4712 	-3674 	-3409 	-3737 	-3515 	-2333];
CAPEX = capital_expenditures;
changes_in_working_capital = 1000000*[3731 	2887 	2994 	2340 	1430 	-1824 	-3536 	-3332 	-2179 	2936 	-11060 	7046 	14265 	-3449 	-6582 	-5276 	5428 	3976 	1181 	605 	4703 	5505 	4436 	1637 	3826 	3086 	3314 	2884 	-214 	566 	220 	1873 	2795 	1015 	1799 	923];

operating_income = fliplr(operating_income);
DeA = fliplr(DeA);
CAPEX = fliplr(CAPEX);
changes_in_working_capital = fliplr(changes_in_working_capital);

FCFF = operating_income + DeA + CAPEX + changes_in_working_capital;


x=1983:2018;
figure
hold on;
plot(x,operating_income);
plot(x,DeA);
plot(x,CAPEX);
plot(x,changes_in_working_capital);
hold off;
legend('Operating Income','DeA','CAPEX','CWC');
ylim([-30000000000 40000000000])
saveas(gcf,'Plot1.png')

figure
hold on;
plot(x,operating_income);
plot(x,DeA);
plot(x,CAPEX);
plot(x,changes_in_working_capital);
plot(x,FCFF,'LineWidth',2,'MarkerSize',10);
hold off;
legend('Operating Income','DeA','CAPEX','CWC','FCFF');
saveas(gcf,'Plot2.png')

xx = 2009:2018;
figure
hold on;
plot(xx,operating_income(27:36));
plot(xx,DeA(27:36));
plot(xx,CAPEX(27:36));
plot(xx,changes_in_working_capital(27:36));
hold off;
legend('Operating Income','DeA','CAPEX','CWC');
ylim([-10000000000 20000000000])
saveas(gcf,'Plot3.png')

figure
hold on;
plot(xx,operating_income(27:36));
plot(xx,DeA(27:36));
plot(xx,CAPEX(27:36));
plot(xx,changes_in_working_capital(27:36));
plot(xx,FCFF(27:36),'LineWidth',2,'MarkerSize',10);
hold off;
legend('Operating Income','DeA','CAPEX','CWC','FCFF');
ylim([-10000000000 20000000000])
saveas(gcf,'Plot4.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_start = '01012017';
data_end = '01012018';
ford = hist_stock_data(data_start,data_end,'F');
sp500 = hist_stock_data(data_start,data_end,'^GSPC');
pf = ford.AdjClose;
pm = sp500.AdjClose;
s=size(pf);
s=s(1)-1;
X=1:s;
rappF=[];
rappSP=[];
for i=X
    rappF(i) = pf(i+1)/pf(i)-1;
    rappSP(i) = pm(i+1)/pm(i)-1;
end
figure
hold on;
plot(rappF);
plot(rappSP);
hold off;
legend('Ford','S&P500');
set(gca,'Xticklabel',[])
saveas(gcf,'beta_1anno.png')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

futurex=2019:2023;
figure
hold on;
plot(x,FCFF);
for x=1:100
    futureFCFF(1) = (randn*V+E)*FCFF(36);
        PV(1) = futureFCFF(1)/(1+WACC);
    for i=2:5
        futureFCFF(i) = (randn*V+E)*futureFCFF(i-1);
        PV(i) = futureFCFF(i)/((1+WACC)^i);
    end
    plot(futurex,futureFCFF);
end
hold off;
