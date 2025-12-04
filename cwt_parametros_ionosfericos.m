% ==============================
% CWT - Dados OMNI (5-min averaged)
% ==============================
clc; clear; close all;

% --- 1) Ler o arquivo tratado do OMNI (DD MM YYYY HH:MM Ey Bz V N SYM_H ...)
opts = detectImportOptions('dados_Omni_Tratados.txt', 'Delimiter', '\t');
T = readtable('dados_Omni_Tratados.txt', opts);

% --- 2) Mostrar as colunas lidas
disp('Colunas lidas do arquivo OMNI:');
disp(T.Properties.VariableNames);

% --- 3) Criar eixo temporal (datetime)
datetime_str = compose('%02d-%02d-%04d %s', ...
    T{:,1}, T{:,2}, T{:,3}, string(T{:,4}));
time_datetime = datetime(datetime_str, 'InputFormat', 'dd-MM-yyyy HH:mm');
xnum = datenum(time_datetime);

% --- 4) Identificar colunas físicas do OMNI
% A partir da 5ª coluna em diante
colunas = 5:width(T);
nomesVarsTabela = T.Properties.VariableNames(colunas);

% Nomes físicos conforme NASA/OMNIWeb
nomesFisicos = { ...
    'Bz, GSM (nT)', ...
    'Flow Speed (km/s)', ...
    'Proton Density (n/cc)', ...
    'Ey - Electric Field (mV/m)', ...
    'AE (nT)', ...   
    'SYM/H (nT)'};

        % --- Salvar automaticamente a figura ---
nomesArquivos = { ...
    'image_bz.png', ...
    'image_flow_speed.png', ...
    'image_proton_density.png', ...
    'image_ey.png', ...
    'image_ae.png', ...
    'image_symh.png' };
% --- 5) Loop para gerar um gráfico por variável
for k = 1:length(colunas)
    sig2 = T{:,colunas(k)};
    nomeColuna = nomesVarsTabela{k};
    nomeFisico = nomesFisicos{k};

    % --- Pré-processamento
    mask_nan = isnan(sig2(:))';
    sig2(isnan(sig2)) = 0;
    sig2 = sig2(:);
    n = numel(sig2);

    % --- Extensão simétrica
    left2 = flipud(sig2);
    sig2_ext = [left2; left2; sig2; left2; left2];

    % --- Configuração da CWT
    fs = 1/300;  % 5 minutos
    sig2_ext(isnan(sig2_ext)) = 0;
    
    fb = cwtfilterbank('SignalLength', numel(sig2_ext), ...
                   'SamplingFrequency', fs, ...
                   'FrequencyLimits', [1e-7 1e-4]);
    
    
    [wt, f, coi] = cwt(sig2_ext, 'FilterBank', fb);

    period = (1 ./ f)./(60*60*24);
    
    % --- Recorte central
    wt_central = wt(:, 2*n+1 : 3*n);
    coi_central = coi(2*n+1 : 3*n);
    W = abs(wt_central).^2;
    W(:, mask_nan) = NaN;

    % --- Gráfico
    figure('Name',['CWT - OMNI ' nomeColuna]);
    h = pcolor(xnum, log2(period), W ./ max(W(:)));
    set(h, 'EdgeColor', 'none');
    set(gca, 'Color', 'w');
    set(h, 'AlphaData', ~isnan(W));
    set(h, 'FaceAlpha', 'flat');
colormap jet;
c = colorbar;                  % salva o handle corretamente
c.Limits = [0 1];
c.Ticks = 0.1:0.1:0.9;
c.TickLabels = string(c.Ticks);
c.Label.FontSize = 16;
c.Label.FontName = 'Arial';


    % --- Eixos e rótulos
   
    ax = gca;

    % Define o intervalo de tempo (eixo X) com resolução diária
    startDate = dateshift(min(time_datetime), 'start', 'day');
    endDate = dateshift(max(time_datetime), 'start', 'day');
    xticks = startDate:days(2):endDate;

    % Aplica os ticks diários ao eixo X
    ax.XTick = datenum(xticks);
    ax.XTickLabel = datestr(xticks, 'dd');  % Exemplo: 01-Aug, 02-Aug...
    ax.XTickLabelRotation = 90;  % Para melhor leitura (opcional)
    ax.XLim = [min(xnum), max(xnum)];  % Garante que o eixo X respeite os limites dos dados


    % Define valores desejados para o eixo Y (em dias)
desired_periods = [0.25 0.5 1 2 4 8 16 31];  % adicione ou remova conforme necessário
ax.YTick = log2(desired_periods);
ax.YTickLabel = string(desired_periods);

ax.FontName = 'Arial';
ax.FontSize = 16;           % tamanho dos números nos eixos

% Fonte dos labels dos eixos
xlabel('Time (days)', 'FontSize', 16, 'FontName', 'Arial', 'FontWeight', 'bold');
ylabel('Period (days)', 'FontSize', 16, 'FontName', 'Arial','FontWeight', 'bold');

% Fonte do título
title(['CWT - ' nomeFisico], 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Arial');


    % --- Cone de influência
    hold on;
    %plot(xnum, log2(coi_central), 'k--', 'LineWidth', 1.5);
    hold off;

    %legend('Cone of Influence', 'Location', 'southwest');
    %return
    
nomeArquivo = nomesArquivos{k};
print(gcf, nomeArquivo, '-dpng', '-r300');

end
