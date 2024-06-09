% 
% 
% 
% TO EYAL - GOOD LUCK
% ======================================================
% Sorry it's in english.
% this is dataprodes, my data processing file for the experiment
% you should know: a.u = arbitrary units. 
% don't worry about it = this is a technichal thing. not relvent to the lab
% report.

% Part 1
% =============

% load list of relvent files
txtfiles = dir('*.txt');

m = [];

figure;
hold on;
lambda = 236;
l = 295.05;
% loop through relevent files
for i = 1: length(txtfiles)
   
    % read matrix, crop NaN final value. (don't worry about it).
    currentMatrix = readmatrix(txtfiles(i).name);
    currentMatrix = currentMatrix(1:end-1,:);

    % smooth the graph, and then get the get the 95% confidence interval
    % via the standard deviation.
    currentMatrix(:,3) = smooth(currentMatrix(:,2),5);
    currentMatrix(:,4) = (2.571/sqrt(5)).*movstd(currentMatrix(:,2),5);
    
    % create plot
    plot(currentMatrix(:,1), currentMatrix(:,2));
    
    % fild the maximum in the range that is given. it will shift around
    % slightly
    [pts, loc] = findpeaks(currentMatrix(:,3), currentMatrix(:,1));
    l = loc(280 < loc & loc < 300);
    lambda = find(currentMatrix(:,1) == l(1));
    
    % get the temperature from the filename. We worked with the thermometer
    % temp because it seems closer to the correct results, and was
    % consistantly lower then the circulator temp.
    s = split(txtfiles(i).name, "-"|".");

    % insert into a matirx the wavelength, absorbance, absorbane error,
    % temperature in kelvin.
    m = [m; l(1) currentMatrix(lambda,3) currentMatrix(lambda,4) str2double(s(2))+273];
end
title("spectra curves at differant temperatures")
xlabel("wavelength(nm)")
ylabel("intensity A (a.u)")
hold off;

% calculating ln(A) and it's error
m(:,5) = log(m(:,2));
m(:,6) = m(:,3)./(m(:,2));

% calculating 1/T and it's error. (error assumed to be plus minus 1, smallest line.)
m(:,7) = 1./m(:,4);
m(:,8) = 1./(m(:,4).^2);

% reduce all to significant digits
[m(:,5), m(:,6)] = significant_digits(m(:,5), m(:,6));
[m(:,7), m(:,8)] = significant_digits(m(:,7), m(:,8));

% fit linear regression. Results were output to the console. p1, the slope
% is the enthalapy devided by R (dH/R). the p2 constans is a mixture of various
% thing we won't deal with.
fprintf("Part 1!!!!! \n================================\n")
[f, g] = fit(m(:,7),m(:,5),fittype('poly1'))

% plot data on figure
figure;
hold on;
errorbar(m(:,7),m(:,5),m(:,6),m(:,6),m(:,8),m(:,8), 'o')
plot(f)
title("ln(A) vs 1/T")
xlabel("1/T (1/k)")
ylabel("ln(A) (a.u)")
hold off;

% write data to excel spreadsheet.
writetable(array2table(m, 'VariableNames',{'wavelength','A', 'hight error', 'Temperature', 'ln(A)', 'ln(A) err', '1/T', '1/T err'}), 'part1.xlsx');
%% 

% Part 2
% =====================

% read files list. the letter t is for turqouise, the color of the graph we
% used
txtfiles = dir('*t.TimeSeries');
m2 = [];

% setting the fit type fot the function we need to fit. in essence 'b' is the
% k1 that we are after. 'a' the differance between our inital concentration
% and equlibrium concentration. 'c' is equilibrium concentration.
ft = fittype(@(a,b,c,x) a*exp(-b*x) + c);
opts = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', rand(1,3)); 
figure;
hold on
for i = 1:length(txtfiles)
    % read the matrix. the timestamp column is read as NaN by matlab,
    % therfore cropped.
    currentMatrix = readmatrix(txtfiles(i).name, 'FileType','text');
    currentMatrix = currentMatrix(:,2:3);

    % the maximum absorbance value is taken, and then the matrix is cropped
    % until 10 timestamps later. the additional jump is to remove the
    % mixing fluctuations, which disrupt the fit.
    [M, I] = max(currentMatrix(:,2));
    currentMatrix = currentMatrix(I+10:end,:);

    % bringing the initial time to zero, to allow a proper fit. 
    currentMatrix(:,1) = currentMatrix(:,1) - currentMatrix(1,1);
    
    % fitting the curve. the non linear regressin requires the odd adition.
    % don't worry about it.
    fitted = false;
    while ~fitted
        try
            [f, g] =  fit(currentMatrix(:,1),currentMatrix(:,2),ft,opts);
            fitted = true;
        catch error
            opts.StartPoint = rand(1,3);
        end
    end
    
    % ploting the plots and data. y axis is absorbance, x axis is time.
    plot(f)
    plot(currentMatrix(:,1),currentMatrix(:,2), '.')
    
    % calculating absolute error from matlab confint. getting temperature
    % by thermostat.
    err = diff(confint(f))/2;
    s = split(txtfiles(i).name,'-');

    % insert fit results into matrix with significant digits
    m2 = [m2; str2double(s(3))+273 ...
        round(f.a, ceil(-log10(err(1)))) round(err(1), ceil(-log10(err(1)))) ...
        round(f.b, ceil(-log10(err(2)))) round(err(2), ceil(-log10(err(2)))) ...
        round(f.c, ceil(-log10(err(3)))) round(err(3), ceil(-log10(err(3)))) ...
        g.adjrsquare];
end
title("absorbtion vs time curves at differant temperature")
xlabel("time(s)")
ylabel("absorbtion (a.u)")
hold off;

% calculate 1/T, ln(k) and ln(k) error
m2(:,9) = 1./m2(:,1);
m2(:,10) = log(m2(:,4));
m2(:,11) = m2(:,5)./m2(:,4);

% reduce to significant digits
[m2(:,10), m2(:,11)]= significant_digits(m2(:,10), m2(:,11));


% fit linear regression part 2. p1 is the slope and negetive the activation
% energy devided by R (-Ea/R). p2 in ln(A) or the natural logarithim of the
% pre exponential constant
fprintf("Part 2!!!!!! \n========================\n")
[f, g] = fit(m2(:,9),m2(:,10),fittype('poly1'))

% plot the data
figure;
hold on;
errorbar(m2(:,9),m2(:,10),m2(:,11), 'o')
plot(f)
title("reaction rate(k1) vs inverse temperatue (1/T)")
xlabel("1/T (1/k)")
ylabel("k1 (1/s)")
hold off;

% write the data to excel table
writetable(array2table(m2, 'VariableNames', ["Temp", "D0-(D equilibrium)", "D0 error", "k", "k error", "D equilibrium", "D equilibrium error","adjust Rsquare", "1/T", "ln(k)","ln(k) err"]), 'part2.xlsx');


% helper function for significant digits. don't worry about it.
function [reduced_data, reduced_error] = significant_digits(data, er)
    if ~isvector(data) || ~isvector(er)
        reduced_data = round(data, ceil(-log10(er(1))));
        reduced_error = round(er(1), ceil(-log10(er(1))));
    elseif length(data) == length(er)
        reduced_data = zeros(length(data),1);
        reduced_error = zeros(length(data),1);
        for i = 1:length(data)
            reduced_data(i) = round(data(i), ceil(-log10(er(i))));
            reduced_error(i) = round(er(i), ceil(-log10(er(i))));
        end
    else
        error("badly scaled vectors.")
    end
end