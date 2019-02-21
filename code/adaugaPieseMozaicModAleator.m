function imgMozaic = adaugaPieseMozaicModAleator(params)
    
%cazul in care imaginea de referinta este gri
imgRef = params.imgReferintaRedimensionata;
if size(imgRef,3) == 1
    imgRef = cat(3, imgRef, imgRef, imgRef);
end
params.imgReferintaRedimensionata = imgRef;

imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);
halfH = round(H/2);
halfW = round(W/2);
switch(params.criteriu)
    case 'aleator'
        
        %zona in care se vor plasa piesele de mozaic
        vectorPixeli = 1:(h * w);
        matricePozitii = reshape(vectorPixeli, [w,h]);
        matricePozitii = matricePozitii' ;
        
        matricePixeliNEdesenati = imcrop(matricePozitii,[ halfW,halfH, w-W-1, h-H-1]);
        vectorPixeliNEdesenati = matricePixeliNEdesenati(:);
        nrTotalPixeli = length(vectorPixeliNEdesenati);
        %piesele se vor plasa cu centrul intr-un pixel random din 'vectorPixeliNEdesenati'
        
        pixeliNedesenati = true;
        sumaInitiala = sum(sum(matricePozitii(halfH : h - halfH, halfW : w - halfW)));
        while ~isempty(vectorPixeliNEdesenati)
            indicePixel = vectorPixeliNEdesenati(randi(length(vectorPixeliNEdesenati)));
            
            % calculam pozitia din 'imgMozaic'
            i = round(indicePixel / w) + 1;
            j = mod(indicePixel,w);
            if mod(indicePixel,w) == 0
                j = j+1;
            end
            
            indice = randi(N);
            imgMozaic(i-halfH+1 : i+halfH, j-halfW+1 : j+halfW, :)... 
                = params.pieseMozaic(:,:,:,indice);
            %cod 1
            matricePozitii(i-halfH+1 : i+halfH, j-halfW+1 : j+halfW) = 0;
            vectorPixeliNEdesenati = matricePozitii(matricePozitii ~= 0);
            %cod 1 timp 0.05s
%             vectorPixeliDesenati = pixeliDesenati(:);
            
%             vectorPixeliNEdesenati=setdiff(vectorPixeliNEdesenati,vectorPixeliDesenati);
%             nrPixeliNedesenati = length(vectorPixeliNEdesenati);
            
            %cod 2
            sumaActuala = sum(sum(matricePozitii(halfH : h - halfH, halfW : w - halfW)));
            if sumaActuala == 0
                pixeliNedesenati = false;
            end
            %cod 2 timp 0.03s
            fprintf('Construim mozaic ... %2.2f%% \n',100*(sumaInitiala-sumaActuala)/sumaInitiala);
        end
        
    case 'distantaCuloareMedie'     
        
        %zona in care se vor plasa piesele de mozaic
        vectorPixeli = 1:(h * w);
        matricePozitii = reshape(vectorPixeli, [w,h]);
        matricePozitii = matricePozitii' ;
        
        matricePixeliNEdesenati = imcrop(matricePozitii,[ halfW,halfH, w-W-1, h-H-1]);
        vectorPixeliNEdesenati = matricePixeliNEdesenati(:);
        nrTotalPixeli = length(vectorPixeliNEdesenati);
        %piesele se vor plasa cu centrul intr-un pixel random din 'vectorPixeliNEdesenati'
        
        while ~isempty(vectorPixeliNEdesenati)
            indicePixel = vectorPixeliNEdesenati(randi(length(vectorPixeliNEdesenati)));
            
            % calculam pozitia din 'imgMozaic'
            i = round(indicePixel / w) + 1;
            j = mod(indicePixel,w);
            if mod(indicePixel,w) == 0
                j = j+1;
            end
            
            piesaImgRef = imcrop(params.imgReferintaRedimensionata,[j-halfW+1,i-halfH+1,W,H]);
            culMedPiesaImgRef = mean( reshape( piesaImgRef, [], 3 ));
                
            ceaMaiBunaDist = 1000;
            ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,1);
            
            for indice = 1:N
%              
                culMedPiesaMozaic = mean( reshape( params.pieseMozaic(:,:,:,indice), [], 3 ));
                   
                V = double(culMedPiesaImgRef) - culMedPiesaMozaic;
                dist = norm(V);
                if dist < ceaMaiBunaDist 
                    ceaMaiBunaDist = dist;
                    ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,indice);
                end
       
            end
            imgMozaic(i-halfH+1 : i+halfH, j-halfW+1 : j+halfW, :)... 
                = ceaMaiBunaPiesa;
            pixeliDesenati = matricePozitii(i-halfH+1 : i+halfH, j-halfW+1 : j+halfW);
            vectorPixeliDesenati = pixeliDesenati(:);
            
            vectorPixeliNEdesenati=setdiff(vectorPixeliNEdesenati,vectorPixeliDesenati);
            nrPixeliNedesenati = length(vectorPixeliNEdesenati);
            
%             for indice = 1:length(vectorPixeliDesenati)
%                 vectorPixeliNEdesenati = vectorPixeliNEdesenati(vectorPixeliNEdesenati~=...
%                     vectorPixeliDesenati(indice));
%             end
            
            fprintf('Construim mozaic ... %2.2f%% \n',100*(nrTotalPixeli-nrPixeliNedesenati)/nrTotalPixeli);
        end
        
    otherwise
        printf('EROARE, optiune necunoscuta \n');
end