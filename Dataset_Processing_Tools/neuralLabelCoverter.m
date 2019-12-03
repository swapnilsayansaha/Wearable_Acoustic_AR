% MasterMatRandom = x(randperm(size(x, 1)), :) << use this to shuffle rows
% randomly, x is the matrix containing feature matrix and labels.
%before training.

%label to neural label converter
labelnum = MasterMatRandom(:,end);
labels = zeros(length(labelnum),9);
for i = 1:length(labelnum)
    switch labelnum(i,1)
        case 1
            labels(i,1) = 1;
            labels(i,2:9) = 0;
        case 2
            labels(i,1) = 0;
            labels(i,2) = 1;
            labels(i,3:9) = 0;
        case 3
            labels(i,1:2) = 0;
            labels(i,3) = 1;
            labels(i,4:9) = 0;
        case 4
            labels(i,1:3) = 0;
            labels(i,4) = 1;
            labels(i,5:9) = 0;
        case 5
            labels(i,1:4) = 0;
            labels(i,5) = 1;
            labels(i,6:9) = 0;
        case 6
            labels(i,1:5) = 0;
            labels(i,6) = 1;
            labels(i,7:9) = 0;
            
        case 7
            labels(i,1:6) = 0;
            labels(i,7) = 1;
            labels(i,8:9) = 0;
        case 8
            labels(i,1:7) = 0;
            labels(i,8) = 1;
            labels(i,9) = 0;  
        case 9
            labels(i,1:8) = 0;
            labels(i,9) = 1;
    end
end
clear i labelnum
MasterMatRandom = MasterMatRandom(:,1:end-1);