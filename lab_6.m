%
% https://web.stanford.edu/class/ee179/labs/Lab6.html
%
close all;
%%
% Remote Keyless System (RKS). 
% In the U.S. these operate at 315 MHz, +/- 2.5 MHz. 
% My Prius key turned out to be at 312.590 MHz.
dk = loadFile('rks312590.dat');
fs = 2048000;                   % Sampling Frequency
t = [1:length(dk)]/2048000;		% Time
% MS 2. ve 5. saniyeden sonra hareket var
plot(t(1:1000:end),abs(dk(1:1000:end)));
title('whole data')
% MS 2-2.1 saniye arasý sayýsal veri
figure;
plot(t(2*fs:2.1*fs),abs(dk(2*fs:2.1*fs)));
title('2-2.1 sec data')
% A decision threshold of 15 will give almost perfect detection (your data will have a different level)
dkd = abs(dk) > 15;
figure;
plot(t(2*fs:2.6*fs)*fs,dkd(2*fs:2.6*fs));
title('Binary data')
axis([t(2*fs)*fs t(2.6*fs)*fs -0.5 1.5])
% MS 4159919'de ilk 1 var. 
% MS 5259769'da veri son buluyor
% bit ölçümleri: (1350+1510)/2 = 1430 alýnabilir?
% MS 1353, 1348, 1352 sample => bit 1 demek!
% MS 1514, 1510, 1511 sample => bit 0 demek!
data_start=4159919;
data_end= 5259769;
bit_length = 1432;
% bit pattern
bit_pattern=dkd(data_start+bit_length/2:bit_length:data_end);
msg=sprintf('There are %d bits in data', floor((data_end-data_start)/bit_length));
disp(msg);
% Universal Radio Hacker (URH) ile karþýlaþtýrma: 
% URH'ye 'rks312590.dat' verisi 
% 'RTL-SDR 312_590MHz 2_048MSps 2_048MHz.complex16u' olarak kaydedildi. 
% Bu dosya URH'dan açýldý ASK ile autodetect yapýldý 
% Bit Length 1351 olarak saptadý. 
% Demodulated data urh_output.txt olarak kaydedildi. 
% Bu script'e bit_length=1432 yapýnca URH ile ayný sonuç elde ediliyor. 
fid=fopen('urh_output.txt','r','n','UTF-8');
urh=fread(fid);
urh=urh-48;
diff=bit_pattern ~= urh;
msg=sprintf('There are %d bit differences between script and URH', sum(diff));
disp(msg);