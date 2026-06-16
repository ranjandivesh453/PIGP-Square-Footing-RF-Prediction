clc;
clear;
close all;

disp('Enhanced PIGP model for RF prediction');
disp('-------------------------------------');

gp = rungp('PIGP_config');

summary(gp);
runtree(gp,'best');

[~, gp, ytrain_pred, coeffs] = feval(gp.fitness.fitfun, ...
    gp.results.best.eval_individual, gp);

ytest_pred = pigp_predict_genes(gp.results.best.eval_individual, ...
    gp.userdata.xtest, coeffs);

disp('Training metrics');
disp(pigp_metrics(gp.userdata.ytrain,ytrain_pred));

disp('Testing metrics');
disp(pigp_metrics(gp.userdata.ytest,ytest_pred));

pigp_export_expression(gp,'best','Final_PIGP_expression.txt');

figure;
scatter(gp.userdata.ytrain,ytrain_pred,55,'filled');
hold on;
plot([min(gp.userdata.ytrain),max(gp.userdata.ytrain)], ...
     [min(gp.userdata.ytrain),max(gp.userdata.ytrain)],'k','LineWidth',1.5);
xlabel('Experimental RF');
ylabel('Predicted RF');
title('Training regression plot');
grid on;

figure;
scatter(gp.userdata.ytest,ytest_pred,55,'filled');
hold on;
plot([min(gp.userdata.ytest),max(gp.userdata.ytest)], ...
     [min(gp.userdata.ytest),max(gp.userdata.ytest)],'k','LineWidth',1.5);
xlabel('Experimental RF');
ylabel('Predicted RF');
title('Testing regression plot');
grid on;