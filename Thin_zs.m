%zs.m
function out=Thin_zs(im)
%
% zs appises the Zhang-Suen skeletonization algorithm to image IM. IM must
% be binary.
%
luteven=makelut('Thin_zseven',3);
lutodd=makelut('Thin_zsodd',3);
done=0;
N=2;
last=im;
previous=bwlookup(last ,lutodd);
current=bwlookup(previous,luteven);
while done==0
    if all(current(:)==last(:))
        done=1;
    end
    N=N+1;
    last=previous;
    previous=current;
    if mod(N,2)==0
        current=bwlookup(current,luteven);
    else
        current=bwlookup(current,lutodd);
    end
end
out=current;
end