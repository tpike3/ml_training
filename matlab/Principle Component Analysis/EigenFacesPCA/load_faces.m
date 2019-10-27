function [faces,irow,icol,resize,pidx,fidx] = ...
    load_faces(directory,person_count,person_max,face_count,face_max,ext)

% This function loads the face images
resize = false;
fidx = 1;

% test image size
img = imread(strcat(directory,'1/1',ext));
img = img(:,:,1);
[irow,icol] = size(img);

if( size(img,1) > 400 )
    img = imresize(img,[200, 200]);
    resize = true;
end

% setup variables
[irow,icol] = size(img);
img_size = irow*icol;
v=zeros(img_size,person_count*face_count);
w=zeros(img_size,person_count*face_count);

% create a random permutation of the people to pick from
people = randperm(person_max);

% choose a random person as our recognition person
rand_idx = mod(round(person_count*rand),person_count)+1;

% pidx is now the randomly selected person index
pidx = people(rand_idx);
for i=1:person_count
    
    % similarly, create a random permutation of possible faces
    faces = randperm(face_max);
    for j=1:face_count
        file = strcat(directory,num2str(people(i)),'/',num2str(faces(j)),ext);
        
        % pre-processing
        img = imread(file);
        if( resize )
            img=imresize(img,[irow icol]); 
        end
        img = img(:,:,1);
        w(:,(i-1)*face_count+j)=reshape(img,img_size,1);
    end
    
    % select our random face that is not in the training set
    if( i == rand_idx )
        fidx = faces(face_count+1);
    end
end

faces = uint8(w);

end


