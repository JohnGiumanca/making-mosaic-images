function params = calculeazaDimensiuniMozaic(params)
%calculeaza dimensiunile mozaicului
%obtine si imaginea de referinta redimensionata avand aceleasi dimensiuni
%ca mozaicul

%completati codul Matlab

[h,w] = size(params.pieseMozaic(:,:,1,1));
[hRef, wRef, c] = size(params.imgReferinta);

numarPixeliOrizontala = params.numarPieseMozaicOrizontala * w;
numarPixeliVerticala = round(hRef * numarPixeliOrizontala / wRef);
numarPieseMozaicVerticala = round(numarPixeliVerticala / h);


%calculeaza automat numarul de piese pe verticala
params.numarPieseMozaicVerticala = numarPieseMozaicVerticala

%calculeaza si imaginea de referinta redimensionata avand aceleasi dimensiuni ca mozaicul
params.imgReferintaRedimensionata = imresize(params.imgReferinta, [numarPixeliVerticala numarPixeliOrizontala]);

