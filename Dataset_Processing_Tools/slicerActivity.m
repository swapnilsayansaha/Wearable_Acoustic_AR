%Slicer used for processing activity data.

%load the activity MATLAB file for a subject.
addpath('C:\Users\swapn\Desktop\202a dataset');
subject = 12; %alter subject number here
%input activity time ranges here (observed from acc/gyr plot (ground truth:
%camera) %input [0 0] in a activity if it is missing.
W = [12.34 45.9]; %walking
R = [51.31 83.07]; %running/jogging
J = [94.14 123.1]; %jumping
St = [123.1 156.4]; %standing
Tl = [158 189.1]; %turning left
Tr = [189.1 217.7]; %turning right
Si = [0 0]; %sitting
L = [264.2 303.1]; %laying
F = [315.4 344.9]; %falling
RangeMat = [W;R;J;St;Tl;Tr;Si;L;F];
Varnames = {'W' 'R' 'J' 'St' 'Tl' 'Tr' 'Si' 'L' 'F'};
for i = 1:length(RangeMat)
    if (RangeMat(i,2) - RangeMat(i,1) ~= 0)
        [~,lowerbound] = min(abs(Out(:,9) - RangeMat(i,1)));
        [~,upperbound] = min(abs(Out(:,9) - RangeMat(i,2)));
        temp = Out(lowerbound:upperbound,2:9);
        timeval = temp(1,8);
        for j = 1:size(temp,1)
            temp(j,8) = temp(j,8) - timeval;
        end
        temp(:,7) = [];
        filename = strcat(num2str(subject),'_',string(Varnames(1,i)),'.csv');
        writematrix(temp, filename); %directory is current directory;
    end
end
clear
