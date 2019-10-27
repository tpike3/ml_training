function factorization()

% Start of script
%-------------------------------------------------------------------------%
close all;                   	% close all figures
clearvars; clearvars -global;	% clear all variables
clc;                         	% clear the command terminal
format shortG;                 	% pick the most compact numeric display
format compact;                	% suppress excess blank lines



% Lets look at the factorization of A
%-------------------------------------------------------------------------%
% Let A be defined as:
A = [ 2  -1  0;
     -1   2 -1;
      0  -1  2]

% first lets check to make sure A is positive definite (this is required 
% for some factorizations) 
determinant = det(A)

% next, factor A.  Notice that each factorization produces a different
% information about the matrix A.

% LU factorization
% Solving Ax=b requires a simple application of back-substitution with U
% followed by a forward-substitution with L.
[L,U] = lu(A)

% Cholesky factorization
% Solving Ax=b requires a simple application of back-substitution with R.
% The caveat is A must be positive definite to use Cholesky.
R = chol(A,'upper')

% QR factorization
% This produces an invertible matrix Q, and orthogonal vectors in R
[Q,R] = qr(A)

% Eigenvalue factorization
% This produces Eigen-vectors in V, and Eigen-values in D
[V,D] = eig(A)

% Singular Value Decomposition
% This produces singular-values in S, and orthogonal vectors in U & V
[U,S,V] = svd(A,0)



% Solutions to Systems of Equations
%-------------------------------------------------------------------------%
% Part 1
%------------------------------------%
% Consider the results for A using Singular Value Decomposition.  This is
% useful for determining the condition number of a matrix.  The condition
% number is a useful way to determine how sensitive b is in the solution to
% Ax=b, meaning, small changes in b will result in large changes to x if A
% is poorly conditioned.  We check this using Singular Value Decomposition.

% Let
b = [4.1;9.7];

% Consider the first example and calculate its SVD and the condition number
A = [ 4.1 2.8;
      9.7 6.6];

[U,S,V] = svd(A,0);

condition_number_SVD = max(diag(S))/min(diag(S))

% now calculate x
x = A\b

% purturb b and calculate x again, notice a small difference for small
% change in b results in a large change in x.
b_bar = b + [0.01; 0];
x = A\b_bar


% Part 2
%------------------------------------%
% there are other ways to calculate the condition number.  For example we
% can use the Eigenvalue decomposition or the L_1 norm.

% Eigenvalue decomposition
[V,D] = eig(A);
condition_number_EVD = abs(max(diag(D))/min(diag(D)))

% L_1 norm (assuming the inverse exists)
condition_number_L1 = norm(A,1)*norm(inv(A),1)


% Part 3
%------------------------------------%
% Now lets consider a matrix with a small condition number.
A = [ 2  -1  0;
     -1   2 -1;
      0  -1  2]

% Singular Value Decomposition  
[U,S,V] = svd(A,0);
condition_number_SVD = max(diag(S))/min(diag(S))

% Eigenvalue decomposition
[V,D] = eig(A);
condition_number_EVD = abs(max(diag(D))/min(diag(D)))

% L_1 norm (assuming the inverse exists)
condition_number_L1 = norm(A,1)*norm(inv(A),1)

% Lets again look at the variation in b.  Let
b = [1;2;3];

% now calculate x
x = A\b

% purturb b and calculate x again, notice a small difference for small
% change in b results in a small change in x.
b_bar = b + [0.01; 0; 0];
x = A\b_bar



% Now lets use the factorization methods to solve Ax=b
%-------------------------------------------------------------------------%
% Here you can select which A and B you would like to use.

% non-square, not invertable, matrix A
A = [3 -6; 4 -8; 0 1];
b = [-1; 7; 2];
  
% square, invertable (non-singular), positive definite matrix A
% A = [ 2  -1  0; -1   2 -1; 0  -1  2]; 
% b = [1; 2; 3];


% LU factorization
%------------------------------------%
disp('LU factorization')
[L,U] = lu(A'*A);
y = inv(L)*A'*b;
x = inv(U)*y


% Cholesky factorization
%------------------------------------%
disp('Cholesky factorization')
% Mx = b as LL'x = b and let L'x = y.
% First we solve Ly = b using forward substitution
% Next, using this, we solve L'x = y using backward substitution
L = chol(A'*A,'lower');
y = matrixFwdSub(L,A'*b);
x = matrixBackSub(L',y) 

 
% SVD factorization
%------------------------------------%
disp('SVD factorization')
[U,S,V] = svd(A,0);
x = V * inv(S) * U' * b


% QR factorization
%------------------------------------%
disp('QR factorization')
[Q,R] = qr(A);
x = matrixBackSub(R,Q'*b)


% ED factorization
%------------------------------------%
disp('EVD factorization')
% create square matrix and 
E = A'*A;
% do ED factorization with eigenvectors in V and eigenvalues in D.
[V,D] = eig(E);
% solve Ax=b by multiplication
%   Note: A = V*D*V^-1, 
%   so V*D*inv(V)*x = b, 
%   but to make E square we used A'*A
%   so V*D*inv(V)*x = A'*b,
% Now solve in 3 steps.
c = inv(V)*A'*b;
y = inv(D)*c;
x = V*y


end % end of factorization demo function



% These are sub-functions that we will need to solve Ax=b
%-------------------------------------------------------------------------%
function x = matrixFwdSub(A,b)
% Matrix forward substitution
%
% x = martixFwdSub(A,b)
%
% Solves x = inv(A) * b
%
%          |1|         |1 0 0|
% With b = |2| and A = |2 1 0|
%          |3|         |3 4 1|
%
% Parameters:
%   A:	input matrix (lower trianglular matrix)
%   b:  input vector
%
% Return values:
%   x:	vector


[~,n] = size(A); 
x = zeros(n,1);

x(1) = b(1)/A(1,1); % this is scalar division

for i = 2:n
    x(i) = (b(i) - A(i,i-1)*x(i-1))/A(i,i);
end

end



function x = matrixBackSub(A,b)
% Matrix backward substitution
%
% x = matrixBackSub(A,b)
%
% Solves x = inv(A) * b
%
%          |1|         |2 2 1|
% With b = |2| and A = |0 1 4|
%          |3|         |0 0 3|
%
% Parameters:
%   A:	input matrix (upper trianglular matrix)
%   b:  input vector
%
% Return values:
%   x:	vector


[~,n] = size(A);
x = zeros(n,1);

x(n) = b(n)/A(n,n); % this is scalar division

for i=n-1:-1:1
   x(i) = (b(i) - A(i,i+1:n)*x(i+1:n))/A(i,i);
end

end