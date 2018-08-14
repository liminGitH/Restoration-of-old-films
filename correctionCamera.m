function outputImg = correctionCamera(output,index)
% load the image
img = (output(:,:,index));
% load the previous image
preI = (output(:,:,index-1));
% get the difference between the current frame and previous frame
diff = abs(img-preI);
% get the sum of the difference matrix
sumDiff = sum(diff(:));
% define the offset
offset = 5;
% calculate the difference between prrevious frame and the current image
% after moving up
upDiff = abs(img(1+offset:end,:) - preI(1:end-offset,:));
sumUp = sum(upDiff(:));

% calculate the difference between prrevious frame and the current image
% after moving down
downDiff = abs(img(1:end-offset,:) - preI(1+offset:end,:));
sumDown = sum(downDiff(:));

% calculate the difference between prrevious frame and the current image
% after moving left
leftDiff = abs(img(:,1+offset:end) - preI(:,1:end-offset));
sumLeft = sum(leftDiff(:));

% calculate the difference between prrevious frame and the current image
% after moving right
rightDiff = abs(img(:,1:end-offset) - preI(:,1+offset:end));
sumRight = sum(rightDiff(:));
% initialize the outputImg
outputImg = img;

% if the difference after moving up is smaller than moving down and don't
% move, then, moving up
if sumUp <sumDown && sumUp < sum(sum(diff(1:end-offset,:),1),2)
    outputImg(1:end-offset,:) = img(1+offset:end,:);

% if the difference after moving down is smaller than moving up and don't
% move, then, moving down
elseif sumUp >sumDown && sumDown < sum(sum(diff(1+offset:end,:),1),2)
    outputImg(1+offset:end,:) = img(1:end-offset,:);
end

% if the difference after moving left is smaller than moving right and don't
% move, then, moving left
if sumLeft <sumRight && sumLeft < sum(sum(diff(:,1:end-offset),1),2)
    outputImg(:,1:end-offset) = img(:,1+offset:end);

% if the difference after moving right is smaller than moving left and don't
% move, then, moving right
elseif sumRight <sumLeft && sumRight < sum(sum(diff(:,1+offset:end),1),2)
    outputImg(:,1+offset:end) = img(:,1:end-offset);

end
