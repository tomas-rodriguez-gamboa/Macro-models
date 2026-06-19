% =====================================================================
% Preguntas 16 y 17
% =====================================================================
clear all; close all;

dynare RBC_extendido noclearall;

vars = {'y','c','k','n','i'};
nombres = struct('y','Producto','c','Consumo','k','Capital','n','Trabajo','i','Inversion');

% ------------------- Pregunta 16: shock de preferencias -------------------
figure('Name','Pregunta 16: shock de preferencias (ub)','Color','w');
for j = 1:length(vars)
    subplot(3,2,j);
    plot(oo_.irfs.(sprintf('%s_ub', vars{j})), 'LineWidth', 1.6);
    yline(0,'k:');
    title(nombres.(vars{j}));
    xlabel('Periodos'); ylabel('% desv. de EE'); grid on;
end

% ---------------- Pregunta 17: shock tradicional (A) vs IA (B) -------------
figure('Name','Pregunta 17: shock tradicional (A) vs IA (B)','Color','w');
for j = 1:length(vars)
    subplot(3,2,j);
    plot(oo_.irfs.(sprintf('%s_ea', vars{j})), 'b-',  'LineWidth', 1.6); hold on;
    plot(oo_.irfs.(sprintf('%s_eb', vars{j})), 'r--', 'LineWidth', 1.6);
    yline(0,'k:');
    title(nombres.(vars{j}));
    xlabel('Periodos'); ylabel('% desv. de EE'); grid on;
end
lh = legend({'Shock tradicional (A)','Shock de IA/automatizacion (B)'});
lh.Position(1:2) = [0.55 0.12];
