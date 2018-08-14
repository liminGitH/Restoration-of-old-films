function outImg = correctionFlicker(output, index)
flickerImg = (output(:,:,index));
[r, c, num] = size(output);
sumImg = 0;
counter = 0;
% initialize the start frame index
start = -2;
% initialize the end frame index
dest = 2;

% add the histogram of the frame to the sumHIst
for i = start:dest
    if index+i>0 && index+i<num
        img = im2double(output(:,:,index+i));
        sumImg = sumImg + img;
        counter = counter + 1;
    end
end
% get the average histogram
averageHist = imhist(sumImg/counter);  
% use the histeq to make the current frame has the intensity as the
% average histogram
outImg = histeq(flickerImg,averageHist);

end

