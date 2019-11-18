%This matlab file takes the excel file containing dataend points as input%
%and outputs/saves a mat file containing the endpoint sequences in a form%
%easily usable by MATLAB when slicing data%

%To use it, just update the path and filename variables with the directory%
%where your endpoint excel file is%

path = "/Users/swapnilsayansaha/Desktop/data endpoints/subject 15/";
filename = "yoyoFriend.xlsx";
matfilename = "Range.mat";
tempsingle = readtable(strcat(path,filename), "Sheet", "Single");
tempsingle = table2array(tempsingle(:,1:5));
tempdouble = readtable(strcat(path,filename), "Sheet", "Double");
tempdouble = table2cell(tempdouble(:,1:7));
tempdoublelabel = tempdouble(:,1);
tempdoubledata = cell2mat(tempdouble(:,2:7));

seqsingle = zeros(52,3);
for i = 1:13
    for j = 2:5
        if(tempsingle(i,j) ~= -1)
            temp = tempsingle(i,1);
            seqsingle((j-1)+4.*(i-1),1) = temp(1,1);
            seqsingle((j-1)+4.*(i-1),2) = tempsingle(i,j);
            if ((j == 4) || (j == 5))
                seqsingle((j-1)+4.*(i-1),3) = 0; %origin to target
            else
                seqsingle((j-1)+4.*(i-1),3) = 1; %target to origin
            end
        end
    end
end
seqsingle( ~any(seqsingle,2), : ) = [];  %remove zero rows.

seqdouble = zeros(126,4);
temp = char(tempdoublelabel);
for i = 1:21
    for j = 1:6
        if(tempdoubledata(i,j) ~= -1)
            z = str2num(temp(i,:));
            seqdouble(j+6.*(i-1),1) = z(1,1);
            seqdouble(j+6.*(i-1),2) = z(1,2);
            seqdouble(j+6.*(i-1),3) = tempdoubledata(i,j);
            if ((j == 1) || (j == 2))
                seqdouble(j+6.*(i-1),4) = 0; %origin to target 1
            elseif ((j == 3) || (j == 4))
                seqdouble(j+6.*(i-1),4) = 0.5; %target 1 to target 2
            else
                seqdouble(j+6.*(i-1),4) = 1; %target 2 to origin
            end
        end
    end
end
seqdouble( ~any(seqdouble,2), : ) = [];  %remove zero rows.
clearvars -except seqdouble seqsingle path matfilename;
save(strcat(path, matfilename), 'seqdouble', 'seqsingle');
clear


