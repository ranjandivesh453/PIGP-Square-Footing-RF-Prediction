function penalty = pigp_physics_penalty(treestrs, coeffs, gp)

X = gp.userdata.xtrain;
signs = gp.userdata.physics_sign;

delta = 1e-4;
total = 0;
count = 0;

for j = 1:size(X,2)

    Xp = X;
    Xm = X;

    Xp(:,j) = Xp(:,j) + delta;
    Xm(:,j) = Xm(:,j) - delta;

    yp = pigp_predict_genes(treestrs,Xp,coeffs);
    ym = pigp_predict_genes(treestrs,Xm,coeffs);

    dydx = (yp - ym) ./ (2*delta);

    if signs(j) > 0
        violation = max(0,-dydx);
    elseif signs(j) < 0
        violation = max(0,dydx);
    else
        violation = zeros(size(dydx));
    end

    total = total + mean(violation.^2);
    count = count + 1;
end

penalty = sqrt(total / count);

if ~isfinite(penalty)
    penalty = 1e6;
end

end