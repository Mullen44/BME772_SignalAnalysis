function [QRS] = QRSduration(Q, S)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    QRS = S - Q';
    QRS = mean(QRS)*5;


end

