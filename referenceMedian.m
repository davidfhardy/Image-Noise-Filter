function [SQMR] = referenceMedian(SQMV,SQMD_B,SQMD_C,p)
% This function finds the reference median

% If it's a case without edge or weak edge, then SQMR is the average of
% medians SQMR(2) and SQMR(3)
if (SQMD_B <= p) || (SQMD_B >= p && SQMD_C <= p)
    SQMR = (SQMV(2) + SQMV(3))/2;
else
    % Strong edge case
    % For now, assume the following since the research paper does not
    % specify the directional averages very well 
    SQMR = (SQMV(2) + SQMV(3))/2;
end
    
end

