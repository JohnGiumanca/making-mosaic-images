function imgMozaic = adaugaPieseMozaicPeCaroiaj(params)
%
%tratati si cazul in care imaginea de referinta este gri (are numai un canal)
imgRef = params.imgReferintaRedimensionata;
if size(imgRef,3) == 1
    imgRef = cat(3, imgRef, imgRef, imgRef);
end
params.imgReferintaRedimensionata = imgRef;

imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);



switch(params.criteriu)
    case 'aleator'
        %pune o piese aleatoare in mozaic, nu tine cont de nimic
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un indice aleator din cele N
                indice = randi(N);    
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
    case 'distantaCuloareMedie'
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        
        nrPieseAdaugate = 0;
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un cea mai apropiata imagine din cele N
                piesaImgRef = imcrop(params.imgReferintaRedimensionata,[(j-1)*W+1,(i-1)*H+1,W,H]);
                culMedPiesaImgRef = mean( reshape( piesaImgRef, [], 3 ));
                
                ceaMaiBunaDist = 1000;
                ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,1);
                for indice = 1:N
%                   r = round(sum(sum(params.pieseMozaic(:,:,1,indice)))/(H*W))
%                   g = round(sum(sum(params.pieseMozaic(:,:,2,indice)))/(H*W))
%                   b = round(sum(sum(params.pieseMozaic(:,:,3,indice)))/(H*W))
                    
                    culMedPiesaMozaic = mean( reshape( params.pieseMozaic(:,:,:,indice), [], 3 ));
                    
                    V = double(culMedPiesaImgRef) - culMedPiesaMozaic;
                    dist = norm(V);
                    if dist < ceaMaiBunaDist 
                        ceaMaiBunaDist = dist;
                        ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,indice);
                    end
       
                end
                
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = ceaMaiBunaPiesa;       
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
    case 'distantaCuloareMedieSiVeciniDiferiti'
        %matrice bordata cu elemente indicele piesei adaugate in mozaic(pentru a
        %verifica vecinii identici)
        
        matriceIndici = zeros(params.numarPieseMozaicVerticala + 2, params.numarPieseMozaicOrizontala + 2);
        
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
                %alege un cea mai apropiata imagine din cele N
                piesaImgRef = imcrop(params.imgReferintaRedimensionata,[(j-1)*W+1,(i-1)*H+1,W,H]);
                culMedPiesaImgRef = mean( reshape( piesaImgRef, [], 3 ));
                
                ceaMaiBunaDist = 1000;
                ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,1);
                for indice = 1:N            
                    culMedPiesaMozaic = mean( reshape( params.pieseMozaic(:,:,:,indice), [], 3 ));
                   
                    V = double(culMedPiesaImgRef) - culMedPiesaMozaic;
                    dist = norm(V);
                    if dist < ceaMaiBunaDist && indice ~= matriceIndici(i,j+1) && indice ~= matriceIndici(i+2,j+1)... 
                             && indice ~= matriceIndici(i+1,j+2) && indice ~= matriceIndici(i+1,j)
                        ceaMaiBunaDist = dist;
                        ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,indice);
                        ceaMaiBunaPiesaIdx = indice;
                    end
       
                end
                
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = ceaMaiBunaPiesa;
                matriceIndici(i+1, j+1) = ceaMaiBunaPiesaIdx;
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
    case 'pieseHexagonale'
        %p este nr de pixeli pe orizontala in care 2 hex se intrepatrund
        [imgHex, p] = mascaHexagonala(params.pieseMozaic(:,:,:,1));
        
        %recalculam numarul de hexagoane pe orizontala
        numarPixeliVerticala = params.numarPieseMozaicVerticala * H;
        numarPixeliOrizontala = round(w * numarPixeliVerticala / h);
        nrPieseMozaicOrizontala = round(numarPixeliOrizontala / (W-p)) - 1;
        nrPieseMozaicVerticala = params.numarPieseMozaicVerticala;
        
        %matricea de vecini
        matriceIndici = zeros(2*(nrPieseMozaicVerticala + 2), 2*(nrPieseMozaicOrizontala + 2));
        
        nrTotalPiese = nrPieseMozaicOrizontala * nrPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        
        for i = 1:nrPieseMozaicVerticala
            for j = 1:2:nrPieseMozaicOrizontala
                
                piesaImgRef = imcrop(params.imgReferintaRedimensionata,[(j-1)*(W-p)+1,(i-1)*H+1,W,H]);
                culMedPiesaImgRef = mean( reshape( piesaImgRef, [], 3 ));
                
                ii = 2*i+1;
                jj = j+1;
                
                ceaMaiBunaDist = 1000;
                ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,1);
                for indice = 1:N            
                    culMedPiesaMozaic = mean( reshape( params.pieseMozaic(:,:,:,indice), [], 3 ));
                   
                    V = double(culMedPiesaImgRef) - culMedPiesaMozaic;
                    dist = norm(V);
                    if dist < ceaMaiBunaDist && indice ~= matriceIndici(ii-1, jj-1) && indice ~= matriceIndici(ii-2, jj) ...
                                            && indice ~= matriceIndici(ii-1, jj+1) && indice ~= matriceIndici(ii+3, jj+1) ...
                                            && indice ~= matriceIndici(ii+1, jj-1) && indice ~= matriceIndici(ii+2, jj) 
                                            
                        ceaMaiBunaDist = dist;
                        ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,indice);
                        ceaMaiBunaPiesaIdx = indice;
                    end
                end
                
                celMaiBunHex = mascaHexagonala(ceaMaiBunaPiesa);
                imgMozaic((i-1)*H+1:i*H, (j-1)*(W-p)+1:(j-1)*(W-p)+W,:) = celMaiBunHex;
                matriceIndici(ii, jj) = ceaMaiBunaPiesaIdx;
                
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                
            end
        end
        
        for i = 1:nrPieseMozaicVerticala-1
            for j = 2:2:nrPieseMozaicOrizontala
                
                piesaImgRef = imcrop(params.imgReferintaRedimensionata,[(j-1)*(W-p)+1,(i-1)*H+1+round(H/2),W,H]);
                culMedPiesaImgRef = mean( reshape( piesaImgRef, [], 3 ));
                
                ii = 2*i+2;
                jj = j+1;
                
                ceaMaiBunaDist = 1000;
                ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,1);
                for indice = 1:N            
                    culMedPiesaMozaic = mean( reshape( params.pieseMozaic(:,:,:,indice), [], 3 ));
                   
                    V = double(culMedPiesaImgRef) - culMedPiesaMozaic;
                    dist = norm(V);
                    if dist < ceaMaiBunaDist && indice ~= matriceIndici(ii-1, jj-1) && indice ~= matriceIndici(ii-2, jj) ...
                                            && indice ~= matriceIndici(ii-1, jj+1) && indice ~= matriceIndici(ii+3, jj+1) ...
                                            && indice ~= matriceIndici(ii+1, jj-1) && indice ~= matriceIndici(ii+2, jj) 
                        ceaMaiBunaDist = dist;
                        ceaMaiBunaPiesa = params.pieseMozaic(:,:,:,indice);
                        ceaMaiBunaPiesaIdx = indice;
                    end
                end
                
                celMaiBunHex = mascaHexagonala(ceaMaiBunaPiesa);
                spatiuDinMozaic = imgMozaic((i-1)*H+1+round(H/2):(i-1)*H+round(H/2)+H, (j-1)*(W-p)+1:(j-1)*(W-p)+W,:);
                imgMozaic((i-1)*H+1+round(H/2):(i-1)*H+round(H/2)+H, (j-1)*(W-p)+1:(j-1)*(W-p)+W,:) = ...
                    spatiuDinMozaic + celMaiBunHex;
                matriceIndici(ii, jj) = ceaMaiBunaPiesaIdx;
                
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                
            end
        end
        
        
        
        
        
                 
    otherwise
        printf('EROARE, optiune necunoscuta \n');
    
end
    
    
    
    
    
