%% Lab 4 Speech Analysis
% Andrew Mullen
clear all;
close all;
clc;

%% Part 1
% Load Data
data = load('lab4data.mat');
male = data.MALE_S;
female = data.FEMALES;
[FA, fs2] = audioread('female_a.wav');
[FI, fs2] = audioread('female_i.wav');
[FU, fs2] = audioread('female_u.wav');
[MA, fs2] = audioread('male_a.wav');
[MI, fs2] = audioread('male_i.wav');
[MU, fs2] = audioread('male_u.wav');

% Initialize variables
fs = 12500;
NM = length(male);
NF = length(female);
NFa = length(FA); NFi = length(FI); NFu = length(FU);
NMa = length(MA); NMi = length(MI); NMu = length(MU);

% Time Vectors
tM = [1:NM]./fs;
tF = [1:NF]./fs;
tFa = [1:NFa]./fs2; tFi = [1:NFi]./fs2; tFu = [1:NFu]./fs2;
tMa = [1:NMa]./fs2; tMi = [1:NMi]./fs2; tMu = [1:NMu]./fs2;

%% Compute auto correlation
%male_ACF = autocorrelation(male);
%female_ACF = autocorrelation(female);
%FA_ACF = autocorrelation(FA); FI_ACF = autocorrelation(FI); FU_ACF = autocorrelation(FU);
%MA_ACF = autocorrelation(MA); MI_ACF = autocorrelation(MI); MU_ACF = autocorrelation(MU); 
load('male_ACF.mat'); load('female_ACF.mat');
load('FA_ACF.mat'); load('FI_ACF.mat'); load('FU_ACF.mat');
load('MA_ACF.mat'); load('MI_ACF.mat'); load('MU_ACF.mat');

male_ACF_seg = male_ACF(1:500);
female_ACF_seg = female_ACF(1:500);
FA_ACF_seg = FA_ACF(1:2000); FI_ACF_seg = FI_ACF(1:2000); FU_ACF_seg = FU_ACF(1:2000);
MA_ACF_seg = MA_ACF(1:2000); MI_ACF_seg = MI_ACF(1:2000); MU_ACF_seg = MU_ACF(1:2000);

%% Pitch period
% FIND APPROPRIATE MINIMUM PEAK HEIGHT
[pksM, locM] = findpeaks(male_ACF_seg, 'MinPeakHeight', 0.25);
[pksF, locF] = findpeaks(female_ACF_seg, 'MinPeakHeight', 0.3);

[pksFA, locFA] = findpeaks(FA_ACF_seg, 'MinPeakHeight', 0.5);
[pksFI, locFI] = findpeaks(FI_ACF_seg, 'MinPeakHeight', 0.5);
[pksFU, locFU] = findpeaks(FU_ACF_seg, 'MinPeakHeight', 0.5);

[pksMA, locMA] = findpeaks(MA_ACF_seg, 'MinPeakHeight', 0.5);
[pksMI, locMI] = findpeaks(MI_ACF_seg, 'MinPeakHeight', 0.6);
[pksMU, locMU] = findpeaks(MU_ACF_seg, 'MinPeakHeight', 0.5);


pitchPeriodM = (locM(2) - locM(1));%/fs;
pitchPeriodF = (locF(2) - locF(1));%/fs;

pitchPeriodFA = (locFA(2) - locFA(1));%/fs2;
pitchPeriodFI = (locFI(2) - locFI(1));%/fs2;
pitchPeriodFU = (locFU(2) - locFU(1));%/fs2;

pitchPeriodMA = (locMA(2) - locMA(1));%/fs2;
pitchPeriodMI = (locMI(2) - locMI(1));%/fs2;
pitchPeriodMU = (locMU(2) - locMU(1));%/fs2;
%% Frequency Spectrum
ssM = abs(fft(male)); fM = [1:NM]*(fs/NM);
ssF = abs(fft(female)); fF = [1:NF]*(fs/NF);

ssFA = abs(fft(FA)); fFa = [1:NFa]*(fs2/NFa);
ssFI = abs(fft(FI)); fFi = [1:NFi]*(fs2/NFi);
ssFU = abs(fft(FU)); fFu = [1:NFu]*(fs2/NFu);

ssMA = abs(fft(MA)); fMa = [1:NMa]*(fs2/NMa);
ssMI = abs(fft(MI)); fMi = [1:NMi]*(fs2/NMi);
ssMU = abs(fft(MU)); fMu = [1:NMu]*(fs2/NMu);

%% Envelope Signals
[upM, lowM] = envelope(ssM, 80, 'peak');
[upF, lowF] = envelope(ssF, 110, 'peak');

[upFA, lowFA] = envelope(ssFA, 400, 'peak');
[upFI, lowFI] = envelope(ssFI, 176, 'peak');
[upFU, lowFU] = envelope(ssFU, 260, 'peak');

[upMA, lowMA] = envelope(ssMA, 400, 'peak');
[upMI, lowMI] = envelope(ssMI, 600, 'peak');
[upMU, lowMU] = envelope(ssMU, 560, 'peak');


[EpksM, ElocM] = findpeaks(upM);
[EpksF, ElocF] = findpeaks(upF);

[EpksFA, ElocFA] = findpeaks(upFA);
[EpksFI, ElocFI] = findpeaks(upFI);
[EpksFU, ElocFU] = findpeaks(upFU);

[EpksMA, ElocMA] = findpeaks(upMA);
[EpksMI, ElocMI] = findpeaks(upMI);
[EpksMU, ElocMU] = findpeaks(upMU);


ElocM = ElocM*(fs/NM); ElocF = ElocF*(fs/NF);

ElocFA = ElocFA*(fs2/NFa); ElocFI = ElocFI*(fs2/NFi); ElocFU = ElocFU*(fs2/NFu);

ElocMA = ElocMA*(fs2/NMa); ElocMI = ElocMI*(fs2/NMi); ElocMU = ElocMU*(fs2/NMu); 


%% Plot signals
figure; 
subplot(411); plot(tM, male); xlabel('Time'); ylabel('Amplitude'); title('Male Signal');
subplot(412); plot(male_ACF_seg); hold on; scatter(locM, pksM); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Male Signal Autocorrelation');
subplot(413); plot(fM, ssM, fM, upM); hold on; scatter(ElocM, EpksM);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum'); xlim([0, 4000]);
subplot(414); plot(fM, ssM, fM, upM); hold on; scatter(ElocM, EpksM);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum Zoomed'); xlim([0, 4000]); ylim([0, 20]);

figure; 
subplot(411); plot(tF, female); xlabel('Time'); ylabel('Amplitude'); title('Female Signal');
subplot(412); plot(female_ACF_seg); hold on; scatter(locF, pksF); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Female Signal Autocorrelation');
subplot(413); plot(fF, ssF, fF, upF); hold on; scatter(ElocF, EpksF);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum'); xlim([0, 4000]);
subplot(414); plot(fF, ssF, fF, upF); hold on; scatter(ElocF, EpksF);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum Zoomed'); xlim([0, 4000]); ylim([0, 15]);

figure; 
subplot(411); plot(tFa, FA); xlabel('Time'); ylabel('Amplitude'); title('Female Signal: vowel = a');
subplot(412); plot(FA_ACF_seg); hold on; scatter(locFA, pksFA); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Female Signal Autocorrelation: vowel = a');
subplot(413); plot(fFa, ssFA, fFa, upFA); hold on; scatter(ElocFA, EpksFA);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum: vowel = a'); xlim([0, 4000]);
subplot(414); plot(fFa, ssFA, fFa, upFA); hold on; scatter(ElocFA, EpksFA);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum Zoomed vowel = a'); xlim([0, 4000]); ylim([0, 55]);

figure; 
subplot(411); plot(tFi, FI); xlabel('Time'); ylabel('Amplitude'); title('Female Signal: vowel = i');
subplot(412); plot(FI_ACF_seg); hold on; scatter(locFI, pksFI); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Female Signal Autocorrelation: vowel = i');
subplot(413); plot(fFi, ssFI, fFi, upFI); hold on; scatter(ElocFI, EpksFI);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum: vowel = i'); xlim([0, 4000]);
subplot(414); plot(fFi, ssFI, fFi, upFI); hold on; scatter(ElocFI, EpksFI);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum Zoomed vowel = i'); xlim([0, 4000]); ylim([0, 150]);

figure; 
subplot(411); plot(tFu, FU); xlabel('Time'); ylabel('Amplitude'); title('Female Signal: vowel = u');
subplot(412); plot(FU_ACF_seg); hold on; scatter(locFU, pksFU); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Female Signal Autocorrelation: vowel = u');
subplot(413); plot(fFu, ssFU, fFu, upFU); hold on; scatter(ElocFU, EpksFU);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum: vowel = u'); xlim([0, 4000]);
subplot(414); plot(fFu, ssFU, fFu, upFU); hold on; scatter(ElocFU, EpksFU);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Female Signal Frequency Spectrum Zoomed vowel = u'); xlim([0, 4000]); ylim([0, 20]);

figure; 
subplot(411); plot(tMa, MA); xlabel('Time'); ylabel('Amplitude'); title('Male Signal: vowel = a');
subplot(412); plot(MA_ACF_seg); hold on; scatter(locMA, pksMA); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Male Signal Autocorrelation: vowel = a');
subplot(413); plot(fMa, ssMA, fMa, upMA); hold on; scatter(ElocMA, EpksMA);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum: vowel = a'); xlim([0, 4000]);
subplot(414); plot(fMa, ssMA, fMa, upMA); hold on; scatter(ElocMA, EpksMA);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum Zoomed vowel = a'); xlim([0, 4000]); ylim([0, 120]);

figure; 
subplot(411); plot(tMi, MI); xlabel('Time'); ylabel('Amplitude'); title('Male Signal: vowel = i');
subplot(412); plot(MI_ACF_seg); hold on; scatter(locMI, pksMI); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Male Signal Autocorrelation: vowel = i');
subplot(413); plot(fMi, ssMI, fMi, upMI); hold on; scatter(ElocMI, EpksMI);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum: vowel = i'); xlim([0, 4000]);
subplot(414); plot(fMi, ssMI, fMi, upMI); hold on; scatter(ElocMI, EpksMI);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum Zoomed vowel = i'); xlim([0, 4000]); ylim([0, 150]);

figure; 
subplot(411); plot(tMu, MU); xlabel('Time'); ylabel('Amplitude'); title('Male Signal: vowel = u');
subplot(412); plot(MU_ACF_seg); hold on; scatter(locMU, pksMU); xlabel('Time Samples (lag)'); ylabel('Amplitude'); title('Male Signal Autocorrelation: vowel = u');
subplot(413); plot(fMu, ssMU, fMu, upMU); hold on; scatter(ElocMU, EpksMU);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum: vowel = u'); xlim([0, 4000]);
subplot(414); plot(fMu, ssMU, fMu, upMU); hold on; scatter(ElocMU, EpksMU);  xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Male Signal Frequency Spectrum Zoomed vowel = u'); xlim([0, 4000]); ylim([0, 20]);

%% Formant Ratio
ratio_female = ElocF(1)/ElocF(3);
ratio_FA = ElocFA(1)/ElocFA(3);
ratio_FI = ElocFI(1)/ElocFI(5);
ratio_FU = ElocFU(1)/ElocFU(4);
ratio_male = ElocM(1)/ElocM(2);
ratio_MA = ElocMA(1)/ElocMA(2);
ratio_MI = ElocMI(1)/ElocMI(5);
ratio_MU = ElocMU(1)/ElocMU(5);

ratio_female = [ratio_female, ratio_FA, ratio_FI, ratio_FU];
ratio_male = [ratio_male, ratio_MA, ratio_MI, ratio_MU];

figure;
scatter(ratio_male, ratio_female)
hold on;
plot([0, 0.3],[0,0.3]);
title('Formant Ratios: Male vs Female')
xlabel('Male Formant Ratios'); ylabel('Female Formant Ratio');
text(ratio_male(1)+0.01, ratio_female(1), 'Beautiful')
text(ratio_male(2)+0.01, ratio_female(2), 'A')
text(ratio_male(3)+0.01, ratio_female(3), 'I')
text(ratio_male(4)+0.01, ratio_female(4), 'U')


%% Check formants
%figure;
%plot(fM, ssM, fM, upM); hold on; scatter(ElocM, EpksM); xlim([0, 4000]); ylim([0, 100]);

%figure;
%plot(fF, ssF, fF, upF); hold on; scatter(ElocF, EpksF); xlim([0, 4000]); ylim([0, 100]);

%figure;
%plot(fMa, ssMA, fMa, upMA); hold on; scatter(ElocMA, EpksMA); xlim([0, 4000]); ylim([0, 4000]);

%figure;
%plot(fMi, ssMI, fMi, upMI); hold on; scatter(ElocMI, EpksMI); xlim([0, 4000]); ylim([0, 2000]);

%figure;
%plot(fMu, ssMU, fMu, upMU); hold on; scatter(ElocMU, EpksMU); xlim([0, 4000]); ylim([0, 100]);

%figure;
%plot(fFa, ssFA, fFa, upFA); hold on; scatter(ElocFA, EpksFA); xlim([0, 4000]); ylim([0, 3000]);

%figure;
%plot(fFi, ssFI, fFi, upFI); hold on; scatter(ElocFI, EpksFI); xlim([0, 4000]); ylim([0, 500]);

%figure;
%plot(fFu, ssFU, fFu, upFU); hold on; scatter(ElocFU, EpksFU); xlim([0, 4000]); ylim([0, 500]);
