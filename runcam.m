display('Baþlýyoruz');
clear all


load detector3class.mat
webcamlist;
mycam = webcam(1);
counter = 1;

while 1
    pause(1/20)
    
    tic
    % Görüntüyü kameradan al
    img = snapshot(mycam);
    % Görüntüyü boyutlandýr ve iyileþtirme yap
    I = imadjust(img, stretchlim(img),[]);
    I = imresize(I, [224,224]);
    I = imadjust(I, stretchlim(I), []);
    
    % görüntüdeki nesneleri tesbit et
    [bboxes, score, label] = detect(detector, I);
 
    
    try %Görüntüde ilgili nesneler varsa, ilgili sýnýrlayýcý kutularý çiz
          img = insertObjectAnnotation(I,'rectangle',bboxes,strcat(num2str(score*100),' - ',cellstr(label)),...
        'TextBoxOpacity',0.9,'FontSize',10);
    catch
        img = I;
    end
    
    %Ekrana vermeden önce çözünürlüðü arttýr
    img = imresize(img, [1024,980]);
    %Ekrana bas
    imagesc(img);
    t = toc;
    
    display(strcat( int2str(counter) ,'. karenin etikenleme ve oluþturulma süresi : ', num2str(t)))
    counter = counter + 1;
end