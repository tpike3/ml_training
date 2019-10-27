function display_faces(face_space,irow,icol,sub_row,sub_col) 
% Face Display 

[~, W] = size(face_space);

%figure('Name','Face Display', 'NumberTitle','off', 'MenuBar', 'none') 
figure('Name','Face Display') 

for i = 1:W 
    subplot(sub_row,sub_col,i); 
    face = reshape(face_space(:,i),irow,icol); 
    imshow(face,[]); 
end

end