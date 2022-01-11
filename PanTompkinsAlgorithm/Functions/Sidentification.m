function [pks, locs] = Sidentification(MA, RR)
%SIDENTIFICATION Summary of this function goes here
%   Detailed explanation goes here
    MA = (MA - min(MA))./(max(MA)-min(MA));
    [pks, locs] = findpeaks(MA,'MinPeakDistance',0.86*RR/5);
end

