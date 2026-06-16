function gp = PIGP_config(gp)

rng(25,'twister');

gp.runcontrol.pop_size = 400;
gp.runcontrol.num_gen  = 150;
gp.runcontrol.verbose  = 10;

gp.selection.tournament.size = 5;
gp.selection.tournament.lex_pressure = true;
gp.selection.elite_fraction = 0.02;

gp.fitness.fitfun = @pigp_regressmulti_fitfun;
gp.fitness.minimisation = true;
gp.fitness.terminate = true;
gp.fitness.terminate_value = 1e-5;

Xtrain = xlsread('RF_data.xlsx','trainX');
ytrain = xlsread('RF_data.xlsx','trainY');
Xtest  = xlsread('RF_data.xlsx','testX');
ytest  = xlsread('RF_data.xlsx','testY');

gp.userdata.xtrain = Xtrain;
gp.userdata.ytrain = ytrain(:);
gp.userdata.xtest  = Xtest;
gp.userdata.ytest  = ytest(:);

gp.nodes.inputs.num_inp = size(Xtrain,2);

gp.treedef.max_depth = 4;
gp.treedef.max_nodes = 35;

gp.genes.multigene = true;
gp.genes.max_genes = 6;

gp.userdata.lambda_phy = 0.20;
gp.userdata.lambda_complex = 5e-4;
gp.userdata.lambda_ridge = 1e-5;

% Df/B positive, e/B negative, H/B positive, q positive
gp.userdata.physics_sign = [1 -1 1 1];

gp.nodes.functions.name{1} = 'plus';
gp.nodes.functions.name{2} = 'minus';
gp.nodes.functions.name{3} = 'times';
gp.nodes.functions.name{4} = 'sin';
gp.nodes.functions.name{5} = 'square';
gp.nodes.functions.name{6} = 'pdivide';

gp.nodes.functions.active(1) = 1;
gp.nodes.functions.active(2) = 1;
gp.nodes.functions.active(3) = 1;
gp.nodes.functions.active(4) = 1;
gp.nodes.functions.active(5) = 1;
gp.nodes.functions.active(6) = 0;   % keep off for cleaner equation

end