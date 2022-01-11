function [Q_val, Q_loc] = Qidentification(MA,RR)
%QIDENTIFICATION Summary of this function goes here
    MA = (MA - min(MA))./(max(MA)-min(MA));
    i = 50;
    j = 1;

    while i < 3999
       
       if MA(i) > 0.02
           if MA(i-1) < MA(i)
               Q_loc(j) = i;
               Q_val(j) = MA(i);
               i = i + round(0.85*RR/5);
               j = j+1;
           end
       end
       i = i+1;
    end



end

