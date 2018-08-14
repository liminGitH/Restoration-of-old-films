function outputImg = correctionBlotches(output,index)
% load the origin frame
img = double(output(:,:,index));
% load the previous frame
preI = double(output(:,:,index-1));
% load the next frame
nextI = double(output(:,:,index+1));
% patchSize is used to get reference pixels from previous and next frame
patchSize = 1;
% define the T value
T = 6;
% define the R value
R = 0.003;
% initialize the mask
mask = ones(size(img));
% initialize the SROD matrix
SROD = zeros(size(img));

for i = patchSize:size(img,1)-patchSize
    for j = 1:size(img,2)
        % initialize the maximum and minimum value of reference pixels
        patchMin = 256;
        patchMax = 0;
        % find the maximum and minimum value from previous and next frame
        for k = -patchSize:patchSize
            if preI(i+patchSize,j)>patchMax
                patchMax = preI(i+patchSize,j);
            end
            if nextI(i+patchSize,j)>patchMax
                patchMax = nextI(i+patchSize,j);
            end
            if preI(i+patchSize,j)<patchMin
                patchMin = preI(i+patchSize,j);
            end
            if nextI(i+patchSize,j)<patchMin
                patchMin = nextI(i+patchSize,j);
            end
        end
        
        % calculate the S-ROD
        % if the current pixel is larger than the patchMax,
        % the result of S-ROD is img(i,j) - patchMax
        % if the current pixel is smaller than the patchMin,
        % the result of S-ROD is patchMin - img(i,j)
        % otherwise, the result is 0
        if img(i,j)>patchMax
            diff = img(i,j) - patchMax;
        elseif img(i,j)<patchMin
            diff = patchMin - img(i,j);
        else
            diff = 0;
        end
        
        SROD(i,j) = diff/5;
        % check if the pixel is the blotch
        if diff > T
            mask(i,j) = 0;
        end
                
    end
end

% initialize the new mask and the outputImg
newMask = mask;
outputImg = img;

for i = 2:size(img,1)-1
    for j = 2:size(img,2)-1
        if mask(i,j)==0
            s = calSize(mask,i,j);
            p = 0;
            % set the probability to be a false blotch with 
            % the s and S-ROD value
            if SROD(i,j) <= 1 && s<6
                p = 0.0919;
            elseif SROD(i,j) <= 2 && s<6
                p = 0.0603;
            elseif SROD(i,j) <= 3 && s<5
                p = 0.0366;
            elseif SROD(i,j) <= 4 && s<4
                p = 0.0205;
            elseif SROD(i,j) <= 5 && s<4
                p = 0.0104;
            elseif SROD(i,j) <= 6 && s<4
                p = 0.0049;
            elseif SROD(i,j) <= 7 && s<3
                p = 0.0021;
            elseif SROD(i,j) <= 8 && s<3
                p = 0.0008;
            elseif SROD(i,j) <= 9 && s<3
                p = 0.0003;
            end
            
            % check if the pixel is a blotch
            if p > R
                newMask(i-1:i+1,j-1:j+1) = 1;
            
            end
        end
    end
end

% if the pixel is a blotch, get the median value of the previous frame
for i = 2:size(img,1)-1
    for j = 2:size(img,2)-1
        if newMask(i,j) == 0
            patch = preI(i-1:i+1,j-1:j+1);
            outputImg(i,j) = median(patch(:));
        end
    end
end

% finally, use median filter to make the frame smooth.
outputImg = medfilt2(outputImg,[5,5])/256;



% this function is used to calculate how many pixels around the current
% pixel within the 3-by-3 search window
function s = calSize(mask,row,col)
s = 0;
for i = -1:1
    for j = -1:1
        if mask(row+i,col+j)==0
            s = s + 1;
        end
    end
end