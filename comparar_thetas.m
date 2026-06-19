% =====================================================================
% Pregunta 14: comparar theta = 0, 0.3, 0.8
% Mismo patron que el script de franco solo que (phis -> thetas)
% =====================================================================
clear all; close all;

thetas = [0, 0.3, 0.8];
results = struct;

for i = 1:length(thetas)
    theta = thetas(i);
    save theta;                          
    dynare RBC_habitos_loop noclearall;  % corre el modelo con ese theta
    results.(sprintf('theta%d', i)) = oo_;
end

% --- Graficar todas las variables, comparando los 3 thetas ---
nombres = struct('y','Producto','c','Consumo','k','Capital','i','Inversion','a','Productividad');

figure('Name','IRFs por valor de theta','Color','w');
for j = 1:length(var_list_)
    vname = char(var_list_(j));
    subplot(3,2,j);
    for i = 1:length(thetas)
        plot(results.(sprintf('theta%d', i)).irfs.(sprintf('%s_z', vname)), 'LineWidth', 1.5);
        hold on;
    end
    yline(0,'k:');
    title(nombres.(vname));
    xlabel('Periodos'); ylabel('% desv. de EE');
    grid on;
end
legend(strcat('\theta = ', string(thetas)));
