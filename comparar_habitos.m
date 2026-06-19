% =====================================================================
% Pregunta 13: IRFs ante shock positivo de productividad
% Compara el modelo CON habitos (theta=0.6) vs SIN habitos (theta=0)
% =====================================================================
clear all; close all;

% --- Correr el modelo SIN habitos (RBC estandar) ---
dynare RBC_sinhabitos noclearall;
res_sin = oo_;

% --- Correr el modelo CON habitos persistentes ---
dynare RBC_habitos noclearall;
res_con = oo_;

% --- Comparar IRFs ante el shock de productividad (z) ---
vars = {'y','c','k','i','a'};
nombres = {'Producto (y)','Consumo (c)','Capital (k)','Inversion (i)','Productividad (a)'};

figure('Name','IRFs: con vs sin habitos','Color','w');
for j = 1:length(vars)
    subplot(3,2,j);
    irf_sin = res_sin.irfs.(sprintf('%s_z', vars{j}));
    irf_con = res_con.irfs.(sprintf('%s_z', vars{j}));

    plot(irf_sin, 'b-',  'LineWidth', 1.6); hold on;
    plot(irf_con, 'r--', 'LineWidth', 1.6);
    yline(0,'k:');

    title(nombres{j});
    xlabel('Periodos');
    ylabel('% desv. de EE');
    grid on;
end

% Leyenda 
lh = legend({'Sin habitos (\theta=0)','Con habitos (\theta=0.6)'});
lh.Position(1:2) = [0.55 0.12];  
