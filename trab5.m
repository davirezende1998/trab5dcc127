
SOCIAIS = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_sociais_1.csv');
% REMOVE COLUNA ID
SOCIAIS.id = [];
idades = table2array(SOCIAIS(:,'idade'))
lidaonde = table2array(SOCIAIS(:,'lida_onde'))
lidadiretamente = table2array(SOCIAIS(:,'lidadiretamente'))
lidadiretamente = categorical(lidadiretamente)
aprovados = table2array(SOCIAIS(:,'aprovado'))
aprovados = categorical(aprovados)
figure
hist(idades)
xlabel('Idade')

%%
figure
hist([categorical(lidaonde)])
%%
[cnt_unique, unique_a] = hist(aprovados,unique(aprovados))
%%
figure
hist([aprovados  lidadiretamente])
legend


%%
vErro = [];
vTempo = [];
vLabel = [];



a = size(SOCIAIS)

table = [];
cont = 1;

%TRATA VALORES STRING PARA NUMERICO > FICA TUDO NUMERICO
for i = 1:a(2)-1
    
    ax = table2array(SOCIAIS(:,i+1));
    
    ax = categorical(ax);
    [GN, ~, G] = unique(ax)
    if i==54
        target = G;
        continue;
    end
    table(:,cont) = G;
    cont = cont+1;
end

[cnt_uniqueb, unique_b] = hist(aprovados,unique(aprovados))
%TREINA E GERA REDE NEURAL
target2= target;
% TRANSFORMA TARGET EM DUMMYVAR = MATRIZES DE 1 E 0
target = dummyvar(target)
%NORMALIZA E TREINA REDE NEURAL DE RECONHECIMENTO DE PADRAO.
[erro,t] = trainNNP(normalize(table),target,53);

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "PNN CASO1"];

%% SVM LINEAR  - CASO 1

input2 = [table target2]; %TIC TOC é função de calcular o tempo, vou plotar um gráfico com os tempos de execução e performance
tic
[svmCaso1, validationAccuracy] =  SVMCASO1(SOCIAIS);

t=toc;

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "SVM CASO1"];


%% CASO

MODULO1 = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_modulo1_1.csv');
target2 = MODULO1.aprovado; %vou usar para a SVM
MODULO1.id=[];
MODULO1.aprovado = []; %RETIRA APROVADO DO SEGUNDO CONJUNTO.
a = size(MODULO1);

%TRATA VALORES STRING PARA NUMERICO > FICA TUDO NUMERICO
for i = 1:a(2)
    
    ax = table2array(MODULO1(:,i));
    
    ax = categorical(ax);
    [GN, ~, G] = unique(ax);
    table(:,cont) = G;
    cont = cont+1;
end
%% NEURAL - CASO 2
%TREINA E GERA REDE NEURAL
%NORMALIZA E TREINA REDE NEURAL DE RECONHECIMENTO DE PADRAO.
[erro,t] = trainNNP(normalize(table),target,59);

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "PNN CASO2"];

%% SVM LINEAR  -  CASO 2

inputM1 = [SOCIAIS MODULO1];
tic
[svmCaso1, validationAccuracy] =  SVMCASO2(inputM1);

t=toc;

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "SVM CASO2"];

%% CASO 3
MODULO2 = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_ateh_modulo2_1.csv');
target2 = MODULO2.aprovado; %vou usar para a SVM
MODULO2.id=[];
MODULO2.aprovado = []; %RETIRA APROVADO DO SEGUNDO CONJUNTO.
a = size(MODULO2);
%TRATA VALORES STRING PARA NUMERICO > FICA TUDO NUMERICO
for i = 1:a(2)
    
    ax = table2array(MODULO2(:,i));
    
    ax = categorical(ax);
    [GN, ~, G] = unique(ax);
    table(:,cont) = G;
    cont = cont+1;
end
%% NEURAL - CASO 3
%TREINA E GERA REDE NEURAL
%NORMALIZA E TREINA REDE NEURAL DE RECONHECIMENTO DE PADRAO.
[erro,t] = trainNNP(normalize(table),target,71);

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "PNN CASO3"];

%% SVM LINEAR  -  CASO 3
inputM2 = [SOCIAIS MODULO2];

tic
[svmCaso1, validationAccuracy] =  SVMCASO3(inputM2);

t=toc;

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "SVM CASO3"];

%% CASO MODULO 2 APENAS
MODULOT = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_ateh_modulo2_1.csv');
MODULOT.id=[];
a = size(MODULOT);
table2 = []
%TRATA VALORES STRING PARA NUMERICO > FICA TUDO NUMERICO
cont =1;
for i = 1:a(2)
    
    ax = table2array(MODULOT(:,i));
    
    ax = categorical(ax);
    [GN, ~, G] = unique(ax);
    if i==10
        target = G;
        continue;
    end
    table2(:,cont) = G;
    cont = cont+1;
end
target = dummyvar(target)
[erro,t] = trainNNP(table2,target,12);

vTempo = [vTempo t];
vErro = [vErro erro];
vLabel = [vLabel "MODULO 2"];
%%

[vTempo,I] = sort(vTempo,'ascend');
vLabel = vLabel(I);
vErro = vErro(I);
h = figure('name','Erro por tempo geral ');
plot(vTempo/60,'LineWidth',2)
title('Tempo de execução por algoritmo')
ylabel('Erro')
legend('tempo de execucao (min)','Erro')
xticks([1:length(vLabel)]);
xticklabels(vLabel);
xtickangle(45)
hold on
plot(vErro,'LineWidth',2)

%%

MODULO1 = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_modulo1_1.csv');
MODULO1.id=[];
aux = MODULO1;
aux.aprovado = [];
h =[];
h2 = [];
a= size(MODULO1)
ch1=1;
ch2=1;
for i = 1: 1000;
    
    if(strcmp(MODULO1.aprovado(i),'Sim'))
        h1(ch1,:) = table2array(aux(i,:));
        ch1=ch1+1;
    else
        h2(ch2,:) = table2array(aux(i,:));
        ch2 =ch2+1;
    end
end
sh1 = sum(h1);
sh2 = sum(h2);

figure
scatter(1:9,sh1,sh1(9),'filled','g');
hold on
scatter(1:9,sh2,sh2(9),'filled','r');
%%
MODULO2 = readtable('C:\Users\pedro\Downloads\Nova pasta\trabalho5_dados_ateh_modulo2_1.csv');
MODULO2.id=[];
aux = MODULO2;
aux.aprovado = [];
h1 =[];
h2 = [];
a= size(MODULO2)
ch1=1;
ch2=1;
for i = 1: 1000;
    
    if(strcmp(MODULO2.aprovado(i),'Sim'))
        h1(ch1,:) = table2array(aux(i,:));
        ch1=ch1+1;
    else
        h2(ch2,:) = table2array(aux(i,:));
        ch2 =ch2+1;
    end
end
sh1 = sum(h1);
sh2 = sum(h2);
figure
scatter(1:18,sh1,sh1(9),'filled','g');
hold on
scatter(1:18,sh2,sh2(9),'filled','r');
%     hold on
%     scatter(2,1,sh1(2),'filled','g');
%     hold on
%     scatter(3,1,sh1(3),'filled','g');
%     hold on
%     scatter(4,1,sh1(4),'filled','g');
%     hold on
%     scatter(5,1,sh1(5),'filled','g');
%     hold on
%     scatter(6,1,sh1(6),'filled','g');
%     hold on
%     scatter(7,1,sh1(7),'filled','g');
%     hold on
%     scatter(8,1,sh1(8),'filled','g');
%     hold on
%     scatter(9,1,sh1(9),'filled','g');
%     hold on
%
%     scatter(1,2,sh2(1),'filled','r');
%     hold on
%     scatter(2,2,sh2(2),'filled','r');
%     hold on
%     scatter(3,2,sh2(3),'filled','r');
%     hold on
%     scatter(4,2,sh2(4),'filled','r');
%     hold on
%     scatter(5,2,sh2(5),'filled','r');
%     hold on
%     scatter(6,2,sh2(6),'filled','r');
%     hold on
%     scatter(7,2,sh2(7),'filled','r');
%     hold on
%     scatter(8,2,sh2(8),'filled','r');
%     hold on


%%
function [erro,t] = trainNNP(input, target, neurons)
%INSTANCIA REDE NEURAL DE RECONHECIMENTO DE PADROES
x = input';
t = target';
tic;
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 40;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.showWindow=0;
% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
tind = vec2ind(t);
yind = vec2ind(y);
erro = sum(tind ~= yind)/numel(tind);

% View the Network
%view(net)
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
f = figure, plotconfusion(t,y)
%figure, plotroc(t,y)

t=toc;
end


function [trainedClassifier, validationAccuracy] = SVMCASO1(trainingData)
inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', {'Nao'; 'Sim'});

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'Aus_nciaDaFamilia_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PoucaComunicacaoComOsPais_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'autoavaliacao_x', 'contatoanterior', 'escolaridade', 'estadocivil', 'idade', 'import_ajud_tutor', 'interacaopares', 'lida_onde', 'lidadiretamente', 'materialdidatico', 'ocupacao', 'organizacaocurso', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'prazoatividades', 'religiao', 'sexo', 'tempodeservico'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, SOCIAIS, use: \n  yfit = c.predictFcn(SOCIAIS) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, SOCIAIS, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 10);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end


function [trainedClassifier, validationAccuracy] = SVMCASO2(trainingData)
inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'quesm1', 'quesm1r', 'forum1', 'forum2', 'forum3', 'forum4', 'ativcolm1', 'ativcolm1r', 'forum1r'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', {'Nao'; 'Sim'});

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'Aus_nciaDaFamilia_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PoucaComunicacaoComOsPais_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ativcolm1', 'ativcolm1r', 'autoavaliacao_x', 'contatoanterior', 'escolaridade', 'estadocivil', 'forum1', 'forum1r', 'forum2', 'forum3', 'forum4', 'idade', 'import_ajud_tutor', 'interacaopares', 'lida_onde', 'lidadiretamente', 'materialdidatico', 'ocupacao', 'organizacaocurso', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'prazoatividades', 'quesm1', 'quesm1r', 'religiao', 'sexo', 'tempodeservico'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'quesm1', 'quesm1r', 'forum1', 'forum2', 'forum3', 'forum4', 'ativcolm1', 'ativcolm1r', 'forum1r'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 10);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end

function [trainedClassifier, validationAccuracy] = SVMCASO3(trainingData)
% [trainedClassifier, validationAccuracy] = SVMCASO3(trainingData)
% Returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A table containing the same predictor and response
%       columns as those imported into the app.
%
%  Output:
%      trainedClassifier: A struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: A function to make predictions on new
%       data.
%
%      validationAccuracy: A double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = SVMCASO3(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 03-Feb-2022 13:51:52


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'quesm2', 'ativcolm2', 'forum5', 'forum6', 'forum7', 'ativcolm2r', 'quesm2r', 'forum8', 'forum2r', 'quesm1', 'quesm1r', 'forum1', 'forum2', 'forum3', 'forum4', 'ativcolm1', 'ativcolm1r', 'forum1r'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', {'Nao'; 'Sim'});

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'Aus_nciaDaFamilia_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PoucaComunicacaoComOsPais_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ativcolm1', 'ativcolm1r', 'ativcolm2', 'ativcolm2r', 'autoavaliacao_x', 'contatoanterior', 'escolaridade', 'estadocivil', 'forum1', 'forum1r', 'forum2', 'forum2r', 'forum3', 'forum4', 'forum5', 'forum6', 'forum7', 'forum8', 'idade', 'import_ajud_tutor', 'interacaopares', 'lida_onde', 'lidadiretamente', 'materialdidatico', 'ocupacao', 'organizacaocurso', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'prazoatividades', 'quesm1', 'quesm1r', 'quesm2', 'quesm2r', 'religiao', 'sexo', 'tempodeservico'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'idade', 'sexo', 'escolaridade', 'estadocivil', 'ocupacao', 'tempodeservico', 'religiao', 'contatoanterior', 'lidadiretamente', 'lida_onde', 'materialdidatico', 'prazoatividades', 'interacaopares', 'organizacaocurso', 'import_ajud_tutor', 'autoavaliacao_x', 'part_outrocurso', 'pp001', 'pp002', 'pp003', 'pp004', 'pp005', 'pp006', 'pp007', 'pp008', 'pp009', 'pp010', 'pp011', 'pp012', 'pp013', 'pp014', 'pp015', 'pp016', 'pp017', 'pp018', 'pp019', 'pp020', 'pp021', 'pp022', 'pp023', 'pp024', 'pp025', 'pp026', 'pp027', 'pp028', 'pp029', 'pp030', 'pp031', 'pp032', 'pp033', 'pp034', 'pp035', 'pp036', 'pp037', 'IdentificacaoPessoalComOTema_motivopart_', 'IdentificacaoProfissionalComOTema_motivopart_', 'ParaAquisicaoDeConhecimentoNaArea_motivopart_', 'PeloFatoDeOCursoSerGratuito_motivopart_', 'PeloFatoDeOCursoEstarVinculado_Universidade_motivopart_', 'PorSerUmCurso_Dist_ncia_motivopart_', 'PorSerUmaOportunidadeDeFormacaoContinuada_motivopart_', 'Aus_nciaDaFamilia_barreiras_', 'PoucaComunicacaoComOsPais_barreiras_', 'UsoDeSubst_nciasPorFamiliares_barreiras_', 'PresencaDeDrogasIlicitasNoAmbienteEscolar_barreiras_', 'ProximidadeDaRedeDeDistribuicaoDeDrogas_barreiras_', 'Aus_nciaDeLimitesDosAlunos_barreiras_', 'Aus_nciaDeColaboracaoDaEquipeEscolar_barreiras_', 'Aus_nciaDeRegrasNoAmbienteEscolar_barreiras_', 'PossuirAlunosInteressadosNaTematica_facilitadores_', 'PresencaDeUmaEquipeParaTrabalharATematica_facilitadores_', 'EstimuloAosAlunos_facilitadores_', 'DesenvolvimentoDeProjetosNaEscola_facilitadores_', 'ApoioAosProjetosEmDesenvolvimento_facilitadores_', 'PresencaDeRegrasNoAmbienteEscolar_facilitadores_', 'PromocaoDeCompromissoEConfianca_facilitadores_', 'ValorizacaoDoAmbienteEscolar_facilitadores_', 'ParticipacaoDaComunidadeEDosPaisNoTrabalhoDePrevencao_facilitad', 'quesm2', 'ativcolm2', 'forum5', 'forum6', 'forum7', 'ativcolm2r', 'quesm2r', 'forum8', 'forum2r', 'quesm1', 'quesm1r', 'forum1', 'forum2', 'forum3', 'forum4', 'ativcolm1', 'ativcolm1r', 'forum1r'};
predictors = inputTable(:, predictorNames);
response = inputTable.aprovado;
isCategoricalPredictor = [false, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 10);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end


%%

