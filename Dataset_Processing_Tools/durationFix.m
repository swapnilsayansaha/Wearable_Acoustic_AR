%This program is used to convert the Unix timestamps into human readable%
%format. It takes in the .mat file of the dataset, removes nan rows%
%and adds two columns containing mS and seconds of corresponding time%
%starting from 0%

RAW3 = RAW3(all(~isnan(RAW3),2),:); % for nan - rows
d = datetime(RAW3(:,1),'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSSS','TimeZone','UTC');
d.TimeZone='-08:00';
temp = zeros(length(d),1);
for i = 1:length(d)
    temp(i,1) = milliseconds(d(i,1) - d(1,1));
end
RAW3(:,8) = temp;
RAW3(:,9) = temp/1000;
clear ans temp i