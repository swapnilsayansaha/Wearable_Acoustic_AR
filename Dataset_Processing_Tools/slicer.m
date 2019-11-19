%copy paste this section of code in the command window, with current folder set 
%dataset folder with files single.mat, Range.mat, double.mat

%single

load single.mat;
load Range.mat;
pathdir = 'singleTargets_TOOT';
mkdir(pathdir);
for i = 1:2:length(seqsingle)
    [~,lowerbound] = min(abs(Out(:,9) - seqsingle(i,2)));
    [~, upperbound] = min(abs(Out(:,9) - seqsingle(i+1,2)));
    temp = Out(lowerbound:upperbound,2:9);
    timeval = temp(1,8);
    for j = 1:size(temp,1)
        temp(j,8) = temp(j,8) - timeval;
    end
    temp(:,7) = [];
    filename = strcat('ID_',num2str(i),'-',num2str(seqsingle(i,1)), '_', num2str(seqsingle(i,3)),'.csv'); 
    filedir = strcat(pathdir, "/", filename);
    writematrix(temp, filedir); 
end
clear;
%double

load double.mat;
load Range.mat;
pathdir = 'doubleTargets_OT_TT_T0';
mkdir(pathdir);
for i = 1:2:length(seqdouble)
    [~,lowerbound] = min(abs(Out(:,9) - seqdouble(i,3)));
    [~, upperbound] = min(abs(Out(:,9) - seqdouble(i+1,3)));
    temp = Out(lowerbound:upperbound,2:9);
    timeval = temp(1,8);
    for j = 1:size(temp,1)
        temp(j,8) = temp(j,8) - timeval;
    end
    temp(:,7) = [];
    filename = strcat('ID_',num2str(i),'-',num2str(seqdouble(i,1)), '_', num2str(seqdouble(i,2)) ,'_',num2str(seqdouble(i,4)),'.csv'); 
    filedir = strcat(pathdir, "/", filename);
    writematrix(temp, filedir); 
end
clear;

%singledouble
%copy paste this section of code in the command window, with current folder set 
%dataset folder with files single_double.mat and Range.mat
load single_double.mat;
load Range.mat;
pathdir = 'singleTargets_TOOT';
mkdir(pathdir);
for i = 1:2:length(seqsingle)
    [~,lowerbound] = min(abs(Out(:,9) - seqsingle(i,2)));
    [~, upperbound] = min(abs(Out(:,9) - seqsingle(i+1,2)));
    temp = Out(lowerbound:upperbound,2:9);
    timeval = temp(1,8);
    for j = 1:size(temp,1)
        temp(j,8) = temp(j,8) - timeval;
    end
    temp(:,7) = [];
    filename = strcat('ID_',num2str(i),'-',num2str(seqsingle(i,1)), '_', num2str(seqsingle(i,3)),'.csv'); 
    filedir = strcat(pathdir, "/", filename);
    writematrix(temp, filedir); 
end
clearvars -except seqdouble Out d
pathdir = 'doubleTargets_OT_TT_T0';
mkdir(pathdir);
for i = 1:2:length(seqdouble)
    [~,lowerbound] = min(abs(Out(:,9) - seqdouble(i,3)));
    [~, upperbound] = min(abs(Out(:,9) - seqdouble(i+1,3)));
    temp = Out(lowerbound:upperbound,2:9);
    timeval = temp(1,8);
    for j = 1:size(temp,1)
        temp(j,8) = temp(j,8) - timeval;
    end
    temp(:,7) = [];
    filename = strcat('ID_',num2str(i),'-',num2str(seqdouble(i,1)), '_', num2str(seqdouble(i,2)) ,'_',num2str(seqdouble(i,4)),'.csv'); 
    filedir = strcat(pathdir, "/", filename);
    writematrix(temp, filedir); 
end
clear;


    