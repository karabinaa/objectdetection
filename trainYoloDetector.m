% veri setini yükle
data = load('verisetim3class.mat');
verisetim = data.verisetim3class;

% Görsellerin dosya yollarýný tanýmla.
verisetim.imageFilename = fullfile(verisetim.imageFilename);


% rastsallýktan emin olabilmek için seed deðerini sýfýrla.
rng(0);

% Veriyi rastgele eðitim ve test setlerine böl
% shuffledIndices = randperm(height(verisetim));
% idx = floor(0.6 * length(shuffledIndices) );
% trainingData = verisetim(shuffledIndices(1:idx),:);
% testData = verisetim(shuffledIndices(idx+1:end),:);

trainingData = verisetim;

% Görsel boyutlarýný aðýn giriþine göre ayarla
imageSize = [224 224 3];

% sýnýf sayýsýný belirle
numClasses = width(verisetim)-1;

anchorBoxes = [

%klavye fare kulaklýk
    38    39
   138   137
   101    58
    70   103
];



baseNetwork = resnet50;

% özellik çýkarým katmanýný belirle
featureLayer = 'activation_40_relu';

% YOLOv2 aðýný oluþtur. 
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);


% eðitim için eðitim parametlerini tanýmla
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 10, .... %sahip olduðum 2GB NVDIA GTX850M GPUnun izin verdiði max deðer. Fazlasý "out of memory" hatasý ile sonuçlanýyor.
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',10,...
    'CheckpointPath', tempdir, ...
    'Shuffle','every-epoch');    
        
% YOLOv2 aðýný eðit.
[detector,info] = trainYOLOv2ObjectDetector(verisetim,lgraph,options);
