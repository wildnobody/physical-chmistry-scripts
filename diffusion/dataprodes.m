txtfiles = dir('WIN*.txt');
m = []
hold on;
for i = 1: length(txtfiles)
    currentMatrix = readmatrix(txtfiles(i).name);
    [f g] = fit(currentMatrix(:,1), currentMatrix(:,2), fittype('gauss1'));
    temp = diff(confint(f))/2;

    stdl = split(string(txtfiles(i).name), '_');
    m(i,1) = str2double(stdl(3))*3600 + str2double(stdl(4))*60 + str2double(stdl(5));
    m(i,2) = round(f.c1/sqrt(2), floor(-log10(temp(3)/sqrt(2))));    
    m(i,3) = round(temp(3)/sqrt(2), floor(-log10(temp(3)/sqrt(2))));
    m(i,4) = round(f.b1, floor(-log10(temp(2))));
    m(i,5) = round(temp(2), floor(-log10(temp(2))));
    m(i,6) = round(f.c1, floor(-log10(temp(1))));
    m(i,7) = round(temp(1), floor(-log10(temp(1))));
    
    m(i,8) = g.rsquare;

    plot(f);
    plot(currentMatrix(:,1),currentMatrix(:,2), '.');
end
m(:,1) = m(:,1) - min(m(:,1));
hold off

figure;
[f g] = fit(m(:,1), m(:,2).^2, fittype('poly1'))
errorbar(m(:,1),m(:,2).^2,2*m(:,3),2*m(:,3), '.');
hold on
plot(f);
hold off

writetable(array2table(m, 'VariableNames',{'time', 'standard deviation', 'standard deviation Error', ...
    'mean', 'mean Error', 'amplitude', 'amplitude Error', 'rsquared'}), 'KNO3.xlsx');