%CODE FOR READING/MODIFYING CHARACTERISTICS AND READING SENSOR DATA OF E-SENSE EARABLE
%(C) 2019 SWAPNIL SAYAN SAHA, NESL, DEPT. OF ECE, UCLA
%WRITTEN IN MATLAB R2019B.

%DON'T RUN THIS CODE AS A SCRIPT! INSTEAD, COPY/PASTE SECTIONS IN COMMAND
%LINE.

%To use the code, copy the device address line to command window and press
%enter. Then you can just copy each section of code and run then in command
%window. You should check which parameters you can alter, such parameters
%are indicated via comments.

%Don't clear device_address variable from workspace. If you do so, you will
%have to copy the line device_address = "XXXXXXXXXXX"; again and run in
%command window every time.


%address of my device named eSense-0306: 4B30F668-5CC9-427D-B68E-0FD0DDEAB0FE (on MAC), 000479000CEA (on Windows)
%enter your device address below
%you can also type in your device name if you don't know the address
%e.g. "eSense-0306"
%you can get device name while trying to pair with your phone or laptop. It
%should start with eSense-XXXX. Or you can simply type blelist in command
%window and get the name.
device_address = "000479000CEA";


%1. read device name
clearvars -except device_address
b = ble(device_address);
dev_name = char(read(characteristic(b, "1800", "2A00")));
disp(dev_name);


%2. change device name (max 22 bytes / 22 characters)
clearvars -except device_address
b = ble(device_address);
new_name = 'eSense-0306'; %enter your device name here as shown, max 22 characters
name_charac = characteristic(b, 'FF06', 'FF0C');
write(name_charac, double(new_name), "uint8", "withresponse");
disp('Updated name! Run the code for reading device name to ensure your updates');


%3. read sampling status and enable sampling
clearvars -except device_address
b = ble(device_address);
rw_state = characteristic(b, "FF06", "FF07");
rw_state_read = read(rw_state);
if rw_state_read(4)
    disp('Sampling enabled');
elseif ~rw_state_read(4)
    disp('Sampling disabled');
end
sampstring = ['Sampling rate: ' num2str(rw_state_read(5)) ' Hz (max: 100, min: 1)'];
disp(sampstring);
%
if (rw_state_read(4) == 0)
    write(rw_state, [0x53 0x35 0x02 0x01 0x32], "uint8" ,"withresponse"); %DO NOT MODIFY ANYTHING HERE. IT'S SET TO BEST POSSIBLE SETTING
end



%4. read battery voltage
%The battery is a Li-Ion battery, so optimum voltage is between 3.7 and
%4.2V.
clearvars -except device_address
b = ble(device_address);
bat = read(characteristic(b, "FF06", "FF0A"));
vol = (bat(4)*256 + bat(5)) ./ 1000;
volstr = ['Battery Voltage: ' num2str(vol)];
disp(volstr);
chargestr = ['Charge Status: ' num2str(bat(6))];
disp(chargestr);



%5. read push button status (read, not subscribe)
clearvars -except device_address
b = ble(device_address);
pb = read(characteristic(b, "FF06", "FF09"));
if pb(4)
    disp('Button pressed');
elseif ~pb(4)
    disp('Button not pressed');
end



%6. read IMU scale and LPF status/bandwidth
clearvars -except device_address
b = ble(device_address);
scale = read(characteristic(b, "FF06", "FF0E"));
temp = dec2bin(scale(5),8);
gyrbin = strcat(temp(4), temp(5));
if strcmp('00', gyrbin)
    disp('Gyr: 250 deg/s, SF: 131');
elseif strcmp('01', gyrbin)
    disp('Gyr: 500 deg/s (default), SF: 65.5');
elseif strcmp('10', gyrbin)
    disp('Gyr: 1000 deg/s, SF: 32.8');
elseif strcmp('11', gyrbin)
    disp('Gyr: 2000 deg/s, SF: 16.4');
end
if temp(8) == '1'
    disp('Gyro LPF bypassed');
elseif temp(8) == '0'
    disp('Gyro LPF enabled');
    gyrtemp = dec2bin(scale(4),8);
    gyrtemp = gyrtemp(:,6:8);
    if strcmp('000',gyrtemp)
        disp('Gyro LPF: 250 Hz');
    elseif strcmp('001', gyrtemp)
        disp('Gyro LPF: 184 Hz');
    elseif strcmp('010', gyrtemp)
        disp('Gyro LPF: 92 Hz');
    elseif strcmp('011', gyrtemp)
        disp('Gyro LPF: 41 Hz');
    elseif strcmp('100', gyrtemp)
        disp('Gyro LPF: 20 Hz');
    elseif strcmp('101', gyrtemp)
        disp('Gyro LPF: 10 Hz');
    elseif strcmp('110', gyrtemp)
        disp('Gyro LPF: 5 Hz (default)');
    elseif strcmp('111', gyrtemp)
        disp('Gyro LPF: 3600 Hz');
    end
end
temp = dec2bin(scale(6), 8);
accbin = strcat(temp(4), temp(5));
if strcmp('00', accbin)
    disp('Acc: 2g, SF: 16384');
elseif strcmp('01', accbin)
    disp('Acc: 4g (default), SF: 8192');
elseif strcmp('10', accbin)
    disp('Acc: 8g, SF: 4096');
elseif strcmp('11', accbin)
    disp('Acc: 16g, SF: 2048');
end
acctempreg = dec2bin(scale(7),8);
if acctempreg(5) == '1'
    disp('Acc LPF bypassed');
elseif acctempreg(5) == '0'
    disp('Acc LPF enabled');
    acctemp = acctempreg(:,6:8);
    if strcmp('000',acctemp)
        disp('Acc LPF: 460 Hz');
    elseif strcmp('001', acctemp)
        disp('Acc LPF: 184 Hz');
    elseif strcmp('010', acctemp)
        disp('Acc LPF: 92 Hz');
    elseif strcmp('011', acctemp)
        disp('Acc LPF: 41 Hz');
    elseif strcmp('100', acctemp)
        disp('Acc LPF: 20 Hz');
    elseif strcmp('101', acctemp)
        disp('Acc LPF: 10 Hz');
    elseif strcmp('110', acctemp)
        disp('Acc LPF: 5 Hz (default)');
    end
end



%7. read IMU factory offset
clearvars -except device_address
b = ble(device_address);
offset = read(characteristic(b, "FF06", "FF0D"));
offset = offset(1,4:15);
offset = double(swapbytes(typecast(uint8(offset), 'int16')));
accxcal = offset(4)/2048;
accycal = offset(5)/2048;
acczcal = offset(6)/2048;
acccalstr = ['Accelerometer calibration trim (x, y, z) (in terms of g): ', num2str(accxcal), ' ' num2str(accycal), ' ', num2str(acczcal)];
disp(acccalstr);
gyroxcal = offset(1);
gyroycal = offset(2);
gyrozcal = offset(3);
gyrocalstr = ['Gyro calibration trim (x, y, z): ', num2str(gyroxcal), ' ' num2str(gyroycal), ' ', num2str(gyrozcal)];
disp(gyrocalstr);



%8. Get advertisement and connection interval
clearvars -except device_address
b = ble(device_address);
intv = read(characteristic(b, "FF06", "FF0B"));
advintmin= (intv(4)*256 + intv(5)) * 0.625;
advintmax = (intv(6)*256 + intv(7)) * 0.625;
connintmin = (intv(8)*256 + intv(9)) * 1.25;
connintmax = (intv(10)*256 + intv(11)) * 1.25;
advstr = ['Advertisement interval (mS): max: ', num2str(advintmax), ' min: ', num2str(advintmin)];
connstr = ['Connection interval (mS): max: ', num2str(connintmax), ' min: ', num2str(connintmin)];
disp(advstr);
disp('Advertisement interval (mS) range: 100-5000');
disp(connstr);
disp('Connection interval (mS) range: 20-2000, max-min should be at least 20');



%9. adjust connection and advertisement intervals
clearvars -except device_address
b = ble(device_address);
intw = characteristic(b, "FF06", "FF07");
%input your advertisement and connection intervals in ms in the four variables below:
%default: 625, 750, 90, 110 for advmin, advmax, connmin, connmax
%respectively. Unit: mS.
%recommended connintmin and max are 20 and 40 mS respectively and advintmin and advintmax
%are 100 and 150 mS respectively (lower means faster data rate, but more power consumption).
newadvintmin = 55;
newadvintmax = 45;
newconnintmin = 30;
newconnintmax = 40;
x = 0;
for i = 1:255
    x = ((newadvintmin/0.625)-i)/256;
    if floor(x) == x
        break;
    end
end
data0 = x;
data1 = i;
x = 0;
for i = 1:255
    x = ((newadvintmax/0.625)-i)/256;
    if floor(x) == x
        break;
    end
end
data2 = x;
data3 = i;
for i = 1:255
    x = ((newconnintmin/1.25)-i)/256;
    if floor(x) == x
        break;
    end
end
data4 = x;
data5 = i;
for i = 1:255
    x = ((newconnintmax/1.25)-i)/256;
    if floor(x) == x
        break;
    end
end
data6 = x;
data7 = i;
if (floor(data0) == data0) && (floor(data1) == data1) && (floor(data2) == data2) && (floor(data3) == data3) && (floor(data4) == data4) && (floor(data5) == data5) && (floor(data6) == data6) && (floor(data7) == data7)
    checksum = dec2bin(8 + data0 + data1 +  data2  + data3 +  data4  + data5  + data6 +  data7);
    if (length(checksum) > 8)
        checksum = bin2dec(checksum(1,end-7:end));
    else
        checksum = bin2dec(checksum);
    end
    write(intw, [0x57 checksum 0x08 data0 data1 data2 data3 data4 data5 data6 data7], "uint8", "withresponse");
    disp('Updated intervals! Use the code for reading adv/conn intervals to check for your updates.');
else
    fprintf('Please modify the intervals such that data0 to data7 are all integers.\nCheck which dataX is causing problems and modify the appropriate interval accordingly.\n');
end



%10 adjust IMU scale and LPF status/bandwidth
clearvars -except device_address
b = ble(device_address);
writescale = characteristic(b, "FF06", "FF0E");

gyrrange = '01'; %options: 00, 01, 10, 11 for 250, 500 (default), 1000 and 2000 deg/S respectively
gyrlpfbypass = '0'; %options: 0: don't bypass (default), 1: bypass
gyrlpfcutoff = '110'; %options: 000 - 250 Hz, 001 - 184 Hz, 010 - 92 Hz, 011 - 41 Hz, 100 - 20 Hz
%101 - 10 Hz, 110 - 5 Hz (default), 111 - 3600 Hz
accrange = '01'; %options: 00, 01, 10, 11 for 2g, 4g (default), 8g and 16g respectively
acclpfbypass = '0'; %options: 0: don't bypass (default), 1: bypass
acclpfcutoff = '110'; %options: 000 - 460 Hz, 001 - 184 Hz, 010 - 92 Hz, 011 - 41 Hz, 100 - 20 Hz
%101 - 10 Hz, 110 - 5 Hz (default)

data0 = bin2dec(strcat("00000",gyrlpfcutoff));
data1 = bin2dec(strcat("000",gyrrange,"0",gyrlpfbypass,gyrlpfbypass));
data2 = bin2dec(strcat("000",accrange,"000"));
data3 = bin2dec(strcat("0000",acclpfbypass,acclpfcutoff));
checksum = dec2bin(4 + data0 + data1 +  data2  + data3);
if (length(checksum) > 8)
    checksum = bin2dec(checksum(1,end-7:end));
else
    checksum = bin2dec(checksum);
end
write(writescale, [0x59 checksum 0x04 data0 data1 data2 data3], "uint8", "withresponse");
disp('Updated scale and LPF! Use the code for reading IMU scale/LPF to check for your updates.');


%10. GET SENSOR READINGS AND SAVE THEM IN A MAT FILE


%Sampling rate doesn't only depend on the earable but also the computer! It
%will reduce if the eSense loses LoS with the computer or range
%increases or if the computer suffers a performance bottleneck. Heavy
%real-time tasks such as real-time data viewing on command window can also
%reduce overall performance. 
%Thus, although we have set the sampling rate from sensor side to be 100 Hz and
%put in appropriate advertisement and connection intervals, the sampling rate drops drastically
clear
n = 4; %how many seconds do you want to record? (empirical assumption ~20 samples per second) (yes even after optimizing
%the earable and the code, the sampling rate is poor).
device_address = "000479000CEA"; %update device name or device address here.
SFacc = 8192; SFgyr = 65.5; %to determine appropriate scale factor, run the
%code in section 6: reading IMU scale and LPF status/bandwidth and note the
%appropriate SF. Update the SF here. By default, SFacc = 8192, SFgyr = 65.5
n = n*20; 
z = zeros(1,7); 
b = ble(device_address);
rw_state = characteristic(b, "FF06", "FF07");
write(rw_state, [83 103 2 1 100], "uint8" ,"withresponse"); 
temptime = clock;
filename = strcat(string(temptime(1)), string(temptime(2)), string(temptime(3)), string(temptime(4)), string(temptime(5)), string(floor(temptime(6))),"_data.csv");
for i = 1:n
    [sensorData, timestamp] = read(characteristic(b, "FF06", "FF08"));
    %acceleration values given in terms of g.
    temp =  double(swapbytes(typecast(uint8(sensorData), 'int16')));
    z(i,4) = (temp(6))/SFacc;
    z(i,5) = (temp(7))/SFacc;
    z(i,6) = (temp(8))/SFacc;
    %angular velocity given as deg/s.
    z(i,1) = (temp(3)/SFgyr) ;
    z(i,2) = (temp(4)/SFgyr);
    z(i,3) = (temp(5)/SFgyr);
    %uncomment the following two lines if you want to see real-time data in
    %command window (not recommended).
    %fprintf('Acc (x, y, z) = %f %f %f\n', accx, accy, accz);
    %fprintf('Gyr (x, y, z) = %f %f %f\n', gyrx, gyry, gyrz);
    z(1,7) = etime(datevec(timestamp), temptime);
    fid = fopen(filename, 'a+');
    fprintf(fid, '%f %f %f %f %f %f %f\n', z(1,1),z(1,2),z(1,3),z(1,4),z(1,5),z(1,6),z(1,7));
    fclose(fid);
    z = zeros(1,7); 
end
A = readmatrix(filename);
x = size(A);
initime = A(1,7);
for i = 1:x(1)
    A(i,7) = A(i,7) - initime;
end
writematrix(A, filename);
%file format: Columns 1 to 3: accx, accy, accz. Columns 4 to 6: gyrx,
%gyry, gyrz. Column 7: seconds elapsed since first timestamp.
%the filename corresponds to the first timestamp time (don't trust it too
%much as it is system time and not NTP time), there's approximately 0.25
%seconds delay in the code.
    
    



