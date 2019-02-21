function [imgHex, p] = mascaHexagonala(img)
    
[H,W,C,N] = size(img);
imgHex = zeros(H, W, 3);
halfH = round(H/2);
p1 = halfH;
p2 = W - p1;

for i = 1:halfH
    for j = p1 - i + 1:p2 + i - 1
        imgHex(i, j,:) = img(i, j, :);
    end
end

for i = halfH+1:H
    for j = p1 - (H-i) + 1:p2 + (H-i) - 1
        imgHex(i, j, :) = img(i, j, :);
    end
end

imgHex = uint8(imgHex);
p = p1;
end