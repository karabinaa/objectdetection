% veri setini y�kle
data = load('verisetim3class.mat');
verisetim = data.verisetim3class;

% G�rsellerin dosya yollar�n� tan�mla.
verisetim.imageFilename = fullfile(verisetim.imageFilename);


% rastsall�ktan emin olabilmek i�in seed de�erini s�f�rla.
rng(0);

% Veriyi rastgele e�itim ve test setlerine b�l
% shuffledIndices = randperm(height(verisetim));
% idx = floor(0.6 * length(shuffledIndices) );
% trainingData = verisetim(shuffledIndices(1:idx),:);
% testData = verisetim(shuffledIndices(idx+1:end),:);

trainingData = verisetim;

% G�rsel boyutlar�n� a��n giri�ine g�re ayarla
imageSize = [224 224 3];

% s�n�f say�s�n� belirle
numClasses = width(verisetim)-1;

anchorBoxes = [

%klavye fare kulakl�k
    38    39
   138   137
   101    58
    70   103
];



baseNetwork = resnet50;

% �zellik ��kar�m katman�n� belirle
featureLayer = 'activation_40_relu';

% YOLOv2 a��n� olu�tur. 
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);


% e�itim i�in e�itim parametlerini tan�mla
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 10, .... %sahip oldu�um 2GB NVDIA GTX850M GPUnun izin verdi�i max de�er. Fazlas� "out of memory" hatas� ile sonu�lan�yor.
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',10,...
    'CheckpointPath', tempdir, ...
    'Shuffle','every-epoch');    
        
% YOLOv2 a��n� e�it.
[detector,info] = trainYOLOv2ObjectDetector(verisetim,lgraph,options);
