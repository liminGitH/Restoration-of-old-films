function outputImg = correctionArtefact(output,index)
% load the image as double format
img = (output(:,:,index));
% use medfilt2 with a row vector to smooth the image
filterImg = medfilt2(img,[1,5]);
% find the difference between the filtered image and origin image
diff = (abs(img-filterImg)*30);
% initialise the new difference matrix
d = zeros(size(img));

% use for-loop to find the difference value between 0.7 and 1.6
% when the difference in this arrange, the noise has more probability 
% to be a noise. (the value of 0.7 and 1.6 obtained after testing)
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if diff(i,j)>0.7 && diff(i,j)<1.6
            d(i,j) = 1;
        end
    end
end

% initialise the output image as the origin image
outputImg = img;
% find the index which may be the noise
index = find(d==1);
% change the noise pixel to the filtered image value
outputImg(index) = filterImg(index); 


end