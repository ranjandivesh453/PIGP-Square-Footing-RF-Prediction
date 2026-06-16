function [fitness,gp,ypred,coeffs] = pigp_regressmulti_fitfun(treestrs,gp)

X = gp.userdata.xtrain;
y = gp.userdata.ytrain(:);

x1 = X(:,1);   % Df/B
x2 = X(:,2);   % e/B
x3 = X(:,3);   % H/B
x4 = X(:,4);   % q

% Fixed interpretable physics basis
Phi_fixed = [ ...
    x1, ...                         % positive Df/B
   -x2, ...                         % negative e/B
    x3, ...                         % positive H/B
    x4, ...                         % positive q
    x1.^2, ...                      % square(Df/B)
    x2.^2, ...                      % square(e/B)
    sin(x1 + x1.*x4 - 9.864), ...
    sin(sin(x4)), ...
    sin(x2.*x4), ...
    sin(x2 + x4) ];

% GP-evolved nonlinear genes
ngenes = length(treestrs);
G = zeros(size(X,1),ngenes);

for i = 1:ngenes
    G(:,i) = pigp_eval_gene(treestrs{i},X);
end

G(~isfinite(G)) = 0;
G = max(min(G,1e4),-1e4);

% Full regression matrix
Phi = [ones(size(X,1),1), Phi_fixed, G];

% Ridge regression
lambda = gp.userdata.lambda_ridge;
coeffs = (Phi' * Phi + lambda * eye(size(Phi,2))) \ (Phi' * y);

% Force physically meaningful signs for fixed terms
coeffs(2)  = abs(coeffs(2));      % Df/B positive
coeffs(3)  = abs(coeffs(3));      % because basis is -e/B
coeffs(4)  = abs(coeffs(4));      % H/B positive
coeffs(5)  = abs(coeffs(5));      % q positive
coeffs(6)  = abs(coeffs(6));      % square(Df/B)
coeffs(7)  = abs(coeffs(7));      % square(e/B)

ypred = Phi * coeffs;

rmse_loss = sqrt(mean((y - ypred).^2));
phy_loss = pigp_physics_penalty(treestrs,coeffs,gp);

% stronger complexity penalty to avoid ugly terms
complexity_loss = gp.userdata.lambda_complex * sum(cellfun(@length,treestrs));

fitness = rmse_loss + gp.userdata.lambda_phy * phy_loss + complexity_loss;

if ~isfinite(fitness)
    fitness = 1e10;
end

end