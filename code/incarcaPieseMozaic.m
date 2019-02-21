function params = incarcaPieseMozaic(params)
%citeste toate cele N piese folosite la mozaic din directorul corespunzator
%toate cele N imagini au aceeasi dimensiune H x W x C, unde:
%H = inaltime, W = latime, C = nr canale (C=1  gri, C=3 color)
%functia intoarce pieseMozaic = matrice H x W x C x N in params
%pieseMoziac(:,:,:,i) reprezinta piese numarul i 

fprintf('Incarcam piesele pentru mozaic din director \n');
%completati codul Matlab

path = strcat(params.numeDirector,'*.',params.tipImagine);
filelist = dir(path);

sizeOfFilelist = length(filelist);
H = params.dimPiesaH;
W = params.dimPiesaW;
pieseMozaic = zeros(H,W,3,sizeOfFilelist);

for idx = 1:length(filelist)
    imgName = strcat(params.numeDirector,filelist(idx).name);
    nextImg = imread(imgName);
    pieseMozaic(:,:,:,idx) = nextImg;
    
end



if params.afiseazaPieseMozaic
    %afiseaza primele 100 de piese ale mozaicului
    figure,
    title('Primele 100 de piese ale mozaicului sunt:');
    idxImg = 0;
    for i = 1:10
        for j = 1:10
            idxImg = idxImg + 1;
            subplot(10,10,idxImg);
            imshow(uint8(pieseMozaic(:,:,:,idxImg)));
        end
    end
    drawnow;
    pause(2);
end

params.pieseMozaic = pieseMozaic;