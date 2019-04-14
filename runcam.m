display('Ba�l�yoruz');
clear all


load detector3class.mat
webcamlist;
mycam = webcam(1);
counter = 1;

while 1
    pause(1/20)
    
    tic
    % G�r�nt�y� kameradan al
    img = snapshot(mycam);
    % G�r�nt�y� boyutland�r ve iyile�tirme yap
    I = imadjust(img, stretchlim(img),[]);
    I = imresize(I, [224,224]);
    I = imadjust(I, stretchlim(I), []);
    
    % g�r�nt�deki nesneleri tesbit et
    [bboxes, score, label] = detect(detector, I);
 
    
    try %G�r�nt�de ilgili nesneler varsa, ilgili s�n�rlay�c� kutular� �iz
          img = insertObjectAnnotation(I,'rectangle',bboxes,strcat(num2str(score*100),' - ',cellstr(label)),...
        'TextBoxOpacity',0.9,'FontSize',10);
    catch
        img = I;
    end
    
    %Ekrana vermeden �nce ��z�n�rl��� artt�r
    img = imresize(img, [1024,980]);
    %Ekrana bas
    imagesc(img);
    t = toc;
    
    display(strcat( int2str(counter) ,'. karenin etikenleme ve olu�turulma s�resi : ', num2str(t)))
    counter = counter + 1;
end