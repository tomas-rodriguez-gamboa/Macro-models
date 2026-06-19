// =====================================================================
// RBC con habitos persistentes en consumo - Tarea Ayudantia
// Loop para comparar modelos con distintos theta y no correr cada uno por separado
// =====================================================================

%-----------------------------------------------------------
% 1. Variables
%-----------------------------------------------------------
var y c k i a;
varexo z;

parameters beta delta alpha rho sigma_z theta;

%-----------------------------------------------------------
% 2. Calibracion
%-----------------------------------------------------------
alpha   = 0.33;
beta    = 0.99;
delta   = 0.025;
rho     = 0.95;
sigma_z = 0.01;
theta   = 0.6;    

%-----------------------------------------------------------
% Cargar parametro externo (para el loop de comparacion)
%-----------------------------------------------------------
load theta;
set_param_value('theta', theta);

%-----------------------------------------------------------
% 3. Modelo
%-----------------------------------------------------------
model;

  // (1) Euler con habitos:
  // 1/(C_t - theta C_{t-1}) - beta*theta/(C_{t+1}-theta C_t)
  //   = beta*[ 1/(C_{t+1}-theta C_t) - beta*theta/(C_{t+2}-theta C_{t+1}) ]
  //     * [ alpha*A_{t+1}*K_{t+1}^(alpha-1) + (1-delta) ]
  1/(exp(c)-theta*exp(c(-1))) - beta*theta/(exp(c(+1))-theta*exp(c))
    = beta*( 1/(exp(c(+1))-theta*exp(c)) - beta*theta/(exp(c(+2))-theta*exp(c(+1))) )
      *( alpha*exp(a(+1))*exp(k)^(alpha-1) + (1-delta) );

  // (2) Restriccion de recursos: C_t + K_{t+1} = A_t K_t^alpha + (1-delta) K_t
  exp(c) + exp(k) = exp(a)*exp(k(-1))^alpha + (1-delta)*exp(k(-1));

  // (3) Producto
  exp(y) = exp(a)*exp(k(-1))^alpha;

  // (4) Inversion
  exp(i) = exp(k) - (1-delta)*exp(k(-1));

  // (5) Productividad exogena
  a = rho*a(-1) + sigma_z*z;

end;

%-----------------------------------------------------------
% 4. Estado estacionario 
%-----------------------------------------------------------
steady_state_model;
  A_ss = 1;
  K_ss = ((1/beta - 1 + delta)/alpha)^(1/(alpha-1));
  Y_ss = A_ss*K_ss^alpha;
  I_ss = delta*K_ss;
  C_ss = Y_ss - I_ss;

  a = 0;
  k = log(K_ss);
  y = log(Y_ss);
  i = log(I_ss);
  c = log(C_ss);
end;

shocks;
  var z = 1;
end;

check;
steady;

stoch_simul(order=1, irf=40, nograph) y c a i k;
