function output = labs3(path, prefix, first, last, digits, suffix)

%
% Read a sequence of images and correct the film defects. This is the file 
% you have to fill for the coursework. Do not change the function 
% declaration, keep this skeleton. You are advised to create subfunctions.
% 
% Arguments:
%
% path: path of the files
% prefix: prefix of the filename
% first: first frame
% last: last frame
% digits: number of digits of the frame number
% suffix: suffix of the filename
%
% This should generate corrected images named [path]/corrected_[prefix][number].png
%
% Example:
%
% mov = labs3('../images','myimage', 0, 10, 4, 'png')
%   -> that will load and correct images from '../images/myimage0000.png' to '../images/myimage0010.png'
%   -> and export '../images/corrected_myimage0000.png' to '../images/corrected_myimage0010.png'
%

% Your code here
output = load_sequence(path, prefix, first, last, digits, suffix);

%%
% This part aims to detect the scene change
sceneCut = [];
% get the histogram information of the first frame
[num_pre, pixel_pre] = imhist(output(:,:,1));
for i = 1:size(output,3)
    % get the histogram information
    [num, pixel] = imhist(output(:,:,i));
    % get the difference between two adjacent frames
    diff = abs(num - num_pre);
    % sum the difference
    sumDiff = sum(diff(:));
    % if the sum of difference is larger than 141000
    % it indicates the scene changed
    if sumDiff >141000
        sceneCut = [sceneCut i];
    end
    num_pre = num;
end

%%
% this part aimes to correct the blotches
newSeq = zeros(size(output));
for i = 1:256
    if i == 1 || i==256
        newSeq(:,:,i) = im2double(output(:,:,i));
    else
        newSeq(:,:,i) = correctionBlotches(output,i);
    end
end

for i = 257:496
    if i == 257 || i==496
        newSeq(:,:,i) = im2double(output(:,:,i));
    else
        newSeq(:,:,i) = correctionBlotches(output,i);
    end
end
%%
% this part aimes to correct the global flicker

for i = 1:size(output,3)
    newSeq(:,:,i) = correctionFlicker(newSeq,i);   
end

%%
% this part aimes to correct the vertical atrefacts
for i = 497:size(output,3)
    newSeq(:,:,i) = correctionArtefact(newSeq,i);
end
%%
% this part aims to correct the camera-shake
for i = 2:256
    newSeq(:,:,i) = correctionCamera(newSeq,i);
end  
for i = 258:496
    newSeq(:,:,i) = correctionCamera(newSeq,i);
end  
%%
for i =1:size(output,3)
    
    if i<10
        str = '00';
    elseif i<100
        str = '0';
    else
        str = '';
    end
    for j = 1: size(sceneCut,2)
        if sceneCut(j) == i
            text = 'scene changed';
            img = newSeq(:,:,i);
            img = insertText(img,[180 100],text);
            img = rgb2gray(img);
            newSeq(:,:,i) = img;
            imshow(newSeq(:,:,i));
        end
    end
    imwrite(newSeq(:,:,i),['result\','footage_',str,num2str(i),'.jpg']);
    imshow(newSeq(:,:,i));
end

