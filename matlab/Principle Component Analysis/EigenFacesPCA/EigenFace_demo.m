% Eigenface recognition
% 
% Description:
% This algorithm uses the eigenface system (based on pricipal component
% analysis - PCA) to recognize faces.
% 
% Credits:
% inspired by C. Ostrum 


% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines


% Load and Display
%-------------------------------------------------------------------------%
directory = 'att_faces/s'; 
ext = '.pgm'; 
person_max = 40; 
face_max = 10;
person_count = 10; % up to person_max
face_count = 9; % up to face_max-1; leaving at least one unknown for recognizing

% Principal components to keep
N = ceil(.25 * (person_count*face_count));

fprintf('Keep only the top %d principal components out of %d\n', ...
    N, person_count*face_count);

if( person_count > person_max || face_count > face_max-1 )
    fprintf('Count values cannot exceed maximums\n');
    return;
end

[faces,irow,icol,resize,pidx,fidx] = ...
    load_faces(directory,person_count,person_max,face_count,face_max,ext);

if person_count <= 10
    display_faces(faces,irow,icol,person_count,face_count);
end


% Choose recognition image
%-------------------------------------------------------------------------%
% We choose an image not in the training set as our image to identify
% Face to recognize
file = strcat(directory,num2str(pidx),'/',num2str(fidx),ext);
recognize = imread(file);
if( resize )
    recognize = imresize(recognize,[irow icol]); 
end
recognize = recognize(:,:,1);
figure
imshow(recognize,[])
title('Face to recognize');


% Calculate the mean
%-------------------------------------------------------------------------%
m = uint8(mean(faces,2));
figure
imshow(reshape(m,irow,icol),[])
title('Mean face');

faces_mean = faces - uint8( single(m)*single( uint8(ones(1,size(faces,2)) ) ));


% Calculating eigenvectors
%-------------------------------------------------------------------------%
% L = A'A
L = single(faces_mean)'*single(faces_mean);
[V,D] = eig(L);

% Plot the eigenvalues. Matlab's "eig" function sorts them from low to
% high, so let's reverse the order for display purposes.
eigenvals = diag(D);
figure
plot(eigenvals(end:-1:1))
title('Eigenvalues');

% Look at the mean squared error, as we increase the number of PCs to keep.
figure
plot(sum(eigenvals) - cumsum(eigenvals(end:-1:1)));
title('Mean squareed error vs number of PCs');

% Here are the principal components.
PC = single(faces_mean)*V;

% Pick the top N eigenfaces
PC = PC(:,end:-1:end-(N-1));

display_faces(PC(:,1:10),irow,icol,1,10); % Display first 10 eigenfaces


% Calculate image signature
%-------------------------------------------------------------------------%
signatures = zeros(size(faces,2),N);
for i=1:size(faces,2);
    signatures(i,:)=single(faces_mean(:,i))'*PC; % Each row is an image signature
end

figure 
imshow(signatures, [], 'InitialMagnification', 300);
title('Signatures of images in database');


% Recognition
%-------------------------------------------------------------------------%
% Now run the algorithm to see if we are able to match the new face
figure('Name','Result', 'NumberTitle','off', 'MenuBar','none')
subplot(231)
imshow(recognize,[])
title('Face to recognize');

% Prepare the recognition face
rec = reshape(recognize,irow*icol,1)-m;
rec_weighted = single(rec)'*PC;

fprintf('Here is the signature of the new (input) face.\n');
fprintf('These are the coefficients of the face projected onto the %d PCs:\n', N);

disp(rec_weighted);

scores = zeros(1,size(signatures,1));

for i=1:size(faces,2)
    % calculate Euclidean distance as score
    scores(i) = norm(signatures(i,:)-rec_weighted,2);
end

% display results
[C,idx] = sort(scores,'ascend');

fprintf('Top 3 scores (Euclidean distance): %f, %f, %f\n', C(1), C(2), C(3));

subplot(234);
imshow(reshape(faces(:,idx(1)),irow,icol),[]),title('Best match');
subplot(235);
imshow(reshape(faces(:,idx(2)),irow,icol),[]),title('2nd best');
subplot(236);
imshow(reshape(faces(:,idx(3)),irow,icol),[]),title('3rd best');

dock_all_figures;

save_all_figs_OPTION('pca_faces','png')




















