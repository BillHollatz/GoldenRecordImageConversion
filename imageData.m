%convert a RGB image to a sound clip
%using the format from the golden record

I = imread('some image path here');
%read in the original image



%split the rgb color spaces
Red = I(:,:,1);
Green = I(:,:,2);
Blue = I(:,:,3);

%get the height and width of the image
[sc,sr] = size(Red);

%build a boundary box around each greyscale image
columBound = zeros(sc+40,20)+127;
rowBound = zeros(20,sr)+127;
Red = [rowBound; Red; rowBound];
Red = [columBound Red columBound];
Green = [rowBound; Green; rowBound];
Green = [columBound Green columBound];
Blue = [rowBound; Blue; rowBound];
Blue = [columBound Blue columBound];

%create the beep before each image
beep = columBound-127;
i=1;
while i < length(beep)*20
    for s = 1:20
        beep(i) = 255;%white parts of beep
        i = i+1;
    end
    for s = 1:20
        %black parts of beep
        i = i+1;
    end
        
end

%add the beep before each image
Red = [beep Red];
Green = [beep Green];
Blue = [beep Blue];

%combine the three greyscale images into one long greyscale image, with 40
%pixels of cushion on the left and right sides
finalImg = [columBound columBound Red Green Blue columBound columBound];
%get the height and width of the long image
[sc,sr] = size(finalImg);

%create the hashmarked guideline for reconstructing the image
i=1;
while i < sr
    if rem(i,2) == 1
        finalImg(1:5,i) = 255;
    else
        finalImg(1:15,i) = 255;
    end
    i = i+1;
end

F = finalImg(1:end);
R = Red(1:end);
G = Green(1:end);
B = Blue(1:end);


F = double(F)*6/2550;
F = F - .3;

R = double(R)*6/2550;
R = R - .3;

G = double(G)*6/2550;
G = G - .3;

B = double(B)*6/2550;
B = B - .3;

recombinedRGBImage = cat(3, Red, Green, Blue);

imshow(finalImg)

%{
subplot(3, 3, 2);
imshow(I);
fontSize = 20;
title('Original RGB Image', 'FontSize', fontSize)
subplot(3, 3, 4);
imshow(Red);
title('Red', 'FontSize', fontSize)
subplot(3, 3, 5);
imshow(Green)
title('Green', 'FontSize', fontSize)
subplot(3, 3, 6);
imshow(Blue);
title('Blue', 'FontSize', fontSize)
subplot(3, 3, 8);
imshow(recombinedRGBImage);
title('Recombined', 'FontSize', fontSize)
%}


audiowrite('image.wav',F,44100);

audioinfo('image.wav')
