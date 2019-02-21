function importDataSet()

destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/airplane';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/automobile';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/bird';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/cat';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/deer';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/dog';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/frog';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/horse';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/ship';
mkdir(destdirectory);
destdirectory = '/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/truck';
mkdir(destdirectory);

sizeH = 32;
sizeW = 32;
imgSize = sizeH * sizeW;

names = load('../cifar/batches.meta.mat');
data = names;
k=1;
for i = 1:5
    file = strcat('../cifar/data_batch_', int2str(i), '.mat');
    dataset = load(file);
    fprintf('Loading %s...\n',dataset.batch_label);
    
    [rows,columns] = size(dataset.data);
    
    for j = 1:rows
        r = reshape( dataset.data(j,1:imgSize),[sizeH,sizeW])';
        g = reshape(dataset.data(j,imgSize+1:imgSize*2),[sizeH,sizeW])';
        b = reshape(dataset.data(j,imgSize*2+1:imgSize*3),[sizeH,sizeW])';
        
        img = uint8(cat(3,r,g,b));
        
        labelNumber = dataset.labels(j) + 1;
        setName = names.label_names(labelNumber);
        
        path = strcat('/Users/johnsmacbook/MyDocs/Facultate/Vedere Artificiala/tema1/data/',setName{1});
        fullpath = strcat(path,'/',int2str(k), '.jpg');
        imwrite(img,fullpath);
        k=k+1;
        
    end
    
end

