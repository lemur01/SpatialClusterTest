% Selection of ROI for cluster analysis
% ROI - anticlockwise no repeats
% lam94@cam.ac.uk

n = 2 % 2 selections for every dataset, anticlockwise
[fn pt] = uigetfile('*.csv')
pts = csvread(fullfile(pt,fn));
pts = pts(:,2:3);
%%
% position index 1:2

imsize  = max(pts(:,1:2));

figure; 
        
for k = 1:n
    clf
    colormap lines
    h_im =imshow(zeros(imsize(2), imsize(1))); hold on
    plot(pts(:,1),pts(:,2), '.'); hold on
    %e = impoly();
    e = drawpolygon();
    BW = createMask(e,h_im); 

    id = find(BW(sub2ind(size(BW), floor(pts(:,2)),floor(pts(:,1))))>0);              
    plot(pts(id,1),pts(id,2), 'o'); hold on
    csvwrite(fullfile(pt, strcat('Sel_',strtok(fn, '.'),num2str(k), '.csv')),pts(id,:));
    csvwrite(fullfile(pt, strcat('Win_',strtok(fn, '.'),num2str(k), '.csv')),e.Position);
    pause(2)
end

        