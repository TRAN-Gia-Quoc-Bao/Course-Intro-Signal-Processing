function SampleHold = Hold_B0(SigEch, r)
[nrows, ncols] = size(SigEch);
if nrows > ncols,
SigEch = SigEch';
end
SampleHold = ones(r, 1)*SigEch;
SampleHold = reshape(SampleHold, 1, r*length(SigEch));